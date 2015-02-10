// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include "shell.h"

char cmd_new1(uchar dir) {
  // ��頥� ��� ��ப�
  cmdLine[0] = 0;

  // ���� ����� 䠩��
  if(!inputBox(dir ? " sozdatx papku " : " sozdatx fajl ") && cmdline[0]!=0) return 0;

  if(!absolutePath(cmdline)) return ERR_RECV_STRING;

  // �᫨ �� ᮧ���� 䠩�
  if(!dir) {
    if(strlen(cmdline) >= 255) return ERR_RECV_STRING;

    // ������塞 � ��砫� ��� ��ப� ��������
    memcpy_back(cmdline+1, cmdline, 255);
    cmdline[0] = '*';

    // ����� ।���� (����� ��뢠���� drawScreen)
    run(editorApp, cmdLine);
    return 0;
  }

  // �������� �����
  dir = fs_mkdir(cmdline);

  // ���������� ᯨ᪠ 䠩���, �᫨ �� �뫮 �訡��
  if(!dir) {
    getFiles();
    dupFiles(0);
  }

  return dir;
}

void cmd_new(uchar dir) {
  drawError("o{ibka sozdaniq papki", cmd_new1(dir));
  // ���ਮᢠ�� �࠭
  drawScreen();
}