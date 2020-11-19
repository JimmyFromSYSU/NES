#include <windows.h>
#include <tchar.h>
#include "resource.h"
#include "tool.h"
#include "cpu.h"
#include "ppu.h"
#include "joystick.h"

#define PRINT_TIMER    1

#define KEY_DOWN(vk_code) ((GetAsyncKeyState(vk_code) & 0x8000) ? 1 : 0)   
// Global Variables:	

HINSTANCE hInst;							// current instance
TCHAR szTitle[] = TEXT("Tank");				// The title bar text
TCHAR szWindowClass[] = TEXT("WinApp");		// the class name
HWND hWnd;

// Foward declarations of functions included in this code module:
ATOM				MyRegisterClass(HINSTANCE hInstance);
BOOL				InitInstance(HINSTANCE, int);
LRESULT CALLBACK	WndProc(HWND, UINT, WPARAM, LPARAM);


//////////////////////////////////////////////////////////////////// begin nfxz
joystick j;
ppu p;
cpu c(&p,&j);
int test_cnt = 0;
const int SX = 0;
const int SY = 0; 
const int pSize  = 3;

unsigned int pData[240*256]={0};

int run_time = 0;		
int lock = 0;
MEMORY * palette;

// CPU 1 frame 
void CPU_RUN(void * c) {
	int f_cnt = 0;
	cpu * tank_cpu = (cpu *)c;
	
	tank_cpu->nmi();
	for(int i = 0;i<60000;i++)
		(tank_cpu->oneStep());
		
	tank_cpu->prepareImage();
	f_cnt++; 

	lock--;
	_endthread();  
}
bool saveImg =0;
bool DoSaveImg = 0;

void game_main(){
	HDC hdc;
	RECT rect;
	HBRUSH hbrush;   
	unsigned int* d ;
		
		
	int X,Y,row,col;
	unsigned int color;

	hdc = GetDC(hWnd);
	
	d = c.getColorData();
	FILE * fp;
	if(DoSaveImg==1){
		fp = fopen("testimg.coe","w");
		fprintf(fp,"memory_initialization_radix=16;\nmemory_initialization_vector=\n");
	}
	
	//if(run_time%2==0){
		for(row = 0;row< 240;row++)
		{
			for(col = 0;col<256;col++)
			{
					
				//hbrush = CreateSolidBrush(RGB(test_cnt,256-test_cnt,0));
				color = d[row*256+col];
				if(DoSaveImg==1){
					int r ,g,b;
					r = (color & 0xFF) >> 4;
					g = ((color >> 8) & 0xFF) >> 4;
					b = ((color >> 16) & 0xFF) >> 4;
					fprintf(fp,"%3X",r+(g<<4)+(b<<8));
					if(row==239 && col ==255)fprintf(fp,";");
					else fprintf(fp,",");
				}
				if(color != pData[row*256+col] || (run_time == 0)){
					X = SX + pSize*col;
					Y = SY + pSize*row;
					SetRect(&rect, X, Y, X+pSize,Y+pSize);
						
						
					//if(color==0)		hbrush = CreateSolidBrush(RGB(0,0,0));
					//else if(color==1)	hbrush = CreateSolidBrush(RGB(255,0,0));
					//else if(color==2)	hbrush = CreateSolidBrush(RGB(0,255,0));
					//else if(color==3)	hbrush = CreateSolidBrush(RGB(0,0,255));
					//else{
						hbrush = CreateSolidBrush(color);
					//}
					FillRect(hdc, &rect, hbrush); 
					DeleteObject(hbrush);
				}
			} 
			if(DoSaveImg==1){
				fprintf(fp,"\n");
			}
		}
	//}
	if(DoSaveImg){
		fclose(fp);
		printf("save file testimg.coe\n");
	}
	DoSaveImg = 0;
	if(saveImg == 1){
		DoSaveImg = 1;
		saveImg = 0;
	}
	
	ReleaseDC(hWnd, hdc);
	memcpy(pData,d,sizeof(unsigned int)*240*256);	
	run_time ++ ;
		
	// CPU Thread
	int hand=-1; 
	while(lock){
		Sleep(10);
	};
	if(lock == 0){
		lock++;
		hand=_beginthread(CPU_RUN,0, &c); 
	}
	//getch();
}

//////////////////////////////////////////////////////////////////// end nfxz

int APIENTRY WinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPSTR     lpCmdLine,
                     int       nCmdShow)
{
 	// TODO: Place code here.
	MSG msg;
	AllocConsole(); 

	freopen("conout$","w",stdout) ;
	
	// Register Class 
	MyRegisterClass(hInstance);

	// Perform application initialization:
	if (!InitInstance (hInstance, nCmdShow)) 
	{
		return FALSE;
	}
	
	
	//////////////////////////////////////////////////////////////////// nfxz
	palette = p.getPalette();
	
	// Main message loop:
	while (GetMessage(&msg, NULL, 0, 0)) 
	{
		//game_main();
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	return msg.wParam;
}



//
//  FUNCTION: MyRegisterClass()
//
//  PURPOSE: Registers the window class.
//
//  COMMENTS:
//
//    This function and its usage is only necessary if you want this code
//    to be compatible with Win32 systems prior to the 'RegisterClassEx'
//    function that was added to Windows 95. 
//
ATOM MyRegisterClass(HINSTANCE hInstance)
{
	WNDCLASSEX wcex;

	wcex.cbSize = sizeof(WNDCLASSEX); 

	wcex.style			= CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc	= (WNDPROC)WndProc;
	wcex.cbClsExtra		= 0;
	wcex.cbWndExtra		= 0;
	wcex.hInstance		= hInstance;
	wcex.hIcon			= LoadIcon (NULL, IDI_APPLICATION);
	wcex.hCursor		= LoadCursor(NULL, IDC_ARROW);
	wcex.hbrBackground	= (HBRUSH)(COLOR_WINDOW+1);
	wcex.lpszMenuName	= MAKEINTRESOURCE (IDC_TANK);
	wcex.lpszClassName	= szWindowClass;
	wcex.hIconSm		= LoadIcon (NULL, IDI_APPLICATION);

	return RegisterClassEx(&wcex);
}

//
//   FUNCTION: InitInstance(HANDLE, int)
//
//   PURPOSE: Saves instance handle and creates main window
//
//   COMMENTS:
//
//        In this function, we save the instance handle in a global variable and
//        create and display the main program window.
//
BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)
{

   hInst = hInstance; // Store instance handle in our global variable

   hWnd = CreateWindow(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW^WS_THICKFRAME,
      CW_USEDEFAULT, 0, 256*pSize, 240*pSize, NULL, NULL, hInstance, NULL);

   if (!hWnd)
   {
      return FALSE;
   }

   ShowWindow(hWnd, nCmdShow);
   UpdateWindow(hWnd);

   return TRUE;
}




//
//  FUNCTION: WndProc(HWND, unsigned, WORD, LONG)
//
//  PURPOSE:  Processes messages for the main window.
//
//  WM_COMMAND	- process the application menu
//  WM_PAINT	- Paint the main window
//  WM_DESTROY	- post a quit message and return
//
//
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	PAINTSTRUCT ps;
	HDC hdc;

	RECT rt;
	TCHAR szHello[]= TEXT ("Hello, C-Free!");
	

	switch (message) 
	{
		case WM_NCHITTEST:
 			break;
		case WM_TIMER:
 			game_main();
	 		break;
		//////////////////////////////////////////////////////////////////// nfxz
		case WM_KEYUP:
			j.setButton(JS_NO,0);
			break;
		case WM_KEYDOWN:
			switch (wParam)
			{
				case VK_TAB:
					j.setButton(JS_SELECT,0);
					break;
		
				//case VK_SPACE:
				//	j.setButton(JS_START,0);
				//	break;
				case VK_RETURN:
					j.setButton(JS_START,0);
					break;
				case VK_ESCAPE:
					saveImg = 1;
					break;
				case VK_SPACE:
					j.setButton(JS_A,0);
					break;
				case VK_RCONTROL:
					j.setButton(JS_B,0);
					break;
				case VK_UP:
					j.setButton(JS_UP,0);
					break;
				case VK_DOWN:
					j.setButton(JS_DOWN,0);
					break;
		
				case VK_LEFT:
					j.setButton(JS_LEFT,0);
					break;
	
				case VK_RIGHT:
					j.setButton(JS_RIGHT,0);
					break;
			}
			break;
		case WM_CREATE:
			SetTimer(hWnd, PRINT_TIMER, 10, NULL);
			break;
		case WM_COMMAND:
    		switch (LOWORD(wParam))
    		{
		    case IDM_ABOUT:
				MessageBox (hWnd, TEXT ("Tank v1.0\nCopyright (C) 2015\n"),
                        TEXT ("About"), MB_OK | MB_ICONINFORMATION);
				break;
			case IDM_EXIT:
				DestroyWindow(hWnd);
				break;
			default:
				return DefWindowProc(hWnd, message, wParam, lParam);	    		
		    }
    		break;
		case WM_PAINT:
			hdc = BeginPaint(hWnd, &ps);
			// TODO: Add any drawing code here...
	
			//GetClientRect(hWnd, &rt);
			//DrawText(hdc, szHello, lstrlen(szHello), &rt, DT_CENTER);
			EndPaint(hWnd, &ps);
			break;
		case WM_CLOSE:
			DestroyWindow(hWnd);
			break;
		case WM_DESTROY:
			PostQuitMessage(0);
			break;
		default:
			return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}
