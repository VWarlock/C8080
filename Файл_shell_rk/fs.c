// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include "fs.h"
#include "n.h"
#include <apogey/video.h>
#include <apogey/bios.h>
#include <stdlib.h>
#include <32.h>

const char* fs_cmdLine = "";
const char* fs_selfName = "SHELL.RK";
uint        fs_low;
uint        fs_high;
uchar       fs_screenWidth;
uchar       fs_screenHeight;
uchar       fs_colors;

char fs_bioskey(char c) {
  if(c) return bioskey();
  return getch();
}

void fs_initScreen() {
//  fs_screenWidth  = 78;
//  fs_screenHeight = 30;
//  return;
  fs_clearScreen();
  asm { 
    ; Настройка микросхем
    lxi h, 61185
    mvi m, 0
    dcr l
    mvi m, 77
    mvi m, 100
    mvi m, 119
    mvi m, 83
    inr l
    mvi m, 35
fs_clearScreen_1:
    lda 61185
    ani 32
    jz fs_clearScreen_1
fs_clearScreen_2:
    lda 61185
    ani 32
    jz fs_clearScreen_2
    ; Программирование контроллеров
    lxi h, 61448
    mvi m, 128
    mvi l, 4
    mvi m, 208
    mvi m, 225
    inr l
    mvi m, 28
    mvi m, 73
    mvi l, 8
    mvi m, 164
    di   
  }
  fs_screenWidth  = 64;
  fs_screenHeight = 30;
  fs_colors = 8;    
}

void fs_clearScreen() {
  asm {
    push b
    ; Форматирование видеопамяти
    xra a
    lxi h, 57808
    mvi b, 3
fs_initScreen_l1:
    mov m, a
    inx h
    mvi m, 241
    inx h
    dcr b
    jnz fs_initScreen_l1    
    mvi c, 31
fs_initScreen_l2:
    mvi b, 74
fs_initScreen_l3:
    mov m, a
    inx h
    dcr b
    jnz fs_initScreen_l3
    mvi m, 241
    inx h
    dcr c
    jnz fs_initScreen_l2
    inx h
    mvi m, 255
    pop b
  }
}

void fs_print(uchar x, uchar y, uchar len, char* text, char spc) {
  asm {
    ; Расчет адреса ((uchar*)0xE1D0) + x + y * 78;
;    lhld fs_print_2
;    mvi h, 0
;    mov d, h
;    mov e, l
;    dad h
;    dad h
;    dad h
;    dad d    
;    dad h
;    dad d    
;    dad h
;    dad d    
;    dad h
;    xchg
;    lhld fs_print_1
;    mvi h, 0
;    dad d  
;    lxi d, 0E1D0h
    
    ; Расчет адреса ((uchar*)0xE1DF) + x + y * 75;
    lhld fs_print_2
    mvi h, 0
    mov d, h
    mov e, l
    dad h
    dad h
    dad h
    dad d    
    dad h
    dad h
    dad d    
    dad h
    dad d
    xchg
    lhld fs_print_1
    mvi h, 0
    dad d  
    lxi d, 0E1DFh
    dad d
    push b
    xchg
    lhld fs_print_4
    xchg
    lda  fs_print_3
    mov  b, a
fs_print_loop:
    ldax d
    inx  d
    ani  07Fh
    jz   fs_print_spc
    mov  m, a
    inx  h
    dcr  b
    jnz  fs_print_loop 
    pop b
    ret

fs_print_spc:
    lda  fs_print_5      
    ani  07Fh
    jz   fs_print_ret
fs_print_loop2:
    mov  m, a
    inx  h
    dcr  b
    jnz  fs_print_loop2
fs_print_ret:
    pop b
    call fs_hideCursor
  }
}

char* fs_window() {
  return "\x1B\x1C\x04\x1C\x10\x06\x11\x02\x1C\x01";
}

void fs_hideCursor() {
  directCursor(255, 255);
}

void fs_cursor(uchar x, uchar y) {  
  directCursor(8+x, 3+y);
}

uint fs_getMemTop() {
  return getMemTop();  
}

void fs_init() {
}

uchar fs_findfirst(const char* path, FileInfo* dest, uint size) {
  uchar i;
  uchar xx;
  fs_low = 0;

  xx=0; 
  for(;path[i]!=0; i++)
    if(path[i]=='/')
     xx++;

  if(xx<4)
  for(i=4; i; --i) {
    memcpy(dest[0].fname, "FOLDER     ", 11);
    i2s(dest[0].fname+6, i, 2, '0');
    memcpy(dest[0].fname+8, "   ", 3);
    dest[0].fattrib = 0x10;
    dest[0].fsize_l = i;
    dest[0].fdate = i;
    dest[0].ftime = i;
    dest++;
    fs_low++;
  }
 
  for(i=rand()&31; i; --i) {
    memcpy(dest[0].fname, "FILE    TXT", 11);
    i2s(dest[0].fname+4, i, 2, '0');
    i2s(dest[0].fname+6, xx, 2, '0');
    memcpy(dest[0].fname+8, "TXT", 3);
    xx++;
    dest[0].fattrib = 0;
    dest[0].fsize_l = i;
    dest[0].fdate = i;
    dest[0].ftime = i;
    dest++;
    fs_low++;
  }
  return 0;
}

ulong readEmuSize;
ulong readEmuSize2;

uchar fs_swap() {
  ulong tmp;
  set32(&tmp, &readEmuSize);
  set32(&readEmuSize, &readEmuSize2);
  set32(&readEmuSize2, &tmp);
  return 0;
}

uchar fs_write(const void* buf, uint size) {
  uint j, k;
//  for(k=100; k; --k)
    for(j=100; j; --j);
  return 0;
}

uchar fs_seek(uint low, uint high, uchar mode) {
  return 1;
}

void fs_reboot() {
  fs_exec("","");
  asm {
    jmp 0F800h
  }
}

uchar fs_read(void* buf, uint size) {
  if(((ushort*)&readEmuSize)[1] == 0 && ((ushort*)&readEmuSize)[0] < size) {
    fs_low = ((ushort*)&readEmuSize)[0];
  } else {
    fs_low = size;
  }
  sub32_16(&readEmuSize, fs_low);
  return 0;
}

uchar fs_open(const char* name) {
  SET32IMM(&readEmuSize, 240000);
  return 0;
}

uchar fs_create(const char* name) {
  SET32IMM(&readEmuSize, 240000);
  return 0;
}

uchar fs_move(const char* from, const char* to) {
  uint i;
  for(i=20000; i; --i);
  return 0;
}

uchar fs_mkdir(const char* name) {
  uint i;
  fs_print(0,0,64,name,0);
  for(i=5000; i; --i);
  return 0;
}

uchar fs_gettotal() { // fs_high:fs_low - размер в Мб
  fs_high = 200;
  fs_low = 20;
  return 0; 
}

uchar fs_getsize() { // fs_high:fs_low - размер
  set32(&fs_result, &readEmuSize);
  return 0; 
}

uchar fs_getfree() { // fs_high:fs_low - размер в Мб
  fs_high = 100;
  fs_low = 20;
  return 0; 
}

uchar fs_findnext(FileInfo* dest, uint size) {  
  return fs_findfirst(":", dest, size);
}

uchar fs_exec(const char* fileName, const char* cmdLine) {
  return 1;
}

uchar fs_delete(const char* name) {
  uint i;
  fs_print(0,0,64,name,0);
  if(0==strcmp(name, "FOLDER01")) return ERR_DIR_NOT_EMPTY;
  if(0==strcmp(name, "FOLDER01/FOLDER04")) return ERR_DIR_NOT_EMPTY;
  for(i=5000; i; --i);
  return 0;
}
