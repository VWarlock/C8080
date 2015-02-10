// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

char fs_bioskey(char c);
void fs_hideCursor();
void fs_initScreen();
void fs_clearScreen();
void fs_print(uchar x, uchar y, uchar len, char* text, char spc);
char* fs_window();
void fs_cursor(uchar x, uchar y);
uint fs_getMemTop();
extern uchar fs_screenWidth, fs_screenHeight, fs_colors;

extern uchar activePanel, rowsCnt;
extern uchar onePanel;

void drawInit();
void drawSwapPanels();
void hideFileCursor();
void showFileCursor();
void drawScreenInt();
void drawFile(uchar x, uchar y, FileInfo* f);
void drawPanelTitle(uchar active, char* title);
void drawColumn(uchar i);
void drawFileInfo1(char* buf);
void drawFileInfoDir();
void drawFileInfo2(char* buf);
void drawCmdLine();
void drawCmdLineWithPath();
void drawWindow(const char* title);
void drawAnyKeyButton();
void drawEscButton();
void drawWindowText(uchar ox, uchar oy, char* text);
void drawWindowProgress(uchar ox, uchar oy, uchar n, char chr);
void drawInput(uchar x, uchar y, uchar max);
void drawFilesCountInt(ulong* total, uint filesCnt);
void drawWindowInput(uchar x, uchar y, uchar max);
void drawWindowTextCenter(uchar x, char* text);

// Коды клавиш

#define KEY_F1    0
#define KEY_F2    1
#define KEY_F3    2
#define KEY_F4    3
#define KEY_LEFT  8
#define KEY_TAB   9
#define KEY_ENTER 13
#define KEY_ESC   27
#define KEY_RIGHT 0x18
#define KEY_UP    0x19
#define KEY_DOWN  0x1A
#define KEY_STR   0x1F
#define KEY_SPACE 0x20
#define KEY_BKSPC 0x7F
