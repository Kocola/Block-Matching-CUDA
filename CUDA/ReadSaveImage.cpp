#include "ReadSaveImage.h"
#include <iostream>
#include <fstream>

/**
* ���ܣ���txt�ļ��ж�ȡ����
* �����fileData ������ݵ�ͷָ��
* ���룺fileName ��ȡ���ı��ļ����ļ���
* ���룺dataNum ��ȡ�����ݸ���
*/
void ReadFile(float *fileData, std::string fileName, int dataNum)
{
	std::fstream file;
	file.open(fileName, std::ios::in);
	
	if (!file.is_open())
	{
		std::cout << "���ܴ��ļ�" << std::endl;
		return;
	}

	// �������ݵ��ڴ���
	for (int i = 0; i < dataNum; i++) file >> fileData[i];

	file.close();
}


/**
* ���ܣ������ݱ��浽�ı��ļ���
* ���룺fileData �������ݵ�ͷָ��
* ���룺fileName ������ı��ļ����ļ���
* ���룺dataNum ��������ݸ���
*/
void SaveFile(float *fileData, std::string fileName, int dataNum)
{
	std::fstream file;
	file.open(fileName, std::ios::out);

	if (!file.is_open())
	{
		std::cout << "���ܴ��ļ�" << std::endl;
		return;
	}

	// �������ݵ��ڴ���
	for (int i = 0; i < dataNum; i++) file << fileData[i] << std::endl;

	file.close();
}
