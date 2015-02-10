// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include "shell.h"
#include "interface.h"

void swapPanels(); // Надо убрать

uchar activePanel, activePanelN, activePanel0;
uchar fileCursorX, fileCursorY;
uchar windowX, windowY;
uchar onePanel;
char* window;

//---------------------------------------------------------------------------

void drawInit() {
  fs_initScreen();
  window = fs_window();
  rowsCnt = fs_screenHeight - 8;
  fileCursorX = 0;
  fileCursorY = 0;  
  windowX = (fs_screenWidth - 32) / 2;
  windowY = (fs_screenHeight - 10) / 2;
  onePanel = fs_screenWidth < 64;
  activePanel0 = onePanel ? 0 : (fs_screenWidth - 31 * 2) / 2;
  activePanel = activePanel0;
}

//---------------------------------------------------------------------------

void drawRect(uchar x, uchar y, uchar w, uchar h, uchar bg) {
  uchar x1;
  if(w <= 1) {
    for(;h > 0; --h,++y)
      fs_print(x,y,1,"",window[0]);
    return;
  }
  if(h <= 1) {
    fs_print(x,y,w,"",window[1]);
    return;
  }
  x1 = x + w - 1;
  w -= 2, h -= 2;
  fs_print(x,y,1,"\x04",window[2]);
  if(w > 0) fs_print(x+1,y,w,"",window[3]);
  fs_print(x1,y,1,"\x10",window[4]);
  ++y;
  for(;h != 0; --h, ++y) {
    fs_print(x, y, 1, "",window[5]);
    if(bg) fs_print(x+1,y,w,"",' ');
    fs_print(x1, y, 1, "",window[6]);
  }
  fs_print(x,y,1,"",window[7]);
  if(w > 0) fs_print(x+1,y,w,"",window[8]);
  fs_print(x1,y,1,"",window[9]);
}

//---------------------------------------------------------------------------

void drawSwapPanels() {
  if(activePanelN) activePanelN=0, activePanel-=31;
              else activePanelN=1, activePanel+=31;
}

//---------------------------------------------------------------------------
// Скрыть курсор

void hideFileCursor() {
  if(!fileCursorX) return;
  fs_print(fileCursorX, fileCursorY, 1, " ", 0);
  fs_print(fileCursorX + 13, fileCursorY, 1, " ", 0);
  fileCursorX = 0;
}

//---------------------------------------------------------------------------

void showFileCursor() {
  // Скрыть прошлый курсор
  hideFileCursor();
  
  // Адрес нового курсора в видеопамяти
  fileCursorX = panelA.cursorX*15 + 1 + activePanel, fileCursorY = 2 + panelA.cursorY;
  fs_print(fileCursorX, fileCursorY, 1, "[", 0);
  fs_print(fileCursorX + 13, fileCursorY, 1, "]", 0);
}

//---------------------------------------------------------------------------

void drawFilesCountInt(ulong* total, uint filesCnt) { 
  uchar v, x, y;
  char buf[12];
  x = 1 + activePanel; y = 4 + rowsCnt;

  i2s32(buf, total, 10, ' ');
  fs_print(x, y, 12, buf, 0);

  fs_print(x+11, y, 12, "bajt w    ", 0);

  if(filesCnt < 1000) {
    i2s(buf, filesCnt, 3, ' ');
    fs_print(x + 18, y, 3, buf, 0);
  }

  v = filesCnt % 100;
  fs_print(x + 22, y, 16, (!(v >= 10 && v < 20) && v % 10 == 1) ? "fajle " : "fajlah ", 0);
}

//---------------------------------------------------------------------------

void drawPanel() { 
  drawRect(activePanel, 0, 31, rowsCnt + 6, 0);
  drawRect(activePanel + 1, rowsCnt + 2, 29, 1, 0); // hLine
  drawRect(activePanel + 15, 1, 1, rowsCnt + 1, 0); // vLine
  fs_print(activePanel + 6, 1, 3, "imq", 0);
  fs_print(activePanel + 21, 1, 3, "imq", 0);  
}

//---------------------------------------------------------------------------
// Рисуем весь экран

void drawScreenInt() {
  // Очистка экрана
  fs_clearScreen();

  // Рисуем подсказку    
  fs_print(activePanel0, fs_screenHeight - 1, fs_screenWidth - activePanel0, "1 FREE 2 NEW  3 VIEW  4 EDIT 5 COPY 6 REN  7 DIR  8 DEL", 0); 

  // Рисуем панели
  drawPanel();
  drawPanelTitle(1, panelA.path1);
  if(!onePanel) {
    drawSwapPanels();
    drawPanel();
    drawPanelTitle(0, panelB.path1);
    drawSwapPanels();
  }

  // Курсора нет
  fileCursorX = 0;
}

//---------------------------------------------------------------------------
// Перерисовываем заголовок панели

void drawPanelTitle(uchar active, char* p) {
  ushort l;
  uchar x;

  // Восстанавливаем рамку
  fs_print(activePanel+1, 0, 29, "", window[3]); 

  // Выводим путь по центру
  if(p[0]==0) p = "/";
  l = strlen(p);
  if(l>=27) p=p+(l-27), l=27;
  x = 1 + (30 - l) / 2 + activePanel;
  fs_print(x, 0, l, p, 0);
  if(!active) return;
  fs_print(x-1, 0, 1, "[", 0);
  fs_print(x+l, 0, 1, "]", 0);
}

//---------------------------------------------------------------------------

void drawFile2(uchar x, uchar y, FileInfo* f) {
  char buf[12];
  memcpy(buf, f->fname, 8);
  buf[8] = (f->fattrib&0x80) ? '*' : ((f->fattrib & 0x06) ? 0x7F : ' '); 
  memcpy(buf + 9, f->fname + 8, 3);  
  fs_print(x, y, 12, buf, 0); 
}

//---------------------------------------------------------------------------

void drawColumn(uchar i) {
  uchar y, xx, yy;
  register ushort n = panelA.offset + i * rowsCnt;
  FileInfo* f = panelA.files1 + n;  

  xx = i * 15 + 2 + activePanel; yy = 2;
  for(y=rowsCnt; y; --y, ++yy) {
    if(n>=panelA.cnt) {
      fs_print(xx, yy, 12, "", ' ');
      continue;
    }
    drawFile2(xx, yy, f);
    ++f; ++n;
  }
}

//---------------------------------------------------------------------------

void drawFile(uchar x, uchar y, FileInfo* f) {
  drawFile2(x*15+2+activePanel, 2+y, f);
}

//---------------------------------------------------------------------------
// Вывод информации о файле под курсором. Имя.

void drawFileInfo1(char* buf) {
  fs_print(2+activePanel, rowsCnt+3, 10, buf, ' ');
}

//---------------------------------------------------------------------------

void drawFileInfoDir() {
  drawFileInfo1("     <DIR>");
}

//---------------------------------------------------------------------------
// Вывод информации о файле под курсором. Размер и дата.

void drawFileInfo2(char* buf) {
  fs_print(13+activePanel, rowsCnt+3, 16, buf, ' ');
}

//---------------------------------------------------------------------------
// Рисуем командную строку и путь в ней

void drawCmdLineWithPath() {
  register ushort o, l, old;
  uchar max = fs_screenWidth/2;

  // Выводим только последние 30 символов пути
  fs_print(0, rowsCnt+6, 1, "/", 0);
  l = strlen(panelA.path1);
  if(l>=max) o=l-max, l=max; else o=0;
  fs_print(1, rowsCnt+6, l, panelA.path1+o, 0);
  fs_print(l+1, rowsCnt+6, 1, ">", 0);

  // Сохраняем значение для drawCmdLine
  panelA.cmdLineOff = l+2;

  // Выводим ком строку
  drawCmdLine();
}

//---------------------------------------------------------------------------

void drawWindowTextCenter(uchar y, char* text) {
  fs_print((fs_screenWidth - strlen(text)) >> 1, windowY + y + 2, 64, text, 0);
}

//---------------------------------------------------------------------------
// Рисуем окно

void drawWindow(const char* title) { 
  register uchar i; 
  fs_hideCursor();
  drawRect(windowX, windowY, 32, 9, 1);
  drawWindowTextCenter(-2, title);
}

//---------------------------------------------------------------------------
// Рисуем текст в окне

void drawWindowText(uchar ox, uchar oy, char* text) {
  fs_print(windowX+ox+2, windowY+oy+2, 28-ox, text, 0);
}

//---------------------------------------------------------------------------
// Рисуем кнопку ANY KEY в окне

void drawAnyKeyButton() {
  drawWindowTextCenter(4, "[ ok ]");
}

//---------------------------------------------------------------------------

void drawEscButton() {
  drawWindowTextCenter(4, "[ stop ]");
}

//---------------------------------------------------------------------------
// Рисуем текст в окне

void drawWindowProgress(uchar ox, uchar oy, uchar n, char chr) {
  if(n == 0) return;
  fs_print(windowX+ox+2, windowY+oy+2, n, "", chr);
}

//---------------------------------------------------------------------------

void drawCmdLine() {
  drawInput(panelA.cmdLineOff, rowsCnt+6, fs_screenWidth-panelA.cmdLineOff);
}

//---------------------------------------------------------------------------
// Рисуем поле ввода

void drawInput(uchar x, uchar y, uchar max) {
  register ushort c, c1, old;
  uint cmdline_offset;
  uint cmdline_pos;
 
  cmdline_pos = strlen(cmdline);
  --max;
  if(cmdline_pos < max) cmdline_offset = 0; else cmdline_offset = cmdline_pos-max;
  c1 = cmdline_pos - cmdline_offset;
  cmdline[cmdline_pos] = 0;
  ++c1;
  if(c1 > max) c1 = max;
  ++c1;
  ++max;
  fs_print(x, y, max, cmdline + cmdline_offset, ' ');

  // Устаналиваем курсор
  fs_cursor(x+cmdline_pos-cmdline_offset, y);
}

//---------------------------------------------------------------------------

void drawWindowInput(uchar x, uchar y, uchar max) {
  drawInput(windowX+x+2, windowY+y+2, max);
}