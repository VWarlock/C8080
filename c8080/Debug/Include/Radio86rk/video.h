// ����� ������-�������� �������� �������. ������������� �������� radio86rkInitVideo 

extern uchar* radio86rkVideoMem @ "radio86rk/radio8screenvars.c";

// ���������� ���� � ������. �� ��������� 78. ��� �������� ����� ���� �� 2 �� 94. 

// ������ ����������� ������ ������� �� 78 ��������. �� ��� ������ 64 ������.
// 8 ������ � 6 ��������� ���� ��������� �� ����� ������. 

// ������ 6 ��������� ����� ����� ������� ���� �������� EOL (0xF1), ������� 
// ���������� ����������������� ��� ����� ������. ��� ������������� ���������
// ��������� ����� ������ �� 7 ����.

// ������� ��������� (����� ������������ ���� � ��������) �� ��������� �� ����� �
// ����������� ����� ������ � ������. ��� �� ����� ������ ���� ���������, 
// ������ ������������ EOL. �� ��� ����� ������ 78 ���� ���������� ����� 
// 6 ������ �� �����.

// ��� ��������� � ������ ���������� ���-�� ���������. ��� 16 ��������� ����� ������
// ����� 94 �����. ������, 16 ���������� (������� EOL) �� ������ ��� �������� 
// �����������.

// ���� �� ���������� EOL, �� �������� ����� 15 ������. �� ����� ������ 
// ���������� 8+64+15 = 87 ����

extern uchar radio86rkVideoBpl @ "radio86rk/radio8screenvars.c";

// ��������� �����������

void radio86rkScreen0 () @ "radio86rk/radio8screen0.c";  // 64x25, ������� ��� ������,  BPL@78, ��� EOL, � ����������� ��������, ��� ��������, ��������� � ���������
void radio86rkScreen0b() @ "radio86rk/radio8screen0b.c"; // 64x25, 0-5 ������� �������, BPL@78, EOL, � ����������� ��������, ��� ��������, ��������� � ���������	
void radio86rkScreen1 () @ "radio86rk/radio8screen1.c";  // 64x25, ������� ��� ������,  BPL@78, ��� EOL, ��������� � ���������, ��� ��������
void radio86rkScreen1b() @ "radio86rk/radio8screen1b.c"; // 64x25, 0-5 ������� �������, BPL@78, EOL, ��������� � ���������, ��� ��������
void radio86rkScreen2a() @ "radio86rk/radio8screen2a.c"; // 64x30, ������� ��� ������,  BPL@75, EOL
void radio86rkScreen2b() @ "radio86rk/radio8screen2b.c"; // 64x30, 0-5 ������� �������, BPL@78, EOL, ���������� �������� ���
void radio86rkScreen2c() @ "radio86rk/radio8screen2c.c"; // 64x30, 16  ������� �������, BPL@94, ��� EOL, ���������� �������� ���

// ������� ������ ������ �� �����

void print(uchar x, uchar y, char* text)              @ "radio86rk/print.c";
void print2(uchar* a, char* text)                     @ "radio86rk/print2.c";
void printn(uchar x, uchar y, uchar len, char* text)  @ "radio86rk/printn.c";
void print2n(uchar* a, uchar len, char* text)         @ "radio86rk/print2n.c";
void printm(uchar x, uchar y, uchar len, char* text)  @ "radio86rk/printm.c";
void print2m(uchar* a, uchar len, char* text)         @ "radio86rk/print2m.c";
void printcn(uchar x, uchar y, uchar len, char c)     @ "radio86rk/printcn.c";
void print2cn(uchar* a, uchar len, char c)            @ "radio86rk/print2cn.c";
uchar* charAddr(uchar x, uchar y)                     @ "radio86rk/charAddr.c";
void directCursor(uchar x, uchar y)                   @ "radio86rk/directCursor.c";

// �������� ���

void waitHorzSync()                                  @ "radio86rk/waithorzsync.c";
