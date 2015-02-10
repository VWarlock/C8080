// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include <n.h>
#include "shell.h"
#include "32.h"
#include <string.h>

#define progress_width 18

uchar cmd_copyFile(char* from, char* to) {
  char buf[16];
  uchar e, progress_i=0;
  ulong progress;
  ulong progress_x, progress_step;

  // ���뢠�� ��室�� 䠩� � ����砥� ��� �����
  if(e = fs_open(from)) return e;
  if(e = fs_getsize()) return e;

  // ����� 蠣� �ண���
  set32(&progress_step, &fs_result);
  div32_16(&progress_step, 40);

  // ����䥩�
  drawWindow(" kopirowanie ");
  drawWindowText(0, 0, "iz:");
  drawWindowText(4, 0, from);
  drawWindowText(0, 1, "w:");
  drawWindowText(4, 1, to);
  drawWindowText(0, 2, "skopirowano           /           bajt");
  drawWindowProgress(0, 3, progress_width, '#');
  i2s32(buf, &fs_result, 10, ' ');
  drawWindowText(23, 2, buf);
  drawEscButton();

  // ������� ���� 䠩�
  if(e = fs_swap()) return e;
  if(e = fs_create(to)) return e;

  // ����஢����
  SET32IMM(&progress, 0);
  SET32IMM(&progress_x, 0);
  for(;;) {
    // �뢮� �ண���
    i2s32(buf, &progress, 10, ' ');
    drawWindowText(12, 2, buf); 

    // ����஢���� �����
    if(e = fs_swap()) return e;
    if(e = fs_read(panelB.files1, 1024) ) return e;
    if(fs_low == 0) return 0; // � ��१���㧪�� 䠩���
    if(e = fs_swap()) return e;
    if(e = fs_write(panelB.files1, fs_low)) return e;

    // �� ����ࠡ�⪠ ���������, �� �� �����ন���� 32-� ��⭮� ��䬥⨨��
    add32_16(&progress, fs_low);

    // �ண���
    add32_16(&progress_x, fs_low);
    while(progress_i < progress_width && cmp32_32(&progress_x, &progress_step) != 1) {
      sub32_32(&progress_x, &progress_step);
      drawWindowText(progress_i, 3, "\x17");
      ++progress_i;
    }

    // ���뢠���
    if(fs_bioskey(1) == KEY_ESC) { e = ERR_USER; break; }
  }

  // ������� 䠩� � ��砥 �訡��. �訡�� 㤠����� �� ��ࠡ��뢠��.
  fs_delete(to);
  return e;
}

//---------------------------------------------------------------------------

void applyMask1(char* dest, char* mask, uchar i) {
  register char m;
  for(;;) {
    m = *mask;
    if(m == '*') return;
    if(m != '?') *dest = m;
    --i;
    if(i==0) return;
    ++mask, ++dest;
  }
}

//---------------------------------------------------------------------------

#define COPY_STACK 8

char cmd_copyFolder(char* from, char* to) {
  char e;
  uint i;
  uchar level=0;
  uint stack[COPY_STACK];
  FileInfo* f;

  // ������� �����
  e = fs_mkdir(to); 
  if(e) return e;

  for(i=0;;++i) {
    // ���誮� ����� 䠩���
    if(i == maxFiles) return ERR_MAX_FILES;

    // ������� ᯨ᮪ 䠩��� �⮩ �����.
    // ����砥� �� ����-���� ����� ࠧ, ⠪ ��� cmd_copyFile ����� ��� ᯨ᮪.
    e = fs_findfirst(from, panelB.files1, i+1);
    if(e != 0 && e != ERR_MAX_FILES) return e; // �� �ᥣ�� �㤥� ������� ERR_MAX_FILES

    // � ��� ����� 䠩���.
    if(i >= fs_low) {
      // ��� ४��ᨨ
      if(level==0) return 0;
      // ������
      dropPathInt(from, 0);
      dropPathInt(to, 0);
      --level;
      i = stack[level];
      continue;
    }
    f = panelB.files1 + i;

    // ����塞 ����� 䠩���
    if(catPathAndUnpack(from, f->fname)) return ERR_RECV_STRING;
    if(catPathAndUnpack(to,   f->fname)) return ERR_RECV_STRING;

    // ��������
    if(f->fattrib & 0x10) {
      // ����ﭥ� ������ � �⥪�
      if(level == COPY_STACK-1) return ERR_RECV_STRING;
      stack[level] = i;
      level++;
      // ������� �����
      e = fs_mkdir(to); 
      if(e) return e;
      // ���� ��筥��� � ���
      i = -1;
      continue;
    }

    // �����㥬 䠩�
    e = cmd_copyFile(from, to);

    // ����⠭�������� ����
    dropPathInt(from, 0);
    dropPathInt(to, 0);

    // ��室�� �᫨ �訡��
    if(e) return e;
  }
}

//---------------------------------------------------------------------------

void applyMask(char* dest, char* mask) {
  applyMask1(dest, mask, 8);
  applyMask1(dest+8, mask+8, 3);
}

//---------------------------------------------------------------------------

char cmd_copymove1(uchar copymode, uchar shiftPressed) {
  char *name;
  char e;
  FileInfo* f;
  char sourceFile[256];
  char mask[11];
  char forMask[11];
  char type;
  uint i;

  if(shiftPressed) {
    // �����㥬 ��� c ��ࢮ� ������ (��� ���)
    f = getSelNoBack();
    if(!f) return 0; // ���� �� ��࠭, ��室�� ��� �訡��
    unpackName(cmdLine, f->fname);
  } else {
    // �����㥬 ���� � ��ன ������
    i = strlen(panelB.path1);
    if(i >= 254) return ERR_RECV_STRING; // ��� ��� �ਡ���� 2 ᨬ����
    cmdLine[0] = '/';
    strcpy(cmdline+1, panelB.path1);
    if(i != 0) strcpy(cmdline+i+1, "/");
  }

  // ������塞 ���짮��⥫� �������� ���� ��� ���
  if(!inputBox(copymode ? " kopirowatx " : " pereimenowatx/peremestitx ") && cmdline[0]!=0) return 0;

  // �८�ࠧ������ �⭮�⥫쭮�� ��� � ��᮫���
  if(!absolutePath(cmdline)) return ERR_RECV_STRING;

  // �ᯮ������ �� ��᪠?
  mask[0] = 0;  
  name = getname(cmdline);
  if(name[0] != 0) {
    // ���࠭塞 ����
    packName(mask, name);
    // ���ࠥ� �� ��� ����
    dropPathInt(cmdLine, 0);
  } else {
    // �᫨ � ��� ��ப� �� � ����, � ��� �� �뤥����, ����� ��� ��ப� ����稢����� �� /.
    // ��� ᨬ��� ���� 㤠����
    if(cmdline[0] != 0 && name[0] == 0) name[-1] = 0;
  }

  // �饬 ���� 䠩�
  type = getFirstSelected(sourceFile);
  if(type == 0) return 0; // ��� ��࠭��� 䠩���

  for(;;) {
    // �८�ࠧ������ �⭮�⥫쭮�� ��� � ��᮫���
    if(!absolutePath(sourceFile)) { e = ERR_RECV_STRING; break; }

    // ������塞 ���
    packName(forMask, getname(sourceFile));
    if(mask[0]) applyMask(forMask, mask);
    if(catPathAndUnpack(cmdline, forMask)) return ERR_RECV_STRING;

    // ������ � ���� �� �����㥬 � �� ��२�����뢠��
    if(0!=strcmp(sourceFile, cmdline)) {
      // �믮������ ����樨
      if(copymode) {
        if(type==2) {
          e = cmd_copyFolder(sourceFile, cmdline);
        } else {
          e = cmd_copyFile(sourceFile, cmdline);
        }
      } else {
        // ���⮥ ����
        drawWindow(" pereimenowanie/pereme}enie ");
        drawWindowText(0, 1, "iz:");
        drawWindowText(4, 1, sourceFile);
        drawWindowText(0, 2, "w:");
        drawWindowText(4, 2, cmdline);
        drawAnyKeyButton();

        // ���뢠���
        if(fs_bioskey(1) == KEY_ESC) { e = ERR_USER; break; }

        e = fs_move(sourceFile, cmdline);    
      }

      if(e) break;
    }

    // ���ࠥ� �� ��� ��� 䠩��
    dropPathInt(cmdLine, 0);

    // ������騩 ��࠭�� 䠩�
    type = getNextSelected(sourceFile);
    if(type == 0) { e=0; break; }
  } // ����� 横��

  // �� ��७�� 䠩�� ���� �������� ��� ������
  // � �� ����஢���� ᯨ᮪ 䠩�� �ᯮ������ ��� ����
  getFiles();
  dupFiles(1);

  return e;
}

//---------------------------------------------------------------------------

char cmd_copymove(uchar copymode, uchar shiftPressed) {
  drawError(copymode ? "o{ibka kopirowaniq" : "o{ibka pereme}eniq", cmd_copymove1(copymode, shiftPressed));
  drawScreen();
}