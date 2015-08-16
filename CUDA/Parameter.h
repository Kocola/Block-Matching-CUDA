#ifndef PARAMETER_H
#define PARAMETER_H

#define majorRow 1 // ȡ���ʱ�������ȣ�0 ��ʾ������

#define imRow 512 // ����ͼ�������
#define imCol 512 // ����ͼ�������
#define batch 3 // ����ͼ��ĵ���ά

#define winRadius 25 // �������뾶
#define blockR 5 // ���Ĵ�С
#define blockSizes (blockR * blockR * batch)
#define similarBlkNum 10 // ���ؿ�ĸ���
#define winStep 2 // ���Ĳ���

#define blockRow (imRow - blockR) // ������Ͻǵ������ֵ
#define blockCol (imCol - blockR) // ������Ͻǵ������ֵ

#define allBlockNum ((blockRow + 1) * (blockCol + 1)) // ���п�ĸ���

#define BM_muMin 0.95f // ������ƶȾ�ֵ����
#define BM_muMax 1.05f // ������ƶȾ�ֵ����
#define BM_deltaMin 0.5f // ������ƶȷ������
#define BM_deltaMax 1.5f // ������ƶȷ������

#define BM_hp 80.0f // �������ƿ�Ȩ��ʱ��ĸ�˹����
#define BLOCKSIZE 16 // �߳̿�Ĵ�С
#define BLOCKSIZE_32 32 // �߳̿�Ĵ�С

#endif //PARAMETER_H