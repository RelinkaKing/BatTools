#include <stdio.h>
#include <Windows.h>
#include "tlhelp32.h"
#include <stdlib.h>
#include <string>
#include <vector>
#include <WINSOCK2.H>  
#include "base64.h"
using namespace std;

string model_id;
string page_no;
string unity_path = "C:\\VesalPPT\\vesal_3D_ppt_unity.exe";
#define unity_port 16666

const BYTE START_CMD       = 1;
const BYTE CONFIRM_CMD     = 2;
const BYTE MSG_CMD         = 3;
const BYTE CTRL_CMD        = 4;
const BYTE WIN_HWND        = 5;

struct net_pack
{
    BYTE _cmd_code;
    WORD _data_len;
    BYTE _data[1000];

    int set_string_data(BYTE cmd_code, const string& str, vector<BYTE> &lst)
    {
        WORD len = str.size();
        lst.resize(3 + len);
        lst[0] = cmd_code;
        lst[1] = len / 256;
        lst[2] = len % 256;
        for (int i = 0; i < len; i++)
        {
            lst[i + 3] = str[i];
        }
    }
};

DWORD WINAPI start_3d(void*)
{
    string cmd = unity_path + " ";
    cmd += model_id;
    system(cmd.c_str());
    return 0;
}

DWORD GetProcessidFromName(LPCTSTR name)
{
    PROCESSENTRY32 pe;
    DWORD id=0;
    HANDLE hSnapshot=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
    pe.dwSize=sizeof(PROCESSENTRY32);
    if (!Process32First(hSnapshot,&pe))
        return 0;

    while(1)
    {
        pe.dwSize=sizeof(PROCESSENTRY32);
        if(Process32Next(hSnapshot,&pe)==FALSE)
        break;
        if(strcmp(pe.szExeFile,name)==0)
        {
            id = pe.th32ProcessID;         
            break;
        }    
    }

    CloseHandle(hSnapshot);
    return id;
}

bool test_unity_started()
{
    while (true)
    {
        SOCKET sclient = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);  
        if(sclient == INVALID_SOCKET)  
        {  
            printf("invalid socket!");  
            return false;  
        }  

        sockaddr_in serAddr;  
        serAddr.sin_family = AF_INET;  
        serAddr.sin_port = htons(unity_port);  
        serAddr.sin_addr.S_un.S_addr = inet_addr("127.0.0.1");  
        if (connect(sclient, (sockaddr *)&serAddr, sizeof(serAddr)) == SOCKET_ERROR)  
        {  //连接失败   
            closesocket(sclient);  
            return false;
        }      

        closesocket(sclient);  
        printf("3d program started!\n");
        return true;    // 成功了。
    }
}

string get_db_pwd()
{
    FILE *fp = fopen("C:\\VesalPPT\\tmp.dat", "rb");
    if (fp == NULL)
    {
        return "";
    }

    char buff[2000] = {0};
    int len = fread(buff, 1, 2000, fp);
    Base64 b64;
    string str = b64.Decode(buff, len);

    for (int i = str.size(); i--; )
    {
        str[i] ^= 0x55;
    }

    return str;
}

HWND get_ppt_mainwin_hwnd()
{
	POINT p;
	p.x = GetSystemMetrics(SM_CXSCREEN) / 2;
	p.y = 0;
	
	HWND hwndPointNow = WindowFromPoint(p);  // 获取鼠标所在窗口的句柄  
	//*/
	return hwndPointNow;
	/*/
	DWORD dwProcessID;
	::GetWindowThreadProcessId(hwndPointNow, &dwProcessID);
	printf("pid is %d\n", dwProcessID);
	
	return NULL;
	//*/
}

bool send_cmd_2_unity()
{
    SOCKET sclient = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);  
    if(sclient == INVALID_SOCKET)  
    {  
        printf("invalid socket!");  
        return false;  
    }  

    sockaddr_in serAddr;  
    serAddr.sin_family = AF_INET;  
    serAddr.sin_port = htons(unity_port);  
    serAddr.sin_addr.S_un.S_addr = inet_addr("127.0.0.1");  
    if (connect(sclient, (sockaddr *)&serAddr, sizeof(serAddr)) == SOCKET_ERROR)  
    {  //连接失败   
        //printf("connect error !");  
        closesocket(sclient);  
        return false;  
    }      

    string vesal_dat = "1*c:\\VesalPPT\\vesal.dat";
    string cmd = vesal_dat + "*" + get_db_pwd() + "*" + model_id;
    vector<BYTE> lst;
    net_pack np;
    np.set_string_data(MSG_CMD, cmd, lst);
    send(sclient, (const char*)&lst[0], lst.size(), 0);

    BYTE buff[1000] = {0};
    int len = recv(sclient, (char*)buff, 3, 0);
    if (len <= 0)
    {
        closesocket(sclient);
        return false;
    }

    int pack_len = buff[1] * 256 + buff[2];
    len = recv(sclient, (char*)(buff + 3), pack_len, 0);
    if (len <= 0)
    {
        closesocket(sclient);
        return false;
    }

    // 不用判断返回包类型了，收到了就表示应答成功了。
	
	// 发送一下页码和句柄
	lst.clear();
	net_pack np2;
	string cmd_hwnd;
	
	char tmp_buf[100];
	sprintf(tmp_buf, "%d", get_ppt_mainwin_hwnd());
	cmd_hwnd += tmp_buf;
	cmd_hwnd += ",";
	cmd_hwnd += page_no;
	
    np2.set_string_data(WIN_HWND, cmd_hwnd, lst);
    send(sclient, (const char*)&lst[0], lst.size(), 0);
	

    closesocket(sclient);
    return true;    // 成功了。
}

typedef struct
{
    HWND hWnd;
    DWORD dwPid;
}WNDINFO;
 
BOOL CALLBACK EnumWindowsProc(HWND hWnd, LPARAM lParam)
{
    WNDINFO* pInfo = (WNDINFO*)lParam;
    DWORD dwProcessId = 0;
    GetWindowThreadProcessId(hWnd, &dwProcessId);

    if(dwProcessId == pInfo->dwPid)
    {
        pInfo->hWnd = hWnd;
        return FALSE;
    }
    return TRUE;
}
 
HWND GetHwndByProcessId(DWORD dwProcessId)
{
    WNDINFO info = {0};
    info.hWnd = NULL;
    info.dwPid = dwProcessId;
    EnumWindows(EnumWindowsProc, (LPARAM)&info);
    return info.hWnd;
}


void homing_trim(string& str) 
{ 
    string::size_type pos = str.find_last_not_of(' '); 
    if(pos != string::npos) 
    { 
        str.erase(pos + 1); 
        pos = str.find_first_not_of(' '); 
        if(pos != string::npos) str.erase(0, pos); 
    } 
    else 
        str.erase(str.begin(), str.end());  
} 

void homing_split(const string& str, const string& separator, vector<string>& lst_string, bool trim)
{
    lst_string.clear();
    int find_begin_pos = 0;
    int pos = 0;
    int sepa_len = separator.size();
    while (true)
    {
        pos = str.find(separator, find_begin_pos);
        if (pos == -1)
        {
            break;
        }
        if (pos != find_begin_pos)
            lst_string.push_back(str.substr(find_begin_pos, pos - find_begin_pos));
        find_begin_pos = pos + sepa_len;
    }
    string tail = str.substr(find_begin_pos);
    if (!tail.empty())
        lst_string.push_back(tail);

    if (trim)
    {
        for (int i = lst_string.size(); i--; )
        {
            homing_trim(lst_string[i]);
        }
    }
}

int main(int c, char **paras)
{
	get_ppt_mainwin_hwnd();
	
    string exe_name = paras[0];
    for (int i = exe_name.size(); i--; )
    {
        if (exe_name[i] == '\\' || exe_name[i] == '/')
        {
            exe_name = exe_name.substr(i + 1);
            break;
        }
    }
	


    WORD sockVersion = MAKEWORD(2, 2);  
    WSADATA data;  
    if (WSAStartup(sockVersion, &data)!=0)  
    {  
        return 0;  
    }  

    

    // 先判断一下unity是否启动
    DWORD process_id = GetProcessidFromName("vesal_3D_ppt_unity.exe");
    if (process_id == 0)
    {
        STARTUPINFO si;
        PROCESS_INFORMATION pi;
        ZeroMemory(&si, sizeof(si));
        si.cb = sizeof(si);
        ZeroMemory(&pi, sizeof(pi));
     
        si.dwFlags = STARTF_USESHOWWINDOW;  // 指定wShowWindow成员有效
        si.wShowWindow = TRUE; 
                            // 为FALSE的话则不显示
        BOOL bRet = ::CreateProcess (
            NULL,           // 不在此指定可执行文件的文件名
            "C:\\VesalPPT\\vesal_3D_ppt_unity.exe",      // 命令行参数
            NULL,           // 默认进程安全性
            NULL,           // 默认线程安全性
            FALSE,          // 指定当前进程内的句柄不可以被子进程继承
            CREATE_NEW_CONSOLE, // 为新进程创建一个新的控制台窗口
            NULL,           // 使用本进程的环境变量
            NULL,           // 使用本进程的驱动器和目录
            &si,
            &pi);


        DWORD start_time = GetTickCount();
        while (true)
        {
            bool ret = test_unity_started();
            if (ret)
                break;

            Sleep(10);
            if (GetTickCount() - start_time >= 15 * 1000)
            {
                return 1;
            }
        }
        // 再获取一下pid
        process_id = GetProcessidFromName("vesal_3D_ppt_unity.exe");
    }   

    
    int pos = exe_name.find(".");
    model_id = exe_name.substr(0, pos);
    send_cmd_2_unity();

    string conf_path = "C:\\VesalPPT\\";
    conf_path += model_id + ".conf";
    FILE* fp = fopen(conf_path.c_str(), "rb");
    if (fp == NULL)
    {
        return 0;
    }

    char buff[200] = {0};
    fread(buff, 1, sizeof(buff), fp);
    string model_paras = buff;
    fclose(fp);

    vector<string> lst_string;
    homing_split(model_paras, " ", lst_string, true);

    //model_id = paras[1];
    float _ppt_height = atof(lst_string[2].c_str());
    float _ppt_width = atof(lst_string[3].c_str());

    float pic_top = atof(lst_string[4].c_str());
    float pic_left = atof(lst_string[5].c_str());
    float pic_height = atof(lst_string[6].c_str());
    float pic_wid = atof(lst_string[7].c_str());
    page_no = lst_string[8].c_str();


    int screen_width = GetSystemMetrics(SM_CXSCREEN);
    int screen_hight = GetSystemMetrics (SM_CYSCREEN);

    int page_width = screen_width;
    int page_hight = screen_hight;

    float ratio1 = (float)screen_width / (float)screen_hight;
    float ratio2 = _ppt_width / _ppt_height;

    if (ratio1 >= ratio2)
    {
        page_hight = screen_hight;
        page_width = (int)(page_hight * ratio2);
    }
    else
    {
        page_width = screen_width;
        page_hight = (int)(page_width / ratio2);
    }


    int x = (screen_width - page_width) / 2 + (int)(pic_left * page_width / _ppt_width);
    int y = (screen_hight - page_hight) / 2 + (int)(pic_top * page_hight / _ppt_height);

    int x1 = (int)(pic_wid * page_width / _ppt_width);
    int y1 = (int)(pic_height * page_hight / _ppt_height);

    HWND hwnd = NULL;
    int count = 30;
    while (count--)
    {
        hwnd = GetHwndByProcessId(process_id);
        if (hwnd == NULL)
        {
            Sleep(100);
        }
        else
            break;
    }

    SetWindowLong(hwnd, GWL_STYLE, 0x80000000);
    ShowWindow(hwnd, 1);
    SetWindowPos(hwnd, HWND_NOTOPMOST, x, y, x1, y1, SWP_DRAWFRAME);
    ::SetForegroundWindow(hwnd);
    //SetWindowPos(hwnd, HWND_NOTOPMOST, x, y, x1, y1, SWP_DRAWFRAME);
}

