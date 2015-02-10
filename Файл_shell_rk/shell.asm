.include "stdlib8080.inc"
; --------------------------------------------------------------
main:
  push b
;825 fs_init();
  call fs_init
;828 maxFiles = fs_getMemTop() - START_FILE_BUFFER;
  call fs_getMemTop
  lxi d, -16384
  dad d
;829 maxFiles /= sizeof(FileInfo)*2;
  lxi d, 40
  call op_div16_swap
;830 panelA.files1 = ((FileInfo*)START_FILE_BUFFER);
  shld maxFiles
  lxi h, 16384
;831 panelB.files1 = ((FileInfo*)START_FILE_BUFFER)+maxFiles;
  shld panelA
  lhld maxFiles
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  lxi d, 16384
  dad d
;834 panelA.path1[0] = 0;
  xra a
;835 panelB.path1[0] = 0;
  sta (panelA)+(2)
;838 cmdline[0] = 0;
  sta (panelB)+(2)
;841 drawInit();  
  sta cmdline
  shld panelB
  call drawInit
;842 drawScreenInt();
  call drawScreenInt
;843 drawCmdLineWithPath();
  call drawCmdLineWithPath
;846 loadState();
  call loadState
;849 getFiles();
  call getFiles
;852 dupFiles(1);
  mvi a, 1
  call dupFiles
;855 selectFile(cmdline);
  lxi h, cmdline
  call selectFile
;856 cmdline[0] = 0;
  xra a
;859 drawScreenInt();
  sta cmdline
  call drawScreenInt
;860 drawFiles2();
  call drawFiles2
;861 drawCmdLineWithPath();
  call drawCmdLineWithPath
;864 while(1) {
l143:
;864 {
  xra a
  call fs_bioskey
;867 switch(c) {
  mov b, a
  ora a
  jz l145
  dcr a
  jz l146
  dcr a
  jz l147
  dcr a
  jz l148
  sui 5
  jz l151
  dcr a
  jz l155
  sui 4
  jz l149
  sui 11
  jz l152
  dcr a
  jz l154
  dcr a
  jz l153
  dcr a
  jz l150
  jmp l144
;868 case KEY_F1:    cmd_freespace();         continue;
l145:
;868 cmd_freespace();         continue;
  call cmd_freespace
;868 continue;
  jmp l143
;869 case KEY_F2:    cmd_new(0);              continue;
l146:
;869 cmd_new(0);              continue;
  xra a
  call cmd_new
;869 continue;
  jmp l143
;870 case KEY_F3:    cmd_editview(viewerApp); continue;
l147:
;870 cmd_editview(viewerApp); continue;
  lxi h, viewerApp
  call cmd_editview
;870 continue;
  jmp l143
;871 case KEY_F4:    cmd_editview(editorApp); continue;
l148:
;871 cmd_editview(editorApp); continue;
  lxi h, editorApp
  call cmd_editview
;871 continue;
  jmp l143
;872 case KEY_ENTER: cmd_enter();             continue;
l149:
;872 cmd_enter();             continue;
  call cmd_enter
;872 continue;
  jmp l143
;873 case KEY_ESC:   cmd_esc();               continue;
l150:
;873 cmd_esc();               continue;
  call cmd_esc
;873 continue;
  jmp l143
;874 case KEY_LEFT:  cursor_left();           continue;
l151:
;874 cursor_left();           continue;
  call cursor_left
;874 continue;
  jmp l143
;875 case KEY_RIGHT: cursor_right();          continue; 
l152:
;875 cursor_right();          continue; 
  call cursor_right
;875 continue; 
  jmp l143
;876 case KEY_DOWN:  cursor_down();           continue;
l153:
;876 cursor_down();           continue;
  call cursor_down
;876 continue;
  jmp l143
;877 case KEY_UP:    cursor_up();             continue; 
l154:
;877 cursor_up();             continue; 
  call cursor_up
;877 continue; 
  jmp l143
;878 case KEY_TAB:   cmd_tab();               continue; 
l155:
;878 cmd_tab();               continue; 
  call cmd_tab
;878 continue; 
  jmp l143
l144:
;882 if(!cmdLine[0]) {
  lda cmdline
  ora a
  jnz l181
;882 {
  mov a, b
  sui 32
  jz l167
  sui 5
  jz l161
  dcr a
  jz l163
  sui 7
  jz l170
  sui 4
  jz l157
  dcr a
  jz l158
  dcr a
  jz l159
  dcr a
  jz l160
  dcr a
  jz l162
  dcr a
  jz l164
  dcr a
  jz l165
  dcr a
  jz l166
  sui 2
  jz l168
  dcr a
  jz l169
  jmp l156
;884 case '1': cmd_freespace();         continue;
l157:
;884 cmd_freespace();         continue;
  call cmd_freespace
;884 continue;
  jmp l143
;885 case '2': cmd_new(0);              continue;
l158:
;885 cmd_new(0);              continue;
  xra a
  call cmd_new
;885 continue;
  jmp l143
;886 case '3': cmd_editview(viewerApp); continue;
l159:
;886 cmd_editview(viewerApp); continue;
  lxi h, viewerApp
  call cmd_editview
;886 continue;
  jmp l143
;887 case '4': cmd_editview(editorApp); continue;
l160:
;887 cmd_editview(editorApp); continue;
  lxi h, editorApp
  call cmd_editview
;887 continue;
  jmp l143
;888 case '%': cmd_copymove(1, 1);      continue;
l161:
;888 cmd_copymove(1, 1);      continue;
  mvi a, 1
  sta cmd_copymove_1
  call cmd_copymove
;888 continue;
  jmp l143
;889 case '5': cmd_copymove(1, 0);      continue;
l162:
;889 cmd_copymove(1, 0);      continue;
  mvi a, 1
  sta cmd_copymove_1
  xra a
  call cmd_copymove
;889 continue;
  jmp l143
;890 case '&': cmd_copymove(0, 1);      continue;
l163:
;890 cmd_copymove(0, 1);      continue;
  xra a
  sta cmd_copymove_1
  inr a
  call cmd_copymove
;890 continue;
  jmp l143
;891 case '6': cmd_copymove(0, 0);      continue;
l164:
;891 cmd_copymove(0, 0);      continue;
  xra a
  sta cmd_copymove_1
  call cmd_copymove
;891 continue;
  jmp l143
;892 case '7': cmd_new(1);              continue;
l165:
;892 cmd_new(1);              continue;
  mvi a, 1
  call cmd_new
;892 continue;
  jmp l143
;893 case '8': cmd_delete();            continue;
l166:
;893 cmd_delete();            continue;
  call cmd_delete
;893 continue;
  jmp l143
;894 case ' ': cmd_inverseOne();        continue;
l167:
;894 cmd_inverseOne();        continue;
  call cmd_inverseOne
;894 continue;
  jmp l143
;895 case ':': cmd_inverseAll();        continue; // *
l168:
;895 cmd_inverseAll();        continue; // *
  call cmd_inverseAll
;895 continue; // *
  jmp l143
;896 case ';': cmd_sel(1);              continue; // +
l169:
;896 cmd_sel(1);              continue; // +
  mvi a, 1
  call cmd_sel
;896 continue; // +
  jmp l143
;897 case '-': cmd_sel(0);              continue;
l170:
;897 cmd_sel(0);              continue;
  xra a
  call cmd_sel
;897 continue;
  jmp l143
l156:
l181:
;902 processInput(c);
  mov a, b
  call processInput
;903 drawCmdLine();
  call drawCmdLine
  jmp l143
l142:
  pop b
  ret
; --------------------------------------------------------------
fs_init:
  ret
; --------------------------------------------------------------
fs_getMemTop:
;186 return getMemTop();  
  call 63536
  ret
; --------------------------------------------------------------
drawInit:
;18 fs_initScreen();
  call fs_initScreen
;19 window = fs_window();
  call fs_window
;20 rowsCnt = fs_screenHeight - 8;
  lda fs_screenHeight
  adi 248
;21 fileCursorX = 0;
  sta rowsCnt
  xra a
;22 fileCursorY = 0;  
  sta fileCursorX
;23 windowX = (fs_screenWidth - 32) / 2;
  shld window
  lhld fs_screenWidth
  mvi h, 0
  lxi d, -32
  dad d
  lxi d, 2
  sta fileCursorY
  call op_div16_swap
  mov a, l
;24 windowY = (fs_screenHeight - 10) / 2;
  lhld fs_screenHeight
  mvi h, 0
  lxi d, -10
  dad d
  lxi d, 2
  sta windowX
  call op_div16_swap
  mov a, l
;25 onePanel = fs_screenWidth < 64;
  sta windowY
  lda fs_screenWidth
  cpi 64
  jnc l390
  mvi a, 1
  jmp l391
; label1
l390:
  xra a
; label1
l391:
;26 activePanel0 = onePanel ? 0 : (fs_screenWidth - 31 * 2) / 2;
  ora a
  sta onePanel
  jz l397
  lxi h, 0
  jmp l396
; label1
l397:
  lhld fs_screenWidth
  mvi h, 0
  lxi d, -62
  dad d
  lxi d, 2
  call op_div16_swap
; label1
l396:
  mov a, l
;27 activePanel = activePanel0;
  sta activePanel0
  sta activePanel
  ret
; --------------------------------------------------------------
drawScreenInt:
;124 fs_clearScreen();
  call fs_clearScreen
;127 fs_print(activePanel0, fs_screenHeight - 1, fs_screenWidth - activePanel0, "1 FREE 2 NEW  3 VIEW  4 EDIT 5 COPY 6 REN  7 DIR  8 DEL", 0); 
  lda activePanel0
  sta fs_print_1
  lda fs_screenHeight
  dcr a
  sta fs_print_2
  lda activePanel0
  mov d, a
  lda fs_screenWidth
  sub d
  sta fs_print_3
  lxi h, str45
  shld fs_print_4
  xra a
  call fs_print
;130 drawPanel();
  call drawPanel
;131 drawPanelTitle(1, panelA.path1);
  mvi a, 1
  sta drawPanelTitle_1
  lxi h, (panelA)+(2)
  call drawPanelTitle
;132 if(!onePanel) {
  lda onePanel
  ora a
  jnz l398
;132 {
  call drawSwapPanels
;134 drawPanel();
  call drawPanel
;135 drawPanelTitle(0, panelB.path1);
  xra a
  sta drawPanelTitle_1
  lxi h, (panelB)+(2)
  call drawPanelTitle
;136 drawSwapPanels();
  call drawSwapPanels
l398:
;140 fileCursorX = 0;
  xra a
  sta fileCursorX
  ret
; --------------------------------------------------------------
drawCmdLineWithPath:
  push b
;223 uchar max = fs_screenWidth/2;
  lhld fs_screenWidth
  mvi h, 0
  lxi d, 2
  call op_div16_swap
  mov a, l
;226 fs_print(0, rowsCnt+6, 1, "/", 0);
  sta drawCmdLineWithPath_max
  lda rowsCnt
  adi 6
  sta fs_print_2
  lxi h, str6
  shld fs_print_4
  xra a
  sta fs_print_1
  inr a
  sta fs_print_3
  xra a
  call fs_print
;227 l = strlen(panelA.path1);
  lxi h, (panelA)+(2)
  call strlen
;228 if(l>=max) o=l-max, l=max; else o=0;
  mov b, h
  mov c, l
  xchg
  lhld drawCmdLineWithPath_max
  mvi h, 0
  call op_cmp16
  jz $+6
  jnc l401
;228 o=l-max, l=max; else o=0;
  mvi h, 0
  xchg
  mov h, b
  mov l, c
  call op_sub16_swap
  shld drawCmdLineWithPath_o
  lhld drawCmdLineWithPath_max
  mvi h, 0
  mov b, h
  mov c, l
  jmp l423
l401:
;228 o=0;
  lxi h, 0
  shld drawCmdLineWithPath_o
; label1
l423:
;229 fs_print(1, rowsCnt+6, l, panelA.path1+o, 0);
  lda rowsCnt
  adi 6
  sta fs_print_2
  mov h, b
  mov l, c
  mov a, l
  sta fs_print_3
  lhld drawCmdLineWithPath_o
  lxi d, (panelA)+(2)
  dad d
  shld fs_print_4
  mvi a, 1
  sta fs_print_1
  xra a
  call fs_print
;230 fs_print(l+1, rowsCnt+6, 1, ">", 0);
  mov h, b
  mov l, c
  inx h
  mov a, l
  sta fs_print_1
  lda rowsCnt
  adi 6
  sta fs_print_2
  lxi h, str47
  shld fs_print_4
  mvi a, 1
  sta fs_print_3
  xra a
  call fs_print
;233 panelA.cmdLineOff = l+2;
  lxi h, 2
  dad b
;236 drawCmdLine();
  shld (panelA)+(264)
  call drawCmdLine
  pop b
  ret
; --------------------------------------------------------------
loadState:
  push b
;697 i = strlen(fs_selfName);
  lhld fs_selfName
  call strlen
;698 if(i < 4) return;
  lxi d, 4
  call op_cmp16
  jnc l424
;698 return;
  pop b
  ret
l424:
;699 i -= 3;
  dcx h
  dcx h
  dcx h
;700 if(0 != strcmp(fs_selfName + i, ".RK")) return;
  mov b, h
  mov c, l
  lhld fs_selfName
  dad b
  shld strcmp_1
  lxi h, str64
  call strcmp
  ora a
  jz l427
;700 return;
  pop b
  ret
l427:
;701 strcpy(fs_selfName + i, ".IN");
  lhld fs_selfName
  dad b
  shld strcpy_1
  lxi h, str65
  call strcpy
;703 if(fs_open(fs_selfName)) return;
  lhld fs_selfName
  call fs_open
  ora a
  jz l430
;703 return;
  pop b
  ret
l430:
;704 fs_read(cmdline, 12);
  lxi h, cmdline
  shld fs_read_1
  lxi h, 12
  call fs_read
;705 if(cmdline[11]) swapPanels();
  lda (cmdline)+(11)
  ora a
  jz l431
;705 swapPanels();
  call swapPanels
l431:
;706 fs_read(panelA.path1, 256); panelA.path1[255] = 0;
  lxi h, (panelA)+(2)
  shld fs_read_1
  lxi h, 256
  call fs_read
;706 panelA.path1[255] = 0;
  xra a
;707 fs_read(panelB.path1, 256); panelB.path1[255] = 0;
  lxi h, (panelB)+(2)
  shld fs_read_1
  lxi h, 256
  sta ((panelA)+(2))+(255)
  call fs_read
;707 panelB.path1[255] = 0;
  xra a
  sta ((panelB)+(2))+(255)
  pop b
  ret
; --------------------------------------------------------------
getFiles:
  push b
;387 fs_hideCursor();
  call fs_hideCursor
;390 panelA.cnt = 0;
  lxi h, 0
;391 panelA.offset = 0;
  shld (panelA)+(262)
;392 panelA.cursorX = 0;
  xra a
;393 panelA.cursorY = 0;
  sta (panelA)+(258)
;395 f = panelA.files1;
  shld (panelA)+(260)
  lhld panelA
;398 if(panelA.path1[0]) {
  sta (panelA)+(259)
  lda (panelA)+(2)
  ora a
  mov b, h
  mov c, l
  jz l432
;398 {
  shld memcpy_1
  lxi h, parentDir
  shld memcpy_2
  lxi h, 20
  call memcpy
;400 ++f;
  lxi h, 20
  dad b
;401 ++panelA.cnt;    
  mov b, h
  mov c, l
  lhld (panelA)+(262)
  inx h
  shld (panelA)+(262)
l432:
;404 st = f;
  mov h, b
  mov l, c
;405 for(;;) {
  shld getFiles_st
l120:
l119:
;405 {
  lxi h, (panelA)+(2)
  shld fs_findfirst_1
  mov h, b
  mov l, c
  shld fs_findfirst_2
  lhld (panelA)+(262)
  xchg
  lhld maxFiles
  call op_sub16_swap
  call fs_findfirst
;407 if(i==ERR_MAX_FILES) i=0; //! Âûâåñòè áû îøèáêè
  cpi 10
  jnz l435
;407 i=0; //! Âûâåñòè áû îøèáêè
  xra a
l435:
;408 if(i==0) break;    
  ora a
  sta getFiles_i
  jnz l444
;408 break;    
  jmp l118
l444:
;409 if(panelA.path1[0]==0) return; //! Âûâåñòè áû îøèáêè
  lda (panelA)+(2)
  ora a
  jnz l453
;409 return; //! Âûâåñòè áû îøèáêè
  pop b
  ret
l453:
;410 panelA.path1[0] = 0;
  xra a
  sta (panelA)+(2)
  jmp l120
l118:
;413 f += fs_low;
  lhld fs_low
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  dad b
;414 panelA.cnt += fs_low;
  mov b, h
  mov c, l
  lhld fs_low
  xchg
  lhld (panelA)+(262)
  dad d
;416 for(j=panelA.cnt, f=panelA.files1; j; --j, ++f) { 
  shld (panelA)+(262)
  shld getFiles_j
  lhld panelA
  mov b, h
  mov c, l
l124:
  lhld getFiles_j
  mov a, h
  ora l
  jz l122
;416 { 
  mov h, b
  mov l, c
  lxi d, 11
  dad d
  mov a, m
  ani 127
  mov m, a
;418 n=f->fname;
  mov h, b
  mov l, c
;419 for(i=12; i; --i, ++n)
  mvi a, 12
  sta getFiles_i
  shld getFiles_n
l128:
;420 if((uchar)*n>='a' && (uchar)*n<='z')
  lhld getFiles_n
  mov a, m
  cpi 97
  jc l454
  mov a, m
  cpi 122
  jz $+6
  jnc l454
;421 *n = *n-('a'-'A');
  mov a, m
  adi 224
  mov m, a
l454:
l127:
  lda getFiles_i
  dcr a
  lhld getFiles_n
  inx h
  shld getFiles_n
  sta getFiles_i
  ora a
  jnz l128
l123:
  lhld getFiles_j
  dcx h
  shld getFiles_j
  lxi h, 20
  dad b
  mov b, h
  mov c, l
  jmp l124
l122:
;424 if(panelA.cnt > 1)
  lhld (panelA)+(262)
  lxi d, 1
  call op_cmp16
  jz l1848
  jc l1848
;425 sort(st, ((FileInfo*)panelA.files1) + (panelA.cnt-1));
  lhld getFiles_st
  shld sort_1
  lhld (panelA)+(262)
  dcx h
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  xchg
  lhld panelA
  dad d
  call sort
l1848:
  pop b
  ret
; --------------------------------------------------------------
dupFiles:
;679 swapPanels();
  sta dupFiles_1
  call swapPanels
;681 if(0==strcmp(panelA.path1, panelB.path1)) {
  lxi h, (panelA)+(2)
  shld strcmp_1
  lxi h, (panelB)+(2)
  call strcmp
  ora a
  jnz l1849
;681 {
  lhld panelA
  shld memcpy_1
  lhld panelB
  shld memcpy_2
  lhld maxFiles
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  call memcpy
;683 panelA.cnt = panelB.cnt;    
  lhld (panelB)+(262)
  shld (panelA)+(262)
  jmp l1873
l1849:
;684 {
  lda dupFiles_1
  ora a
  jz l1874
;686 getFiles();
  call getFiles
l1874:
; label1
l1873:
;689 getSel();
  call getSel
;690 swapPanels();
  call swapPanels
  ret
; --------------------------------------------------------------
selectFile:
  push b
;433 for(l=0, f=panelA.files1; l<panelA.cnt; ++l, ++f) {
  lxi b, 0
  shld selectFile_1
  lhld panelA
  shld selectFile_f
l132:
  lhld (panelA)+(262)
  xchg
  mov h, b
  mov l, c
  call op_cmp16
  jnc l130
;433 {
  lhld selectFile_f
  shld memcmp_1
  lhld selectFile_1
  shld memcmp_2
  lxi h, 11
  call memcmp
  ora a
  jnz l1893
;434 {
  lhld rowsCnt
  mvi h, 0
  dad h
  xchg
  mov h, b
  mov l, c
  call op_cmp16
  jc l1901
;436 {
  xchg
  lhld rowsCnt
  mvi h, 0
  call op_mod16
  push h
  lhld rowsCnt
  mvi h, 0
  xchg
  mov h, b
  mov l, c
  call op_sub16_swap
  pop d
  call op_sub16_swap
;438 l-=panelA.offset;
  shld (panelA)+(260)
  xchg
  mov h, b
  mov l, c
  call op_sub16_swap
l1901:
;441 panelA.cursorX = l/rowsCnt;
  mov b, h
  mov c, l
  xchg
  lhld rowsCnt
  mvi h, 0
  call op_div16
  mov a, l
;442 panelA.cursorY = op_div16_mod;
  sta (panelA)+(258)
  lda op_div16_mod
;443 break;
  sta (panelA)+(259)
  jmp l130
l1893:
l131:
  inx b
  lhld selectFile_f
  lxi d, 20
  dad d
  shld selectFile_f
  jmp l132
l130:
  pop b
  ret
; --------------------------------------------------------------
drawFiles2:
;110 drawFiles();
  call drawFiles
;111 drawFilesCount();
  call drawFilesCount
;112 if(!onePanel) {
  lda onePanel
  ora a
  jnz l1902
;112 {
  call swapPanels
;114 drawFiles();
  call drawFiles
;115 drawFilesCount();
  call drawFilesCount
;116 drawFileInfo();
  call drawFileInfo
;117 swapPanels();
  call swapPanels
l1902:
;119 showFileCursorAndDrawFileInfo();
  call showFileCursorAndDrawFileInfo
  ret
; --------------------------------------------------------------
fs_bioskey:
;20 if(c) return bioskey();
  ora a
  sta fs_bioskey_1
  jz l1903
;20 return bioskey();
  call 63515
  ret
l1903:
;21 return getch();
  call 63491
  ret
; --------------------------------------------------------------
cmd_freespace:
  push b
;30 drawWindow(" nakopitelx ");
  lxi h, str17
  call drawWindow
;31 drawWindowText(6, 2, "prowerka...");  
  mvi a, 2
  sta drawWindowText_2
  mvi a, 6
  sta drawWindowText_1
  lxi h, str18
  call drawWindowText
;34 if(e = fs_getfree()) { 
  call fs_getfree
  ora a
  mov b, a
  jz l1904
;34 { 
  lxi h, str19
  shld drawError_1
  call drawError
  jmp l1912
l1904:
;36 {
  mvi a, 2
  sta cmd_freespace_1_1
  lxi h, str20
  call cmd_freespace_1
;41 if(!fs_gettotal()) cmd_freespace_1(1, "wsego:");
  call fs_gettotal
  ora a
  jnz l1913
;41 cmd_freespace_1(1, "wsego:");
  mvi a, 1
  sta cmd_freespace_1_1
  lxi h, str21
  call cmd_freespace_1
l1913:
;44 drawAnyKeyButton();
  call drawAnyKeyButton
;45 fs_bioskey(0);
  xra a
  call fs_bioskey
; label1
l1912:
;48 drawScreen();
  call drawScreen
  pop b
  ret
; --------------------------------------------------------------
cmd_new:
;41 drawError("o{ibka sozdaniq papki", cmd_new1(dir));
  lxi h, str24
  shld drawError_1
  sta cmd_new_1
  call cmd_new1
  call drawError
;43 drawScreen();
  call drawScreen
  ret
; --------------------------------------------------------------
cmd_editview:
  push b
;733 FileInfo* f = getSel();
  shld cmd_editview_1
  call getSel
;734 if(f->fattrib & 0x10) return;
  mov b, h
  mov c, l
  lxi h, 11
  dad b
  mov a, m
  ani 16
  jz l1914
;734 return;
  pop b
  ret
l1914:
;735 unpackName(cmdLine, f->fname);
  lxi h, cmdline
  shld unpackName_1
  mov h, b
  mov l, c
  call unpackName
;736 if(!absolutePath(cmdLine)) {
  lxi h, cmdline
  call absolutePath
  ora a
  jnz l1915
;736 {
  call drawScreen
;738 return;
  pop b
  ret
l1915:
;740 run(app, cmdLine);
  lhld cmd_editview_1
  shld run_1
  lxi h, cmdline
  call run
  pop b
  ret
; --------------------------------------------------------------
cmd_enter:
  push b
;751 if(cmdLine[0]) {
  lda cmdline
  ora a
  jz l1916
;751 {
  call runCmdLine
;753 return;
  pop b
  ret
l1916:
;757 f = getSelNoBack();
  call getSelNoBack
;760 if(f == 0) { 
  mov a, h
  ora l
  jnz l1917
;760 { 
  mov b, h
  mov c, l
  call dropPath
;762 return; 
  pop b
  ret
l1917:
;766 unpackName(cmdLine, f->fname);
  mov b, h
  mov c, l
  lxi h, cmdline
  shld unpackName_1
  mov h, b
  mov l, c
  call unpackName
;767 if(!absolutePath(cmdLine)) { drawScreen(); return; }
  lxi h, cmdline
  call absolutePath
  ora a
  jnz l1918
;767 { drawScreen(); return; }
  call drawScreen
;767 return; }
  pop b
  ret
l1918:
;770 if((f->fattrib & 0x10) != 0) { 
  lxi h, 11
  dad b
  mov a, m
  ani 16
  jz l1919
;770 { 
  lxi h, (panelA)+(2)
  shld strcpy_1
  lxi h, cmdline
  call strcpy
;772 cmdline[0] = 0;
  xra a
;773 reloadFiles(0);
  lxi h, 0
  sta cmdline
  call reloadFiles
;774 return;
  pop b
  ret
l1919:
;778 run(cmdline, "");
  lxi h, cmdline
  shld run_1
  lxi h, str32
  call run
  pop b
  ret
; --------------------------------------------------------------
cmd_esc:
;784 if(cmdLine[0]) {
  lda cmdline
  ora a
  jz l1920
;784 {
  xra a
;786 drawCmdLine();
  sta cmdline
  call drawCmdLine
;787 return;
  ret
l1920:
;789 dropPath();
  call dropPath
  ret
; --------------------------------------------------------------
cursor_left:
;548 if(panelA.cursorX) { 
  lda (panelA)+(258)
  ora a
  jz l1921
;548 { 
  dcr a
  sta (panelA)+(258)
  jmp l1936
l1921:
;551 if(panelA.offset) { 
  lhld (panelA)+(260)
  mov a, h
  ora l
  jz l1937
;551 { 
  xchg
  lhld rowsCnt
  mvi h, 0
  call op_cmp16
  jz l1945
  jc l1945
;552 { 
  lxi h, 0
;554 drawFiles();
  shld (panelA)+(260)
  call drawFiles
  jmp l1953
l1945:
;555 {
  lhld rowsCnt
  mvi h, 0
  xchg
  lhld (panelA)+(260)
  call op_sub16_swap
;557 drawFiles();
  shld (panelA)+(260)
  call drawFiles
; label1
l1953:
  jmp l1958
l1937:
;560 if(panelA.cursorY) {
  lda (panelA)+(259)
  ora a
  jz l1959
;560 {
  xra a
l1959:
  sta (panelA)+(259)
; label1
l1958:
; label1
l1936:
;564 showFileCursorAndDrawFileInfo();
  call showFileCursorAndDrawFileInfo
  ret
; --------------------------------------------------------------
cursor_right:
  push b
;574 w = panelA.offset + panelA.cursorY + panelA.cursorX*22;
  lhld (panelA)+(258)
  mvi h, 0
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad d
  dad h
  push h
  lhld (panelA)+(259)
  mvi h, 0
  xchg
  lhld (panelA)+(260)
  dad d
  pop d
  dad d
;575 if(w + rowsCnt >= panelA.cnt) { //! ïåðåïóòàíû > è >=
  mov b, h
  mov c, l
  lhld rowsCnt
  mvi h, 0
  dad b
  xchg
  lhld (panelA)+(262)
  call op_cmp16
  jz $+6
  jnc l2558
;575 { //! ïåðåïóòàíû > è >=
  xchg
  mov h, b
  mov l, c
  inx h
  call op_cmp16
  jc l2580
;577 { 
  pop b
  ret
l2580:
;581 panelA.cursorY = panelA.cnt - (panelA.offset + panelA.cursorX*rowsCnt + 1);
  lhld rowsCnt
  mvi h, 0
  xchg
  lhld (panelA)+(258)
  mvi h, 0
  call op_mul16
  xchg
  lhld (panelA)+(260)
  dad d
  inx h
  xchg
  lhld (panelA)+(262)
  call op_sub16_swap
  mov a, l
;583 if(panelA.cursorY > rowsCnt-1) {
  mov l, a
  mvi h, 0
  xchg
  lhld rowsCnt
  mvi h, 0
  dcx h
  sta (panelA)+(259)
  call op_cmp16
  jnc l2661
;583 {
  lda rowsCnt
  mov d, a
  lda (panelA)+(259)
  sub d
;585 if(panelA.cursorX == 1) { 
  sta (panelA)+(259)
  lda (panelA)+(258)
  dcr a
  jnz l2683
;585 { 
  lhld rowsCnt
  mvi h, 0
  xchg
  lhld (panelA)+(260)
  dad d
;587 drawFiles();
  shld (panelA)+(260)
  call drawFiles
  jmp l2707
l2683:
;588 {
  lda (panelA)+(258)
  inr a
  sta (panelA)+(258)
; label1
l2707:
l2661:
  jmp l2708
l2558:
;593 if(panelA.cursorX == 1) { 
  lda (panelA)+(258)
  dcr a
  jnz l2709
;593 { 
  lhld rowsCnt
  mvi h, 0
  xchg
  lhld (panelA)+(260)
  dad d
;595 drawFiles();
  shld (panelA)+(260)
  call drawFiles
  jmp l2731
l2709:
;596 {
  lda (panelA)+(258)
  inr a
  sta (panelA)+(258)
; label1
l2731:
; label1
l2708:
;600 showFileCursorAndDrawFileInfo();
  call showFileCursorAndDrawFileInfo
  pop b
  ret
; --------------------------------------------------------------
cursor_down:
;626 if(panelA.offset + panelA.cursorX*rowsCnt + panelA.cursorY + 1 >= panelA.cnt) return;
  lhld (panelA)+(262)
  push h
  lhld rowsCnt
  mvi h, 0
  xchg
  lhld (panelA)+(258)
  mvi h, 0
  call op_mul16
  xchg
  lhld (panelA)+(260)
  dad d
  xchg
  lhld (panelA)+(259)
  mvi h, 0
  dad d
  inx h
  pop d
  call op_cmp16
  rnc
;626 return;
l2732:
;628 if(panelA.cursorY < rowsCnt-1) {
  lhld rowsCnt
  mvi h, 0
  dcx h
  xchg
  lhld (panelA)+(259)
  mvi h, 0
  call op_cmp16
  jnc l3250
;628 {
  lda (panelA)+(259)
  inr a
  sta (panelA)+(259)
  jmp l3293
l3250:
;631 if(panelA.cursorX == 0) {
  lda (panelA)+(258)
  ora a
  jnz l3294
;631 {
  xra a
;633 ++panelA.cursorX; 
  sta (panelA)+(259)
  lda (panelA)+(258)
  inr a
  sta (panelA)+(258)
  jmp l3302
l3294:
;634 { 
  lhld (panelA)+(260)
;636 drawFiles();
  inx h
  shld (panelA)+(260)
  call drawFiles
; label1
l3302:
; label1
l3293:
;639 showFileCursorAndDrawFileInfo();
  call showFileCursorAndDrawFileInfo
  ret
; --------------------------------------------------------------
cursor_up:
;607 if(panelA.cursorY) { 
  lda (panelA)+(259)
  ora a
  jz l3303
;607 { 
  dcr a
  sta (panelA)+(259)
  jmp l3318
l3303:
;610 if(panelA.cursorX) { 
  lda (panelA)+(258)
  ora a
  jz l3319
;610 { 
  dcr a
;612 panelA.cursorY = rowsCnt-1; 
  sta (panelA)+(258)
  lda rowsCnt
  dcr a
  sta (panelA)+(259)
  jmp l3343
l3319:
;614 if(panelA.offset) {
  lhld (panelA)+(260)
  mov a, h
  ora l
  jz l3344
;614 {
;616 drawFiles();
  dcx h
  shld (panelA)+(260)
  call drawFiles
l3344:
; label1
l3343:
; label1
l3318:
;619 showFileCursorAndDrawFileInfo();
  call showFileCursorAndDrawFileInfo
  ret
; --------------------------------------------------------------
cmd_tab:
;646 hideFileCursor();
  call hideFileCursor
;647 drawPanelTitle(0, panelA.path1);
  xra a
  sta drawPanelTitle_1
  lxi h, (panelA)+(2)
  call drawPanelTitle
;648 swapPanels();
  call swapPanels
;649 showFileCursor();
  call showFileCursor
;650 drawPanelTitle(1, panelA.path1);
  mvi a, 1
  sta drawPanelTitle_1
  lxi h, (panelA)+(2)
  call drawPanelTitle
;651 drawCmdLineWithPath();
  call drawCmdLineWithPath
  ret
; --------------------------------------------------------------
cmd_copymove:
;269 drawError(copymode ? "o{ibka kopirowaniq" : "o{ibka pereme}eniq", cmd_copymove1(copymode, shiftPressed));
  sta cmd_copymove_2
  lda cmd_copymove_1
  ora a
  jz l3346
  lxi h, str10
  jmp l3345
; label1
l3346:
  lxi h, str11
; label1
l3345:
  shld drawError_1
  sta cmd_copymove1_1
  lda cmd_copymove_2
  call cmd_copymove1
  call drawError
;270 drawScreen();
  call drawScreen
  ret
; --------------------------------------------------------------
cmd_delete:
  push b
;72 if(confirm(" udalitx ", "wy hotite udalitx fail(y)?")) {
  lxi h, str13
  shld confirm_1
  lxi h, str14
  call confirm
  ora a
  jz l3347
;72 {
  mvi c, 0
;76 if(getFirstSelected(cmdLine)) {
  lxi h, cmdline
  call getFirstSelected
  ora a
  jz l3355
;76 {
l26:
l25:
;77 {
  lxi h, cmdline
  call absolutePath
  ora a
  jnz l3363
;78 { e = ERR_RECV_STRING; break; }
  mvi b, 11
;78 break; }
  jmp l24
l3363:
;81 e = cmd_deleteFile();
  call cmd_deleteFile
;84 if(e == ERR_DIR_NOT_EMPTY) {
  cpi 7
  jnz l3364
;84 {
  mvi c, 1
;86 e = cmd_deleteFolder();
  call cmd_deleteFolder
l3364:
;88 if(e) break;
  ora a
  mov b, a
  jz l3365
;88 break;
  jmp l24
l3365:
;91 if(!getNextSelected(cmdLine)) break;
  lxi h, cmdline
  call getNextSelected
  ora a
  jnz l3374
;91 break;
  jmp l24
l3374:
  jmp l26
l24:
;95 drawError("o{ibka udaleniq", e);
  lxi h, str15
  shld drawError_1
  mov a, b
  call drawError
;98 getFiles();
  call getFiles
;99 dupFiles(needRefresh2);
  mov a, c
  call dupFiles
l3355:
l3347:
;103 drawScreen();
  call drawScreen
  pop b
  ret
; --------------------------------------------------------------
cmd_inverseOne:
  push b
;795 FileInfo* f = getSelNoBack();
  call getSelNoBack
;796 if(!f) return;
  mov a, h
  ora l
  jnz l3375
;796 return;
  pop b
  ret
l3375:
;797 f->fattrib ^= 0x80;
  mov b, h
  mov c, l
  lxi d, 11
  dad d
  mov a, m
  xri 128
  mov m, a
;798 drawFile(panelA.cursorX, panelA.cursorY, f);
  lda (panelA)+(258)
  sta drawFile_1
  lda (panelA)+(259)
  sta drawFile_2
  mov h, b
  mov l, c
  call drawFile
;799 cursor_down();
  call cursor_down
  pop b
  ret
; --------------------------------------------------------------
cmd_inverseAll:
  push b
;807 for(f = panelA.files1, i = panelA.cnt; i; --i, ++f) {
  lhld panelA
  mov b, h
  mov c, l
  lhld (panelA)+(262)
  shld cmd_inverseAll_i
l140:
  lhld cmd_inverseAll_i
  mov a, h
  ora l
  jz l138
;807 {
  mov h, b
  mov l, c
  lxi d, 11
  dad d
  mov a, m
  ani 16
  jz l8510
;808 {
  mov a, m
  ani 127
  mov m, a
  jmp l12212
l8510:
;810 {
  mov h, b
  mov l, c
  lxi d, 11
  dad d
  mov a, m
  xri 128
  mov m, a
; label1
l12212:
l139:
  lhld cmd_inverseAll_i
  dcx h
  shld cmd_inverseAll_i
  lxi h, 20
  dad b
  mov b, h
  mov c, l
  jmp l140
l138:
;814 drawFiles();
  call drawFiles
;815 showFileCursor();
  call showFileCursor
  pop b
  ret
; --------------------------------------------------------------
cmd_sel:
  push b
;33 strcpy(cmdLine, "*.*");
  lxi h, cmdline
  shld strcpy_1
  lxi h, str25
  sta cmd_sel_1
  call strcpy
;34 if(inputBox(" pometitx fajly ")) {
  lxi h, str26
  call inputBox
  ora a
  jz l12213
;34 {
  lxi h, cmd_sel_buf
  shld packName_1
  lxi h, cmdline
  call packName
;37 for(i=panelA.cnt, f=panelA.files1; i; --i, ++f) {
  lhld (panelA)+(262)
  shld cmd_sel_i
  lhld panelA
  mov b, h
  mov c, l
l34:
  lhld cmd_sel_i
  mov a, h
  ora l
  jz l32
;37 {
  mov h, b
  mov l, c
  lxi d, 11
  dad d
  mov a, m
  ani 16
  jz l17348
;38 {
  mov a, m
  ani 127
  mov m, a
  jmp l25391
l17348:
;40 {
  mov h, b
  mov l, c
  shld compareMask_1
  lxi h, cmd_sel_buf
  call compareMask
  ora a
  jz l25392
;41 {
  lda cmd_sel_1
  ora a
  jz l27542
;42 {
  mov h, b
  mov l, c
  lxi d, 11
  dad d
  mov a, m
  ori 128
  mov m, a
  jmp l28060
l27542:
;44 {
  mov h, b
  mov l, c
  lxi d, 11
  dad d
  mov a, m
  ani 127
  mov m, a
; label1
l28060:
l25392:
; label1
l25391:
l33:
  lhld cmd_sel_i
  dcx h
  shld cmd_sel_i
  lxi h, 20
  dad b
  mov b, h
  mov c, l
  jmp l34
l32:
l12213:
;52 drawScreen();
  call drawScreen
  pop b
  ret
; --------------------------------------------------------------
processInput:
  push b
;156 register uint cmdline_pos = strlen(cmdline);
  lxi h, cmdline
  sta processInput_1
  call strlen
;157 if(c==KEY_BKSPC) {
  lda processInput_1
  cpi 127
  mov b, h
  mov c, l
  jnz l28061
;157 {
  mov a, h
  ora l
  jnz l28069
;158 return;
  pop b
  ret
l28069:
;159 --cmdline_pos;    
;160 cmdline[cmdline_pos] = 0;
  dcx h
  lxi d, cmdline
  mov b, h
  mov c, l
  dad d
  mvi m, 0
;161 return;
  pop b
  ret
l28061:
;163 if(c>=32) {
  cpi 32
  jc l28072
;163 {
  lxi d, 255
  call op_cmp16
  jnz l28080
;164 return; 
  pop b
  ret
l28080:
;165 cmdline[cmdline_pos] = c;
  lda processInput_1
  lxi d, cmdline
  dad d
  mov m, a
;166 ++cmdline_pos;
  inx b
;167 cmdline[cmdline_pos] = 0;
  lxi h, cmdline
  dad b
  mvi m, 0
l28072:
  pop b
  ret
; --------------------------------------------------------------
drawCmdLine:
;286 drawInput(panelA.cmdLineOff, rowsCnt+6, fs_screenWidth-panelA.cmdLineOff);
  lda (panelA)+(264)
  sta drawInput_1
  lda rowsCnt
  adi 6
  sta drawInput_2
  lhld (panelA)+(264)
  xchg
  lhld fs_screenWidth
  mvi h, 0
  call op_sub16_swap
  mov a, l
  call drawInput
  ret
; --------------------------------------------------------------
fs_initScreen:
;28 fs_clearScreen();
  call fs_clearScreen
;29 asm { 
 
    ; Íàñòðîéêà ìèêðîñõåì
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
    ; Ïðîãðàììèðîâàíèå êîíòðîëëåðîâ
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
  
;61 fs_screenWidth  = 64;
  mvi a, 64
;62 fs_screenHeight = 30;
  sta fs_screenWidth
  mvi a, 30
;63 fs_colors = 8;    
  sta fs_screenHeight
  mvi a, 8
  sta fs_colors
  ret
; --------------------------------------------------------------
fs_window:
;174 return "\x1B\x1C\x04\x1C\x10\x06\x11\x02\x1C\x01";
  lxi h, str27
  ret
; --------------------------------------------------------------
fs_clearScreen:
;67 asm {
    push b
    ; Ôîðìàòèðîâàíèå âèäåîïàìÿòè
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
  
  ret
; --------------------------------------------------------------
fs_print:
;99 asm {
  sta fs_print_5
    ; Ðàñ÷åò àäðåñà ((uchar*)0xE1D0) + x + y * 78;
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
    
    ; Ðàñ÷åò àäðåñà ((uchar*)0xE1DF) + x + y * 75;
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
  
  ret
; --------------------------------------------------------------
drawPanel:
;112 drawRect(activePanel, 0, 31, rowsCnt + 6, 0);
  lda activePanel
  sta drawRect_1
  lda rowsCnt
  adi 6
  sta drawRect_4
  xra a
  sta drawRect_2
  mvi a, 31
  sta drawRect_3
  xra a
  call drawRect
;113 drawRect(activePanel + 1, rowsCnt + 2, 29, 1, 0); // hLine
  lda activePanel
  inr a
  sta drawRect_1
  lda rowsCnt
  adi 2
  sta drawRect_2
  mvi a, 1
  sta drawRect_4
  mvi a, 29
  sta drawRect_3
  xra a
  call drawRect
;114 drawRect(activePanel + 15, 1, 1, rowsCnt + 1, 0); // vLine
  lda activePanel
  adi 15
  sta drawRect_1
  lda rowsCnt
  inr a
  sta drawRect_4
  mvi a, 1
  sta drawRect_2
  sta drawRect_3
  xra a
  call drawRect
;115 fs_print(activePanel + 6, 1, 3, "imq", 0);
  lda activePanel
  adi 6
  sta fs_print_1
  lxi h, str44
  shld fs_print_4
  mvi a, 1
  sta fs_print_2
  mvi a, 3
  sta fs_print_3
  xra a
  call fs_print
;116 fs_print(activePanel + 21, 1, 3, "imq", 0);  
  lda activePanel
  adi 21
  sta fs_print_1
  lxi h, str44
  shld fs_print_4
  mvi a, 1
  sta fs_print_2
  mvi a, 3
  sta fs_print_3
  xra a
  call fs_print
  ret
; --------------------------------------------------------------
drawPanelTitle:
  push b
;151 fs_print(activePanel+1, 0, 29, "", window[3]); 
  lda activePanel
  inr a
  sta fs_print_1
  shld drawPanelTitle_2
  lxi h, str32
  shld fs_print_4
  xra a
  sta fs_print_2
  mvi a, 29
  sta fs_print_3
  lhld window
  inx h
  inx h
  inx h
  mov a, m
  call fs_print
;154 if(p[0]==0) p = "/";
  lhld drawPanelTitle_2
  xra a
  ora m
  jnz l28089
;154 p = "/";
  lxi h, str6
l28089:
;155 l = strlen(p);
  shld drawPanelTitle_2
  call strlen
;156 if(l>=27) p=p+(l-27), l=27;
  lxi d, 27
  call op_cmp16
  mov b, h
  mov c, l
  jc l28090
;156 p=p+(l-27), l=27;
  lxi h, 65509
  dad b
  xchg
  lhld drawPanelTitle_2
  dad d
  lxi b, 27
  shld drawPanelTitle_2
l28090:
;157 x = 1 + (30 - l) / 2 + activePanel;
  mov h, b
  mov l, c
  lxi d, 30
  call op_sub16
  lxi d, 2
  call op_div16_swap
  inx h
  xchg
  lhld activePanel
  mvi h, 0
  dad d
  mov a, l
;158 fs_print(x, 0, l, p, 0);
  sta fs_print_1
  mov h, b
  mov l, c
  sta drawPanelTitle_x
  mov a, l
  sta fs_print_3
  lhld drawPanelTitle_2
  shld fs_print_4
  xra a
  sta fs_print_2
  call fs_print
;159 if(!active) return;
  lda drawPanelTitle_1
  ora a
  jnz l28171
;159 return;
  pop b
  ret
l28171:
;160 fs_print(x-1, 0, 1, "[", 0);
  lda drawPanelTitle_x
  dcr a
  sta fs_print_1
  lxi h, str39
  shld fs_print_4
  xra a
  sta fs_print_2
  inr a
  sta fs_print_3
  xra a
  call fs_print
;161 fs_print(x+l, 0, 1, "]", 0);
  lhld drawPanelTitle_x
  mvi h, 0
  dad b
  mov a, l
  sta fs_print_1
  lxi h, str40
  shld fs_print_4
  xra a
  sta fs_print_2
  inr a
  sta fs_print_3
  xra a
  call fs_print
  pop b
  ret
; --------------------------------------------------------------
drawSwapPanels:
;62 if(activePanelN) activePanelN=0, activePanel-=31;
  lda activePanelN
  ora a
  jz l28172
;62 activePanelN=0, activePanel-=31;
  xra a
  sta activePanelN
  lda activePanel
  adi 225
  sta activePanel
  jmp l28194
l28172:
;63 activePanelN=1, activePanel+=31;
  mvi a, 1
  sta activePanelN
  lda activePanel
  adi 31
  sta activePanel
; label1
l28194:
  ret
; --------------------------------------------------------------
strlen:
;2 asm { 
  shld strlen_1
 
    lxi d, -1
strlen_l1:
    xra a
    ora m
    inx d
    inx h
    jnz strlen_l1
    xchg
  
  ret
; --------------------------------------------------------------
strcmp:
  push b
;3 while(1) {
  shld strcmp_2
l176:
;3 {
  lhld strcmp_1
  mov a, m
  lhld strcmp_2
  sta strcmp_a
  mov a, m
;5 if(a < b) return 255;
  mov b, a
  lda strcmp_a
  cmp b
  jnc l28195
;5 return 255;
  mvi a, 255
  pop b
  ret
l28195:
;6 if(b < a) return 1;
  cmp b
  jz l28204
  jc l28204
;6 return 1;
  mvi a, 1
  pop b
  ret
l28204:
;7 if(*d==0) return 0;
  lhld strcmp_1
  xra a
  ora m
  jnz l28213
;7 return 0;
  xra a
  pop b
  ret
l28213:
;8 ++d, ++s;
  inx h
  shld strcmp_1
  lhld strcmp_2
  inx h
  shld strcmp_2
  jmp l176
l175:
  pop b
  ret
; --------------------------------------------------------------
strcpy:
;2 asm {
  shld strcpy_2
    ; de = src
    xchg
    ; hl = to
    lhld strcpy_1
strcpy_l1:
    ; *dest = *src
    ldax d
    mov m, a
    ora a
    inx h
    inx d
    jnz strcpy_l1
    dcx h
  
  ret
; --------------------------------------------------------------
fs_open:
;1 { ((ushort*)a)[0] = (b&0xFFFF); ((ushort*)a)[1] = (b>>16); }
  shld fs_open_1
  lxi h, 43392
;1 ((ushort*)a)[1] = (b>>16); }
  shld readEmuSize
  lxi h, 3
;272 return 0;
  xra a
  shld (readEmuSize)+(2)
  ret
; --------------------------------------------------------------
fs_read:
;261 if(((ushort*)&readEmuSize)[1] == 0 && ((ushort*)&readEmuSize)[0] < size) {
  shld fs_read_2
  lhld (readEmuSize)+(2)
  mov a, h
  ora l
  jnz l28214
  lhld fs_read_2
  xchg
  lhld readEmuSize
  call op_cmp16
  jnc l28214
;261 {
  shld fs_low
  jmp l28232
l28214:
;263 {
  lhld fs_read_2
  shld fs_low
; label1
l28232:
;266 sub32_16(&readEmuSize, fs_low);
  lxi h, readEmuSize
  shld sub32_16_1
  lhld fs_low
  call sub32_16
;267 return 0;
  xra a
  ret
; --------------------------------------------------------------
swapPanels:
;56 memswap(&panelA, &panelB, sizeof(Panel));  
  lxi h, panelA
  shld memswap_1
  lxi h, panelB
  shld memswap_2
  lxi h, 266
  call memswap
;57 if(onePanel) {
  lda onePanel
  ora a
  jz l28233
;57 {
  mvi a, 1
  sta drawPanelTitle_1
  lxi h, (panelA)+(2)
  call drawPanelTitle
;59 drawCmdLineWithPath();
  call drawCmdLineWithPath
;60 drawFiles2();
  call drawFiles2
;61 return;
  ret
l28233:
;63 drawSwapPanels();
  call drawSwapPanels
  ret
; --------------------------------------------------------------
fs_hideCursor:
;178 directCursor(255, 255);
  mvi a, 255
  sta directCursor_1
  call directCursor
  ret
; --------------------------------------------------------------
memcpy:
;2 asm {
  shld memcpy_3
    ; if(cnt==0) return
    mov a, h
    ora l
    rz
    ; start
    push b
    ; de = count
    xchg
    ; bc = from
    lhld memcpy_2
    mov c, l
    mov b, h
    ; hl = to
    lhld memcpy_1
    ; enter loop
    inr d
    xra a
    ora e
    jz memcpy_l2
memcpy_l1:
    ; *dest = *src
    ldax b
    mov m, a
    ; dest++, src++
    inx h
    inx b
    ; while(--cnt)
    dcr e
    jnz memcpy_l1
memcpy_l2:
    dcr d
    jnz memcpy_l1
    pop b
  
  ret
; --------------------------------------------------------------
fs_findfirst:
  push b
;195 fs_low = 0;
  shld fs_findfirst_3
  lxi h, 0
;197 xx=0; 
  mvi c, 0
;198 for(;path[i]!=0; i++)
  shld fs_low
l38:
  mov l, b
  mvi h, 0
  xchg
  lhld fs_findfirst_1
  dad d
  xra a
  ora m
  jz l36
;199 if(path[i]=='/')
  mov l, b
  mvi h, 0
  xchg
  lhld fs_findfirst_1
  dad d
  mov a, m
  cpi 47
  jnz l28242
;200 xx++;
  inr c
l28242:
l37:
  inr b
  jmp l38
l36:
;202 if(xx<4)
  mov a, c
  cpi 4
  jnc l28269
;203 for(i=4; i; --i) {
  mvi b, 4
l42:
;203 {
  lhld fs_findfirst_2
  shld memcpy_1
  lxi h, str28
  shld memcpy_2
  lxi h, 11
  call memcpy
;205 i2s(dest[0].fname+6, i, 2, '0');
  lhld fs_findfirst_2
  lxi d, 6
  dad d
  shld i2s_1
  mov l, b
  mvi h, 0
  shld i2s_2
  lxi h, 2
  shld i2s_3
  mvi a, 48
  call i2s
;206 memcpy(dest[0].fname+8, "   ", 3);
  lhld fs_findfirst_2
  lxi d, 8
  dad d
  shld memcpy_1
  lxi h, str29
  shld memcpy_2
  lxi h, 3
  call memcpy
;207 dest[0].fattrib = 0x10;
  lhld fs_findfirst_2
  lxi d, 11
  dad d
  mvi m, 16
;208 dest[0].fsize_l = i;
  inx h
  xchg
  mov l, b
  mvi h, 0
  xchg
  mov m, e
  inx h
  mov m, d
;209 dest[0].fdate = i;
  mov l, b
  mvi h, 0
  push h
  lhld fs_findfirst_2
  lxi d, 18
  dad d
  pop d
  mov m, e
  inx h
  mov m, d
;210 dest[0].ftime = i;
  dcx h
  dcx h
  dcx h
  xchg
  mov l, b
  mvi h, 0
  xchg
  mov m, e
  inx h
  mov m, d
;211 dest++;
  lhld fs_findfirst_2
  lxi d, 20
  dad d
;212 fs_low++;
  shld fs_findfirst_2
  lhld fs_low
  inx h
  shld fs_low
l41:
  dcr b
  xra a
  cmp b
  jnz l42
l28269:
;215 for(i=rand()&31; i; --i) {
  call rand
  ani 31
  mov b, a
l46:
  xra a
  cmp b
  jz l44
;215 {
  lhld fs_findfirst_2
  shld memcpy_1
  lxi h, str30
  shld memcpy_2
  lxi h, 11
  call memcpy
;217 i2s(dest[0].fname+4, i, 2, '0');
  lhld fs_findfirst_2
  lxi d, 4
  dad d
  shld i2s_1
  mov l, b
  mvi h, 0
  shld i2s_2
  lxi h, 2
  shld i2s_3
  mvi a, 48
  call i2s
;218 i2s(dest[0].fname+6, xx, 2, '0');
  lhld fs_findfirst_2
  lxi d, 6
  dad d
  shld i2s_1
  mov l, c
  mvi h, 0
  shld i2s_2
  lxi h, 2
  shld i2s_3
  mvi a, 48
  call i2s
;219 memcpy(dest[0].fname+8, "TXT", 3);
  lhld fs_findfirst_2
  lxi d, 8
  dad d
  shld memcpy_1
  lxi h, str31
  shld memcpy_2
  lxi h, 3
  call memcpy
;220 xx++;
  inr c
;221 dest[0].fattrib = 0;
  lhld fs_findfirst_2
  lxi d, 11
  dad d
  mvi m, 0
;222 dest[0].fsize_l = i;
  inx h
  xchg
  mov l, b
  mvi h, 0
  xchg
  mov m, e
  inx h
  mov m, d
;223 dest[0].fdate = i;
  mov l, b
  mvi h, 0
  push h
  lhld fs_findfirst_2
  lxi d, 18
  dad d
  pop d
  mov m, e
  inx h
  mov m, d
;224 dest[0].ftime = i;
  dcx h
  dcx h
  dcx h
  xchg
  mov l, b
  mvi h, 0
  xchg
  mov m, e
  inx h
  mov m, d
;225 dest++;
  lhld fs_findfirst_2
  lxi d, 20
  dad d
;226 fs_low++;
  shld fs_findfirst_2
  lhld fs_low
  inx h
  shld fs_low
l45:
  dcr b
  jmp l46
l44:
;228 return 0;
  xra a
  pop b
  ret
; --------------------------------------------------------------
sort:
  push b
;329 FileInfo *st_[SORT_STACK_MAX*2], **st = st_;
  shld sort_2
  lxi h, sort_st_
;330 uchar stc = 0;
  xra a
;331 while(1) {
  sta sort_stc
  shld sort_st
l107:
;331 {
  lhld sort_1
;333 j = high;
  shld sort_i
  lhld sort_2
;334 x = low + (high-low)/2;
  mov b, h
  mov c, l
  lhld sort_1
  xchg
  lhld sort_2
  call op_sub16_swap
  lxi d, 20
  call op_div16_swap
  lxi d, 2
  call op_div16_swap
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  xchg
  lhld sort_1
  dad d
;335 while(1) {
  shld sort_x
l109:
;335 {
l111:
  lhld sort_x
  shld cmpFileInfo_1
  lhld sort_i
  call cmpFileInfo
  ora a
  jz l110
;336 i++;
  lhld sort_i
  lxi d, 20
  dad d
  shld sort_i
  jmp l111
l110:
;337 while(0!=cmpFileInfo(j, x)) j--;
l113:
  mov h, b
  mov l, c
  shld cmpFileInfo_1
  lhld sort_x
  call cmpFileInfo
  ora a
  jz l112
;337 j--;
  lxi h, 65516
  dad b
  mov b, h
  mov c, l
  jmp l113
l112:
;338 if(i <= j) {
  mov h, b
  mov l, c
  xchg
  lhld sort_i
  call op_cmp16
  jz $+6
  jnc l28278
;338 {
  shld memswap_1
  mov h, b
  mov l, c
  shld memswap_2
  lxi h, 20
  call memswap
;340 if(x==i) x=j; else if(x==j) x=i;
  lhld sort_i
  xchg
  lhld sort_x
  call op_cmp16
  jnz l28286
;340 x=j; else if(x==j) x=i;
  mov h, b
  mov l, c
  shld sort_x
  jmp l28301
l28286:
;340 if(x==j) x=i;
  mov h, b
  mov l, c
  xchg
  lhld sort_x
  call op_cmp16
  jnz l28302
;340 x=i;
  lhld sort_i
l28302:
  shld sort_x
; label1
l28301:
;341 i++; j--;   
  lhld sort_i
  lxi d, 20
  dad d
;341 j--;   
  shld sort_i
  lxi h, 65516
  dad b
  mov b, h
  mov c, l
l28278:
;343 if(j<=i) break;
  mov h, b
  mov l, c
  xchg
  lhld sort_i
  call op_cmp16
  jc l28311
;343 break;
  jmp l108
l28311:
  jmp l109
l108:
;345 if(i < high) {
  lhld sort_2
  xchg
  lhld sort_i
  call op_cmp16
  jnc l28320
;345 {
  mov h, b
  mov l, c
  xchg
  lhld sort_1
  call op_cmp16
  jnc l28376
;346 if(stc != SORT_STACK_MAX) *st = low, ++st, *st = j, ++st, ++stc;
  lda sort_stc
  cpi 32
  jz l28385
;346 *st = low, ++st, *st = j, ++st, ++stc;
  xchg
  lhld sort_st
  mov m, e
  inx h
  mov m, d
  dcx h
  inx h
  inx h
  shld sort_st
  xchg
  mov h, b
  mov l, c
  xchg
  mov m, e
  inx h
  mov m, d
  lhld sort_st
  inr a
  inx h
  inx h
  shld sort_st
l28385:
  sta sort_stc
l28376:
;347 low = i; 
  lhld sort_i
;348 continue;
  shld sort_1
  jmp l107
l28320:
;350 if(low < j) { 
  xchg
  mov h, b
  mov l, c
  call op_cmp16
  jz l28386
  jc l28386
;350 { 
;352 continue; 
  shld sort_2
  jmp l107
l28386:
;354 if(stc==0) break;
  lda sort_stc
  ora a
  jnz l28387
;354 break;
  jmp l106
l28387:
;355 --stc, --st, high = *st, --st, low = *st; 
  dcr a
  lhld sort_st
  dcx h
  dcx h
  shld sort_st
  sta sort_stc
  mov a, m
  inx h
  mov h, m
  mov l, a
  shld sort_2
  lhld sort_st
  dcx h
  dcx h
  shld sort_st
  mov a, m
  inx h
  mov h, m
  mov l, a
  shld sort_1
  jmp l107
l106:
  pop b
  ret
; --------------------------------------------------------------
getSel:
  push b
;125 uint n = panelA.offset+panelA.cursorY+panelA.cursorX*rowsCnt;
  lhld rowsCnt
  mvi h, 0
  xchg
  lhld (panelA)+(258)
  mvi h, 0
  call op_mul16
  push h
  lhld (panelA)+(259)
  mvi h, 0
  xchg
  lhld (panelA)+(260)
  dad d
  pop d
  dad d
;126 if(n < panelA.cnt) return panelA.files1 + n;
  mov b, h
  mov c, l
  lhld (panelA)+(262)
  xchg
  mov h, b
  mov l, c
  call op_cmp16
  jnc l28414
;126 return panelA.files1 + n;
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  xchg
  lhld panelA
  dad d
  pop b
  ret
l28414:
;127 panelA.offset = 0;
  lxi h, 0
;128 panelA.cursorY = 0;
  xra a
;129 panelA.cursorX = 0;
  sta (panelA)+(259)
;130 if(panelA.cnt != 0) return panelA.files1;
  shld (panelA)+(260)
  lhld (panelA)+(262)
  sta (panelA)+(258)
  mov a, h
  ora l
  jz l28415
;130 return panelA.files1;
  lhld panelA
  pop b
  ret
l28415:
;131 return (FileInfo*)parentDir;
  lxi h, parentDir
  pop b
  ret
; --------------------------------------------------------------
memcmp:
;2 asm {
  shld memcmp_3
    ; if(len==0) return 0;
    mov a, l
    ora h
    rz
    push b
    ; de = len
    xchg
    ; bc = d
    lhld memcmp_1
    mov b, h
    mov c, l
    ; hl = s
    lhld memcmp_2
    ; loop
memcmp_l1:
      ldax b
      cmp m
      jnz memcmp_stop
      inx h
      inx b
      dcx d
      mov a, d
      ora e
    jnz memcmp_l1
    pop b
    ; a=0
    ret
memcmp_stop:
    pop b
    sbb a
    rc
    inr a
    ret
  
  ret
; --------------------------------------------------------------
drawFiles:
;30 hideFileCursor();
  call hideFileCursor
;31 drawColumn(0);
  xra a
  call drawColumn
;32 drawColumn(1);
  mvi a, 1
  call drawColumn
  ret
; --------------------------------------------------------------
drawFilesCount:
  push b
;1 { ((ushort*)a)[0] = (b&0xFFFF); ((ushort*)a)[1] = (b>>16); }
  lxi h, 0
;1 ((ushort*)a)[1] = (b>>16); }
  shld drawFilesCount_total
;43 filesCnt = 0;
  shld (drawFilesCount_total)+(2)
;44 for(p = panelA.files1, i = panelA.cnt; i; ++p, --i) {
  shld drawFilesCount_filesCnt
  lhld panelA
  mov b, h
  mov c, l
  lhld (panelA)+(262)
  shld drawFilesCount_i
l78:
  lhld drawFilesCount_i
  mov a, h
  ora l
  jz l76
;44 {
  lxi h, 11
  dad b
  mov a, m
  ani 16
  jnz l28418
;45 ++filesCnt;
  lhld drawFilesCount_filesCnt
  inx h
  shld drawFilesCount_filesCnt
l28418:
;46 add32_32(&total, &p->fsize);
  lxi h, drawFilesCount_total
  shld add32_32_1
  lxi h, 12
  dad b
  call add32_32
l77:
  lxi h, 20
  dad b
  mov b, h
  mov c, l
  lhld drawFilesCount_i
  dcx h
  shld drawFilesCount_i
  jmp l78
l76:
;49 drawFilesCountInt(&total, filesCnt);
  lxi h, drawFilesCount_total
  shld drawFilesCountInt_1
  lhld drawFilesCount_filesCnt
  call drawFilesCountInt
  pop b
  ret
; --------------------------------------------------------------
drawFileInfo:
  push b
;73 f = getSel();
  call getSel
;75 if(f->fattrib & 0x10) {
  mov b, h
  mov c, l
  lxi h, 11
  dad b
  mov a, m
  ani 16
  jz l28419
;75 {
  call drawFileInfoDir
  jmp l28481
l28419:
;77 {
  lxi h, drawFileInfo_buf
  shld i2s32_1
  lxi h, 12
  dad b
  shld i2s32_2
  lxi h, 10
  shld i2s32_3
  mvi a, 32
  call i2s32
;79 drawFileInfo1(buf);
  lxi h, drawFileInfo_buf
  call drawFileInfo1
; label1
l28481:
;82 if(f->fdate==0 && f->ftime==0) {
  lxi h, 18
  dad b
  mov a, m
  inx h
  mov h, m
  mov l, a
  mov a, h
  ora l
  jnz l28484
  lxi h, 16
  dad b
  mov a, m
  inx h
  mov h, m
  mov l, a
  mov a, h
  ora l
  jnz l28484
;82 {
  xra a
  sta drawFileInfo_buf
  jmp l28646
l28484:
;84 {
  lxi h, drawFileInfo_buf
  shld i2s_1
  lxi h, 18
  dad b
  mov a, m
  inx h
  mov h, m
  mov l, a
  lxi d, 31
  call op_and16
  shld i2s_2
  lxi h, 2
  shld i2s_3
  mvi a, 32
  call i2s
;86 buf[2] = '-';
  mvi a, 45
;87 i2s(buf+3, (f->fdate>>5) & 15, 2, '0');
  lxi h, (drawFileInfo_buf)+(3)
  shld i2s_1
  lxi h, 18
  dad b
  sta (drawFileInfo_buf)+(2)
  mov a, m
  inx h
  mov h, m
  mov l, a
  lxi d, 5
  call op_shr16_swap
  lxi d, 15
  call op_and16
  shld i2s_2
  lxi h, 2
  shld i2s_3
  mvi a, 48
  call i2s
;88 buf[5] = '-';
  mvi a, 45
;89 i2s(buf+6, (f->fdate>>9)+1980, 4, '0');
  lxi h, (drawFileInfo_buf)+(6)
  shld i2s_1
  lxi h, 18
  dad b
  sta (drawFileInfo_buf)+(5)
  mov a, m
  inx h
  mov h, m
  mov l, a
  lxi d, 9
  call op_shr16_swap
  lxi d, 1975
  dad d
  shld i2s_2
  lxi h, 4
  shld i2s_3
  mvi a, 48
  call i2s
;90 buf[10] = ' ';
  mvi a, 32
;91 i2s(buf+11, f->ftime>>11, 2, '0');
  lxi h, (drawFileInfo_buf)+(11)
  shld i2s_1
  lxi h, 16
  dad b
  sta (drawFileInfo_buf)+(10)
  mov a, m
  inx h
  mov h, m
  mov l, a
  lxi d, 11
  call op_shr16_swap
  shld i2s_2
  lxi h, 2
  shld i2s_3
  mvi a, 48
  call i2s
;92 buf[13] = ':';
  mvi a, 58
;93 i2s(buf+14, (f->ftime>>5)&63, 2, '0');
  lxi h, (drawFileInfo_buf)+(14)
  shld i2s_1
  lxi h, 16
  dad b
  sta (drawFileInfo_buf)+(13)
  mov a, m
  inx h
  mov h, m
  mov l, a
  lxi d, 5
  call op_shr16_swap
  lxi d, 63
  call op_and16
  shld i2s_2
  lxi h, 2
  shld i2s_3
  mvi a, 48
  call i2s
; label1
l28646:
;95 drawFileInfo2(buf);
  lxi h, drawFileInfo_buf
  call drawFileInfo2
  pop b
  ret
; --------------------------------------------------------------
showFileCursorAndDrawFileInfo:
;102 showFileCursor();
  call showFileCursor
;103 drawFileInfo();  
  call drawFileInfo
  ret
; --------------------------------------------------------------
drawWindow:
;250 fs_hideCursor();
  shld drawWindow_1
  call fs_hideCursor
;251 drawRect(windowX, windowY, 32, 9, 1);
  lda windowX
  sta drawRect_1
  lda windowY
  sta drawRect_2
  mvi a, 9
  sta drawRect_4
  mvi a, 32
  sta drawRect_3
  mvi a, 1
  call drawRect
;252 drawWindowTextCenter(-2, title);
  mvi a, 254
  sta drawWindowTextCenter_1
  lhld drawWindow_1
  call drawWindowTextCenter
  ret
; --------------------------------------------------------------
drawWindowText:
;259 fs_print(windowX+ox+2, windowY+oy+2, 28-ox, text, 0);
  shld drawWindowText_3
  lhld drawWindowText_1
  mvi h, 0
  xchg
  lhld windowX
  mvi h, 0
  dad d
  inx h
  inx h
  mov a, l
  sta fs_print_1
  lhld drawWindowText_2
  mvi h, 0
  xchg
  lhld windowY
  mvi h, 0
  dad d
  inx h
  inx h
  mov a, l
  sta fs_print_2
  lda drawWindowText_1
  mov d, a
  mvi a, 28
  sub d
  sta fs_print_3
  lhld drawWindowText_3
  shld fs_print_4
  xra a
  call fs_print
  ret
; --------------------------------------------------------------
fs_getfree:
;305 fs_high = 100;
  lxi h, 100
;306 fs_low = 20;
  shld fs_high
  lxi h, 20
;307 return 0; 
  xra a
  shld fs_low
  ret
; --------------------------------------------------------------
drawError:
;178 if(e == 0) return;
  ora a
  sta drawError_2
  rz
;178 return;
l28647:
;181 drawWindow(" o{ibka ");
  lxi h, str50
  call drawWindow
;182 drawAnyKeyButton();
  call drawAnyKeyButton
;183 drawWindowText(0, 0, text);
  xra a
  sta drawWindowText_1
  sta drawWindowText_2
  lhld drawError_1
  call drawWindowText
;186 switch(e) {
  lda drawError_2
  dcr a
  jz l81
  dcr a
  jz l82
  dcr a
  jz l84
  dcr a
  jz l85
  dcr a
  jz l86
  dcr a
  jz l87
  dcr a
  jz l83
  dcr a
  jz l88
  sui 3
  jz l90
  sui 117
  jz l89
  jmp l80
;187 case ERR_NO_FILESYSTEM: text = "net fajlowoj sistemy"; break;
l81:
;187 text = "net fajlowoj sistemy"; break;
  lxi h, str51
;187 break;
  shld drawError_1
  jmp l80
;188 case ERR_DISK_ERR: text = "o{ibka nakopitelq"; break;
l82:
;188 text = "o{ibka nakopitelq"; break;
  lxi h, str52
;188 break;
  shld drawError_1
  jmp l80
;189 case ERR_DIR_NOT_EMPTY: text = "papka ne pusta"; break;
l83:
;189 text = "papka ne pusta"; break;
  lxi h, str53
;189 break;
  shld drawError_1
  jmp l80
;190 case ERR_NOT_OPENED: text = "fajl ne otkryt"; break;
l84:
;190 text = "fajl ne otkryt"; break;
  lxi h, str54
;190 break;
  shld drawError_1
  jmp l80
;191 case ERR_NO_PATH: text = "putx ne najden"; break;
l85:
;191 text = "putx ne najden"; break;
  lxi h, str55
;191 break;
  shld drawError_1
  jmp l80
;192 case ERR_DIR_FULL: text = "maksimum fajlow w papke"; break;
l86:
;192 text = "maksimum fajlow w papke"; break;
  lxi h, str56
;192 break;
  shld drawError_1
  jmp l80
;193 case ERR_NO_FREE_SPACE: text = "disk zapolnen"; break;
l87:
;193 text = "disk zapolnen"; break;
  lxi h, str57
;193 break;
  shld drawError_1
  jmp l80
;194 case ERR_FILE_EXISTS: text = "fail su}estwuet"; break;
l88:
;194 text = "fail su}estwuet"; break;
  lxi h, str58
;194 break;
  shld drawError_1
  jmp l80
;195 case ERR_USER: text = "prerwano polxzowatelem"; break;
l89:
;195 text = "prerwano polxzowatelem"; break;
  lxi h, str59
;195 break;
  shld drawError_1
  jmp l80
;196 case ERR_RECV_STRING: text = "putx bolx{e 255 simwolow"; break;
l90:
;196 text = "putx bolx{e 255 simwolow"; break;
  lxi h, str60
;196 break;
  shld drawError_1
  jmp l80
l80:
;201 drawWindowText(0, 2, text);
  xra a
  sta drawWindowText_1
  mvi a, 2
  sta drawWindowText_2
  lhld drawError_1
  call drawWindowText
;204 fs_bioskey(0);
  xra a
  call fs_bioskey
  ret
; --------------------------------------------------------------
cmd_freespace_1:
;11 i2s32(buf, (ulong*)&fs_low, 10, ' ');
  shld cmd_freespace_1_2
  lxi h, cmd_freespace_1_buf
  shld i2s32_1
  lxi h, fs_low
  shld i2s32_2
  lxi h, 10
  shld i2s32_3
  mvi a, 32
  call i2s32
;14 memcpy_back(buf+10, buf+7, 3); buf[9]  = ' ';
  lxi h, (cmd_freespace_1_buf)+(10)
  shld memcpy_back_1
  lxi h, (cmd_freespace_1_buf)+(7)
  shld memcpy_back_2
  lxi h, 3
  call memcpy_back
;14 buf[9]  = ' ';
  mvi a, 32
;15 memcpy_back(buf+6,  buf+4, 3); buf[5]  = ' ';
  lxi h, (cmd_freespace_1_buf)+(6)
  shld memcpy_back_1
  lxi h, (cmd_freespace_1_buf)+(4)
  shld memcpy_back_2
  lxi h, 3
  sta (cmd_freespace_1_buf)+(9)
  call memcpy_back
;15 buf[5]  = ' ';
  mvi a, 32
;16 memcpy_back(buf+2,  buf+1, 3); buf[1]  = ' ';
  lxi h, (cmd_freespace_1_buf)+(2)
  shld memcpy_back_1
  lxi h, (cmd_freespace_1_buf)+(1)
  shld memcpy_back_2
  lxi h, 3
  sta (cmd_freespace_1_buf)+(5)
  call memcpy_back
;16 buf[1]  = ' ';
  mvi a, 32
;17 strcpy(buf+13, " mb");
  lxi h, (cmd_freespace_1_buf)+(13)
  shld strcpy_1
  lxi h, str16
  sta (cmd_freespace_1_buf)+(1)
  call strcpy
;20 drawWindowText(6, y, text);
  lda cmd_freespace_1_1
  sta drawWindowText_2
  mvi a, 6
  sta drawWindowText_1
  lhld cmd_freespace_1_2
  call drawWindowText
;21 drawWindowText(16, y, buf);
  lda cmd_freespace_1_1
  sta drawWindowText_2
  mvi a, 16
  sta drawWindowText_1
  lxi h, cmd_freespace_1_buf
  call drawWindowText
  ret
; --------------------------------------------------------------
fs_gettotal:
;294 fs_high = 200;
  lxi h, 200
;295 fs_low = 20;
  shld fs_high
  lxi h, 20
;296 return 0; 
  xra a
  shld fs_low
  ret
; --------------------------------------------------------------
drawAnyKeyButton:
;266 drawWindowTextCenter(4, "[ ok ]");
  mvi a, 4
  sta drawWindowTextCenter_1
  lxi h, str48
  call drawWindowTextCenter
  ret
; --------------------------------------------------------------
drawScreen:
;146 cmdline[0] = 0;
  xra a
;147 drawScreenInt();
  sta cmdline
  call drawScreenInt
;148 drawCmdLineWithPath();
  call drawCmdLineWithPath
;149 drawFiles2();
  call drawFiles2
  ret
; --------------------------------------------------------------
cmd_new1:
;8 cmdLine[0] = 0;
  sta cmd_new1_1
  xra a
;11 if(!inputBox(dir ? " sozdatx papku " : " sozdatx fajl ") && cmdline[0]!=0) return 0;
  sta cmdline
  lda cmd_new1_1
  ora a
  jz l28705
  lxi h, str22
  jmp l28704
; label1
l28705:
  lxi h, str23
; label1
l28704:
  call inputBox
  ora a
  jnz l28648
  lda cmdline
  ora a
  jz l28648
;11 return 0;
  xra a
  ret
l28648:
;13 if(!absolutePath(cmdline)) return ERR_RECV_STRING;
  lxi h, cmdline
  call absolutePath
  ora a
  jnz l28714
;13 return ERR_RECV_STRING;
  mvi a, 11
  ret
l28714:
;16 if(!dir) {
  lda cmd_new1_1
  ora a
  jnz l28723
;16 {
  lxi h, cmdline
  call strlen
  lxi d, 255
  call op_cmp16
  jc l28731
;17 return ERR_RECV_STRING;
  mvi a, 11
  ret
l28731:
;20 memcpy_back(cmdline+1, cmdline, 255);
  lxi h, (cmdline)+(1)
  shld memcpy_back_1
  lxi h, cmdline
  shld memcpy_back_2
  lxi h, 255
  call memcpy_back
;21 cmdline[0] = '*';
  mvi a, 42
;24 run(editorApp, cmdLine);
  lxi h, editorApp
  shld run_1
  lxi h, cmdline
  sta cmdline
  call run
;25 return 0;
  xra a
  ret
l28723:
;29 dir = fs_mkdir(cmdline);
  lxi h, cmdline
  call fs_mkdir
;32 if(!dir) {
  ora a
  sta cmd_new1_1
  jnz l28732
;32 {
  call getFiles
;34 dupFiles(0);
  xra a
  call dupFiles
l28732:
;37 return dir;
  lda cmd_new1_1
  ret
; --------------------------------------------------------------
unpackName:
  push b
;255 for(i=0; i!=11; ++i, ++s) {
  mvi b, 0
  shld unpackName_2
l100:
;255 {
  mvi a, 8
  cmp b
  jnz l28733
;256 *d = '.', ++d;
  lhld unpackName_1
  mvi m, 46
  inx h
  shld unpackName_1
l28733:
;257 if(*s!=' ') *d = *s, ++d;
  lhld unpackName_2
  mov a, m
  cpi 32
  jz l28742
;257 *d = *s, ++d;
  mov a, m
  lhld unpackName_1
  mov m, a
  inx h
  shld unpackName_1
l28742:
l99:
  inr b
  lhld unpackName_2
  inx h
  shld unpackName_2
  mvi a, 11
  cmp b
  jnz l100
;259 if(d[-1]=='.') --d;
  lhld unpackName_1
  dcx h
  mov a, m
  cpi 46
  jnz l28823
;259 --d;
  lhld unpackName_1
  dcx h
  shld unpackName_1
l28823:
;260 *d = 0;
  lhld unpackName_1
  mvi m, 0
  pop b
  ret
; --------------------------------------------------------------
absolutePath:
  push b
;484 if(str[0] == '/') {
  mov a, m
  cpi 47
  jnz l28824
;484 {
  shld strcpy_1
  shld absolutePath_1
  inx h
  call strcpy
;486 return 1;
  mvi a, 1
  pop b
  ret
l28824:
;490 l = strlen(panelA.path1);
  shld absolutePath_1
  lxi h, (panelA)+(2)
  call strlen
;493 if(l != 0) l++;
  mov a, h
  ora l
  mov b, h
  mov c, l
  jz l28825
;493 l++;
  inx h
  mov b, h
  mov c, l
l28825:
;496 if(strlen(str) + l >= 255) return 0;
  lhld absolutePath_1
  call strlen
  dad b
  lxi d, 255
  call op_cmp16
  jc l28834
;496 return 0;
  xra a
  pop b
  ret
l28834:
;499 memcpy_back(str+l, str, strlen(str)+1);
  lhld absolutePath_1
  dad b
  shld memcpy_back_1
  lhld absolutePath_1
  shld memcpy_back_2
  call strlen
  inx h
  call memcpy_back
;500 memcpy(str, panelA.path1, l);
  lhld absolutePath_1
  shld memcpy_1
  lxi h, (panelA)+(2)
  shld memcpy_2
  mov h, b
  mov l, c
  call memcpy
;503 if(l != 0) str[l-1] = '/';
  mov h, b
  mov l, c
  mov a, h
  ora l
  jz l28843
;503 str[l-1] = '/';
  dcx h
  xchg
  lhld absolutePath_1
  dad d
  mvi m, 47
l28843:
;505 return 1;
  mvi a, 1
  pop b
  ret
; --------------------------------------------------------------
run:
;725 saveState();
  shld run_2
  call saveState
;726 drawError(prog, fs_exec(prog, cmdLine)); 
  lhld run_1
  shld drawError_1
  shld fs_exec_1
  lhld run_2
  call fs_exec
  call drawError
;727 drawScreen(); // Òàì ïðîèñõîäèò î÷èñòêà êîì ñòðîêè
  call drawScreen
  ret
; --------------------------------------------------------------
runCmdLine:
  push b
;661 if(!absolutePath(cmdline)) return;
  lxi h, cmdline
  call absolutePath
  ora a
  jnz l28844
;661 return;
  pop b
  ret
l28844:
;664 cmdLine2 = strchr(cmdLine, ' ');
  lxi h, cmdline
  shld strchr_1
  mvi a, 32
  call strchr
;665 if(cmdLine2) {
  mov a, h
  ora l
  mov b, h
  mov c, l
  jz l28845
;665 {
  xra a
  stax b
;667 ++cmdLine2;
  inx h
  mov b, h
  mov c, l
  jmp l28853
l28845:
;668 {
  lxi b, str32
; label1
l28853:
;673 run(cmdLine, cmdLine2);
  lxi h, cmdline
  shld run_1
  mov h, b
  mov l, c
  call run
  pop b
  ret
; --------------------------------------------------------------
getSelNoBack:
  push b
;137 FileInfo* f = getSel();
  call getSel
;138 if(f->fname[0] == '.') f = 0;
  mov a, m
  cpi 46
  mov b, h
  mov c, l
  jnz l28854
;138 f = 0;
  lxi b, 0
l28854:
;139 return f;  
  mov h, b
  mov l, c
  pop b
  ret
; --------------------------------------------------------------
dropPath:
;540 dropPathInt(panelA.path1, buf);
  lxi h, (panelA)+(2)
  shld dropPathInt_1
  lxi h, dropPath_buf
  call dropPathInt
;541 reloadFiles(buf);
  lxi h, dropPath_buf
  call reloadFiles
  ret
; --------------------------------------------------------------
reloadFiles:
;453 drawPanelTitle(1, panelA.path1);
  mvi a, 1
  sta drawPanelTitle_1
  shld reloadFiles_1
  lxi h, (panelA)+(2)
  call drawPanelTitle
;454 drawCmdLineWithPath();
  call drawCmdLineWithPath
;457 getFiles();
  call getFiles
;460 drawPanelTitle(1, panelA.path1);   
  mvi a, 1
  sta drawPanelTitle_1
  lxi h, (panelA)+(2)
  call drawPanelTitle
;461 drawCmdLineWithPath();
  call drawCmdLineWithPath
;464 if(sfile) {
  lhld reloadFiles_1
  mov a, h
  ora l
  jz l28855
;464 {
  call selectFile
l28855:
;469 drawFilesCount();
  call drawFilesCount
;470 drawFiles();
  call drawFiles
;471 showFileCursorAndDrawFileInfo();
  call showFileCursorAndDrawFileInfo
;474 drawCmdLine(); 
  call drawCmdLine
  ret
; --------------------------------------------------------------
hideFileCursor:
;70 if(!fileCursorX) return;
  lda fileCursorX
  ora a
  rz
;70 return;
l28856:
;71 fs_print(fileCursorX, fileCursorY, 1, " ", 0);
  sta fs_print_1
  lda fileCursorY
  sta fs_print_2
  lxi h, str38
  shld fs_print_4
  mvi a, 1
  sta fs_print_3
  xra a
  call fs_print
;72 fs_print(fileCursorX + 13, fileCursorY, 1, " ", 0);
  lda fileCursorX
  adi 13
  sta fs_print_1
  lda fileCursorY
  sta fs_print_2
  lxi h, str38
  shld fs_print_4
  mvi a, 1
  sta fs_print_3
  xra a
  call fs_print
;73 fileCursorX = 0;
  xra a
  sta fileCursorX
  ret
; --------------------------------------------------------------
showFileCursor:
;80 hideFileCursor();
  call hideFileCursor
;83 fileCursorX = panelA.cursorX*15 + 1 + activePanel, fileCursorY = 2 + panelA.cursorY;
  lhld (panelA)+(258)
  mvi h, 0
  mov d, h
  mov e, l
  dad h
  dad d
  dad h
  dad d
  dad h
  dad d
  inx h
  xchg
  lhld activePanel
  mvi h, 0
  dad d
  mov a, l
  sta fileCursorX
  lda (panelA)+(259)
  adi 2
;84 fs_print(fileCursorX, fileCursorY, 1, "[", 0);
  sta fileCursorY
  lda fileCursorX
  sta fs_print_1
  lda fileCursorY
  sta fs_print_2
  lxi h, str39
  shld fs_print_4
  mvi a, 1
  sta fs_print_3
  xra a
  call fs_print
;85 fs_print(fileCursorX + 13, fileCursorY, 1, "]", 0);
  lda fileCursorX
  adi 13
  sta fs_print_1
  lda fileCursorY
  sta fs_print_2
  lxi h, str40
  shld fs_print_4
  mvi a, 1
  sta fs_print_3
  xra a
  call fs_print
  ret
; --------------------------------------------------------------
cmd_copymove1:
  push b
;176 if(shiftPressed) {
  ora a
  sta cmd_copymove1_2
  jz l28857
;176 {
  call getSelNoBack
;179 if(!f) return 0; // ” ©« ­¥ ¢ë¡à ­, ¢ëå®¤¨¬ ¡¥§ ®è¨¡ª¨
  mov a, h
  ora l
  jnz l28865
;179 return 0; // ” ©« ­¥ ¢ë¡à ­, ¢ëå®¤¨¬ ¡¥§ ®è¨¡ª¨
  xra a
  pop b
  ret
l28865:
;180 unpackName(cmdLine, f->fname);
  shld cmd_copymove1_f
  lxi h, cmdline
  shld unpackName_1
  lhld cmd_copymove1_f
  call unpackName
  jmp l28874
l28857:
;181 {
  lxi h, (panelB)+(2)
  call strlen
;184 if(i >= 254) return ERR_RECV_STRING; // ’ ª ª ª ¯à¨¡ ¢¨¬ 2 á¨¬¢®« 
  lxi d, 254
  call op_cmp16
  jc l28875
;184 return ERR_RECV_STRING; // ’ ª ª ª ¯à¨¡ ¢¨¬ 2 á¨¬¢®« 
  mvi a, 11
  pop b
  ret
l28875:
;185 cmdLine[0] = '/';
  mvi a, 47
;186 strcpy(cmdline+1, panelB.path1);
  shld cmd_copymove1_i
  lxi h, (cmdline)+(1)
  shld strcpy_1
  lxi h, (panelB)+(2)
  sta cmdline
  call strcpy
;187 if(i != 0) strcpy(cmdline+i+1, "/");
  lhld cmd_copymove1_i
  mov a, h
  ora l
  jz l28876
;187 strcpy(cmdline+i+1, "/");
  lxi d, cmdline
  dad d
  inx h
  shld strcpy_1
  lxi h, str6
  call strcpy
l28876:
; label1
l28874:
;191 if(!inputBox(copymode ? " kopirowatx " : " pereimenowatx/peremestitx ") && cmdline[0]!=0) return 0;
  lda cmd_copymove1_1
  ora a
  jz l29974
  lxi h, str7
  jmp l29973
; label1
l29974:
  lxi h, str8
; label1
l29973:
  call inputBox
  ora a
  jnz l29917
  lda cmdline
  ora a
  jz l29917
;191 return 0;
  xra a
  pop b
  ret
l29917:
;194 if(!absolutePath(cmdline)) return ERR_RECV_STRING;
  lxi h, cmdline
  call absolutePath
  ora a
  jnz l29983
;194 return ERR_RECV_STRING;
  mvi a, 11
  pop b
  ret
l29983:
;197 mask[0] = 0;  
  xra a
;198 name = getname(cmdline);
  lxi h, cmdline
  sta cmd_copymove1_mask
  call getName
;199 if(name[0] != 0) {
  xra a
  ora m
  shld cmd_copymove1_name
  jz l29984
;199 {
  lxi h, cmd_copymove1_mask
  shld packName_1
  lhld cmd_copymove1_name
  call packName
;203 dropPathInt(cmdLine, 0);
  lxi h, cmdline
  shld dropPathInt_1
  lxi h, 0
  call dropPathInt
  jmp l29992
l29984:
;204 {
  lda cmdline
  ora a
  jz l29993
  lhld cmd_copymove1_name
  xra a
  ora m
  jnz l29993
;207 name[-1] = 0;
  dcx h
  mvi m, 0
l29993:
; label1
l29992:
;211 type = getFirstSelected(sourceFile);
  lxi h, cmd_copymove1_sourceFile
  call getFirstSelected
;212 if(type == 0) return 0; // ¥â ¢ë¡à ­­ëå ä ©«®¢
  mov c, a
  xra a
  cmp c
  jnz l29996
;212 return 0; // ¥â ¢ë¡à ­­ëå ä ©«®¢
  pop b
  ret
l29996:
;214 for(;;) {
l16:
l15:
;214 {
  lxi h, cmd_copymove1_sourceFile
  call absolutePath
  ora a
  jnz l29997
;216 { e = ERR_RECV_STRING; break; }
  mvi b, 11
;216 break; }
  jmp l14
l29997:
;219 packName(forMask, getname(sourceFile));
  lxi h, cmd_copymove1_forMask
  shld packName_1
  lxi h, cmd_copymove1_sourceFile
  call getName
  call packName
;220 if(mask[0]) applyMask(forMask, mask);
  lda cmd_copymove1_mask
  ora a
  jz l29998
;220 applyMask(forMask, mask);
  lxi h, cmd_copymove1_forMask
  shld applyMask_1
  lxi h, cmd_copymove1_mask
  call applyMask
l29998:
;221 if(catPathAndUnpack(cmdline, forMask)) return ERR_RECV_STRING;
  lxi h, cmdline
  shld catPathAndUnpack_1
  lxi h, cmd_copymove1_forMask
  call catPathAndUnpack
  ora a
  jz l30007
;221 return ERR_RECV_STRING;
  mvi a, 11
  pop b
  ret
l30007:
;224 if(0!=strcmp(sourceFile, cmdline)) {
  lxi h, cmd_copymove1_sourceFile
  shld strcmp_1
  lxi h, cmdline
  call strcmp
  ora a
  jz l30016
;224 {
  lda cmd_copymove1_1
  ora a
  jz l30072
;226 {
  mvi a, 2
  cmp c
  jnz l30128
;227 {
  lxi h, cmd_copymove1_sourceFile
  shld cmd_copyFolder_1
  lxi h, cmdline
  call cmd_copyFolder
  mov b, a
  jmp l30143
l30128:
;229 {
  lxi h, cmd_copymove1_sourceFile
  shld cmd_copyFile_1
  lxi h, cmdline
  call cmd_copyFile
  mov b, a
; label1
l30143:
  jmp l30144
l30072:
;232 {
  lxi h, str9
  call drawWindow
;235 drawWindowText(0, 1, "iz:");
  xra a
  sta drawWindowText_1
  inr a
  sta drawWindowText_2
  lxi h, str2
  call drawWindowText
;236 drawWindowText(4, 1, sourceFile);
  mvi a, 1
  sta drawWindowText_2
  mvi a, 4
  sta drawWindowText_1
  lxi h, cmd_copymove1_sourceFile
  call drawWindowText
;237 drawWindowText(0, 2, "w:");
  xra a
  sta drawWindowText_1
  mvi a, 2
  sta drawWindowText_2
  lxi h, str3
  call drawWindowText
;238 drawWindowText(4, 2, cmdline);
  mvi a, 2
  sta drawWindowText_2
  add a
  sta drawWindowText_1
  lxi h, cmdline
  call drawWindowText
;239 drawAnyKeyButton();
  call drawAnyKeyButton
;242 if(fs_bioskey(1) == KEY_ESC) { e = ERR_USER; break; }
  mvi a, 1
  call fs_bioskey
  cpi 27
  jnz l30145
;242 { e = ERR_USER; break; }
  mvi b, 128
;242 break; }
  jmp l14
l30145:
;244 e = fs_move(sourceFile, cmdline);    
  lxi h, cmd_copymove1_sourceFile
  shld fs_move_1
  lxi h, cmdline
  call fs_move
  mov b, a
; label1
l30144:
;247 if(e) break;
  xra a
  cmp b
  jz l30146
;247 break;
  jmp l14
l30146:
l30016:
;251 dropPathInt(cmdLine, 0);
  lxi h, cmdline
  shld dropPathInt_1
  lxi h, 0
  call dropPathInt
;254 type = getNextSelected(sourceFile);
  lxi h, cmd_copymove1_sourceFile
  call getNextSelected
;255 if(type == 0) { e=0; break; }
  ora a
  mov c, a
  jnz l30147
;255 { e=0; break; }
  mvi b, 0
;255 break; }
  jmp l14
l30147:
  jmp l16
l14:
;260 getFiles();
  call getFiles
;261 dupFiles(1);
  mvi a, 1
  call dupFiles
;263 return e;
  mov a, b
  pop b
  ret
; --------------------------------------------------------------
confirm:
;237 drawWindow(title);
  shld confirm_2
  lhld confirm_1
  call drawWindow
;238 drawWindowText(3, 1, text);
  mvi a, 1
  sta drawWindowText_2
  mvi a, 3
  sta drawWindowText_1
  lhld confirm_2
  call drawWindowText
;239 drawWindowText(6, 4, "[ wk - ok ]  [ ar2 - otmena ]");
  mvi a, 4
  sta drawWindowText_2
  mvi a, 6
  sta drawWindowText_1
  lxi h, str63
  call drawWindowText
;242 while(1) {
l94:
;242 {
  xra a
  call fs_bioskey
  sui 13
  jz l96
  sui 14
  jz l97
  jmp l95
;244 case KEY_ENTER: return 1;
l96:
;244 return 1;
  mvi a, 1
  ret
;245 case KEY_ESC: return 0;
l97:
;245 return 0;
  xra a
  ret
l95:
  jmp l94
l93:
  ret
; --------------------------------------------------------------
getFirstSelected:
  push b
;284 nextSelectedCnt = panelA.cnt;
  shld getFirstSelected_1
  lhld (panelA)+(262)
;285 nextSelectedFile = panelA.files1;
  shld nextSelectedCnt
  lhld panelA
;286 if(type = getNextSelected(name)) return type; 
  shld nextSelectedFile
  lhld getFirstSelected_1
  call getNextSelected
  ora a
  jz l30148
;286 return type; 
  pop b
  ret
l30148:
;288 nextSelectedFile = getSelNoBack();
  mov b, a
  call getSelNoBack
;289 if(!nextSelectedFile) return 0;
  mov a, h
  ora l
  shld nextSelectedFile
  jnz l30149
;289 return 0;
  xra a
  pop b
  ret
l30149:
;290 unpackName(name, nextSelectedFile->fname);
  lhld getFirstSelected_1
  shld unpackName_1
  lhld nextSelectedFile
  call unpackName
;291 if(nextSelectedFile->fattrib & 0x10) return 2;
  lhld nextSelectedFile
  lxi d, 11
  dad d
  mov a, m
  ani 16
  jz l30150
;291 return 2;
  mvi a, 2
  pop b
  ret
l30150:
;292 return 1;
  mvi a, 1
  pop b
  ret
; --------------------------------------------------------------
cmd_deleteFile:
;8 drawWindow(" udalenie ");
  lxi h, str12
  call drawWindow
;9 drawWindowText(0, 1, cmdline);
  xra a
  sta drawWindowText_1
  inr a
  sta drawWindowText_2
  lxi h, cmdline
  call drawWindowText
;10 drawEscButton();
  call drawEscButton
;13 if(fs_bioskey(1) == KEY_ESC) return ERR_USER;
  mvi a, 1
  call fs_bioskey
  cpi 27
  jnz l30151
;13 return ERR_USER;
  mvi a, 128
  ret
l30151:
;16 return fs_delete(cmdline);
  lxi h, cmdline
  call fs_delete
  ret
; --------------------------------------------------------------
cmd_deleteFolder:
  push b
;27 level = 0;
  mvi c, 0
;29 while(1) {
l19:
;29 {
  lxi h, cmdline
  shld fs_findfirst_1
  lhld panelB
  shld fs_findfirst_2
  lhld maxFiles
  call fs_findfirst
;32 if(e != 0 && e != ERR_MAX_FILES) return e;
  ora a
  mov b, a
  jz l30152
  cpi 10
  jz l30152
;32 return e;
  pop b
  ret
l30152:
;33 panelB.cnt = fs_low;
  lhld fs_low
;36 e = 0;
  mvi b, 0
;37 for(p=panelB.files1, i=panelB.cnt; i; --i, ++p) {
  shld (panelB)+(262)
  lhld panelB
  shld cmd_deleteFolder_p
  lhld (panelB)+(262)
  shld cmd_deleteFolder_i
l22:
  lhld cmd_deleteFolder_i
  mov a, h
  ora l
  jz l20
;37 {
  lxi h, cmdline
  shld catPathAndUnpack_1
  lhld cmd_deleteFolder_p
  call catPathAndUnpack
  ora a
  jz l30155
;38 return ERR_RECV_STRING;
  mvi a, 11
  pop b
  ret
l30155:
;39 e = cmd_deleteFile();
  call cmd_deleteFile
;40 if(e == ERR_DIR_NOT_EMPTY) break;
  cpi 7
  mov b, a
  jnz l30156
;40 break;
  jmp l20
l30156:
;41 dropPathInt(cmdLine, 0);
  lxi h, cmdline
  shld dropPathInt_1
  lxi h, 0
  call dropPathInt
;43 if(e) return e;
  mov a, b
  ora a
  jz l30157
;43 return e;
  pop b
  ret
l30157:
l21:
  lhld cmd_deleteFolder_i
  dcx h
  shld cmd_deleteFolder_i
  lhld cmd_deleteFolder_p
  lxi d, 20
  dad d
  shld cmd_deleteFolder_p
  jmp l22
l20:
;47 if(e == ERR_DIR_NOT_EMPTY) { 
  mvi a, 7
  cmp b
  jnz l30184
;47 { 
  inr c
;49 continue;
  jmp l19
l30184:
;53 if(panelB.cnt == maxFiles) continue;
  lhld maxFiles
  xchg
  lhld (panelB)+(262)
  call op_cmp16
  jnz l30185
;53 continue;
  jmp l19
l30185:
;56 e = cmd_deleteFile();
  call cmd_deleteFile
;57 if(e) return e;
  ora a
  jz l30186
;57 return e;
  pop b
  ret
l30186:
;60 if(level == 0) return 0;
  mov b, a
  xra a
  cmp c
  jnz l30195
;60 return 0;
  pop b
  ret
l30195:
;61 --level;
  dcr c
;62 dropPathInt(cmdLine, 0);
  lxi h, cmdline
  shld dropPathInt_1
  lxi h, 0
  call dropPathInt
  jmp l19
l18:
  pop b
  ret
; --------------------------------------------------------------
getNextSelected:
;298 for(;;) {
  shld getNextSelected_1
l104:
l103:
;298 {
  lhld nextSelectedCnt
  mov a, h
  ora l
  jnz l30196
;299 return 0;
  xra a
  ret
l30196:
;300 if(nextSelectedFile->fattrib & 0x80) break;
  lhld nextSelectedFile
  lxi d, 11
  dad d
  mov a, m
  ani 128
  jz l30205
;300 break;
  jmp l102
l30205:
;301 ++nextSelectedFile, --nextSelectedCnt;
  lxi d, 9
  dad d
  shld nextSelectedFile
  lhld nextSelectedCnt
  dcx h
  shld nextSelectedCnt
  jmp l104
l102:
;304 nextSelectedFile->fattrib &= 0x7F;
  lhld nextSelectedFile
  lxi d, 11
  dad d
  mov a, m
  ani 127
  mov m, a
;305 unpackName(name, nextSelectedFile->fname);
  lhld getNextSelected_1
  shld unpackName_1
  lhld nextSelectedFile
  call unpackName
;306 ++nextSelectedFile, --nextSelectedCnt;
  lhld nextSelectedFile
  lxi d, 20
  dad d
  shld nextSelectedFile
  lhld nextSelectedCnt
;307 if(nextSelectedFile[-1].fattrib & 0x10) return 2;
  dcx h
  shld nextSelectedCnt
  lhld nextSelectedFile
  lxi d, -20
  dad d
  lxi d, 31
  dad d
  mov a, m
  ani 16
  jz l30208
;307 return 2;
  mvi a, 2
  ret
l30208:
;308 return 1;
  mvi a, 1
  ret
; --------------------------------------------------------------
drawFile:
;195 drawFile2(x*15+2+activePanel, 2+y, f);
  shld drawFile_3
  lhld drawFile_1
  mvi h, 0
  mov d, h
  mov e, l
  dad h
  dad d
  dad h
  dad d
  dad h
  dad d
  inx h
  inx h
  xchg
  lhld activePanel
  mvi h, 0
  dad d
  mov a, l
  sta drawFile2_1
  lda drawFile_2
  adi 2
  sta drawFile2_2
  lhld drawFile_3
  call drawFile2
  ret
; --------------------------------------------------------------
inputBox:
  push b
;212 clearFlag = 1;
  mvi c, 1
;215 drawWindow(title);
  shld inputBox_1
  call drawWindow
;216 drawWindowText(3, 0, "imq:");
  xra a
  sta drawWindowText_2
  mvi a, 3
  sta drawWindowText_1
  lxi h, str61
  call drawWindowText
;217 drawWindowTextCenter(4, "[ ok ]  [ otmena ]");
  mvi a, 4
  sta drawWindowTextCenter_1
  lxi h, str62
  call drawWindowTextCenter
;220 while(1) {
l92:
;220 {
  mvi a, 1
  sta drawWindowInput_1
  sta drawWindowInput_2
  mvi a, 26
  call drawWindowInput
;222 c = fs_bioskey(0);
  xra a
  call fs_bioskey
;223 if(c==KEY_RIGHT) clearFlag = 0;
  cpi 24
  jnz l30209
;223 clearFlag = 0;
  mvi c, 0
l30209:
;224 if(c==KEY_LEFT) clearFlag = 0;
  cpi 8
  jnz l30218
;224 clearFlag = 0;
  mvi c, 0
l30218:
;225 if(c==KEY_ENTER) { fs_hideCursor(); return 1; }
  cpi 13
  jnz l30227
;225 { fs_hideCursor(); return 1; }
  mov b, a
  call fs_hideCursor
;225 return 1; }
  mvi a, 1
  pop b
  ret
l30227:
;226 if(c==KEY_ESC) { fs_hideCursor(); return 0; }
  cpi 27
  jnz l30228
;226 { fs_hideCursor(); return 0; }
  mov b, a
  call fs_hideCursor
;226 return 0; }
  xra a
  pop b
  ret
l30228:
;227 if(clearFlag) clearFlag = 0, cmdline[0] = 0;
  mov b, a
  xra a
  cmp c
  jz l30229
;227 clearFlag = 0, cmdline[0] = 0;
  mov c, a
  sta cmdline
l30229:
;228 processInput(c);
  mov a, b
  call processInput
  jmp l92
l91:
  pop b
  ret
; --------------------------------------------------------------
packName:
  push b
;364 memset(buf, ' ', 11);    
  shld packName_2
  lhld packName_1
  shld memset_1
  mvi a, 32
  sta memset_2
  lxi h, 11
  call memset
;366 i = 8;
  mvi b, 8
;367 f = '.';
  mvi a, 46
;368 for(;;) {
  sta packName_f
l116:
l115:
;368 {
  lhld packName_2
  mov a, m
;370 if(c == 0) return;
  ora a
  jnz l30230
;370 return;
  pop b
  ret
l30230:
;371 ++path;
;372 if(c == f) { buf += i; i = 3; f = 0; continue; }
  mov c, a
  lda packName_f
  cmp c
  inx h
  shld packName_2
  jnz l30231
;372 { buf += i; i = 3; f = 0; continue; }
  mov l, b
  mvi h, 0
  xchg
  lhld packName_1
  dad d
;372 i = 3; f = 0; continue; }
  mvi b, 3
;372 f = 0; continue; }
  xra a
;372 continue; }
  shld packName_1
  sta packName_f
  jmp l115
l30231:
;373 if(i) { *buf = c; ++buf; --i; }
  xra a
  cmp b
  jz l30232
;373 { *buf = c; ++buf; --i; }
  mov a, c
  mov m, a
;373 ++buf; --i; }
;373 --i; }
  dcr b
  inx h
  shld packName_1
l30232:
  jmp l116
l114:
  pop b
  ret
; --------------------------------------------------------------
compareMask:
;21 if(!compareMask1(fileName, mask, 8)) return 0;
  shld compareMask_2
  lhld compareMask_1
  shld compareMask1_1
  lhld compareMask_2
  shld compareMask1_2
  mvi a, 8
  call compareMask1
  ora a
  jnz l30233
;21 return 0;
  xra a
  ret
l30233:
;22 return compareMask1(fileName+8, mask+8, 3);
  lhld compareMask_1
  lxi d, 8
  dad d
  shld compareMask1_1
  lhld compareMask_2
  lxi d, 8
  dad d
  shld compareMask1_2
  mvi a, 3
  call compareMask1
  ret
; --------------------------------------------------------------
drawInput:
  push b
;297 cmdline_pos = strlen(cmdline);
  lxi h, cmdline
  sta drawInput_3
  call strlen
;298 --max;
  lda drawInput_3
  dcr a
;299 if(cmdline_pos < max) cmdline_offset = 0; else cmdline_offset = cmdline_pos-max;
  mov b, h
  mov c, l
  mov l, a
  mvi h, 0
  xchg
  mov h, b
  mov l, c
  sta drawInput_3
  call op_cmp16
  jnc l30234
;299 cmdline_offset = 0; else cmdline_offset = cmdline_pos-max;
  lxi h, 0
  shld drawInput_cmdline_offset
  jmp l30242
l30234:
;299 cmdline_offset = cmdline_pos-max;
  lhld drawInput_3
  mvi h, 0
  xchg
  mov h, b
  mov l, c
  call op_sub16_swap
  shld drawInput_cmdline_offset
; label1
l30242:
;300 c1 = cmdline_pos - cmdline_offset;
  lhld drawInput_cmdline_offset
  xchg
  mov h, b
  mov l, c
  call op_sub16_swap
;301 cmdline[cmdline_pos] = 0;
  shld drawInput_c1
  lxi h, cmdline
  dad b
  mvi m, 0
;302 ++c1;
  lhld drawInput_c1
;303 if(c1 > max) c1 = max;
  inx h
  shld drawInput_c1
  xchg
  lhld drawInput_3
  mvi h, 0
  call op_cmp16
  jnc l30245
;303 c1 = max;
  mvi h, 0
  shld drawInput_c1
l30245:
;304 ++c1;
  lhld drawInput_c1
;305 ++max;
  lda drawInput_3
  inr a
;306 fs_print(x, y, max, cmdline + cmdline_offset, ' ');
  sta drawInput_3
  lda drawInput_1
  sta fs_print_1
  lda drawInput_2
  sta fs_print_2
  lda drawInput_3
  sta fs_print_3
  inx h
  shld drawInput_c1
  lhld drawInput_cmdline_offset
  lxi d, cmdline
  dad d
  shld fs_print_4
  mvi a, 32
  call fs_print
;309 fs_cursor(x+cmdline_pos-cmdline_offset, y);
  lhld drawInput_cmdline_offset
  xchg
  lhld drawInput_1
  mvi h, 0
  dad b
  call op_sub16_swap
  mov a, l
  sta fs_cursor_1
  lda drawInput_2
  call fs_cursor
  pop b
  ret
; --------------------------------------------------------------
drawRect:
  push b
;34 if(w <= 1) {
  sta drawRect_5
  lda drawRect_3
  cpi 1
  jz $+6
  jnc l30246
;34 {
l66:
  lda drawRect_4
  cpi 0
  jz l64
  jc l64
;36 fs_print(x,y,1,"",window[0]);
  lda drawRect_1
  sta fs_print_1
  lda drawRect_2
  sta fs_print_2
  lxi h, str32
  shld fs_print_4
  mvi a, 1
  sta fs_print_3
  lhld window
  mov a, m
  call fs_print
l65:
  lda drawRect_4
  dcr a
  sta drawRect_4
  lda drawRect_2
  inr a
  sta drawRect_2
  jmp l66
l64:
;37 return;
  pop b
  ret
l30246:
;39 if(h <= 1) {
  lda drawRect_4
  cpi 1
  jz $+6
  jnc l30247
;39 {
  lda drawRect_1
  sta fs_print_1
  lda drawRect_2
  sta fs_print_2
  lda drawRect_3
  sta fs_print_3
  lxi h, str32
  shld fs_print_4
  lhld window
  inx h
  mov a, m
  call fs_print
;41 return;
  pop b
  ret
l30247:
;43 x1 = x + w - 1;
  lhld drawRect_3
  mvi h, 0
  xchg
  lhld drawRect_1
  mvi h, 0
  dad d
  dcx h
  mov a, l
;44 w -= 2, h -= 2;
  mov b, a
  lda drawRect_3
  adi 254
  sta drawRect_3
  lda drawRect_4
  adi 254
;45 fs_print(x,y,1,"\x04",window[2]);
  sta drawRect_4
  lda drawRect_1
  sta fs_print_1
  lda drawRect_2
  sta fs_print_2
  lxi h, str36
  shld fs_print_4
  mvi a, 1
  sta fs_print_3
  lhld window
  inx h
  inx h
  mov a, m
  call fs_print
;46 if(w > 0) fs_print(x+1,y,w,"",window[3]);
  lda drawRect_3
  cpi 0
  jz l30274
  jc l30274
;46 fs_print(x+1,y,w,"",window[3]);
  lda drawRect_1
  inr a
  sta fs_print_1
  lda drawRect_2
  sta fs_print_2
  lda drawRect_3
  sta fs_print_3
  lxi h, str32
  shld fs_print_4
  lhld window
  inx h
  inx h
  inx h
  mov a, m
  call fs_print
l30274:
;47 fs_print(x1,y,1,"\x10",window[4]);
  mov a, b
  sta fs_print_1
  lda drawRect_2
  sta fs_print_2
  lxi h, str37
  shld fs_print_4
  mvi a, 1
  sta fs_print_3
  lhld window
  lxi d, 4
  dad d
  mov a, m
  call fs_print
;48 ++y;
  lda drawRect_2
  inr a
;49 for(;h != 0; --h, ++y) {
  sta drawRect_2
l70:
  lda drawRect_4
  ora a
  jz l68
;49 {
  lda drawRect_1
  sta fs_print_1
  lda drawRect_2
  sta fs_print_2
  lxi h, str32
  shld fs_print_4
  mvi a, 1
  sta fs_print_3
  lhld window
  lxi d, 5
  dad d
  mov a, m
  call fs_print
;51 if(bg) fs_print(x+1,y,w,"",' ');
  lda drawRect_5
  ora a
  jz l30283
;51 fs_print(x+1,y,w,"",' ');
  lda drawRect_1
  inr a
  sta fs_print_1
  lda drawRect_2
  sta fs_print_2
  lda drawRect_3
  sta fs_print_3
  lxi h, str32
  shld fs_print_4
  mvi a, 32
  call fs_print
l30283:
;52 fs_print(x1, y, 1, "",window[6]);
  mov a, b
  sta fs_print_1
  lda drawRect_2
  sta fs_print_2
  lxi h, str32
  shld fs_print_4
  mvi a, 1
  sta fs_print_3
  lhld window
  lxi d, 6
  dad d
  mov a, m
  call fs_print
l69:
  lda drawRect_4
  dcr a
  sta drawRect_4
  lda drawRect_2
  inr a
  sta drawRect_2
  jmp l70
l68:
;54 fs_print(x,y,1,"",window[7]);
  lda drawRect_1
  sta fs_print_1
  lda drawRect_2
  sta fs_print_2
  lxi h, str32
  shld fs_print_4
  mvi a, 1
  sta fs_print_3
  lhld window
  lxi d, 7
  dad d
  mov a, m
  call fs_print
;55 if(w > 0) fs_print(x+1,y,w,"",window[8]);
  lda drawRect_3
  cpi 0
  jz l30292
  jc l30292
;55 fs_print(x+1,y,w,"",window[8]);
  lda drawRect_1
  inr a
  sta fs_print_1
  lda drawRect_2
  sta fs_print_2
  lda drawRect_3
  sta fs_print_3
  lxi h, str32
  shld fs_print_4
  lhld window
  lxi d, 8
  dad d
  mov a, m
  call fs_print
l30292:
;56 fs_print(x1,y,1,"",window[9]);
  mov a, b
  sta fs_print_1
  lda drawRect_2
  sta fs_print_2
  lxi h, str32
  shld fs_print_4
  mvi a, 1
  sta fs_print_3
  lhld window
  lxi d, 9
  dad d
  mov a, m
  call fs_print
  pop b
  ret
; --------------------------------------------------------------
sub32_16:
;4 asm {
  shld sub32_16_2
    lhld sub32_16_1
    xchg
    lhld sub32_16_2
  
    ldax d
    sub l
    stax d
   
    inx d
    ldax d
    sbb h
    stax d

    inx d
    ldax d
    sbi 0
    stax d

    inx d
    ldax d
    sbi 0
    stax d
  
  ret
; --------------------------------------------------------------
memswap:
;2 asm {
  shld memswap_3
    push b
    ; de = count
    xchg
    ; bc = from
    lhld memswap_2
    mov c, l
    mov b, h
    ; hl = to
    lhld memswap_1
memswap_l1:
    ; if(cnt==0) return
    mov a, d
    ora e
    jz memswap_l2
    ; *dest = *src
    ldax b
    sta memswap_v1
    mov a, m
    stax b
    .db 36h ; mvi m, 0
memswap_v1:
    .db 0    
    ; dest++, src++, cnt--
    inx h
    inx b
    dcx d
    ; loop
    jmp memswap_l1
memswap_l2:
    pop b
  
  ret
; --------------------------------------------------------------
directCursor:
;1 ((uchar*)0xEF00)
  sta directCursor_2
  mvi a, 128
  sta 61185
;1 ((uchar*)0xEF00)
  lda directCursor_1
  sta 61184
;1 ((uchar*)0xEF00)
  lda directCursor_2
  sta 61184
  ret
; --------------------------------------------------------------
i2s:
;4 buf += n;  
  lhld i2s_3
  xchg
  lhld i2s_1
  dad d
;5 *buf = 0;
  mvi m, 0
;6 while(1) {
  sta i2s_4
  shld i2s_1
l178:
;6 {
  lhld i2s_2
  lxi d, 10
  call op_div16_swap
;8 --buf;
  shld i2s_2
  lhld i2s_1
;9 *buf = "0123456789ABCDEF"[op_div16_mod];
  dcx h
  shld i2s_1
  push h
  lhld op_div16_mod
  lxi d, str66
  dad d
  mov a, m
  pop d
  stax d
;10 --n;
  lhld i2s_3
;11 if(n == 0) return;
  dcx h
  mov a, h
  ora l
  shld i2s_3
  rz
;11 return;
l30301:
;12 if(v == 0) break;
  lhld i2s_2
  mov a, h
  ora l
  jnz l30309
;12 break;
  jmp l177
l30309:
  jmp l178
l177:
;14 while(1) {
l180:
;14 {
  lhld i2s_1
;16 *buf = spc;
  lda i2s_4
  dcx h
  mov m, a
;17 if(--n == 0) break;
  shld i2s_1
  lhld i2s_3
  dcx h
  mov a, h
  ora l
  shld i2s_3
  jnz l30312
;17 break;
  jmp l179
l30312:
  jmp l180
l179:
  ret
; --------------------------------------------------------------
rand:
;4 asm {
    LDA rand_seed
    mov e,a
    add a
    add a
    add e
    inr a
    sta rand_seed
  
  ret
; --------------------------------------------------------------
cmpFileInfo:
  push b
;317 i = (a->fattrib&0x10);
  shld cmpFileInfo_2
  lhld cmpFileInfo_1
  lxi d, 11
  dad d
  mov a, m
  ani 16
;318 j = (b->fattrib&0x10);
  lhld cmpFileInfo_2
  lxi d, 11
  dad d
  sta cmpFileInfo_i
  mov a, m
  ani 16
;319 if(i<j) return 1;
  mov b, a
  lda cmpFileInfo_i
  cmp b
  jnc l30393
;319 return 1;
  mvi a, 1
  pop b
  ret
l30393:
;320 if(j<i) return 0;
  cmp b
  jz l30402
  jc l30402
;320 return 0;
  xra a
  pop b
  ret
l30402:
;321 if(1==memcmp(a->fname, b->fname, sizeof(a->fname))) return 1;
  lhld cmpFileInfo_1
  shld memcmp_1
  lhld cmpFileInfo_2
  shld memcmp_2
  lxi h, 11
  call memcmp
  dcr a
  jnz l30411
;321 return 1;
  mvi a, 1
  pop b
  ret
l30411:
;322 return 0;
  xra a
  pop b
  ret
; --------------------------------------------------------------
drawColumn:
  push b
;178 register ushort n = panelA.offset + i * rowsCnt;
  lhld rowsCnt
  mvi h, 0
  xchg
  mov l, a
  mvi h, 0
  sta drawColumn_1
  call op_mul16
  xchg
  lhld (panelA)+(260)
  dad d
;179 FileInfo* f = panelA.files1 + n;  
  shld drawColumn_n
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  xchg
  lhld panelA
  dad d
;181 xx = i * 15 + 2 + activePanel; yy = 2;
  shld drawColumn_f
  lhld drawColumn_1
  mvi h, 0
  mov d, h
  mov e, l
  dad h
  dad d
  dad h
  dad d
  dad h
  dad d
  inx h
  inx h
  xchg
  lhld activePanel
  mvi h, 0
  dad d
  mov a, l
;181 yy = 2;
  mvi b, 2
;182 for(y=rowsCnt; y; --y, ++yy) {
  mov c, a
  lda rowsCnt
  sta drawColumn_y
l74:
  lda drawColumn_y
  ora a
  jz l72
;182 {
  lhld (panelA)+(262)
  xchg
  lhld drawColumn_n
  call op_cmp16
  jc l30414
;183 {
  mov a, c
  sta fs_print_1
  mov a, b
  sta fs_print_2
  lxi h, str32
  shld fs_print_4
  mvi a, 12
  sta fs_print_3
  mvi a, 32
  call fs_print
;185 continue;
  jmp l73
l30414:
;187 drawFile2(xx, yy, f);
  mov a, c
  sta drawFile2_1
  mov a, b
  sta drawFile2_2
  lhld drawColumn_f
  call drawFile2
;188 ++f; ++n;
  lhld drawColumn_f
  lxi d, 20
  dad d
;188 ++n;
  shld drawColumn_f
  lhld drawColumn_n
  inx h
  shld drawColumn_n
l73:
  lda drawColumn_y
  dcr a
  inr b
  sta drawColumn_y
  jmp l74
l72:
  pop b
  ret
; --------------------------------------------------------------
add32_32:
;4 asm {   
  shld add32_32_2
   
    ; hl = add32_32_2   
    xchg
    lhld add32_32_1
    xchg

    ldax d
    add  m
    stax d
    inx  h
    inx  d
    ldax d
    adc  m
    stax d
    inx  h
    inx  d
    ldax d
    adc  m
    stax d
    inx  h
    inx  d
    ldax d
    adc  m
    stax d
  
  ret
; --------------------------------------------------------------
drawFilesCountInt:
  push b
;93 x = 1 + activePanel; y = 4 + rowsCnt;
  lda activePanel
  inr a
;93 y = 4 + rowsCnt;
  sta drawFilesCountInt_x
  lda rowsCnt
  adi 4
;95 i2s32(buf, total, 10, ' ');
  shld drawFilesCountInt_2
  lxi h, drawFilesCountInt_buf
  shld i2s32_1
  lhld drawFilesCountInt_1
  shld i2s32_2
  lxi h, 10
  shld i2s32_3
  mov b, a
  mvi a, 32
  call i2s32
;96 fs_print(x, y, 12, buf, 0);
  lda drawFilesCountInt_x
  sta fs_print_1
  mov a, b
  sta fs_print_2
  lxi h, drawFilesCountInt_buf
  shld fs_print_4
  mvi a, 12
  sta fs_print_3
  xra a
  call fs_print
;98 fs_print(x+11, y, 12, "bajt w    ", 0);
  lda drawFilesCountInt_x
  adi 11
  sta fs_print_1
  mov a, b
  sta fs_print_2
  lxi h, str41
  shld fs_print_4
  mvi a, 12
  sta fs_print_3
  xra a
  call fs_print
;100 if(filesCnt < 1000) {
  lhld drawFilesCountInt_2
  lxi d, 1000
  call op_cmp16
  jnc l30417
;100 {
  lxi h, drawFilesCountInt_buf
  shld i2s_1
  lhld drawFilesCountInt_2
  shld i2s_2
  lxi h, 3
  shld i2s_3
  mvi a, 32
  call i2s
;102 fs_print(x + 18, y, 3, buf, 0);
  lda drawFilesCountInt_x
  adi 18
  sta fs_print_1
  mov a, b
  sta fs_print_2
  lxi h, drawFilesCountInt_buf
  shld fs_print_4
  mvi a, 3
  sta fs_print_3
  xra a
  call fs_print
l30417:
;105 v = filesCnt % 100;
  lhld drawFilesCountInt_2
  lxi d, 100
  call op_mod16_swap
  mov a, l
;106 fs_print(x + 22, y, 16, (!(v >= 10 && v < 20) && v % 10 == 1) ? "fajle " : "fajlah ", 0);
  mov c, a
  lda drawFilesCountInt_x
  adi 22
  sta fs_print_1
  mov a, b
  sta fs_print_2
  mov a, c
  cpi 10
  jc l30498
  cpi 20
  jc l30497
l30498:
  mov l, a
  mvi h, 0
  lxi d, 10
  call op_mod16_swap
  lxi d, 1
  call op_cmp16
  jnz l30497
  lxi h, str42
  jmp l30496
; label1
l30497:
  lxi h, str43
; label1
l30496:
  shld fs_print_4
  mvi a, 16
  sta fs_print_3
  xra a
  call fs_print
  pop b
  ret
; --------------------------------------------------------------
drawFileInfoDir:
;208 drawFileInfo1("     <DIR>");
  lxi h, str46
  call drawFileInfo1
  ret
; --------------------------------------------------------------
i2s32:
;7 set32(&v, src);
  lxi h, i2s32_v
  shld set32_1
  lhld i2s32_2
  sta i2s32_4
  call set32
;9 buf += n;  
  lhld i2s32_3
  xchg
  lhld i2s32_1
  dad d
;10 *buf = 0;
  mvi m, 0
;12 while(1) {
  shld i2s32_1
l172:
;12 {
  lxi h, i2s32_v
  shld div32_16_1
  lxi h, 10
  call div32_16
;14 --buf;
  lhld i2s32_1
;15 *buf = "0123456789ABCDEF"[op_div16_mod];
  dcx h
  shld i2s32_1
  push h
  lhld op_div16_mod
  lxi d, str66
  dad d
  mov a, m
  pop d
  stax d
;16 if(--n == 0) return;
  lhld i2s32_3
  dcx h
  mov a, h
  ora l
  shld i2s32_3
  rz
;16 return;
l30507:
;17 if(((ushort*)&v)[0] == 0 && ((ushort*)&v)[1] == 0) break;
  lhld i2s32_v
  mov a, h
  ora l
  jnz l30515
  lhld (i2s32_v)+(2)
  mov a, h
  ora l
  jnz l30515
;17 break;
  jmp l171
l30515:
  jmp l172
l171:
;20 while(1) {
l174:
;20 {
  lhld i2s32_1
;22 *buf = spc;
  lda i2s32_4
  dcx h
  mov m, a
;23 if(--n == 0) break;
  shld i2s32_1
  lhld i2s32_3
  dcx h
  mov a, h
  ora l
  shld i2s32_3
  jnz l30518
;23 break;
  jmp l173
l30518:
  jmp l174
l173:
  ret
; --------------------------------------------------------------
drawFileInfo1:
;202 fs_print(2+activePanel, rowsCnt+3, 10, buf, ' ');
  lda activePanel
  adi 2
  sta fs_print_1
  lda rowsCnt
  adi 3
  sta fs_print_2
  shld fs_print_4
  mvi a, 10
  sta fs_print_3
  mvi a, 32
  shld drawFileInfo1_1
  call fs_print
  ret
; --------------------------------------------------------------
drawFileInfo2:
;215 fs_print(13+activePanel, rowsCnt+3, 16, buf, ' ');
  lda activePanel
  adi 13
  sta fs_print_1
  lda rowsCnt
  adi 3
  sta fs_print_2
  shld fs_print_4
  mvi a, 16
  sta fs_print_3
  add a
  shld drawFileInfo2_1
  call fs_print
  ret
; --------------------------------------------------------------
drawWindowTextCenter:
;242 fs_print((fs_screenWidth - strlen(text)) >> 1, windowY + y + 2, 64, text, 0);
  shld drawWindowTextCenter_2
  call strlen
  xchg
  lhld fs_screenWidth
  mvi h, 0
  call op_sub16_swap
  lxi d, 1
  call op_shr16_swap
  mov a, l
  sta fs_print_1
  lhld drawWindowTextCenter_1
  mvi h, 0
  xchg
  lhld windowY
  mvi h, 0
  dad d
  inx h
  inx h
  mov a, l
  sta fs_print_2
  lhld drawWindowTextCenter_2
  shld fs_print_4
  mvi a, 64
  sta fs_print_3
  xra a
  call fs_print
  ret
; --------------------------------------------------------------
memcpy_back:
;2 asm {
  shld memcpy_back_3
    ; if(cnt==0) return
    mov a, h
    ora l
    rz
    ; start
    push b
    ; de = count
    xchg
    ; bc = from
    lhld memcpy_back_2
    dad d
    mov c, l
    mov b, h
    ; hl = to
    lhld memcpy_back_1
    dad d
    ; enter loop
    inr d
    xra a
    ora e
    jz memcpy_back_l2
memcpy_back_l1:
    ; dest--, src--
    dcx h
    dcx b
    ; *dest = *src
    ldax b
    mov m, a
    ; while(cnt)
    dcr e
    jnz memcpy_back_l1
memcpy_back_l2:
    dcr d
    jnz memcpy_back_l1
    pop b
  
  ret
; --------------------------------------------------------------
fs_mkdir:
  push b
;288 fs_print(0,0,64,name,0);
  shld fs_print_4
  xra a
  sta fs_print_1
  sta fs_print_2
  mvi a, 64
  sta fs_print_3
  xra a
  shld fs_mkdir_1
  call fs_print
;289 for(i=5000; i; --i);
  lxi b, 5000
l58:
l57:
  dcx b
  mov h, b
  mov l, c
  mov a, h
  ora l
  jnz l58
;290 return 0;
  xra a
  pop b
  ret
; --------------------------------------------------------------
saveState:
;713 if(fs_create(fs_selfName) && fs_open(fs_selfName)) return;
  lhld fs_selfName
  call fs_create
  ora a
  jz l30519
  lhld fs_selfName
  call fs_open
  ora a
  rnz
;713 return;
l30519:
;714 fs_write(getSel()->fname, 11);
  call getSel
  shld fs_write_1
  lxi h, 11
  call fs_write
;715 fs_write(&activePanel, 1);
  lxi h, activePanel
  shld fs_write_1
  lxi h, 1
  call fs_write
;716 fs_write(panelA.path1, 256);
  lxi h, (panelA)+(2)
  shld fs_write_1
  lxi h, 256
  call fs_write
;717 fs_write(panelB.path1, 256);
  lxi h, (panelB)+(2)
  shld fs_write_1
  lxi h, 256
  call fs_write
  ret
; --------------------------------------------------------------
fs_exec:
;315 return 1;
  mvi a, 1
  shld fs_exec_2
  ret
; --------------------------------------------------------------
strchr:
;2 asm {
  sta strchr_2
    mov d, a
    lhld strchr_1
strchr_l1:
    ; *dest = *src    
    mov a, m
    cmp d
    rz
    inx h
    ora a
    jnz strchr_l1
    mov h, a
    mov l, a
  
  ret
; --------------------------------------------------------------
dropPathInt:
  push b
;525 p = getname(src);
  shld dropPathInt_2
  lhld dropPathInt_1
  call getName
;528 if(preparedName) packName(preparedName, p);
  mov b, h
  mov c, l
  lhld dropPathInt_2
  mov a, h
  ora l
  jz l30520
;528 packName(preparedName, p);
  shld packName_1
  mov h, b
  mov l, c
  call packName
l30520:
;531 if(p != src) --p;
  mov h, b
  mov l, c
  xchg
  lhld dropPathInt_1
  call op_cmp16
  jz l30529
;531 --p;
  dcx b
l30529:
;532 *p = 0;
  xra a
  stax b
  pop b
  ret
; --------------------------------------------------------------
getName:
  push b
;512 for(p = name; *p; p++)
  shld getName_1
  mov b, h
  mov c, l
l136:
  ldax b
  ora a
  jz l134
;513 if(*p == '/')
  ldax b
  cpi 47
  jnz l30532
;514 name = p+1;
  mov h, b
  mov l, c
  inx h
  shld getName_1
l30532:
l135:
  inx b
  jmp l136
l134:
;515 return name;
  lhld getName_1
  pop b
  ret
; --------------------------------------------------------------
applyMask:
;160 applyMask1(dest, mask, 8);
  shld applyMask_2
  lhld applyMask_1
  shld applyMask1_1
  lhld applyMask_2
  shld applyMask1_2
  mvi a, 8
  call applyMask1
;161 applyMask1(dest+8, mask+8, 3);
  lhld applyMask_1
  lxi d, 8
  dad d
  shld applyMask1_1
  lhld applyMask_2
  lxi d, 8
  dad d
  shld applyMask1_2
  mvi a, 3
  call applyMask1
  ret
; --------------------------------------------------------------
catPathAndUnpack:
  push b
;266 uint len = strlen(str);
  shld catPathAndUnpack_2
  lhld catPathAndUnpack_1
  call strlen
;267 if(len) {
  mov a, h
  ora l
  mov b, h
  mov c, l
  jz l30533
;267 {
  lxi d, 242
  call op_cmp16
  jc l30541
;268 return 1; // Íå âëåçàåò ðàçäåëèòåëü ïëþñ èìÿ ôàéëà  
  mvi a, 1
  pop b
  ret
l30541:
;269 str[len] = '/';  
  lhld catPathAndUnpack_1
  dad b
  mvi m, 47
;270 str += len+1;
  mov h, b
  mov l, c
  inx h
  xchg
  lhld catPathAndUnpack_1
  dad d
  shld catPathAndUnpack_1
l30533:
;272 unpackName(str, fileName);
  lhld catPathAndUnpack_1
  shld unpackName_1
  lhld catPathAndUnpack_2
  call unpackName
;273 return 0;
  xra a
  pop b
  ret
; --------------------------------------------------------------
cmd_copyFolder:
  push b
;97 uchar level=0;
  mvi c, 0
;102 e = fs_mkdir(to); 
  shld cmd_copyFolder_2
  call fs_mkdir
;103 if(e) return e;
  ora a
  jz l30542
;103 return e;
  pop b
  ret
l30542:
;105 for(i=0;;++i) {
  lxi h, 0
  mov b, a
  shld cmd_copyFolder_i
l12:
;105 {
  lhld maxFiles
  xchg
  lhld cmd_copyFolder_i
  call op_cmp16
  jnz l30543
;107 return ERR_MAX_FILES;
  mvi a, 10
  pop b
  ret
l30543:
;111 e = fs_findfirst(from, panelB.files1, i+1);
  lhld cmd_copyFolder_1
  shld fs_findfirst_1
  lhld panelB
  shld fs_findfirst_2
  lhld cmd_copyFolder_i
  inx h
  call fs_findfirst
;112 if(e != 0 && e != ERR_MAX_FILES) return e; // Œë ¢á¥£¤  ¡ã¤¥¬ ¯®«ãç¨âì ERR_MAX_FILES
  ora a
  mov b, a
  jz l30546
  cpi 10
  jz l30546
;112 return e; // Œë ¢á¥£¤  ¡ã¤¥¬ ¯®«ãç¨âì ERR_MAX_FILES
  pop b
  ret
l30546:
;115 if(i >= fs_low) {
  lhld fs_low
  xchg
  lhld cmd_copyFolder_i
  call op_cmp16
  jc l30564
;115 {
  xra a
  cmp c
  jnz l30572
;117 return 0;
  pop b
  ret
l30572:
;119 dropPathInt(from, 0);
  lhld cmd_copyFolder_1
  shld dropPathInt_1
  lxi h, 0
  call dropPathInt
;120 dropPathInt(to, 0);
  lhld cmd_copyFolder_2
  shld dropPathInt_1
  lxi h, 0
  call dropPathInt
;121 --level;
  dcr c
;122 i = stack[level];
  mov l, c
  mvi h, 0
  dad h
  lxi d, cmd_copyFolder_stack
  dad d
  mov a, m
  inx h
  mov h, m
  mov l, a
;123 continue;
  shld cmd_copyFolder_i
  jmp l11
l30564:
;125 f = panelB.files1 + i;
  mov d, h
  mov e, l
  dad h
  dad h
  dad d
  dad h
  dad h
  xchg
  lhld panelB
  dad d
;128 if(catPathAndUnpack(from, f->fname)) return ERR_RECV_STRING;
  shld cmd_copyFolder_f
  lhld cmd_copyFolder_1
  shld catPathAndUnpack_1
  lhld cmd_copyFolder_f
  call catPathAndUnpack
  ora a
  jz l30581
;128 return ERR_RECV_STRING;
  mvi a, 11
  pop b
  ret
l30581:
;129 if(catPathAndUnpack(to,   f->fname)) return ERR_RECV_STRING;
  lhld cmd_copyFolder_2
  shld catPathAndUnpack_1
  lhld cmd_copyFolder_f
  call catPathAndUnpack
  ora a
  jz l30590
;129 return ERR_RECV_STRING;
  mvi a, 11
  pop b
  ret
l30590:
;132 if(f->fattrib & 0x10) {
  lhld cmd_copyFolder_f
  lxi d, 11
  dad d
  mov a, m
  ani 16
  jz l30599
;132 {
  mvi a, 7
  cmp c
  jnz l30661
;134 return ERR_RECV_STRING;
  mvi a, 11
  pop b
  ret
l30661:
;135 stack[level] = i;
  mov l, c
  mvi h, 0
  dad h
  lxi d, cmd_copyFolder_stack
  dad d
  xchg
  lhld cmd_copyFolder_i
  xchg
  mov m, e
  inx h
  mov m, d
;136 level++;
  inr c
;138 e = fs_mkdir(to); 
  lhld cmd_copyFolder_2
  call fs_mkdir
;139 if(e) return e;
  ora a
  jz l30662
;139 return e;
  pop b
  ret
l30662:
;141 i = -1;
  lxi h, 65535
;142 continue;
  shld cmd_copyFolder_i
  mov b, a
  jmp l11
l30599:
;146 e = cmd_copyFile(from, to);
  lhld cmd_copyFolder_1
  shld cmd_copyFile_1
  lhld cmd_copyFolder_2
  call cmd_copyFile
;149 dropPathInt(from, 0);
  lhld cmd_copyFolder_1
  shld dropPathInt_1
  lxi h, 0
  mov b, a
  call dropPathInt
;150 dropPathInt(to, 0);
  lhld cmd_copyFolder_2
  shld dropPathInt_1
  lxi h, 0
  call dropPathInt
;153 if(e) return e;
  mov a, b
  ora a
  jz l30663
;153 return e;
  pop b
  ret
l30663:
l11:
  lhld cmd_copyFolder_i
  inx h
  shld cmd_copyFolder_i
  jmp l12
l10:
  pop b
  ret
; --------------------------------------------------------------
cmd_copyFile:
  push b
;13 uchar e, progress_i=0;
  mvi c, 0
;18 if(e = fs_open(from)) return e;
  shld cmd_copyFile_2
  lhld cmd_copyFile_1
  call fs_open
  ora a
  jz l30664
;18 return e;
  pop b
  ret
l30664:
;19 if(e = fs_getsize()) return e;
  call fs_getsize
  ora a
  jz l30673
;19 return e;
  pop b
  ret
l30673:
;22 set32(&progress_step, &fs_result);
  lxi h, cmd_copyFile_progress_step
  shld set32_1
  lxi h, fs_low
  mov b, a
  call set32
;23 div32_16(&progress_step, 40);
  lxi h, cmd_copyFile_progress_step
  shld div32_16_1
  lxi h, 40
  call div32_16
;26 drawWindow(" kopirowanie ");
  lxi h, str1
  call drawWindow
;27 drawWindowText(0, 0, "iz:");
  xra a
  sta drawWindowText_1
  sta drawWindowText_2
  lxi h, str2
  call drawWindowText
;28 drawWindowText(4, 0, from);
  xra a
  sta drawWindowText_2
  mvi a, 4
  sta drawWindowText_1
  lhld cmd_copyFile_1
  call drawWindowText
;29 drawWindowText(0, 1, "w:");
  xra a
  sta drawWindowText_1
  inr a
  sta drawWindowText_2
  lxi h, str3
  call drawWindowText
;30 drawWindowText(4, 1, to);
  mvi a, 1
  sta drawWindowText_2
  mvi a, 4
  sta drawWindowText_1
  lhld cmd_copyFile_2
  call drawWindowText
;31 drawWindowText(0, 2, "skopirowano           /           bajt");
  xra a
  sta drawWindowText_1
  mvi a, 2
  sta drawWindowText_2
  lxi h, str4
  call drawWindowText
;32 drawWindowProgress(0, 3, progress_width, '#');
  xra a
  sta drawWindowProgress_1
  mvi a, 3
  sta drawWindowProgress_2
  mvi a, 18
  sta drawWindowProgress_3
  mvi a, 35
  call drawWindowProgress
;33 i2s32(buf, &fs_result, 10, ' ');
  lxi h, cmd_copyFile_buf
  shld i2s32_1
  lxi h, fs_low
  shld i2s32_2
  lxi h, 10
  shld i2s32_3
  mvi a, 32
  call i2s32
;34 drawWindowText(23, 2, buf);
  mvi a, 2
  sta drawWindowText_2
  mvi a, 23
  sta drawWindowText_1
  lxi h, cmd_copyFile_buf
  call drawWindowText
;35 drawEscButton();
  call drawEscButton
;38 if(e = fs_swap()) return e;
  call fs_swap
  ora a
  jz l30674
;38 return e;
  pop b
  ret
l30674:
;39 if(e = fs_create(to)) return e;
  lhld cmd_copyFile_2
  call fs_create
  ora a
  jz l30683
;39 return e;
  pop b
  ret
l30683:
;1 { ((ushort*)a)[0] = (b&0xFFFF); ((ushort*)a)[1] = (b>>16); }
  lxi h, 0
;1 ((ushort*)a)[1] = (b>>16); }
  shld cmd_copyFile_progress
;1 { ((ushort*)a)[0] = (b&0xFFFF); ((ushort*)a)[1] = (b>>16); }
  shld (cmd_copyFile_progress)+(2)
;1 ((ushort*)a)[1] = (b>>16); }
  shld cmd_copyFile_progress_x
;44 for(;;) {
  mov b, a
  shld (cmd_copyFile_progress_x)+(2)
l2:
l1:
;44 {
  lxi h, cmd_copyFile_buf
  shld i2s32_1
  lxi h, cmd_copyFile_progress
  shld i2s32_2
  lxi h, 10
  shld i2s32_3
  mvi a, 32
  call i2s32
;47 drawWindowText(12, 2, buf); 
  mvi a, 2
  sta drawWindowText_2
  mvi a, 12
  sta drawWindowText_1
  lxi h, cmd_copyFile_buf
  call drawWindowText
;50 if(e = fs_swap()) return e;
  call fs_swap
  ora a
  jz l30684
;50 return e;
  pop b
  ret
l30684:
;51 if(e = fs_read(panelB.files1, 1024) ) return e;
  lhld panelB
  shld fs_read_1
  lxi h, 1024
  call fs_read
  ora a
  jz l30693
;51 return e;
  pop b
  ret
l30693:
;52 if(fs_low == 0) return 0; // ‘ ¯¥à¥§ £àã§ª®© ä ©«®¢
  lhld fs_low
  mov b, a
  mov a, h
  ora l
  jnz l30702
;52 return 0; // ‘ ¯¥à¥§ £àã§ª®© ä ©«®¢
  xra a
  pop b
  ret
l30702:
;53 if(e = fs_swap()) return e;
  call fs_swap
  ora a
  jz l30711
;53 return e;
  pop b
  ret
l30711:
;54 if(e = fs_write(panelB.files1, fs_low)) return e;
  lhld panelB
  shld fs_write_1
  lhld fs_low
  call fs_write
  ora a
  jz l30720
;54 return e;
  pop b
  ret
l30720:
;57 add32_16(&progress, fs_low);
  lxi h, cmd_copyFile_progress
  shld add32_16_1
  lhld fs_low
  mov b, a
  call add32_16
;60 add32_16(&progress_x, fs_low);
  lxi h, cmd_copyFile_progress_x
  shld add32_16_1
  lhld fs_low
  call add32_16
;61 while(progress_i < progress_width && cmp32_32(&progress_x, &progress_step) != 1) {
l5:
  mov a, c
  cpi 18
  jnc l4
  lxi h, cmd_copyFile_progress_x
  shld cmp32_32_1
  lxi h, cmd_copyFile_progress_step
  call cmp32_32
  dcr a
  jz l4
;61 {
  lxi h, cmd_copyFile_progress_x
  shld sub32_32_1
  lxi h, cmd_copyFile_progress_step
  call sub32_32
;63 drawWindowText(progress_i, 3, "\x17");
  mov a, c
  sta drawWindowText_1
  mvi a, 3
  sta drawWindowText_2
  lxi h, str5
  call drawWindowText
;64 ++progress_i;
  inr c
  jmp l5
l4:
;68 if(fs_bioskey(1) == KEY_ESC) { e = ERR_USER; break; }
  mvi a, 1
  call fs_bioskey
  cpi 27
  jnz l30721
;68 { e = ERR_USER; break; }
  mvi b, 128
;68 break; }
  jmp l0
l30721:
  jmp l2
l0:
;72 fs_delete(to);
  lhld cmd_copyFile_2
  call fs_delete
;73 return e;
  mov a, b
  pop b
  ret
; --------------------------------------------------------------
fs_move:
  push b
;282 for(i=20000; i; --i);
  lxi b, 20000
  shld fs_move_2
l54:
l53:
  dcx b
  mov h, b
  mov l, c
  mov a, h
  ora l
  jnz l54
;283 return 0;
  xra a
  pop b
  ret
; --------------------------------------------------------------
drawEscButton:
;272 drawWindowTextCenter(4, "[ stop ]");
  mvi a, 4
  sta drawWindowTextCenter_1
  lxi h, str49
  call drawWindowTextCenter
  ret
; --------------------------------------------------------------
fs_delete:
  push b
;320 fs_print(0,0,64,name,0);
  shld fs_print_4
  xra a
  sta fs_print_1
  sta fs_print_2
  mvi a, 64
  sta fs_print_3
  xra a
  shld fs_delete_1
  call fs_print
;321 if(0==strcmp(name, "FOLDER01")) return ERR_DIR_NOT_EMPTY;
  lhld fs_delete_1
  shld strcmp_1
  lxi h, str34
  call strcmp
  ora a
  jnz l30722
;321 return ERR_DIR_NOT_EMPTY;
  mvi a, 7
  pop b
  ret
l30722:
;322 if(0==strcmp(name, "FOLDER01/FOLDER04")) return ERR_DIR_NOT_EMPTY;
  lhld fs_delete_1
  shld strcmp_1
  lxi h, str35
  call strcmp
  ora a
  jnz l30731
;322 return ERR_DIR_NOT_EMPTY;
  mvi a, 7
  pop b
  ret
l30731:
;323 for(i=5000; i; --i);
  lxi b, 5000
l62:
l61:
  dcx b
  mov h, b
  mov l, c
  mov a, h
  ora l
  jnz l62
;324 return 0;
  xra a
  pop b
  ret
; --------------------------------------------------------------
drawFile2:
;168 memcpy(buf, f->fname, 8);
  shld drawFile2_3
  lxi h, drawFile2_buf
  shld memcpy_1
  lhld drawFile2_3
  shld memcpy_2
  lxi h, 8
  call memcpy
;169 buf[8] = (f->fattrib&0x80) ? '*' : ((f->fattrib & 0x06) ? 0x7F : ' '); 
  lhld drawFile2_3
  lxi d, 11
  dad d
  mov a, m
  ani 128
  jz l30733
  lxi h, 42
  jmp l30732
; label1
l30733:
  lhld drawFile2_3
  lxi d, 11
  dad d
  mov a, m
  ani 6
  jz l30787
  lxi h, 127
  jmp l30786
; label1
l30787:
  lxi h, 32
; label1
l30786:
; label1
l30732:
  mov a, l
;170 memcpy(buf + 9, f->fname + 8, 3);  
  lxi h, (drawFile2_buf)+(9)
  shld memcpy_1
  lhld drawFile2_3
  lxi d, 8
  dad d
  shld memcpy_2
  lxi h, 3
  sta (drawFile2_buf)+(8)
  call memcpy
;171 fs_print(x, y, 12, buf, 0); 
  lda drawFile2_1
  sta fs_print_1
  lda drawFile2_2
  sta fs_print_2
  lxi h, drawFile2_buf
  shld fs_print_4
  mvi a, 12
  sta fs_print_3
  xra a
  call fs_print
  ret
; --------------------------------------------------------------
drawWindowInput:
;315 drawInput(windowX+x+2, windowY+y+2, max);
  lhld drawWindowInput_1
  mvi h, 0
  xchg
  lhld windowX
  mvi h, 0
  dad d
  inx h
  inx h
  sta drawWindowInput_3
  mov a, l
  sta drawInput_1
  lhld drawWindowInput_2
  mvi h, 0
  xchg
  lhld windowY
  mvi h, 0
  dad d
  inx h
  inx h
  mov a, l
  sta drawInput_2
  lda drawWindowInput_3
  call drawInput
  ret
; --------------------------------------------------------------
memset:
;2 asm {
  shld memset_3
    push b
    lda memset_2
    xchg
    lhld memset_1
    xchg
    lxi b, -1    
memset_l1:
    dad b
    jnc memset_l2
    stax d
    inx d
    jmp memset_l1
memset_l2:
    pop b
  
  ret
; --------------------------------------------------------------
compareMask1:
  push b
;8 for(;;) {
  sta compareMask1_3
l30:
l29:
;8 {
  lhld compareMask1_2
  mov a, m
;10 if(m == '*') return 1;
  cpi 42
  mov b, a
  jnz l30788
;10 return 1;
  mvi a, 1
  pop b
  ret
l30788:
;11 if(m != '?' && m != *fileName) return 0;  
  cpi 63
  jz l30797
  lhld compareMask1_1
  mov a, m
  cmp b
  jz l30797
;11 return 0;  
  xra a
  pop b
  ret
l30797:
;12 --i;
  lda compareMask1_3
  dcr a
;13 if(i==0) return 1;
  ora a
  sta compareMask1_3
  jnz l30798
;13 return 1;
  mvi a, 1
  pop b
  ret
l30798:
;14 ++mask, ++fileName;
  lhld compareMask1_2
  inx h
  shld compareMask1_2
  lhld compareMask1_1
  inx h
  shld compareMask1_1
  jmp l30
l28:
  pop b
  ret
; --------------------------------------------------------------
fs_cursor:
;182 directCursor(8+x, 3+y);
  sta fs_cursor_2
  lda fs_cursor_1
  adi 8
  sta directCursor_1
  lda fs_cursor_2
  adi 3
  call directCursor
  ret
; --------------------------------------------------------------
set32:
;4 asm {
  shld set32_2
    xchg ; de = set32_2
    lhld set32_1
    ldax d
    mov m, a
    inx h
    inx d
    ldax d
    mov m, a
    inx h
    inx d
    ldax d
    mov m, a
    inx h
    inx d
    ldax d
    mov m, a
  
  ret
; --------------------------------------------------------------
div32_16:
;9 ((ushort*)a)[1] = ((ushort*)a)[1] / b;
  shld div32_16_2
  xchg
  lhld div32_16_1
  inx h
  inx h
  mov a, m
  inx h
  mov h, m
  mov l, a
  call op_div16_swap
  xchg
  lhld div32_16_1
  inx h
  inx h
  mov m, e
  inx h
  mov m, d
;11 ((uchar*)&div32_16_tmp)[1] = op_div16_mod;
  lda op_div16_mod
;12 ((uchar*)&div32_16_tmp)[0] = ((uchar*)a)[1];
  lhld div32_16_1
  inx h
  sta (div32_16_tmp)+(1)
  mov a, m
;13 ((uchar*)a)[1] = div32_16_tmp / b;
  lhld div32_16_2
  xchg
  sta div32_16_tmp
  lhld div32_16_tmp
  call op_div16_swap
  mov a, l
  lhld div32_16_1
  inx h
  mov m, a
;15 ((uchar*)&div32_16_tmp)[1] = op_div16_mod;
  lda op_div16_mod
;16 ((uchar*)&div32_16_tmp)[0] = ((uchar*)a)[0];
  lhld div32_16_1
  sta (div32_16_tmp)+(1)
  mov a, m
;17 ((uchar*)a)[0] = div32_16_tmp / b;
  push h
  lhld div32_16_2
  xchg
  sta div32_16_tmp
  lhld div32_16_tmp
  call op_div16_swap
  mov a, l
  pop d
  stax d
  ret
; --------------------------------------------------------------
fs_create:
;1 { ((ushort*)a)[0] = (b&0xFFFF); ((ushort*)a)[1] = (b>>16); }
  shld fs_create_1
  lxi h, 43392
;1 ((ushort*)a)[1] = (b>>16); }
  shld readEmuSize
  lxi h, 3
;277 return 0;
  xra a
  shld (readEmuSize)+(2)
  ret
; --------------------------------------------------------------
fs_write:
  push b
;245 for(j=100; j; --j);
  lxi b, 100
  shld fs_write_2
l50:
l49:
  dcx b
  mov h, b
  mov l, c
  mov a, h
  ora l
  jnz l50
;246 return 0;
  xra a
  pop b
  ret
; --------------------------------------------------------------
applyMask1:
  push b
;80 for(;;) {
  sta applyMask1_3
l8:
l7:
;80 {
  lhld applyMask1_2
  mov a, m
;82 if(m == '*') return;
  cpi 42
  jnz l30799
;82 return;
  pop b
  ret
l30799:
;83 if(m != '?') *dest = m;
  cpi 63
  jz l30808
;83 *dest = m;
  lhld applyMask1_1
  mov m, a
l30808:
;84 --i;
  mov b, a
  lda applyMask1_3
  dcr a
;85 if(i==0) return;
  ora a
  jnz l30811
;85 return;
  pop b
  ret
l30811:
;86 ++mask, ++dest;
  lhld applyMask1_2
  inx h
  shld applyMask1_2
  lhld applyMask1_1
  inx h
  shld applyMask1_1
  sta applyMask1_3
  jmp l8
l6:
  pop b
  ret
; --------------------------------------------------------------
fs_getsize:
;300 set32(&fs_result, &readEmuSize);
  lxi h, fs_low
  shld set32_1
  lxi h, readEmuSize
  call set32
;301 return 0; 
  xra a
  ret
; --------------------------------------------------------------
drawWindowProgress:
;279 if(n == 0) return;
  sta drawWindowProgress_4
  lda drawWindowProgress_3
  ora a
  rz
;279 return;
l30812:
;280 fs_print(windowX+ox+2, windowY+oy+2, n, "", chr);
  lhld drawWindowProgress_1
  mvi h, 0
  xchg
  lhld windowX
  mvi h, 0
  dad d
  inx h
  inx h
  mov a, l
  sta fs_print_1
  lhld drawWindowProgress_2
  mvi h, 0
  xchg
  lhld windowY
  mvi h, 0
  dad d
  inx h
  inx h
  mov a, l
  sta fs_print_2
  lda drawWindowProgress_3
  sta fs_print_3
  lxi h, str32
  shld fs_print_4
  lda drawWindowProgress_4
  call fs_print
  ret
; --------------------------------------------------------------
fs_swap:
;236 set32(&tmp, &readEmuSize);
  lxi h, fs_swap_tmp
  shld set32_1
  lxi h, readEmuSize
  call set32
;237 set32(&readEmuSize, &readEmuSize2);
  lxi h, readEmuSize
  shld set32_1
  lxi h, readEmuSize2
  call set32
;238 set32(&readEmuSize2, &tmp);
  lxi h, readEmuSize2
  shld set32_1
  lxi h, fs_swap_tmp
  call set32
;239 return 0;
  xra a
  ret
; --------------------------------------------------------------
add32_16:
;4 asm {
  shld add32_16_2
    ; de = *to
    lhld add32_16_1
    mov e, m
    inx h
    mov d, m

    ; hl = de + from
    lhld add32_16_2
    dad d

    ; *hl = de
    xchg
    lhld add32_16_1
    mov m, e
    inx h
    mov m, d     

    ; …á«¨ ¯¥à¥¯®«­¥­¨¥, â® ã¢¥«¨ç¨¢ ¥¬ ¢¥àå­¨© à §àï¤
    rnc
    inx h
    inr m    

    ; …á«¨ ¯¥à¥¯®«­¥­¨¥, â® ã¢¥«¨ç¨¢ ¥¬ ¢¥àå­¨© à §àï¤
    rnz
    inx h
    inr m
  
  ret
; --------------------------------------------------------------
cmp32_32:
;4 asm {
  shld cmp32_32_2
    lhld cmp32_32_1
    inx h
    inx h
    inx h
    xchg

    lhld cmp32_32_2
    inx h
    inx h
    inx h
  
    ldax d
    cmp m
    jnz cmp32_32_l0
   
    dcx h
    dcx d
    ldax d
    cmp m
    jnz cmp32_32_l0
    
    dcx h
    dcx d
    ldax d
    cmp m
    jnz cmp32_32_l0

    dcx h
    dcx d
    ldax d
    cmp m
    rz

cmp32_32_l0:   
    cmc
    sbb a
    ori 1
    ret
  
  ret
; --------------------------------------------------------------
sub32_32:
;4 asm {
  shld sub32_32_2
    lhld sub32_32_1
    xchg
    lhld sub32_32_2
  
    ldax d
    sub m
    stax d
   
    inx h
    inx d
    ldax d
    sbb m
    stax d
    
    inx h
    inx d
    ldax d
    sbb m
    stax d

    inx h
    inx d
    ldax d
    sbb m
    stax d
  
  ret
; --------------------------------------------------------------
; STDLIB
; --------------------------------------------------------------
op_cmp16:
    mov a, h
    cmp d
    rnz
    mov a, l
    cmp e
    ret
; Óìíîæåíèå HL íà DE, ðåçóëüòàò â HL. BC ïîðòèòü íåëüçÿ

op_mul16:
  push b
  mov b, h
  mov c, l
  lxi h, 0
  mvi a, 17
op_mul16_1:
  dcr a
  jz op_mul16_4
  dad h
  xchg
  jnc op_mul16_2
  dad h
  inx h
  jmp op_mul16_3
op_mul16_2:
  dad h
op_mul16_3:
  xchg
  jnc op_mul16_1
  dad b
  jnc op_mul16_1
  inx d
  jmp op_mul16_1
  ret
op_mul16_4:
  pop b
  ret
op_div16_mod: .dw 0

op_div16:
        xchg
op_div16_swap:
        PUSH B ; HL äåëèòñÿ íà DE, ðåçóëüòàò â HL, îñòàòîê â DE
        XCHG
        CALL _DIV0
        XCHG
        SHLD op_div16_mod
        XCHG
        POP B
        RET

_DIV0:
_DIV:	MOV A,H
	ORA L
	RZ
	LXI B,0000
	PUSH B
_DIV1:	MOV A,E
	SUB L
	MOV A,D
	SBB H
	JC _DIV2
	PUSH H
	DAD H
	JNC _DIV1
_DIV2:	LXI H,0000
_DIV3:	POP B
	MOV A,B
	ORA C
	RZ
	DAD H
	PUSH D
	MOV A,E
	SUB C
	MOV E,A
	MOV A,D
	SBB B
	MOV D,A
	JC _DIV4
	INX H
	POP B
	JMP _DIV3
_DIV4:	POP D
	JMP _DIV3  
        RET

op_mod16:
        xchg
op_mod16_swap:
        call op_div16
        lhld op_div16_mod
        ret
op_sub16:
    xchg
op_sub16_swap:
    mov a, l
    sub e
    mov l, a
    mov a, h
    sbb d
    mov h, a
    ret
; Ñäâèã HL íà DE, ðåçóëüòàò â HL. BC ïîðòèòü íåëüçÿ

op_shr16:
  xchg
op_shr16_swap:
  inr e
op_shr16_l:
  dcr e
  rz
  sub a
  ora h 
  rar
  mov h, a
  mov a, l
  rar
  mov l, a
  jmp op_shr16_l
op_and16:
    mov a, h
    ana d
    mov h, a
    mov a, l
    ana e
    mov l, a
    ret
; --------------------------------------------------------------
; STRINGS
; --------------------------------------------------------------
str32: .db "", 0
str36: .db "", 0
str37: .db "", 0
str5: .db "", 0
str27: .db "", 0
str38: .db " ", 0
str29: .db "   ", 0
str46: .db "     <DIR>", 0
str1: .db " kopirowanie ", 0
str7: .db " kopirowatx ", 0
str16: .db " mb", 0
str17: .db " nakopitelx ", 0
str50: .db " o{ibka ", 0
str9: .db " pereimenowanie/pereme}enie ", 0
str8: .db " pereimenowatx/peremestitx ", 0
str26: .db " pometitx fajly ", 0
str23: .db " sozdatx fajl ", 0
str22: .db " sozdatx papku ", 0
str12: .db " udalenie ", 0
str13: .db " udalitx ", 0
str25: .db "*.*", 0
str65: .db ".IN", 0
str64: .db ".RK", 0
str6: .db "/", 0
str66: .db "0123456789ABCDEF", 0
str45: .db "1 FREE 2 NEW  3 VIEW  4 EDIT 5 COPY 6 REN  7 DIR  8 DEL", 0
str33: .db ":", 0
str47: .db ">", 0
str30: .db "FILE    TXT", 0
str28: .db "FOLDER     ", 0
str34: .db "FOLDER01", 0
str35: .db "FOLDER01/FOLDER04", 0
str31: .db "TXT", 0
str39: .db "[", 0
str48: .db "[ ok ]", 0
str62: .db "[ ok ]  [ otmena ]", 0
str49: .db "[ stop ]", 0
str63: .db "[ wk - ok ]  [ ar2 - otmena ]", 0
str40: .db "]", 0
str41: .db "bajt w    ", 0
str57: .db "disk zapolnen", 0
str58: .db "fail su}estwuet", 0
str54: .db "fajl ne otkryt", 0
str43: .db "fajlah ", 0
str42: .db "fajle ", 0
str44: .db "imq", 0
str61: .db "imq:", 0
str2: .db "iz:", 0
str56: .db "maksimum fajlow w papke", 0
str51: .db "net fajlowoj sistemy", 0
str10: .db "o{ibka kopirowaniq", 0
str52: .db "o{ibka nakopitelq", 0
str11: .db "o{ibka pereme}eniq", 0
str24: .db "o{ibka sozdaniq papki", 0
str15: .db "o{ibka udaleniq", 0
str19: .db "o{ibka ~teniq", 0
str53: .db "papka ne pusta", 0
str59: .db "prerwano polxzowatelem", 0
str18: .db "prowerka...", 0
str60: .db "putx bolx{e 255 simwolow", 0
str55: .db "putx ne najden", 0
str4: .db "skopirowano           /           bajt", 0
str20: .db "swobodno: ", 0
str3: .db "w:", 0
str21: .db "wsego:", 0
str14: .db "wy hotite udalitx fail(y)?", 0
; --------------------------------------------------------------
; GLOBAL VARS
; --------------------------------------------------------------
fs_cmdLine: .dw $+2
 .db 0
 .ds 1
fs_selfName: .dw $+2
 .db 83, 72, 69, 76, 76, 46, 82, 75, 0
fs_low: .ds 2
fs_high: .ds 2
fs_screenWidth: .ds 1
fs_screenHeight: .ds 1
fs_colors: .ds 1
readEmuSize: .ds 4
readEmuSize2: .ds 4
activePanel: .ds 1
activePanelN: .ds 1
activePanel0: .ds 1
fileCursorX: .ds 1
fileCursorY: .ds 1
windowX: .ds 1
windowY: .ds 1
onePanel: .ds 1
window: .dw $+2
 .ds 2
editorApp: .db 66, 79, 79, 84, 47, 69, 68, 73, 84, 46, 82, 75, 0
viewerApp: .db 66, 79, 79, 84, 47, 86, 73, 69, 87, 46, 82, 75, 0
panelA: .ds 266
panelB: .ds 266
cmdline: .ds 256
maxFiles: .ds 2
rowsCnt: .db 16
parentDir: .db 46, 46, 32, 32, 32, 32, 32, 32, 32, 32, 32, 16, 0, 0, 0, 0
 .db 0, 0, 0, 0
nextSelectedCnt: .ds 2
nextSelectedFile: .dw $+2
 .ds 2
div32_16_tmp: .ds 2
rand_seed: .db 250
; --------------------------------------------------------------
; FUNCTION VARS
; --------------------------------------------------------------
main_c: .ds 1
drawCmdLineWithPath_o: .ds 2
drawCmdLineWithPath_l: .ds 2
drawCmdLineWithPath_old: .ds 2
drawCmdLineWithPath_max: .ds 1
loadState_i: .ds 2
getFiles_f: .ds 2
getFiles_st: .ds 2
getFiles_n: .ds 2
getFiles_i: .ds 1
getFiles_j: .ds 2
getFiles_dir: .ds 20
dupFiles_1: .ds 1
selectFile_1: .ds 2
selectFile_l: .ds 2
selectFile_f: .ds 2
fs_bioskey_1: .ds 1
cmd_freespace_e: .ds 1
cmd_new_1: .ds 1
cmd_editview_1: .ds 2
cmd_editview_f: .ds 2
cmd_enter_d: .ds 2
cmd_enter_i: .ds 1
cmd_enter_f: .ds 2
cmd_enter_l: .ds 2
cmd_enter_o: .ds 2
cursor_right_w: .ds 2
cmd_copymove_1: .ds 1
cmd_copymove_2: .ds 1
cmd_delete_e: .ds 1
cmd_delete_needRefresh2: .ds 1
cmd_inverseOne_f: .ds 2
cmd_inverseAll_f: .ds 2
cmd_inverseAll_i: .ds 2
cmd_sel_1: .ds 1
cmd_sel_f: .ds 2
cmd_sel_i: .ds 2
cmd_sel_buf: .ds 11
processInput_1: .ds 1
processInput_cmdline_pos: .ds 2
fs_print_1: .ds 1
fs_print_2: .ds 1
fs_print_3: .ds 1
fs_print_4: .ds 2
fs_print_5: .ds 1
drawPanelTitle_1: .ds 1
drawPanelTitle_2: .ds 2
drawPanelTitle_l: .ds 2
drawPanelTitle_x: .ds 1
strlen_1: .ds 2
strcmp_1: .ds 2
strcmp_2: .ds 2
strcmp_a: .ds 1
strcmp_b: .ds 1
strcpy_1: .ds 2
strcpy_2: .ds 2
fs_open_1: .ds 2
fs_read_1: .ds 2
fs_read_2: .ds 2
memcpy_1: .ds 2
memcpy_2: .ds 2
memcpy_3: .ds 2
fs_findfirst_1: .ds 2
fs_findfirst_2: .ds 2
fs_findfirst_3: .ds 2
fs_findfirst_i: .ds 1
fs_findfirst_xx: .ds 1
sort_1: .ds 2
sort_2: .ds 2
sort_i: .ds 2
sort_j: .ds 2
sort_x: .ds 2
sort_st_: .ds 128
sort_st: .ds 2
sort_stc: .ds 1
getSel_n: .ds 2
memcmp_1: .ds 2
memcmp_2: .ds 2
memcmp_3: .ds 2
drawFilesCount_total: .ds 4
drawFilesCount_i: .ds 2
drawFilesCount_filesCnt: .ds 2
drawFilesCount_p: .ds 2
drawFileInfo_f: .ds 2
drawFileInfo_buf: .ds 18
drawWindow_1: .ds 2
drawWindow_i: .ds 1
drawWindowText_1: .ds 1
drawWindowText_2: .ds 1
drawWindowText_3: .ds 2
drawError_1: .ds 2
drawError_2: .ds 1
drawError_buf: .ds 4
cmd_freespace_1_1: .ds 1
cmd_freespace_1_2: .ds 2
cmd_freespace_1_buf: .ds 17
cmd_new1_1: .ds 1
unpackName_1: .ds 2
unpackName_2: .ds 2
unpackName_i: .ds 1
absolutePath_1: .ds 2
absolutePath_l: .ds 2
run_1: .ds 2
run_2: .ds 2
runCmdLine_cmdLine2: .ds 2
getSelNoBack_f: .ds 2
dropPath_buf: .ds 11
reloadFiles_1: .ds 2
cmd_copymove1_1: .ds 1
cmd_copymove1_2: .ds 1
cmd_copymove1_name: .ds 2
cmd_copymove1_e: .ds 1
cmd_copymove1_f: .ds 2
cmd_copymove1_sourceFile: .ds 256
cmd_copymove1_mask: .ds 11
cmd_copymove1_forMask: .ds 11
cmd_copymove1_type: .ds 1
cmd_copymove1_i: .ds 2
confirm_1: .ds 2
confirm_2: .ds 2
getFirstSelected_1: .ds 2
getFirstSelected_type: .ds 1
cmd_deleteFolder_level: .ds 1
cmd_deleteFolder_e: .ds 1
cmd_deleteFolder_p: .ds 2
cmd_deleteFolder_i: .ds 2
getNextSelected_1: .ds 2
drawFile_1: .ds 1
drawFile_2: .ds 1
drawFile_3: .ds 2
inputBox_1: .ds 2
inputBox_c: .ds 1
inputBox_clearFlag: .ds 1
packName_1: .ds 2
packName_2: .ds 2
packName_c: .ds 1
packName_f: .ds 1
packName_i: .ds 1
compareMask_1: .ds 2
compareMask_2: .ds 2
drawInput_1: .ds 1
drawInput_2: .ds 1
drawInput_3: .ds 1
drawInput_c: .ds 2
drawInput_c1: .ds 2
drawInput_old: .ds 2
drawInput_cmdline_offset: .ds 2
drawInput_cmdline_pos: .ds 2
drawRect_1: .ds 1
drawRect_2: .ds 1
drawRect_3: .ds 1
drawRect_4: .ds 1
drawRect_5: .ds 1
drawRect_x1: .ds 1
sub32_16_1: .ds 2
sub32_16_2: .ds 2
memswap_1: .ds 2
memswap_2: .ds 2
memswap_3: .ds 2
directCursor_1: .ds 1
directCursor_2: .ds 1
i2s_1: .ds 2
i2s_2: .ds 2
i2s_3: .ds 2
i2s_4: .ds 1
cmpFileInfo_1: .ds 2
cmpFileInfo_2: .ds 2
cmpFileInfo_i: .ds 1
cmpFileInfo_j: .ds 1
drawColumn_1: .ds 1
drawColumn_y: .ds 1
drawColumn_xx: .ds 1
drawColumn_yy: .ds 1
drawColumn_n: .ds 2
drawColumn_f: .ds 2
add32_32_1: .ds 2
add32_32_2: .ds 2
drawFilesCountInt_1: .ds 2
drawFilesCountInt_2: .ds 2
drawFilesCountInt_v: .ds 1
drawFilesCountInt_x: .ds 1
drawFilesCountInt_y: .ds 1
drawFilesCountInt_buf: .ds 12
i2s32_1: .ds 2
i2s32_2: .ds 2
i2s32_3: .ds 2
i2s32_4: .ds 1
i2s32_v: .ds 4
drawFileInfo1_1: .ds 2
drawFileInfo2_1: .ds 2
drawWindowTextCenter_1: .ds 1
drawWindowTextCenter_2: .ds 2
memcpy_back_1: .ds 2
memcpy_back_2: .ds 2
memcpy_back_3: .ds 2
fs_mkdir_1: .ds 2
fs_mkdir_i: .ds 2
fs_exec_1: .ds 2
fs_exec_2: .ds 2
strchr_1: .ds 2
strchr_2: .ds 1
dropPathInt_1: .ds 2
dropPathInt_2: .ds 2
dropPathInt_p: .ds 2
getName_1: .ds 2
getName_p: .ds 2
applyMask_1: .ds 2
applyMask_2: .ds 2
catPathAndUnpack_1: .ds 2
catPathAndUnpack_2: .ds 2
catPathAndUnpack_len: .ds 2
cmd_copyFolder_1: .ds 2
cmd_copyFolder_2: .ds 2
cmd_copyFolder_e: .ds 1
cmd_copyFolder_i: .ds 2
cmd_copyFolder_level: .ds 1
cmd_copyFolder_stack: .ds 16
cmd_copyFolder_f: .ds 2
cmd_copyFile_1: .ds 2
cmd_copyFile_2: .ds 2
cmd_copyFile_buf: .ds 16
cmd_copyFile_e: .ds 1
cmd_copyFile_progress_i: .ds 1
cmd_copyFile_progress: .ds 4
cmd_copyFile_progress_x: .ds 4
cmd_copyFile_progress_step: .ds 4
fs_move_1: .ds 2
fs_move_2: .ds 2
fs_move_i: .ds 2
fs_delete_1: .ds 2
fs_delete_i: .ds 2
drawFile2_1: .ds 1
drawFile2_2: .ds 1
drawFile2_3: .ds 2
drawFile2_buf: .ds 12
drawWindowInput_1: .ds 1
drawWindowInput_2: .ds 1
drawWindowInput_3: .ds 1
memset_1: .ds 2
memset_2: .ds 1
memset_3: .ds 2
compareMask1_1: .ds 2
compareMask1_2: .ds 2
compareMask1_3: .ds 1
compareMask1_m: .ds 1
fs_cursor_1: .ds 1
fs_cursor_2: .ds 1
set32_1: .ds 2
set32_2: .ds 2
div32_16_1: .ds 2
div32_16_2: .ds 2
fs_create_1: .ds 2
fs_write_1: .ds 2
fs_write_2: .ds 2
fs_write_j: .ds 2
fs_write_k: .ds 2
applyMask1_1: .ds 2
applyMask1_2: .ds 2
applyMask1_3: .ds 1
applyMask1_m: .ds 1
drawWindowProgress_1: .ds 1
drawWindowProgress_2: .ds 1
drawWindowProgress_3: .ds 1
drawWindowProgress_4: .ds 1
fs_swap_tmp: .ds 4
add32_16_1: .ds 2
add32_16_2: .ds 2
cmp32_32_1: .ds 2
cmp32_32_2: .ds 2
sub32_32_1: .ds 2
sub32_32_2: .ds 2
.end