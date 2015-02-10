// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include "shell.h"

char cmd_deleteFile() {
  // �������� 䠩��
  drawWindow(" udalenie ");
  drawWindowText(0, 1, cmdline);
  drawEscButton();

  // ���뢠���
  if(fs_bioskey(1) == KEY_ESC) return ERR_USER;

  // �������� 䠩��
  return fs_delete(cmdline);
}

//---------------------------------------------------------------------------

char cmd_deleteFolder() {
  uchar level; // 8 ��� 墠��, ⠪ ��� ����� ��� �ᥣ� 255 ᨬ�����.
  char e;
  FileInfo* p;
  uint i;

  level = 0;

  while(1) {
    // ������� ᯨ᮪ 䠩��� �⮩ �����
    e = fs_findfirst(cmdline, panelB.files1, maxFiles);  
    if(e != 0 && e != ERR_MAX_FILES) return e;
    panelB.cnt = fs_low;

    // ����塞 ���, ���� ��� 㤠�����
    e = 0;
    for(p=panelB.files1, i=panelB.cnt; i; --i, ++p) {
      if(catPathAndUnpack(cmdLine, p->fname)) return ERR_RECV_STRING;
      e = cmd_deleteFile();
      if(e == ERR_DIR_NOT_EMPTY) break;
      dropPathInt(cmdLine, 0);
      // �᫨ �訡��, ��室��
      if(e) return e;
    }

    // �᫨ 㤠�塞�� ����� �� ���� ��室�� � ���
    if(e == ERR_DIR_NOT_EMPTY) { 
      ++level;
      continue;
    }

    // �� ����� ����稫� ERR_MAX_FILES, ���⮬� ������ ������ �����.
    if(panelB.cnt == maxFiles) continue;

    // ����塞 ��� �����
    e = cmd_deleteFile();
    if(e) return e;

    // ��室�� �� �����
    if(level == 0) return 0;
    --level;
    dropPathInt(cmdLine, 0);
  }
}

//---------------------------------------------------------------------------

void cmd_delete() {
  uchar e, needRefresh2;

  // ������ � ���짮��⥫� 
  if(confirm(" udalitx ", "wy hotite udalitx fail(y)?")) {
    needRefresh2 = 0;

    // �������� � ���� ��� ��� ���
    if(getFirstSelected(cmdLine)) {
      for(;;) {
        if(!absolutePath(cmdline)) { e = ERR_RECV_STRING; break; }

        // �������� 䠩��
        e = cmd_deleteFile();

        // �᫨ �� ����� � 䠩����, � 㤠�塞 �� ४��ᨢ��
        if(e == ERR_DIR_NOT_EMPTY) {
          needRefresh2 = 1; // �ࠢ�� ������ �㤥� �ᯮ�祭�
          e = cmd_deleteFolder();
        }
        if(e) break;

        // ������騩 䠩�
        if(!getNextSelected(cmdLine)) break;
      }

      // �뢮� �訡��
      drawError("o{ibka udaleniq", e);

      // ���������� ᯨ᪠ 䠩���
      getFiles();
      dupFiles(needRefresh2);
    }
  }

  drawScreen();
}
