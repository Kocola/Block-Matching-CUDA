function  [posIdx, weiIdx]   =  blockMaching(im, par)
% ���� �� ��ƥ�䣬���������Ŀ����ƵĿ��Լ�Ȩ��
% im �� ����ͼ��
% par �� ����
% posIdx �� �����Ŀ����ƵĿ��λ������
% weiIdx �� �����Ŀ����ƵĿ��Ȩ������
% 2015 06 13 �

[height, width, ch] = size(im);
searchRadius  =  par.s1; % �������뾶
similarBlkNum =  par.nblk; % ���ƿ�ĸ���
win           =  par.win; % ��Ĵ�С
blockSize     =  win^2; % ÿ�����Ԫ�ظ���
step          =  par.step; % ���Ĵ��Ĳ���
hp            =  80; % ��˹����

%% ����
N          =  height - win + 1; % �����ʼ�����귶Χ
M          =  width - win + 1; % �����ʼ�����귶Χ
blockNum   =  N * M; % ��ĸ���
leftUpRow  =  1:step:N; % ÿ���������ʼ����
leftUpRow  =  [leftUpRow leftUpRow(end)+1:N]; % ������һ���飬��Ϊ�������һ������ȡ��
leftUpCol  =  1:step:M; % ÿ���������ʼ����
leftUpCol  =  [leftUpCol leftUpCol(end)+1:M]; % ������һ���飬��Ϊ�������һ������ȡ��

%% �ֿ�
X = divideBlock3D(im, win); % ��ȡ�����еĿ飬Ҳ����˵����Ϊ1������
X = X';

%% �������ƿ鲢����Ȩ��
I      = reshape(1:blockNum, N, M); % ���п������
I = I'; % ������
N1     = length(leftUpRow); % ���������Ŀ�
M1     = length(leftUpCol); % ���������Ŀ�
posIdx = zeros(similarBlkNum, N1*M1 ); % ÿ�����Ŀ�����ƿ�����
weiIdx = zeros(similarBlkNum, N1*M1 ); % ÿ�����Ŀ��Ӧ�����ƿ��Ȩ��
rmin   = bsxfun(@max, bsxfun(@minus, leftUpRow, searchRadius), 1); % ������������С����
rmax   = bsxfun(@min, bsxfun(@plus, leftUpRow, searchRadius), N); % �����������������
cmin   = bsxfun(@max, bsxfun(@minus, leftUpCol, searchRadius), 1); % ������������С����
cmax   = bsxfun(@min, bsxfun(@plus, leftUpCol, searchRadius), M); % �����������������

for  i  =  1 : N1
    for  j  =  1 : M1        
        offInAllBlk   = (leftUpRow(i) - 1) * M + leftUpCol(j); % ��ǰ���Ŀ������п��е�����(������)
        offInCentralBlk  = (i-1) * M1 + j; % ��ǰ���Ŀ����������Ŀ��е�����(������)
        
        idx   = I(rmin(i):rmax(i), cmin(j):cmax(j));  %����[rmin:rmax, cmin:cmax]ȷ�������������������ƿ�
        idx = idx';
        idx   = idx(:);
             
        dis   = sum(bsxfun(@minus, X(idx, :), X(offInAllBlk, :)).^2, 2); % �������ڵĿ������Ŀ�ľ���
        dis   = dis ./ (blockSize*ch); % ��һ��
        similarBlkInd = maxN(dis, similarBlkNum); % �ҵ�������С�ļ����������
        posIdx(:,offInCentralBlk)  =  idx(similarBlkInd); % �������ƿ�����

        wei   =  exp( -dis(similarBlkInd) ./ hp ); % ��˹
        weiIdx(:,offInCentralBlk)  =  wei ./ (sum(wei(:))+eps); % ��һ��
    end
end

function index = maxN(data, N)
% ���� ���ҵ� data ������ N ����������������
% 2015 06 13 �

[~, index] = sort(data);
index = index(1:N);