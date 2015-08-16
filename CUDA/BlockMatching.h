#ifndef BLOCKMATCHING_H
#define BLOCKMATCHING_H


#include <cuda_runtime.h>
#include <device_launch_parameters.h>

/**
*�����posIdx_D ���ƿ��λ��
* �����weiIdx_D ���ƿ��Ȩ��
* ���룺rowNum ���Ŀ������
* ���룺colNum ���Ŀ������
*/
__global__ void BM_Init_WeightAndPos(int *posIdx_D, float *weiIdx_D, int rowNum, int colNum);

/*
* ���ܣ����������������귶Χ (��)
* ���룺blocks_D ��ȡ�Ŀ飬һ��Ϊһ����
* ���룺leftUpRow_D ÿ�����Ŀ������ʼ����
* ���룺leftUpCol_D ÿ�����Ŀ������ʼ����
* ���룺rmin_D ������������С����
* ���룺rmax_D �����������������
* ���룺cmin_D ������������С����
* ���룺cmax_D �����������������
* ���룺blocksMean_D ÿ����ľ�ֵ
* ���룺blocksVar_D ÿ����ķ���
* �����posIdx_D ���ƿ��λ��
* �����weiIdx_D ���ƿ��Ȩ��
* ���룺rowNum ���Ŀ������
* ���룺colNum ���Ŀ������
*/
__global__ void BlockMatching_R(float *blocks_D, int *leftUpRow_D, int *leftUpCol_D, int *rmin_D, int *rmax_D, int *cmin_D, int *cmax_D, float *blocksMean_D, float *blocksVar_D, int *posIdx_D, float *weiIdx_D, int rowNum, int colNum);

/*
* ���ܣ����������������귶Χ (Jump Flooding)
* ���룺blocks_D ��ȡ�Ŀ飬һ��Ϊһ����
* ���룺leftUpRow_D ÿ�����Ŀ������ʼ����
* ���룺leftUpCol_D ÿ�����Ŀ������ʼ����
* ���룺blocksMean_D ÿ����ľ�ֵ
* ���룺blocksVar_D ÿ����ķ���
* �����posIdx_D ���ƿ��λ��
* �����weiIdx_D ���ƿ��Ȩ��
* ���룺rowNum ���Ŀ������
* ���룺colNum ���Ŀ������
*/
__global__ void BlockMatching_S(float *blocks_D, int *leftUpRow_D, int *leftUpCol_D, float *blocksMean_D, float *blocksVar_D, int *posIdx_D, float *weiIdx_D, int rowNum, int colNum);

/*
* ���ܣ����������������귶Χ
* ���룺blocks_D ��ȡ�Ŀ飬һ��Ϊһ����
* ���룺leftUpRow_D ÿ�����Ŀ������ʼ����
* ���룺leftUpCol_D ÿ�����Ŀ������ʼ����
* ���룺rmin_D ������������С����
* ���룺rmax_D �����������������
* ���룺cmin_D ������������С����
* ���룺cmax_D �����������������
* ���룺blocksMean_D ÿ����ľ�ֵ
* ���룺blocksVar_D ÿ����ķ���
* �����posIdx_D ���ƿ��λ��
* �����weiIdx_D ���ƿ��Ȩ��
* ���룺rowNum ���Ŀ������
* ���룺colNum ���Ŀ������
*/
__global__ void BlockMatching_RS(float *blocks_D, int *leftUpRow_D, int *leftUpCol_D, int *rmin_D, int *rmax_D, int *cmin_D, int *cmax_D, float *blocksMean_D, float *blocksVar_D, int *posIdx_D, float *weiIdx_D, int rowNum, int colNum);

/*
* ���ܣ��������ƿ��Ȩ��
* �����weiIdx_D ���ƿ��Ȩ��
* ���룺rowNum ���Ŀ������
* ���룺colNum ���Ŀ������
*/
__global__ void BM_Calculate_Weight(float *weiIdx_D, int rowNum, int colNum);
#endif // BLOCKMATCHING_H