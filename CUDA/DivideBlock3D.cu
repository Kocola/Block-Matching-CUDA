#include "DivideBlock3D.h"
#include "Parameter.h"
#include "ReadSaveImage.h"

#include <cuda_runtime.h>
#include <device_launch_parameters.h>

/*
* ���ܣ���ͼ������ȡ��
* ���룺im_D ����ȡ���ͼ��
* �����blocks_D ��ȡ�Ŀ飬һ��Ϊһ����
* ���룺row ����ͼ������
* ���룺col ����ͼ������
*/
__global__ void DivideBlock3D_raw(float *im_D, float *blocks_D, int row, int col)
{
	int x_id = blockDim.x * blockIdx.x + threadIdx.x; // ������
	int y_id = blockDim.y * blockIdx.y + threadIdx.y; // ������
	int index = y_id * col + x_id;

	__shared__ float sData[BLOCKSIZE + 4][BLOCKSIZE + 4];

	for (int k = 0; k < batch; k++)
	{
		float *dataPtr = &im_D[k * row * col];

		/* ���Ͻ� 16 * 16 */
		if (x_id < col && y_id < row)
			sData[threadIdx.y][threadIdx.x] = dataPtr[index];

		if (blockDim.x != gridDim.x && blockDim.y != gridDim.y)
		{
			/* ���½� 4 * 4 */
			if (threadIdx.y >= 12 && threadIdx.x >= 12)
				sData[threadIdx.y + 4][threadIdx.x + 4] = dataPtr[index + 4 * col + 4];

			/* ���Ͻ� 16 * 4 */
			if (threadIdx.x >= 12)
				sData[threadIdx.y][threadIdx.x + 4] = dataPtr[index + 4];

			/* ���½� 4 * 16 */
			if (threadIdx.y >= 12)
				sData[threadIdx.y + 4][threadIdx.x] = dataPtr[index + 4 * col];
		}

		__syncthreads();

		if (x_id < col - 4 && y_id < row - 4)
		{
			int indexOffset = (y_id * (col - blockR + 1) + x_id) * blockSizes + k * blockR * blockR;

			for (int i = 0; i < blockR; i++)
			{
				int indexRow = i * blockR;
				for (int j = 0; j < blockR; j++)
				{
					blocks_D[indexOffset + indexRow + j] = sData[threadIdx.y + i][threadIdx.x + j];
				}
			}
		}

		__syncthreads();
	}
}


/*
* ���ܣ���ͼ������ȡ��
* ���룺im_D ����ȡ���ͼ��
* �����blocks_D ��ȡ�Ŀ飬һ��Ϊһ����
* ���룺row ����ͼ������
* ���룺col ����ͼ������
*/
__global__ void DivideBlock3D(float *im_D, float *blocks_D, int row, int col)
{
	int x_id = blockDim.x * blockIdx.x + threadIdx.x; // ������
	int y_id = blockDim.y * blockIdx.y + threadIdx.y; // ������
	int index = y_id * col + x_id;

	__shared__ float sData[BLOCKSIZE + (blockR - 1)][BLOCKSIZE + (blockR - 1)];


	for (int k = 0; k < batch; k++)
	{
		float *dataPtr = &im_D[k * row * col];

		/* ���Ͻ� 16 * 16 */
		if (x_id < col && y_id < row) 
			sData[threadIdx.y][threadIdx.x] = dataPtr[index];

		if (blockDim.x != gridDim.x && blockDim.y != gridDim.y)
		{
			/* ���½� 4 * 4 */
			if (threadIdx.y >= BLOCKSIZE - (blockR - 1) && threadIdx.x >= BLOCKSIZE - (blockR - 1))
				sData[threadIdx.y + (blockR - 1)][threadIdx.x + (blockR - 1)] = dataPtr[index + (blockR - 1) * col + (blockR - 1)];

			/* ���Ͻ� 16 * 4 */
			if (threadIdx.x >= BLOCKSIZE - (blockR - 1))
				sData[threadIdx.y][threadIdx.x + (blockR - 1)] = dataPtr[index + (blockR - 1)];

			/* ���½� 4 * 16 */
			if (threadIdx.y >= BLOCKSIZE - (blockR - 1))
				sData[threadIdx.y + (blockR - 1)][threadIdx.x] = dataPtr[index + (blockR - 1) * col];
		}

		__syncthreads();

		if (x_id < col - blockR + 1 && y_id < row - blockR + 1)
		{
#if majorRow
			int indexOffset = (y_id * (col - blockR + 1) + x_id) * blockSizes + k * blockR * blockR; // ȡ�鰴�����ȣ�(0,1)��ʼ���ǵ�2��
#else
			int indexOffset = (x_id * (row - blockR + 1) + y_id) * blockSizes + k * blockR * blockR; // ȡ�鰴�����ȣ�(1,0)��ʼ���ǵ�2��
#endif

			for (int i = 0; i < blockR; i++)
			{
				int indexRow = i * blockR;
				for (int j = 0; j < blockR; j++)
				{
					blocks_D[indexOffset + indexRow + j] = sData[threadIdx.y + i][threadIdx.x + j];
				}
			}
		}

		__syncthreads();
	}
}

