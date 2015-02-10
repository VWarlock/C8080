// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include "shell.h"
#include <mem.h>

void cmd_freespace_1(uchar y, const char* text) {
  char buf[17];

  // �८�ࠧ������ �᫠ � ��ப�
  i2s32(buf, (ulong*)&fs_low, 10, ' ');

  // ��ନࢠ���� ��ப� � �ଠ� XXX XXX XXX ��
  memcpy_back(buf+10, buf+7, 3); buf[9]  = ' ';
  memcpy_back(buf+6,  buf+4, 3); buf[5]  = ' ';
  memcpy_back(buf+2,  buf+1, 3); buf[1]  = ' ';
  strcpy(buf+13, " mb");

  // �뢮� �� �࠭
  drawWindowText(6, y, text);
  drawWindowText(16, y, buf);
}

//---------------------------------------------------------------------------

void cmd_freespace() {
  uchar e;  

  // ����䥩�
  drawWindow(" nakopitelx ");
  drawWindowText(6, 2, "prowerka...");  

  // �믮��塞
  if(e = fs_getfree()) { 
    drawError("o{ibka ~teniq", e);
  } else {
    // �뢮� ������
    cmd_freespace_1(2, "swobodno: ");

    // ����� ��饣� ����
    if(!fs_gettotal()) cmd_freespace_1(1, "wsego:");

    // ���� ���짮��⥫�
    drawAnyKeyButton();
    fs_bioskey(0);
  }

  drawScreen();
}
