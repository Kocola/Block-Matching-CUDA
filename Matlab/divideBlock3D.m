function block = divideBlock3D(im, win)
% ���� ����ȡ�����еĿ飬Ҳ����˵����Ϊ1������
% im : ����ͼ��
% win : ��Ĵ�С��һ��ά��
% ˵�� :
% 2015 06 12 �

[height, width, ch] = size(im); % ͼ����С��к�ҳ��
blockSize = win * win * ch; % ���Ԫ�ظ���
N         =  height - win + 1; % �����ʼ�����귶Χ
M         =  width - win + 1; % �����ʼ�����귶Χ
blockNum  =  N * M; % ��ĸ���
block     =  zeros(blockSize, blockNum, 'single');

% ������ȡ��
k = 0;
for m = 1:ch
    for i  = 1:win
        for j  = 1:win
            k    =  k+1;
            blk  =  im(i : height-win+i, j : width-win+j, m);
            blk = blk'; % ����ȡ��ķ��򣬱��������ȡ
            blk  =  blk(:);
            block(k,:) =  blk';
        end
    end
end