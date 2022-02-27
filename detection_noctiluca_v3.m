%������﷢��   0701 v3
clc;close all;
clear all;

% plot(maxl,maxv,'*','color','R'); 
folderPath = 'C:\Users\XC\Desktop\С����\2-����\�ü�ֵ����Ũ��\0-data\11\';
fileType = '*.dat';
filesList = dir(strcat(folderPath, fileType));
filesLen = length(filesList);
number_all = [];


i_all = [];
for i = 1:filesLen
    fName = filesList(i).name; % ��ȡ��ǰĿ¼���ļ�����
    fPath = strcat(folderPath, fName); % ��ȡ��ǰ�ļ�
    dataSet = importdata(fPath);
    dataSet = dataSet.data;% ��ԭʼ��Ϣ���ؽ���
     %% ԭʼ����Ԥ����
    bioData = dataSet(:, 10:end);% ��ȡ��10��֮�������
    
    [m, n] = size(bioData); % ����о����ݵĴ�С��m������n����
    DATA= [];
    number=0;
    for j = 1:m
       DATA =[DATA,bioData(j,:)]; 
    end
    
    %% �ø����޳����ܴ����վλ   
number1 = 0;
for i1 = 1:length(DATA)
     if DATA(i1) < 20
         number1 = number1+1;
     end
end
gailv =  number1./length(DATA);
if gailv < 0.8
    continue
end





    %%
tempData = DATA; % ���������߼��жϵġ���ʱ���ݡ�
    tempData(tempData < 20) = NaN; % ������С��10����ֵ����ΪNaN
    tempData(find(isnan(tempData)==1)) = 0;
    DATA = tempData
    
    
    
    maxDATA = max(DATA);
    [maxv,maxl]=findpeaks(DATA);
    minDATA = max(DATA)-DATA;
    [minv,minl]=findpeaks(minDATA);
    
    plot(1:length(DATA),DATA);
    hold on
    plot(maxl,maxv,'*','color','R');
    hold on
    plot(minl,DATA(minl),'*','color','b');
%     xlim([1 500]);
    peakDATA=[];
    
    for k = 1:length(minl)-1
        aaa = minl(k);
        bbb = minl(k+1);
        peakDATA = DATA(aaa:bbb);
        %%  �ж��Ƿ��ǵ���ҹ����
        peakUBAT = peakDATA.*1.46000e+007;
        len = length(peakUBAT);
        [pv,pvl] = max(peakUBAT);
        Judge1 =0;
        Judge2 = 0;
        Judge3 = 0;
        %%  �ж�����1����ֵ  ����ֵ��������ʱ��Judge1 =1
        if  pv>5e+8    %&& pv<1e+10
%             Judge1 = 2
%             
%         elseif pv<5e+8
%             Judge1 = 0
%         else 
            Judge1 = 1
        end
        %% �ж�����2��������ʱ�� ��������ʱ�����Ҫ��ʱ��Judge2 =1
       threshold = 0.1*pv
       left_l = 1;
       right_l = len;
        for k1 = pvl:-1:1
            if peakUBAT(k1)<threshold
                left_l = k1
                break
            end
        end    %%%Ѱ�������ֵ
        for k1 = pvl:len
            if peakUBAT(k1)<threshold
                right_l = k1
                break
            end
        end   %%%Ѱ���ұ���ֵ
        peakUBAT_new = peakUBAT(left_l:right_l);
        len_new = length(peakUBAT_new);
        if len_new>6 && len_new<72
            Judge2 = 1
        end
        %% �ж�����3�����������ֵʱ�� ����Ҫ��ʱ Judge3 = 1
        len_max = pvl-left_l;
        if len_max<10 && len_max>2
            Judge3 = 1
        end
        ccc = Judge1 +Judge2+Judge3;
        if ccc == 3
            number = number+1;
         
         

%            fig = figure(k) 
%            xx_extract = 1:len_new;
%            plot(xx_extract,peakUBAT_new,'k');
%            savePngName =strcat('C:\Users\XC\Desktop\С����\2-����\ʶ�𵥷�\H24\',num2str(k),'.png'); 
%            saveas(fig, savePngName); % saves��������figure���浽��Ӧ·����
%            close(fig); % �رյ�ǰ��figure
        end
    end
% number_all = [number_all,number];
% i_all = [i_all,i];   

a = 3.*number./m;

end




