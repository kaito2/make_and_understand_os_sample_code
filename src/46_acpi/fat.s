;************************************************************************
;	FAT:FAT-1
;************************************************************************
		times (FAT1_START) - ($ - $$)	db	0x00
;------------------------------------------------------------------------
FAT1:
		db		0xFF, 0xFF												; �N���X�^:0
		dw		0xFFFF													; �N���X�^:1
		dw		0xFFFF													; �N���X�^:2

;************************************************************************
;	FAT:FAT-2
;************************************************************************
		times (FAT2_START) - ($ - $$)	db	0x00
;------------------------------------------------------------------------
FAT2:
		db		0xFF, 0xFF												; �N���X�^:0
		dw		0xFFFF													; �N���X�^:1
		dw		0xFFFF													; �N���X�^:2

;************************************************************************
;	FAT:���[�g�f�B���N�g���̈�
;************************************************************************
		times (ROOT_START) - ($ - $$)	db	0x00
;------------------------------------------------------------------------
FAT_ROOT:
		db		'BOOTABLE', 'DSK'										; + 0:�{�����[�����x��
		db		ATTR_ARCHIVE | ATTR_VOLUME_ID							; +11:����
		db		0x00													; +12:�i�\��j
		db		0x00													; +13:TS
		dw		( 0 << 11) | ( 0 << 5) | (0 / 2)						; +14:�쐬����
		dw		( 0 <<  9) | ( 0 << 5) | ( 1)							; +16:�쐬��
		dw		( 0 <<  9) | ( 0 << 5) | ( 1)							; +18:�A�N�Z�X��
		dw		0x0000													; +20:�i�\��j
		dw		( 0 << 11) | ( 0 << 5) | (0 / 2)						; +22:�X�V����
		dw		( 0 <<  9) | ( 0 << 5) | ( 1)							; +24:�X�V��
		dw		0														; +26:�擪�N���X�^
		dd		0														; +28:�t�@�C���T�C�Y

		db		'SPECIAL ', 'TXT'										; + 0:�{�����[�����x��
		db		ATTR_ARCHIVE											; +11:����
		db		0x00													; +12:�i�\��j
		db		0x00													; +13:TS
		dw		( 0 << 11) | ( 0 << 5) | (0 / 2)						; +14:�쐬����
		dw		( 0 <<  9) | ( 1 << 5) | ( 1)							; +16:�쐬��
		dw		( 0 <<  9) | ( 1 << 5) | ( 1)							; +18:�A�N�Z�X��
		dw		0x0000													; +20:�i�\��j
		dw		( 0 << 11) | ( 0 << 5) | (0 / 2)						; +22:�X�V����
		dw		( 0 <<  9) | ( 1 << 5) | ( 1)							; +24:�X�V��
		dw		2														; +26:�擪�N���X�^
		dd		FILE.end - FILE											; +28:�t�@�C���T�C�Y

;************************************************************************
;	FAT:�f�[�^�̈�
;************************************************************************
		times FILE_START - ($ - $$)	db	0x00
;------------------------------------------------------------------------
FILE:	db		'hello, FAT!'
.end:	db		0

ALIGN 512, db 0x00

		times (512 * 63)	db	0x00
