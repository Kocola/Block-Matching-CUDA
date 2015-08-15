#include "SetSearchWinCoordinate.h"
#include "Parameter.h"

/*
* ���ܣ��������Ŀ���ʼ���귶Χ
* ���룺row ͼ������
* ���룺col ͼ������
* ���룺iBlock ��Ĵ�С
* ���룺leftUpRow �����ʼ������
* �����leftUpCol �����ʼ������
* ���룺im_H ͼ�񣬴洢˳����-��-ҳ
*/
void SetParameter(int row, int col, int step, int iBlock, std::vector<int> &leftUpRow, std::vector<int> &leftUpCol)
{
	int N = row - iBlock; // �����ʼ�����귶Χ
	int M = col - iBlock; // �����ʼ�����귶Χ

	for (int i = 0; i < N; i += step)
	{
		leftUpRow.push_back(i);
	}

	if (leftUpRow.back() != N)
	{
		leftUpRow.push_back(N);
	}

	for (int i = 0; i < M; i += step)
	{
		leftUpCol.push_back(i);
	}

	if (leftUpCol.back() != M)
	{
		leftUpCol.push_back(M);
	}
}

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
__global__ void SetSearchWinCoordinate(int *leftUpRow_D, int *leftUpCol_D, int *rmin_D, int *rmax_D, int *cmin_D, int *cmax_D, int rowNum, int colNum, int rowMax, int colMax)
{
	int x_id = blockDim.x * blockIdx.x + threadIdx.x;

	if (0 == blockIdx.x) /* ������������С���� */
	{
		for (int i = threadIdx.x; i < rowNum; i += blockDim.x)
		{
			int currData = leftUpRow_D[i] - winRadius;
			rmin_D[i] = currData >= 0 ? currData : 0;
			//printf("rmin_D[%d] = %d\n", i, rmin_D[i]);
		}
	}
	else if (1 == blockIdx.x) /* ����������������� */
	{
		for (int i = threadIdx.x; i < rowNum; i += blockDim.x)
		{
			int currData = leftUpRow_D[i] + winRadius;
			rmax_D[i] = currData < rowMax ? currData : rowMax;
			//printf("rmax_D[%d] = %d\n", i, rmax_D[i]);
		}
	}
	else if (2 == blockIdx.x) /* ������������С���� */
	{
		for (int i = threadIdx.x; i < colNum; i += blockDim.x)
		{
			int currData = leftUpCol_D[i] - winRadius;
			cmin_D[i] = currData >= 0 ? currData : 0;
			//printf("cmin_D[%d] = %d\n", i, cmin_D[i]);
		}
	}
	else if (3 == blockIdx.x) /* ����������������� */
	{
		for (int i = threadIdx.x; i < colNum; i += blockDim.x)
		{
			int currData = leftUpCol_D[i] + winRadius;
			cmax_D[i] = currData < colMax ? currData : colMax;
			//printf("cmax_D[%d] = %d\n", i, cmax_D[i]);
		}
	}

}