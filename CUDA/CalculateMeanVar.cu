#include "CalculateMeanVar.h"
#include "Parameter.h"

#include <cuda_runtime.h>
#include <device_launch_parameters.h>
/*
* ���ܣ�����ÿ��ͼ���ľ�ֵ�ͷ���
* ���룺blocks_D ��ȡ�Ŀ飬һ��Ϊһ����
* �����blocksMean_D ÿ����ľ�ֵ
* �����blocksVar_D ÿ����ķ���
* ���룺rowNum ȫ�ֿ������
* ���룺colNum ȫ�ֿ������
*/
__global__ void BM_Calculate_Mean_Var(float *blocks_D, float *blocksMean_D, float *blocksVar_D, int rowNum, int colNum)
{
	int x_id = blockDim.x * blockIdx.x + threadIdx.x; // ������ 

	if (x_id < rowNum * colNum)
	{
		float *currBlk = &blocks_D[x_id * blockSizes];

		/* �����ֵ */
		float blocksMean = 0.0f;
		for (int i = 0; i < blockSizes; i++)
		{
			blocksMean += currBlk[i];
		}
		blocksMean = blocksMean / blockSizes;

		blocksMean_D[x_id] = blocksMean;

		/* ���㷽�� */
		float blocksVar = 0.0f;
		for (int i = 0; i < blockSizes; i++)
		{
			blocksVar += (currBlk[i] - blocksMean) * (currBlk[i] - blocksMean);
		}
		blocksVar = blocksVar / blockSizes;

		blocksVar_D[x_id] = blocksVar;
	}
}