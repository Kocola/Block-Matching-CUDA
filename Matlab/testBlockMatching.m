% ȡ��ʱ������

clc;
clear;
close all

%%
par.s1   = 25; % �������뾶
par.nblk = 10; % ���ƿ�ĸ���
par.win  = 5; % ��Ĵ�С
par.step = 2; % ���Ĵ��Ĳ���

im = single(imread('LenaRGB.bmp'));

%%

tic
[posArr, weiArr]   =  blockMaching(im, par);
toc

