#ifndef CALCULATEMEANVAR_H
#define CALCULATEMEANVAR_H

/*
* ���ܣ�����ÿ��ͼ���ľ�ֵ�ͷ���
* ���룺blocks_D ��ȡ�Ŀ飬һ��Ϊһ����
* �����blocksMean_D ÿ����ľ�ֵ
* �����blocksVar_D ÿ����ķ���
* ���룺rowNum ȫ�ֿ������
* ���룺colNum ȫ�ֿ������
*/
__global__ void BM_Calculate_Mean_Var(float *blocks_D, float *blocksMean_D, float *blocksVar_D, int rowNum, int colNum);

#endif // DIVIDEBLOCK3D_H