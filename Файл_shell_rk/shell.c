// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include <n.h>
#include <stdlib.h>
#include <mem.h>
#include "32.h"
#include <string.h>
#include "shell.h"

void drawFiles2();

char   editorApp[1] = "BOOT/EDIT.RK";
char   viewerApp[1] = "BOOT/VIEW.RK";
Panel  panelA;
Panel  panelB;
char   cmdline[256]; 
uint   maxFiles;

uchar rowsCnt = 16;

//---------------------------------------------------------------------------

const char parentDir[20] = { '.','.',' ',' ',' ',' ',' ',' ',' ',' ',' ',0x10,0,0,0,0,0,0,0,0 };

//---------------------------------------------------------------------------
// ������������ ��� ����� �� �������� ������

void drawFiles() {
  hideFileCursor();
  drawColumn(0);
  drawColumn(1);
}

//---------------------------------------------------------------------------

void drawFilesCount() {
  ulong total;
  uint i, filesCnt;
  FileInfo* p;   
  
  SET32IMM(&total, 0);
  filesCnt = 0;
  for(p = panelA.files1, i = panelA.cnt; i; ++p, --i) {
    if((p->fattrib & 0x10) == 0) ++filesCnt;
    add32_32(&total, &p->fsize);
  }

  drawFilesCountInt(&total, filesCnt);
}

//---------------------------------------------------------------------------
// ������� �������� ������

void swapPanels() {
  memswap(&panelA, &panelB, sizeof(Panel));  
  if(onePanel) {
    drawPanelTitle(1, panelA.path1);   
    drawCmdLineWithPath();
    drawFiles2();
    return;
  }
  drawSwapPanels();
}

//---------------------------------------------------------------------------
// ������� �� ����� ���������� � ��������� �����

void drawFileInfo() {
  FileInfo* f;
  char buf[18];

  f = getSel();

  if(f->fattrib & 0x10) {
    drawFileInfoDir();
  } else {
    i2s32(buf, &f->fsize, 10, ' ');           
    drawFileInfo1(buf);
  }

  if(f->fdate==0 && f->ftime==0) {
    buf[0] = 0;
  } else {
    i2s(buf, f->fdate & 31, 2, ' ');  
    buf[2] = '-';
    i2s(buf+3, (f->fdate>>5) & 15, 2, '0');
    buf[5] = '-';
    i2s(buf+6, (f->fdate>>9)+1980, 4, '0');
    buf[10] = ' ';
    i2s(buf+11, f->ftime>>11, 2, '0');
    buf[13] = ':';
    i2s(buf+14, (f->ftime>>5)&63, 2, '0');
  }
  drawFileInfo2(buf);
}

//---------------------------------------------------------------------------
// ������������ ������ � ���������� � ��������� �����

void showFileCursorAndDrawFileInfo() {
  showFileCursor();
  drawFileInfo();  
}
  
//---------------------------------------------------------------------------
// ������������ ��� ����� �� ���� �������

void drawFiles2() {
  drawFiles();
  drawFilesCount();
  if(!onePanel) {
    swapPanels();
    drawFiles();
    drawFilesCount();
    drawFileInfo();
    swapPanels();
  }
  showFileCursorAndDrawFileInfo();
}

//---------------------------------------------------------------------------

FileInfo* getSel() {
  uint n = panelA.offset+panelA.cursorY+panelA.cursorX*rowsCnt;
  if(n < panelA.cnt) return panelA.files1 + n;
  panelA.offset = 0;
  panelA.cursorY = 0;
  panelA.cursorX = 0;
  if(panelA.cnt != 0) return panelA.files1;
  return (FileInfo*)parentDir;
}

//---------------------------------------------------------------------------

FileInfo* getSelNoBack() {
  FileInfo* f = getSel();
  if(f->fname[0] == '.') f = 0;
  return f;  
}

//---------------------------------------------------------------------------
// ������������ ���� �����

void drawScreen() {
  cmdline[0] = 0;
  drawScreenInt();
  drawCmdLineWithPath();
  drawFiles2();
}

//---------------------------------------------------------------------------
// ������ �����

void processInput(uchar c) {
  register uint cmdline_pos = strlen(cmdline);
  if(c==KEY_BKSPC) {
    if(cmdline_pos==0) return;
    --cmdline_pos;    
    cmdline[cmdline_pos] = 0;
    return;
  }
  if(c>=32) {
    if(cmdline_pos==255) return; 
    cmdline[cmdline_pos] = c;
    ++cmdline_pos;
    cmdline[cmdline_pos] = 0;
  }
}

//---------------------------------------------------------------------------
// ���� � �������

void drawError(const char* text, uchar e) {
  char buf[4];

  // ��� ������
  if(e == 0) return;
  
  // ������ ����
  drawWindow(" o{ibka ");
  drawAnyKeyButton();
  drawWindowText(0, 0, text);

  // �������� ������
  switch(e) {
    case ERR_NO_FILESYSTEM: text = "net fajlowoj sistemy"; break;
    case ERR_DISK_ERR: text = "o{ibka nakopitelq"; break;
    case ERR_DIR_NOT_EMPTY: text = "papka ne pusta"; break;
    case ERR_NOT_OPENED: text = "fajl ne otkryt"; break;
    case ERR_NO_PATH: text = "putx ne najden"; break;
    case ERR_DIR_FULL: text = "maksimum fajlow w papke"; break;
    case ERR_NO_FREE_SPACE: text = "disk zapolnen"; break;
    case ERR_FILE_EXISTS: text = "fail su}estwuet"; break;
    case ERR_USER: text = "prerwano polxzowatelem"; break;
    case ERR_RECV_STRING: text = "putx bolx{e 255 simwolow"; break;
    default: i2s(buf, e, 3, '0'); text = buf; break;
  };

  // ������� �������� ������
  drawWindowText(0, 2, text);

  // ����
  fs_bioskey(0);
}

//---------------------------------------------------------------------------
// ���� �� ������� �����

char inputBox(const char* title) {
  register uchar c, clearFlag;
  clearFlag = 1;

  // ������ ����
  drawWindow(title);
  drawWindowText(3, 0, "imq:");
  drawWindowTextCenter(4, "[ ok ]  [ otmena ]");
 
  // ������������ ������� ������
  while(1) {
    drawWindowInput(1, 1, 32-6);
    c = fs_bioskey(0);
    if(c==KEY_RIGHT) clearFlag = 0;
    if(c==KEY_LEFT) clearFlag = 0;
    if(c==KEY_ENTER) { fs_hideCursor(); return 1; }
    if(c==KEY_ESC) { fs_hideCursor(); return 0; }
    if(clearFlag) clearFlag = 0, cmdline[0] = 0;
    processInput(c);
  }
}

//---------------------------------------------------------------------------
// ���� �������������

char confirm(const char* title, const char* text) {
  // ������ ����
  drawWindow(title);
  drawWindowText(3, 1, text);
  drawWindowText(6, 4, "[ wk - ok ]  [ ar2 - otmena ]");

  // ������������ ������� ������
  while(1) {
    switch(fs_bioskey(0)) {
      case KEY_ENTER: return 1;
      case KEY_ESC: return 0;
    }
  }
}

//---------------------------------------------------------------------------
// �������������� ��� ����� � ������
	 
void unpackName(char* d, const char* s) {
  register uchar i;
  for(i=0; i!=11; ++i, ++s) {
    if(i==8) *d = '.', ++d;
    if(*s!=' ') *d = *s, ++d;
  }
  if(d[-1]=='.') --d;
  *d = 0;
}

//---------------------------------------------------------------------------

char catPathAndUnpack(char* str, char* fileName) {
  uint len = strlen(str);
  if(len) {
    if(len >= 255-13) return 1; // �� ������� ����������� ���� ��� �����  
    str[len] = '/';  
    str += len+1;
  }
  unpackName(str, fileName);
  return 0;
}

//---------------------------------------------------------------------------
// ����������� ��� ���������� ����� � �����

uint nextSelectedCnt;
FileInfo* nextSelectedFile;

char getFirstSelected(char* name) {
  char type;
  nextSelectedCnt = panelA.cnt;
  nextSelectedFile = panelA.files1;
  if(type = getNextSelected(name)) return type; 

  nextSelectedFile = getSelNoBack();
  if(!nextSelectedFile) return 0;
  unpackName(name, nextSelectedFile->fname);
  if(nextSelectedFile->fattrib & 0x10) return 2;
  return 1;
}

//---------------------------------------------------------------------------

char getNextSelected(char* name) {
  for(;;) {
    if(nextSelectedCnt == 0) return 0;
    if(nextSelectedFile->fattrib & 0x80) break;
    ++nextSelectedFile, --nextSelectedCnt;
  }

  nextSelectedFile->fattrib &= 0x7F;
  unpackName(name, nextSelectedFile->fname);
  ++nextSelectedFile, --nextSelectedCnt;
  if(nextSelectedFile[-1].fattrib & 0x10) return 2;
  return 1;
}

//---------------------------------------------------------------------------

#define SORT_STACK_MAX 32

uchar cmpFileInfo(FileInfo* a, FileInfo* b) {
  register uchar i, j;
  i = (a->fattrib&0x10);
  j = (b->fattrib&0x10);
  if(i<j) return 1;
  if(j<i) return 0;
  if(1==memcmp(a->fname, b->fname, sizeof(a->fname))) return 1;
  return 0;
}

//---------------------------------------------------------------------------

void sort(FileInfo* low, FileInfo* high) {
  FileInfo *i, *j, *x;
  FileInfo *st_[SORT_STACK_MAX*2], **st = st_;
  uchar stc = 0;
  while(1) {
    i = low;
    j = high;
    x = low + (high-low)/2;
    while(1) {
      while(0!=cmpFileInfo(x, i)) i++;
      while(0!=cmpFileInfo(j, x)) j--;
      if(i <= j) {
        memswap(i, j, sizeof(FileInfo));
        if(x==i) x=j; else if(x==j) x=i;
        i++; j--;   
      }
      if(j<=i) break;
    }
    if(i < high) {
      if(low < j) if(stc != SORT_STACK_MAX) *st = low, ++st, *st = j, ++st, ++stc;
      low = i; 
      continue;
    }
    if(low < j) { 
      high = j;
      continue; 
    }
    if(stc==0) break;
    --stc, --st, high = *st, --st, low = *st; 
  }
}

//---------------------------------------------------------------------------

void packName(char* buf, char *path) {
  register uchar c, f, i;

  memset(buf, ' ', 11);    

  i = 8;
  f = '.';
  for(;;) {
    c = *path;
    if(c == 0) return;
    ++path;
    if(c == f) { buf += i; i = 3; f = 0; continue; }
    if(i) { *buf = c; ++buf; --i; }
  }                                      
}

//---------------------------------------------------------------------------

void getFiles() {
  FileInfo *f, *st;
  char *n;
  uchar i;
  uint j;
  FileInfo dir;

  // ������ ��������
  fs_hideCursor();
    
  // ���������� ������, �������� � ��� �� ������
  panelA.cnt = 0;
  panelA.offset = 0;
  panelA.cursorX = 0;
  panelA.cursorY = 0;

  f = panelA.files1;

  // ��������� � ������ ������ ������� ..
  if(panelA.path1[0]) {
    memcpy(f, parentDir, sizeof(FileInfo));
    ++f;
    ++panelA.cnt;    
  }

  st = f;
  for(;;) {
    i = fs_findfirst(panelA.path1, f, maxFiles-panelA.cnt);  
    if(i==ERR_MAX_FILES) i=0; //! ������� �� ������
    if(i==0) break;    
    if(panelA.path1[0]==0) return; //! ������� �� ������
    panelA.path1[0] = 0;
  }

  f += fs_low;
  panelA.cnt += fs_low;
 
  for(j=panelA.cnt, f=panelA.files1; j; --j, ++f) { 
    f->fattrib &= 0x7F;
    n=f->fname;
    for(i=12; i; --i, ++n)
      if((uchar)*n>='a' && (uchar)*n<='z')
        *n = *n-('a'-'A');
  }

  if(panelA.cnt > 1)
    sort(st, ((FileInfo*)panelA.files1) + (panelA.cnt-1));
}

//---------------------------------------------------------------------------

void selectFile(char* sfile) {
  register ushort l;
  FileInfo* f;
  for(l=0, f=panelA.files1; l<panelA.cnt; ++l, ++f) {
    if(0==memcmp(f->fname, sfile, 11)) {
      // �������. ���� ������ ����� �� ����� ������, �������� ������.
      if(l>=2*rowsCnt) {
        panelA.offset = l-rowsCnt-(l%rowsCnt);
        l-=panelA.offset;
      }
      // ������������ ������
      panelA.cursorX = l/rowsCnt;
      panelA.cursorY = op_div16_mod;
      break;
    }
  }
}

//---------------------------------------------------------------------------
// ������������� ������ ������

void reloadFiles(char* sfile) {  
  // ���������� ���� � ���������
  drawPanelTitle(1, panelA.path1);
  drawCmdLineWithPath();

  // ��������� ������ ������
  getFiles();

  // ���������� ���� � ��������� � ��� ������ (��� ����� ���������)
  drawPanelTitle(1, panelA.path1);   
  drawCmdLineWithPath();

  // ���� � ����� ���� � ������ �� ���� ������
  if(sfile) {
    selectFile(sfile);
  }

  // �������������� ��������� ���������
  drawFilesCount();
  drawFiles();
  showFileCursorAndDrawFileInfo();
 
  // ���������� ���������� ������ //! �������� �� ����
  drawCmdLine(); 
}

//---------------------------------------------------------------------------
// ������������� ������������� ���� � ����������

char absolutePath(char* str) {
  uint l;

  // �� ��� ����������
  if(str[0] == '/') {
    strcpy(str, str+1);
    return 1;
  }

  // ����� ����
  l = strlen(panelA.path1);

  // ���� ��� �� �������� �����, ���������� ����� ��� ����������� /
  if(l != 0) l++;

  // �������� ������������
  if(strlen(str) + l >= 255) return 0;

  // ��������� � ��� ������
  memcpy_back(str+l, str, strlen(str)+1);
  memcpy(str, panelA.path1, l);

  // ���� ��� �� �������� �����, ��������� ����������� /
  if(l != 0) str[l-1] = '/';

  return 1;
}

//---------------------------------------------------------------------------

const char* getName(const char* name) {
  const char* p;
  for(p = name; *p; p++)
    if(*p == '/')
      name = p+1;
  return name;
}

//---------------------------------------------------------------------------
// ����� �� �����

void dropPathInt(char* src, char* preparedName) {
  char *p;

  // �������� �� ���� ��������� �����
  p = getname(src);

  // ��������� ��� ����� �� ������� �����
  if(preparedName) packName(preparedName, p);

  // ������� ��������� �����
  if(p != src) --p;
  *p = 0;
}

//---------------------------------------------------------------------------
// ����� �� �����

void dropPath() {
  char buf[11]; 
  dropPathInt(panelA.path1, buf);
  reloadFiles(buf);
}

//---------------------------------------------------------------------------
// ����������� ������� �����

void cursor_left() {
  if(panelA.cursorX) { 
    --panelA.cursorX; 
  } else
  if(panelA.offset) { 
    if(rowsCnt > panelA.offset) { 
      panelA.offset = 0; 
      drawFiles();
    } else {
      panelA.offset -= rowsCnt;
      drawFiles();
    }
  } else
  if(panelA.cursorY) {
    panelA.cursorY = 0; 
  }

  showFileCursorAndDrawFileInfo();
}

//---------------------------------------------------------------------------
// ����������� ������� ������

void cursor_right() {
  uint w;

  // ������������ ������ ������
  w = panelA.offset + panelA.cursorY + panelA.cursorX*22;
  if(w + rowsCnt >= panelA.cnt) { //! ���������� > � >=
    // ��� ��������� ����
    if(w + 1 >= panelA.cnt) { 
      return;
    }
    // ��������� ��������� �� Y
    panelA.cursorY = panelA.cnt - (panelA.offset + panelA.cursorX*rowsCnt + 1);
    // ������������ ������
    if(panelA.cursorY > rowsCnt-1) {
      panelA.cursorY -= rowsCnt;
      if(panelA.cursorX == 1) { 
        panelA.offset += rowsCnt;
        drawFiles();
      } else {
        panelA.cursorX++; 
      }
    }
  } else
  if(panelA.cursorX == 1) { 
    panelA.offset += rowsCnt;
    drawFiles();
  } else {
    panelA.cursorX++;
  }

  showFileCursorAndDrawFileInfo();
}

//---------------------------------------------------------------------------
// ����������� ������� �����

void cursor_up() {
  if(panelA.cursorY) { 
    --panelA.cursorY;
  } else        
  if(panelA.cursorX) { 
    --panelA.cursorX;
    panelA.cursorY = rowsCnt-1; 
  } else        
  if(panelA.offset) {
    --panelA.offset; 
    drawFiles();
  }

  showFileCursorAndDrawFileInfo();
}

//---------------------------------------------------------------------------
// ����������� ������� ����

void cursor_down() {
  if(panelA.offset + panelA.cursorX*rowsCnt + panelA.cursorY + 1 >= panelA.cnt) return;

  if(panelA.cursorY < rowsCnt-1) {
    ++panelA.cursorY;
  } else        
  if(panelA.cursorX == 0) {
    panelA.cursorY = 0;
    ++panelA.cursorX; 
  } else { 
    ++panelA.offset; 
    drawFiles();
  }

  showFileCursorAndDrawFileInfo();
}

//---------------------------------------------------------------------------
// ��������� �������� ������

void cmd_tab() {
  hideFileCursor();
  drawPanelTitle(0, panelA.path1);
  swapPanels();
  showFileCursor();
  drawPanelTitle(1, panelA.path1);
  drawCmdLineWithPath();
}

//---------------------------------------------------------------------------
// ������ ��� ������

void runCmdLine() {
  register char *cmdLine2;

  // �������������� �������������� ���� � ����������
  if(!absolutePath(cmdline)) return;

  // ���������� ��� ������ �� ������� �������
  cmdLine2 = strchr(cmdLine, ' ');
  if(cmdLine2) {
    *cmdLine2 = 0;
    ++cmdLine2;
  } else {
    cmdLine2 = "";
  }

  // ������
  run(cmdLine, cmdLine2);
}

//---------------------------------------------------------------------------

void dupFiles(uchar reload) {
  swapPanels();
  // ���� ���� ����������, �� ������ �������� ������ ������
  if(0==strcmp(panelA.path1, panelB.path1)) {
    memcpy(panelA.files1, panelB.files1, maxFiles*sizeof(FileInfo));
    panelA.cnt = panelB.cnt;    
  } else {
    // ����� ����� ���������
    if(reload) getFiles();
  }
  // ���� ������ �� ��������� ������
  getSel();
  swapPanels();
}

//---------------------------------------------------------------------------

void loadState() {
  uint i;
  i = strlen(fs_selfName);
  if(i < 4) return;
  i -= 3;
  if(0 != strcmp(fs_selfName + i, ".RK")) return;
  strcpy(fs_selfName + i, ".IN");

  if(fs_open(fs_selfName)) return;
  fs_read(cmdline, 12);
  if(cmdline[11]) swapPanels();
  fs_read(panelA.path1, 256); panelA.path1[255] = 0;
  fs_read(panelB.path1, 256); panelB.path1[255] = 0;
}

//---------------------------------------------------------------------------

void saveState() {
  if(fs_create(fs_selfName) && fs_open(fs_selfName)) return;
  fs_write(getSel()->fname, 11);
  fs_write(&activePanel, 1);
  fs_write(panelA.path1, 256);
  fs_write(panelB.path1, 256);
}

//---------------------------------------------------------------------------
// ��������� ���������. � ������ ������ ������� ������ �� �����, � �����
// �������� ��� ������ � ������������ �����

void run(const char* prog, const char* cmdLine) {
  saveState();
  drawError(prog, fs_exec(prog, cmdLine)); 
  drawScreen(); // ��� ���������� ������� ��� ������
}

//---------------------------------------------------------------------------

void cmd_editview(char* app) {
  FileInfo* f = getSel();
  if(f->fattrib & 0x10) return;
  unpackName(cmdLine, f->fname);
  if(!absolutePath(cmdLine)) {
    drawScreen();
    return;
  }
  run(app, cmdLine);
}

//---------------------------------------------------------------------------

void cmd_enter() {
  char *d, i;
  FileInfo* f;
  uint l, o;

  // ������ ��� ������
  if(cmdLine[0]) {
    runCmdLine(); // ������� ����������� �����
    return;
  }

  // ��������� ����
  f = getSelNoBack();

  // ����� �� �����
  if(f == 0) { 
    dropPath(); 
    return; 
  }

  // �������� ������ ��� �����
  unpackName(cmdLine, f->fname);
  if(!absolutePath(cmdLine)) { drawScreen(); return; }

  // ������ � �����
  if((f->fattrib & 0x10) != 0) { 
    strcpy(panelA.path1, cmdline);
    cmdline[0] = 0;
    reloadFiles(0);
    return;
  }
  
  // ��������� ����
  run(cmdline, "");
}  

//---------------------------------------------------------------------------

void cmd_esc() {
  if(cmdLine[0]) {
     cmdline[0] = 0;
     drawCmdLine();
     return;
  }
  dropPath();
}

//---------------------------------------------------------------------------

void cmd_inverseOne() {
  FileInfo* f = getSelNoBack();
  if(!f) return;
  f->fattrib ^= 0x80;
  drawFile(panelA.cursorX, panelA.cursorY, f);
  cursor_down();
}

//---------------------------------------------------------------------------

void cmd_inverseAll() {
  FileInfo* f;
  uint i;
  for(f = panelA.files1, i = panelA.cnt; i; --i, ++f) {
    if(f->fattrib & 0x10) {
      f->fattrib &= 0x7F;
    } else {
      f->fattrib ^= 0x80;
    }
  }
  drawFiles();
  showFileCursor();
}

//---------------------------------------------------------------------------
// ������� ���������

void main() {
  register uchar c;

  // ������������� �������� ������� (���� � ��������� ������ ��������)
  fs_init();

  // ������������� ������
  maxFiles = fs_getMemTop() - START_FILE_BUFFER;
  maxFiles /= sizeof(FileInfo)*2;
  panelA.files1 = ((FileInfo*)START_FILE_BUFFER);
  panelB.files1 = ((FileInfo*)START_FILE_BUFFER)+maxFiles;

  // ���� �� ���������
  panelA.path1[0] = 0;
  panelB.path1[0] = 0;

  // ������ ��� ������
  cmdline[0] = 0;
  
  // �������������� ���� �����, ���� ��� ������
  drawInit();  
  drawScreenInt();
  drawCmdLineWithPath();

  // �������� ���������
  loadState();

  // �������� ������ � ����� ������
  getFiles();

  // ������ ������ ����� ������ �����
  dupFiles(1);

  // �������������� ����� ��� ��������
  selectFile(cmdline);
  cmdline[0] = 0;

  // ������� ������ ������ �� �����. ���� ��� ���������, ������� �������������� ��.
  drawScreenInt();
  drawFiles2();
  drawCmdLineWithPath();

  // ����������� ���� ��������� ������
  while(1) {
    c = fs_bioskey(0);

    switch(c) {
      case KEY_F1:    cmd_freespace();         continue;
      case KEY_F2:    cmd_new(0);              continue;
      case KEY_F3:    cmd_editview(viewerApp); continue;
      case KEY_F4:    cmd_editview(editorApp); continue;
      case KEY_ENTER: cmd_enter();             continue;
      case KEY_ESC:   cmd_esc();               continue;
      case KEY_LEFT:  cursor_left();           continue;
      case KEY_RIGHT: cursor_right();          continue; 
      case KEY_DOWN:  cursor_down();           continue;
      case KEY_UP:    cursor_up();             continue; 
      case KEY_TAB:   cmd_tab();               continue; 
    }    

    // ������� ������ ��� ������ ��� ������
    if(!cmdLine[0]) {
      switch(c) {
        case '1': cmd_freespace();         continue;
        case '2': cmd_new(0);              continue;
        case '3': cmd_editview(viewerApp); continue;
        case '4': cmd_editview(editorApp); continue;
        case '%': cmd_copymove(1, 1);      continue;
        case '5': cmd_copymove(1, 0);      continue;
        case '&': cmd_copymove(0, 1);      continue;
        case '6': cmd_copymove(0, 0);      continue;
        case '7': cmd_new(1);              continue;
        case '8': cmd_delete();            continue;
        case ' ': cmd_inverseOne();        continue;
        case ':': cmd_inverseAll();        continue; // *
        case ';': cmd_sel(1);              continue; // +
        case '-': cmd_sel(0);              continue;
      }                   
    }

    // ����� ������� � ��� ������
    processInput(c);
    drawCmdLine();
  }
}