#ifndef DIVIDEBLOCK3D_H
#define DIVIDEBLOCK3D_H

/*
* ���ܣ���ͼ������ȡ��
* ���룺im_D ����ȡ���ͼ��
* �����blocks_D ��ȡ�Ŀ飬һ��Ϊһ����
* ���룺row ����ͼ������
* ���룺col ����ͼ������
*/
__global__ void DivideBlock3D(float *im_D, float *blocks_D, int row, int col);

#endif // DIVIDEBLOCK3D_H