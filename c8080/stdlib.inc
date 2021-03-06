; ��������� ��� RKA �����

  device zxspectrum48
  org 0h

entry:
  db 0, 4, 0, 0
  jp main

;----------------------------------------------------------------------------
; ��������� A �� D, ��������� � HL. BC ������� ������

op_mul:
  push bc
  ld hl, 0
  ld e, d  ; de=d
  ld d, l  
  ld c, 8
op_mul1:
  add hl, hl
  add a
  jp nc, op_mul2
    add hl, de
op_mul2:
  dec c
  jp nz, op_mul1
pop_bc_ret:
  pop bc
  ret

;----------------------------------------------------------------------------
; ��������� HL �� DE, ��������� � HL. BC ������� ������

op_mul16:
  push bc
  ld bc, hl
  ld hl, 0
  ld a, 17
op_mul16_1:
  dec a
  jp z, pop_bc_ret
  add hl, hl
  ex hl, de 
  jp nc, op_mul16_2
  add hl, hl
  inc hl
  jp op_mul16_3
op_mul16_2:
  add hl, hl
op_mul16_3:
  ex de, hl
  jp nc, op_mul16_1
  add hl, bc
  jp nc, op_mul16_1
  inc de
  jp op_mul16_1

;----------------------------------------------------------------------------
; ����� HL �� DE, ��������� � HL. BC ������� ������

op_shr16:
  inc e
x:dec e
  ret z
  sub a
  or h 
  rra
  ld h, a
  ld a, l
  rra
  ld l, a
  jp x

;----------------------------------------------------------------------------
; ����� A �� D, ��������� � A. BC ������� ������

op_shl:
  inc d
op_shl_2:
  dec d
  ret z
  add a
  jp op_shl_2

;----------------------------------------------------------------------------
; ����� A �� D, ��������� � A. HL, BC ������� ������

op_shr:
  inc d
op_shr_2:
  dec d
  ret z
  cp a
  rra
  jp op_shr_2
