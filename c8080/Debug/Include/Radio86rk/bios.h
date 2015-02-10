// ���� ������

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
#define KEY_SPACE 0x20
#define KEY_BKSPC 0x7F

// BIOS ���������� ��86

char reboot()                                  @ 0xF800;                           // F800 ������������
char getch()                                   @ 0xF803;                           // F803 ���� ������� � ���������� � ���������
char getTape(char syncFlag)                    @ 0xF806;                           // F806 ������ ����� � ����������� (FF - � ������� �����������, 08 - ��� ������ �����������)
void putch(char c)                             @ "radio86rk/putch.c";              // F809 ����� ������� �� �����
void putTape(char c)                           @ "radio86rk/puttape.c";            // F80C ������ ����� �� ����������
char kbhit()                                   @ "radio86rk/kbhit.c";              // F812 ����� ��������� ���������� (FF - �� ���� ������� �� ������)
void puthex(char)                              @ 0xF815;                           // F815 ����� �� ����� 16-������� �����
void puts(const char*)                         @ 0xF818;                           // F818 ����� �� ����� ��������� ������
char bioskey()                                 @ 0xF81B;                           // F81B ����� ��������� ���������� 2 (FF - �� ���� ������� �� ������, FE - ������ ������� ���/���, ����� A - ��� �������)
int  wherexy()                                 @ 0xF81E;                           // F81E ������ ��������� �������(� - ����� �����, L - ����� �������)
char getCharFromCursor()                       @ "radio86rk/getcharfromcursor.c";  // F821 ������ ������� ��� ��������
void loadTape(void* start)                     @ "radio86rk/loadtape.c";           // F824 ������ ����� � ����������� (�� ��� ��������� ������������)
void saveTape(void* start, void* end, int crc) @ "radio86rk/savetape.c";           // F827 ����� ����� �� ����������
int  crcTape(void* start, void* end)           @ "radio86rk/crctape.c";            // F82A ������� ����������� ����� �����
void initVideo()                               @ "radio86rk/initvideo.c";          // F82D ������������� ����������������
int  getMemTop()                               @ 0xF830;                           // F830 ������ ������� ������� ��������� ������
void setMemTop(int)                            @ 0xF833;                           // F833 ��������� ������� ������� ��������� ������

// �������� ����������� ���������� ��

char wherex()                                  @ "radio86rk/wherex.c";             // F81E ��������� ������� �� ��� X @ (char)wherexy()
char wherey()                                  @ "radio86rk/wherey.c";             // F81E ��������� ������� �� ��� Y @ (char)(wherexy()>>8)
void gotoxy(char,char)                         @ "radio86rk/gotoxy.c";             // F809 ����������� ������ � ���������� @ putch(0x1B, 'Y', y+0x20, x+0x20)
void clrscr()                                  @ "radio86rk/clrscr.c";             // F809 �������� ����� = putch(0x1F)
