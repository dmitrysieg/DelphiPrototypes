{$APPTYPE GUI}

uses
   Windows,
   Messages;

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

      else WndProc := DefWindowProc(hwnd, msg, wPar, lPar);
   end;
end;

const
   clsName: PChar = 'MyWindowClass';
   wndName: PChar = 'Hello, World!';

var
   hInst: HMODULE;
   wClass: TWndClass;
   hwnd: Windows.HWND;
   msg: Windows.MSG;
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

   ShowWindow(hwnd, SW_SHOWNORMAL);
   UpdateWindow(hwnd);

   while GetMessage(msg, 0, 0, 0) do begin
      TranslateMessage(msg);
      DispatchMessage(msg);
   end;

   DeleteObject(wClass.hbrBackground);
end.