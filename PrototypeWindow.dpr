{$APPTYPE GUI}

uses
   {$R 'menu.res' 'menu.rc'}
   Windows,
   Messages;

const
   clsName: PChar = 'MyWindowClass';
   wndName: PChar = 'Hello, World!';
   IDM_EXIT: LongWord = 103;

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