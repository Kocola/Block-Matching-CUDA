#ifndef READSAVEIMAGE_H
#define READSAVEIMAGE_H

#include <iostream>
/**
* ���ܣ������ݱ��浽�ı��ļ���
* ���룺fileData �������ݵ�ͷָ��
* ���룺fileName ������ı��ļ����ļ���
* ���룺dataNum ��������ݸ���
*/
void SaveFile(float *fileData, std::string fileName, int dataNum);

/**
* ���ܣ���txt�ļ��ж�ȡ����
* �����fileData ������ݵ�ͷָ��
* ���룺fileName ��ȡ���ı��ļ����ļ���
* ���룺dataNum ��ȡ�����ݸ���
*/
void ReadFile(float *fileData, std::string fileName, int dataNum);
#endif // !READSAVEIMAGE_H
