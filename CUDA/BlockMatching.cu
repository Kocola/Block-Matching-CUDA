#include "BlockMatching.h"
#include "Parameter.h"
#include <iostream>

__constant__ int searchOffset[2][8] = { { -1, -1, -1, 0, 0, 1, 1, 1 }, { -1, 0, 1, -1, 1, -1, 0, 1 } }; // ��������ƫ��

/**
* ���ܣ���������������ŷ������
* ���룺objects ��������
* �����clusters ������������
* ���룺vecLength ��������
*/
__device__ inline static float EuclidDistance(float *center, float *search, int vecLength)
{
	float dist = 0.0f;

	for (int i = 0; i < vecLength; i++)
	{
		float onePoint = center[i] - search[i];
		dist += onePoint * onePoint;
	}
	
	return(dist);
}

/**
* ���ܣ����ҵ�ǰ���Ƿ�Ϊ���ƿ�
* ���룺posIdx_D ��ǰ���Ŀ��Ӧ�����ƿ��λ������
* �����weiIdx_D ��ǰ���Ŀ��Ӧ�����ƿ��Ȩ������
* ���룺wei �µ�Ȩ��
* ���룺pos �µ�Ȩ�ض�Ӧ��λ��
*/
__device__ void FindSimilarBlocks(int *posIdx_D, float *weiIdx_D, float wei, int pos)
{
	int index = similarBlkNum - 1;

	while (index >= 0 && abs(weiIdx_D[index]) < 1e-6)
	{
		index--;
	}

	if (index == similarBlkNum - 1 && weiIdx_D[index] >= wei)
	{
		index--;
	}

	while (index >= 0 && weiIdx_D[index] > wei)
	{
		weiIdx_D[index + 1] = weiIdx_D[index];
		posIdx_D[index + 1] = posIdx_D[index];

		index--;
	}

	if (similarBlkNum - 1 != index)
	{
		weiIdx_D[index + 1] = wei;
		posIdx_D[index + 1] = pos;
	}
}

/**
*�����posIdx_D ���ƿ��λ��
* �����weiIdx_D ���ƿ��Ȩ��
* ���룺rowNum ���Ŀ������
* ���룺colNum ���Ŀ������
*/
__global__ void BM_Init_WeightAndPos(int *posIdx_D, float *weiIdx_D, int rowNum, int colNum)
{
	int x_id = blockDim.x * blockIdx.x + threadIdx.x; // ������
	int y_id = blockDim.y * blockIdx.y + threadIdx.y; // ������

	if (y_id < rowNum && x_id < colNum)
	{
		int offInCentralBlk = y_id * colNum + x_id; // ��������

		float *weiIdx = &weiIdx_D[offInCentralBlk * similarBlkNum];
		int *posIdx = &posIdx_D[offInCentralBlk * similarBlkNum];
		for (int i = 0; i < similarBlkNum; i++)
		{
			weiIdx[i] = 2e30;
			posIdx[i] = offInCentralBlk;
		}
	}
}

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
__global__ void BlockMatching_R(float *blocks_D, int *leftUpRow_D, int *leftUpCol_D, int *rmin_D, int *rmax_D, int *cmin_D, int *cmax_D, float *blocksMean_D, float *blocksVar_D, int *posIdx_D, float *weiIdx_D, int rowNum, int colNum)
{
	int x_id = blockDim.x * blockIdx.x + threadIdx.x; // ������
	int y_id = blockDim.y * blockIdx.y + threadIdx.y; // ������

	if (y_id < rowNum && x_id < colNum)
	{
		int offInAllBlk = leftUpRow_D[y_id] * (imCol - blockR + 1) + leftUpCol_D[x_id]; // ��������
		int offInCentralBlk = y_id * colNum + x_id; // ��������

		float *ptrCenter = &blocks_D[offInAllBlk * blockSizes];

		/* �������еĿ� */
		for (int i = rmin_D[y_id]; i <= rmax_D[y_id]; i++)
		{
			for (int j = cmin_D[x_id]; j <= cmax_D[x_id]; j++)
			{
				int searchIdx = i * (imCol - blockR + 1) + j; // ��������
				float *ptrSearchIdx = &blocks_D[searchIdx * blockSizes];

				if (BM_muMax > (blocksMean_D[offInAllBlk] / blocksMean_D[searchIdx]) > BM_muMin && BM_deltaMax > (blocksVar_D[offInAllBlk] / blocksVar_D[searchIdx]) > BM_deltaMin)
				{
					float dist = EuclidDistance(ptrCenter, ptrSearchIdx, blockSizes);
					FindSimilarBlocks(&posIdx_D[offInCentralBlk * similarBlkNum], &weiIdx_D[offInCentralBlk * similarBlkNum], dist / float(blockSizes), searchIdx);
				}
			}
		}
		//if (x_id == 0 && y_id == 252)
		//{
		//	for (int i = 0; i < similarBlkNum; i++)
		//	{
		//		printf("x_id = %d, y_id = %d, posIdx_D[%d] = %d, weiIdx_D[%d] = %f\n", x_id, y_id, i, posIdx_D[offInCentralBlk * similarBlkNum + i], i, weiIdx_D[offInCentralBlk * similarBlkNum + i]);
		//	}
		//}
	}
}

/*
* ���ܣ����������������귶Χ
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
__global__ void BlockMatching_S(float *blocks_D, int *leftUpRow_D, int *leftUpCol_D, float *blocksMean_D, float *blocksVar_D, int *posIdx_D, float *weiIdx_D, int rowNum, int colNum)
{
	int x_id = blockDim.x * blockIdx.x + threadIdx.x; // ������
	int y_id = blockDim.y * blockIdx.y + threadIdx.y; // ������

	if (y_id < rowNum && x_id < colNum)
	{
		int offInAllBlk = leftUpRow_D[y_id] * (imCol - blockR + 1) + leftUpCol_D[x_id]; // ��������
		int offInCentralBlk = y_id * colNum + x_id; // ��������

		float *ptrCenter = &blocks_D[offInAllBlk * blockSizes];

		/* ����Jump Flooding �еĿ� */
		int searchIdx = offInAllBlk;
		for (int step = 1; step <= imRow / 2; step *= 2)
		{
			for (int i = 0; i < 8; i++)
			{
				int currRow = leftUpRow_D[y_id] + searchOffset[0][i] * step;
				int currCol = leftUpCol_D[x_id] + searchOffset[1][i] * step;
				if (currRow >= 0 && currRow < imRow - blockR && currCol >=0 && currCol < imCol - blockR)
				{
					searchIdx = currRow * (imCol - blockR + 1) + currCol; // ��������
					float *ptrSearchIdx = &blocks_D[searchIdx * blockSizes];

					if (BM_muMax >(blocksMean_D[offInAllBlk] / blocksMean_D[searchIdx]) > BM_muMin && BM_deltaMax >(blocksVar_D[offInAllBlk] / blocksVar_D[searchIdx]) > BM_deltaMin)
					{
						float dist = EuclidDistance(ptrCenter, ptrSearchIdx, blockSizes);
						FindSimilarBlocks(&posIdx_D[offInCentralBlk * similarBlkNum], &weiIdx_D[offInCentralBlk * similarBlkNum], dist / float(blockSizes), searchIdx);
					}
				}
			}
		}
		FindSimilarBlocks(&posIdx_D[offInCentralBlk * similarBlkNum], &weiIdx_D[offInCentralBlk * similarBlkNum], 0.0f, offInAllBlk);
	}
}

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
__global__ void BlockMatching_RS(float *blocks_D, int *leftUpRow_D, int *leftUpCol_D, int *rmin_D, int *rmax_D, int *cmin_D, int *cmax_D, float *blocksMean_D, float *blocksVar_D, int *posIdx_D, float *weiIdx_D, int rowNum, int colNum)
{
	int x_id = blockDim.x * blockIdx.x + threadIdx.x; // ������
	int y_id = blockDim.y * blockIdx.y + threadIdx.y; // ������

	if (y_id < rowNum && x_id < colNum)
	{
		int offInAllBlk = leftUpRow_D[y_id] * (imCol - blockR + 1) + leftUpCol_D[x_id]; // ��������
		int offInCentralBlk = y_id * colNum + x_id; // ��������

		float *ptrCenter = &blocks_D[offInAllBlk * blockSizes];

		/* �������еĿ� */
		int searchIdx = offInAllBlk;
		for (int i = rmin_D[y_id]; i <= rmax_D[y_id]; i++)
		{
			for (int j = cmin_D[x_id]; j <= cmax_D[x_id]; j++)
			{
				searchIdx = i * (imCol - blockR + 1) + j; // ��������
				float *ptrSearchIdx = &blocks_D[searchIdx * blockSizes];
				if (BM_muMax > (blocksMean_D[offInAllBlk] / blocksMean_D[searchIdx]) > BM_muMin && BM_deltaMax > (blocksVar_D[offInAllBlk] / blocksVar_D[searchIdx]) > BM_deltaMin)
				{
					float dist = EuclidDistance(ptrCenter, ptrSearchIdx, blockSizes);
					FindSimilarBlocks(&posIdx_D[offInCentralBlk * similarBlkNum], &weiIdx_D[offInCentralBlk * similarBlkNum], dist / float(blockSizes), searchIdx);
				}
			}
		}

		/* ����Jump Flooding �еĿ� */
		for (int step = winRadius + 1; step <= imRow / 2; step *= 2)
		{
			for (int i = 0; i < 8; i++)
			{
				int currRow = leftUpRow_D[y_id] + searchOffset[0][i] * step;
				int currCol = leftUpCol_D[x_id] + searchOffset[1][i] * step;
				if (currRow >= 0 && currRow < imRow - blockR && currCol >=0 && currCol < imCol - blockR)
				{
					searchIdx = currRow * (imCol - blockR + 1) + currCol; // ��������
					float *ptrSearchIdx = &blocks_D[searchIdx * blockSizes];

					if (BM_muMax >(blocksMean_D[offInAllBlk] / blocksMean_D[searchIdx]) > BM_muMin && BM_deltaMax >(blocksVar_D[offInAllBlk] / blocksVar_D[searchIdx]) > BM_deltaMin)
					{
						float dist = EuclidDistance(ptrCenter, ptrSearchIdx, blockSizes);
						FindSimilarBlocks(&posIdx_D[offInCentralBlk * similarBlkNum], &weiIdx_D[offInCentralBlk * similarBlkNum], dist / float(blockSizes), searchIdx);
					}
				}
			}
		}
	}
}

/*
* ���ܣ��������ƿ��Ȩ��
* �����weiIdx_D ���ƿ��Ȩ��
* ���룺rowNum ���Ŀ������
* ���룺colNum ���Ŀ������
*/
__global__ void BM_Calculate_Weight(float *weiIdx_D, int rowNum, int colNum)
{
	int x_id = blockDim.x * blockIdx.x + threadIdx.x; // ������ 

	if (x_id < rowNum * colNum)
	{
		__shared__ float sData[BLOCKSIZE * BLOCKSIZE][similarBlkNum];

		float *currBlk = &weiIdx_D[x_id * similarBlkNum];
		float sum = 1e-15;
		
		if (x_id == 0 * colNum + 252)
		{
			for (int i = 0; i < similarBlkNum; i++)
			{
				printf("x_id = %d, sum = %f, weiIdx_D[%d] = %f\n", x_id, sum, i, weiIdx_D[x_id * similarBlkNum + i]);
			}
			printf("\n");
		}

		/* ��˹��Ȩ �� ���빲���ڴ�*/
		for (int i = 0; i < similarBlkNum; i++)
		{
			sData[threadIdx.x][i] = exp(-currBlk[i] / BM_hp);
		}

		__syncthreads();

		/* ��� */
		for (int i = 0; i < similarBlkNum; i++)
		{
			sum += sData[threadIdx.x][i];
		}
		__syncthreads();

		/* ���� */
		for (int i = 0; i < similarBlkNum; i++)
		{
			currBlk[i] = sData[threadIdx.x][i] / sum;
		}

		if (x_id == 0 * colNum + 252)
		{
			for (int i = 0; i < similarBlkNum; i++)
			{
				printf("x_id = %d, sum = %f, weiIdx_D[%d] = %f\n", x_id, sum, i, weiIdx_D[x_id * similarBlkNum + i]);
			}
		}
	}
}