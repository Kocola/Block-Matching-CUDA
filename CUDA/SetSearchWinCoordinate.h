#ifndef SETSEARCHWINCOORDINATE_H
#define SETSEARCHWINCOORDINATE_H

#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#include <iostream>
#include <vector>

/*
* ���ܣ��������Ŀ���ʼ���귶Χ
* ���룺row ͼ������
* ���룺col ͼ������
* ���룺iBlock ��Ĵ�С
* ���룺leftUpRow �����ʼ������
* �����leftUpCol �����ʼ������
* ���룺im_H ͼ�񣬴洢˳����-��-ҳ
*/
void SetParameter(int row, int col, int step, int iBlock, std::vector<int> &leftUpRow, std::vector<int> &leftUpCol);

/*
* ���ܣ����������������귶Χ
* ���룺leftUpRow_D ÿ�����Ŀ������ʼ����
* ���룺leftUpCol_D ÿ�����Ŀ������ʼ����
* �����rmin_D ������������С����
* �����rmax_D �����������������
* �����cmin_D ������������С����
* �����cmax_D �����������������
* ���룺rowNum ���Ŀ������
* ���룺colNum ���Ŀ������
* ���룺rowMax ������������������꣬�� 0 ��ʼ
* ���룺colMax ������������������꣬�� 0 ��ʼ
*/
__global__ void SetSearchWinCoordinate(int *leftUpRow_D, int *leftUpCol_D, int *rmin_D, int *rmax_D, int *cmin_D, int *cmax_D, int rowNum, int colNum, int rowMax, int colMax);

#endif // SETSEARCHWINCOORDINATE_H