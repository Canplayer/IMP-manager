// SnipasteRun.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

#include <iostream>
#include <windows.h>
#include <tlhelp32.h>    //进程快照函数头文件
#include <stdio.h>
#include <string>

#pragma warning(disable:4996)
#pragma comment( linker, "/subsystem:windows /entry:mainCRTStartup" )


static unsigned char dec_tab[256] = {
            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
            0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  0,  0,  0,  0,  0,  0,
            0, 10, 11, 12, 13, 14, 15,  0,  0,  0,  0,  0,  0,  0,  0,  0,
            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
            0, 10, 11, 12, 13, 14, 15,  0,  0,  0,  0,  0,  0,  0,  0,  0,
            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
};

/**
 * URL 解码函数
 * @param str {const char*} 经URL编码后的字符串
 * @return {char*} 解码后的字符串，返回值不可能为空，需要用 free 释放
 */
char* acl_url_decode(const char* str) {
    int len = (int)strlen(str);
    char* tmp = (char*)malloc(len + 1);

    int i = 0, pos = 0;
    for (i = 0; i < len; i++) {
        if (str[i] != '%')
            tmp[pos] = str[i];
        else if (i + 2 >= len) {  /* check boundary */
            tmp[pos++] = '%';  /* keep it */
            if (++i >= len)
                break;
            tmp[pos] = str[i];
            break;
        }
        else if (isalnum(str[i + 1]) && isalnum(str[i + 2])) {
            tmp[pos] = (dec_tab[(unsigned char)str[i + 1]] << 4)
                + dec_tab[(unsigned char)str[i + 2]];
            i += 2;
        }
        else
            tmp[pos] = str[i];

        pos++;
    }

    tmp[pos] = '\0';
    return tmp;
}


using namespace std;
bool getProcess(const char* procressName)                //此函数进程名不区分大小写
{
    char pName[MAX_PATH];                                //和PROCESSENTRY32结构体中的szExeFile字符数组保持一致，便于比较
    strcpy(pName, procressName);                            //拷贝数组
    CharLowerBuff(pName, MAX_PATH);                        //将名称转换为小写
    PROCESSENTRY32 currentProcess;                        //存放快照进程信息的一个结构体
    currentProcess.dwSize = sizeof(currentProcess);        //在使用这个结构之前，先设置它的大小
    HANDLE hProcess = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);//给系统内的所有进程拍一个快照

    if (hProcess == INVALID_HANDLE_VALUE)
    {
        printf("CreateToolhelp32Snapshot()调用失败!\n");
        return false;
    }

    bool bMore = Process32First(hProcess, &currentProcess);        //获取第一个进程信息
    while (bMore)
    {
        CharLowerBuff(currentProcess.szExeFile, MAX_PATH);        //将进程名转换为小写
        if (strcmp(currentProcess.szExeFile, pName) == 0)            //比较是否存在此进程
        {
            CloseHandle(hProcess);                                //清除hProcess句柄
            return true;
        }
        bMore = Process32Next(hProcess, &currentProcess);            //遍历下一个
    }

    CloseHandle(hProcess);    //清除hProcess句柄
    return false;
}

int main(int argc, char* argv[])
{
    string path = "C:\\Apps\\Snipaste\\Snipaste.exe ";
    string parm;
    for (int i = 1; i < argc; i++) {
        parm += argv[i];
        parm += " ";
    }
    parm = parm.substr(parm.find_first_not_of("snipaste:"));
    parm = parm.substr(parm.find_first_not_of("//"));
    if (parm.substr(parm.length() - 2).compare("/")) {
        parm = parm.substr(0, parm.length() - 2);
    }


    string pathwithparm = path + parm;

    char _path[100];
    char _fullpath[200];
    strcpy(_path,path.c_str());
    strcpy(_fullpath, pathwithparm.c_str());

    char* de = acl_url_decode(_fullpath);
    //cout << de << endl;
    if (getProcess("Snipaste.exe"))
        
        //WinExec("C:\\Apps\\Snipaste\\Snipaste.exe snip --delay 0.5 -o file-dialog", SW_NORMAL);
        WinExec(de, SW_NORMAL);
    else
    {
        WinExec(_path, SW_NORMAL);
        _sleep(1000);
        WinExec(de, SW_NORMAL);
    }
    //getchar();
}
