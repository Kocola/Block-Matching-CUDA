function saveMatToText(data, saveFileName)
% �����ݱ���Ϊ�ı��ļ�

fid=fopen(saveFileName, 'wt');

% һ��һ��д�룬�ո�����������
for k = 1:size(data, 3)
    for i = 1:size(data, 1)
        fprintf(fid, '%f ', data(i, 1:end-1, k));
        fprintf(fid, '%f\n', data(i, end, k));
    end
end

fclose(fid);