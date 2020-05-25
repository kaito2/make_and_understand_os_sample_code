;************************************************************************
;
;	�J�[�l����
;
;************************************************************************

;************************************************************************
;	�}�N��
;************************************************************************
%include	"../include/define.s"
%include	"../include/macro.s"

		ORG		KERNEL_LOAD						; �J�[�l���̃��[�h�A�h���X

[BITS 32]
;************************************************************************
;	�G���g���|�C���g
;************************************************************************
kernel:
		;---------------------------------------
		; �t�H���g�A�h���X���擾
		;---------------------------------------
		mov		esi, BOOT_LOAD + SECT_SIZE		; ESI   = 0x7C00 + 512
		movzx	eax, word [esi + 0]				; EAX   = [ESI + 0] // �Z�O�����g
		movzx	ebx, word [esi + 2]				; EBX   = [ESI + 2] // �I�t�Z�b�g
		shl		eax, 4							; EAX <<= 4;
		add		eax, ebx						; EAX  += EBX;
		mov		[FONT_ADR], eax					; FONT_ADR[0] = EAX;

		;---------------------------------------
		; ������
		;---------------------------------------
		cdecl	init_int						; // ���荞�݃x�N�^�̏�����
		cdecl	init_pic						; // ���荞�݃R���g���[���̏�����

		set_vect	0x00, int_zero_div			; // ���荞�ݏ����̓o�^�F0���Z
		set_vect	0x21, int_keyboard			; // ���荞�ݏ����̓o�^�FKBC
		set_vect	0x28, int_rtc				; // ���荞�ݏ����̓o�^�FRTC

		;---------------------------------------
		; �f�o�C�X�̊��荞�݋���
		;---------------------------------------
		cdecl	rtc_int_en, 0x10				; rtc_int_en(UIE); // �X�V�T�C�N���I�����荞�݋���

		;---------------------------------------
		; IMR(���荞�݃}�X�N���W�X�^)�̐ݒ�
		;---------------------------------------
		outp	0x21, 0b_1111_1001				; // ���荞�ݗL���F�X���[�uPIC/KBC
		outp	0xA1, 0b_1111_1110				; // ���荞�ݗL���FRTC

		;---------------------------------------
		; CPU�̊��荞�݋���
		;---------------------------------------
		sti										; // ���荞�݋���

		;---------------------------------------
		; �t�H���g�̈ꗗ�\��
		;---------------------------------------
		cdecl	draw_font, 63, 13				; // �t�H���g�̈ꗗ�\��
		cdecl	draw_color_bar, 63, 4			; // �J���[�o�[�̕\��

		;---------------------------------------
		; ������̕\��
		;---------------------------------------
		cdecl	draw_str, 25, 14, 0x010F, .s0	; draw_str();

.10L:											; while (;;)
												; {
		;---------------------------------------
		; �����̕\��
		;---------------------------------------
		mov		eax, [RTC_TIME]					;   // �����̎擾
		cdecl	draw_time, 72, 0, 0x0700, eax	;   // �����̕\��

		;---------------------------------------
		; �L�[�R�[�h�̎擾
		;---------------------------------------
		cdecl	ring_rd, _KEY_BUFF, .int_key	;   EAX = ring_rd(buff, &int_key);
		cmp		eax, 0							;   if (EAX == 0)
		je		.10E							;   {
												;   
		;---------------------------------------
		; �L�[�R�[�h�̕\��
		;---------------------------------------
		cdecl	draw_key, 2, 29, _KEY_BUFF		;     ring_show(key_buff); // �S�v�f��\��
.10E:											;   }
		jmp		.10L							; }

.s0:	db	" Hello, kernel! ", 0

ALIGN 4, db 0
.int_key:	dd	0

ALIGN 4, db 0
FONT_ADR:	dd	0
RTC_TIME:	dd	0

;************************************************************************
;	���W���[��
;************************************************************************
%include	"../modules/protect/vga.s"
%include	"../modules/protect/draw_char.s"
%include	"../modules/protect/draw_font.s"
%include	"../modules/protect/draw_str.s"
%include	"../modules/protect/draw_color_bar.s"
%include	"../modules/protect/draw_pixel.s"
%include	"../modules/protect/draw_line.s"
%include	"../modules/protect/draw_rect.s"
%include	"../modules/protect/itoa.s"
%include	"../modules/protect/rtc.s"
%include	"../modules/protect/draw_time.s"
%include	"../modules/protect/interrupt.s"
%include	"../modules/protect/pic.s"
%include	"../modules/protect/int_rtc.s"
%include	"../modules/protect/int_keyboard.s"
%include	"../modules/protect/ring_buff.s"

;************************************************************************
;	�p�f�B���O
;************************************************************************
		times KERNEL_SIZE - ($ - $$) db 0x00	; �p�f�B���O
