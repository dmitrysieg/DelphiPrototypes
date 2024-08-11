{$APPTYPE GUI}

uses
   {$R 'menu.res' 'menu.rc'}
   Windows,
   Messages,
   CommDlg,
   StrUtils;

const
   clsName: PChar = 'MyWindowClass';
   wndName: PChar = 'Hello, World!';
   IDM_EXIT: LongWord = 103;
   IDM_OPEN: LongWord = 101;
   IDM_SAVE: LongWord = 102;
   MAX_FILENAME_LENGTH = 1024;

procedure ProcessOpenFile(hwnd: HWND);
var
   ofn: OPENFILENAME;
   oFileName: AnsiString;
   oFileTitle: AnsiString;
begin
   FillChar(ofn, sizeof(ofn), 0);
   SetLength(oFilename, MAX_FILENAME_LENGTH);
   SetLength(oFileTitle, MAX_FILENAME_LENGTH);
   
   with ofn do begin
      lStructSize := sizeof(ofn);

      hWndOwner := hwnd;
      hInstance := GetModuleHandle(nil);

      lpstrFile := PAnsiChar(oFileName);
      lpstrFileTitle := PAnsiChar(oFileTitle);
      nMaxFileTitle := MAX_FILENAME_LENGTH;
      nMaxFile := MAX_FILENAME_LENGTH;
      lpstrTitle := PChar('Open File...');
      lpstrFilter := PChar('All files (*.*)' + #0 + '*.*' + #0 + 'EXE files (*.exe)' + #0 + '*.exe' + #0);
      nFilterIndex := 2;
      Flags := OFN_PATHMUSTEXIST or OFN_FILEMUSTEXIST;
   end;

   if GetOpenFileName(ofn) then begin
      MessageBox(hwnd, PChar(oFileName), PChar(oFileTitle), 0);
   end;
end;

procedure ProcessSaveFileExtension(var S: AnsiString; Extension: AnsiString);
begin
   SetLength(S, lstrlen(PChar(S)));
   if not StrUtils.AnsiEndsText(Extension, S) then begin
      S := lstrcat(PChar(S), PChar(Extension));
   end;
end;

procedure ProcessSaveFile(hwnd: HWND);
var
   ofn: OPENFILENAME;
   oFileName: AnsiString;
   oFileTitle: AnsiString;
begin
   FillChar(ofn, sizeof(ofn), 0);
   SetLength(oFilename, MAX_FILENAME_LENGTH);
   SetLength(oFileTitle, MAX_FILENAME_LENGTH);

   with ofn do begin
      lStructSize := sizeof(ofn);

      hWndOwner := hwnd;
      hInstance := GetModuleHandle(nil);

      lpstrFile := PAnsiChar(oFileName);
      lpstrFileTitle := PAnsiChar(oFileTitle);
      nMaxFileTitle := MAX_FILENAME_LENGTH;
      nMaxFile := MAX_FILENAME_LENGTH;
      lpstrTitle := PChar('Save File...');
      lpstrFilter := PChar('EXE files (*.exe)' + #0 + '*.exe' + #0);
      nFilterIndex := 1;
//      Flags := OFN_PATHMUSTEXIST or OFN_FILEMUSTEXIST;
   end;

   if GetSaveFileName(ofn) then begin
      ProcessSaveFileExtension(oFileName, '.exe');
      ProcessSaveFileExtension(oFileTitle, '.exe');
      MessageBox(hwnd, PChar(oFileName), PChar(oFileTitle), 0);
   end;
end;

function WndProc(hwnd: HWND; msg, wPar, lPar: LongWord): LRESULT; stdcall;
var
   hdc: Windows.HDC;
   ps: PAINTSTRUCT;
begin
   case msg of

      WM_CREATE: WndProc := 1;

      WM_DESTROY: begin
         PostQuitMessage(0);
         WndProc := 0;
      end;

      WM_PAINT: begin
         hdc := BeginPaint(hwnd, ps);
         FillRect(hdc, ps.rcPaint, HBRUSH(COLOR_WINDOW + 1));
         EndPaint(hwnd, ps);
      end;

      WM_COMMAND: begin
         if wPar = IDM_EXIT then begin
            PostQuitMessage(0);
            WndProc := 0;
         end else
         if wPar = IDM_OPEN then begin
            ProcessOpenFile(hwnd);
         end else
         if wPar = IDM_SAVE then begin
            ProcessSaveFile(hwnd);
         end;
      end;

      else WndProc := DefWindowProc(hwnd, msg, wPar, lPar);
   end;
end;

var
   hInst: HMODULE;
   wClass: TWndClass;
   hwnd: Windows.HWND;
   msg: Windows.MSG;
   MainMenu: HMENU;
begin
   hInst := GetModuleHandle(nil);

   with wClass do begin
      lpfnWndProc    := @WndProc;
      hInstance      := hInst;
      lpszClassName  := clsName;
      hIcon          := LoadIcon(0, IDI_APPLICATION);
      hCursor        := LoadCursor(0, IDC_ARROW);
   end;

   RegisterClass(wClass);
   hwnd := CreateWindow(
      clsName,
      wndName,
      WS_TILEDWINDOW,
      CW_USEDEFAULT,
      CW_USEDEFAULT,
      CW_USEDEFAULT,
      CW_USEDEFAULT,
      0,
      0,
      hInst,
      nil
   );

   MainMenu := LoadMenu(hInst, 'MYMENU');
   SetMenu(hwnd, MainMenu);

   ShowWindow(hwnd, SW_SHOWNORMAL);
   UpdateWindow(hwnd);

   while GetMessage(msg, 0, 0, 0) do begin
      TranslateMessage(msg);
      DispatchMessage(msg);
   end;

   DeleteObject(wClass.hbrBackground);
end.