%检测生物发光   0701 v3
clc;close all;
clear all;

% plot(maxl,maxv,'*','color','R'); 
folderPath = 'C:\Users\XC\Desktop\小论文\2-分析\用极值计算浓度\0-data\11\';
fileType = '*.dat';
filesList = dir(strcat(folderPath, fileType));
filesLen = length(filesList);
number_all = [];


i_all = [];
for i = 1:filesLen
    fName = filesList(i).name; % 获取当前目录下文件名称
    fPath = strcat(folderPath, fName); % 读取当前文件
    dataSet = importdata(fPath);
    dataSet = dataSet.data;% 把原始信息加载进来
     %% 原始数据预处理
    bioData = dataSet(:, 10:end);% 裁取第10列之后的数据
    
    [m, n] = size(bioData); % 获得研究数据的大小，m行数，n列数
    DATA= [];
    number=0;
    for j = 1:m
       DATA =[DATA,bioData(j,:)]; 
    end
    
    %% 用概率剔除不能处理的站位   
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
tempData = DATA; % 用来进行逻辑判断的“临时数据”
    tempData(tempData < 20) = NaN; % 将所有小于10的数值设置为NaN
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
        %%  判断是否是单个夜光藻
        peakUBAT = peakDATA.*1.46000e+007;
        len = length(peakUBAT);
        [pv,pvl] = max(peakUBAT);
        Judge1 =0;
        Judge2 = 0;
        Judge3 = 0;
        %%  判断条件1：峰值  当峰值符合条件时，Judge1 =1
        if  pv>5e+8    %&& pv<1e+10
%             Judge1 = 2
%             
%         elseif pv<5e+8
%             Judge1 = 0
%         else 
            Judge1 = 1
        end
        %% 判断条件2：发光总时间 当发光总时间符合要求时，Judge2 =1
       threshold = 0.1*pv
       left_l = 1;
       right_l = len;
        for k1 = pvl:-1:1
            if peakUBAT(k1)<threshold
                left_l = k1
                break
            end
        end    %%%寻找左边阈值
        for k1 = pvl:len
            if peakUBAT(k1)<threshold
                right_l = k1
                break
            end
        end   %%%寻找右边阈值
        peakUBAT_new = peakUBAT(left_l:right_l);
        len_new = length(peakUBAT_new);
        if len_new>6 && len_new<72
            Judge2 = 1
        end
        %% 判断条件3：到发光最大值时间 符合要求时 Judge3 = 1
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
%            savePngName =strcat('C:\Users\XC\Desktop\小论文\2-分析\识别单峰\H24\',num2str(k),'.png'); 
%            saveas(fig, savePngName); % saves函数，把figure保存到对应路径下
%            close(fig); % 关闭当前的figure
        end
    end
% number_all = [number_all,number];
% i_all = [i_all,i];   

a = 3.*number./m;

end




