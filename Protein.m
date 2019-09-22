clf;clc;close all;

fileName='4.tif';
imgData= rgb2gray(imread(fileName));
info=imfinfo (fileName);
size(imgData);

%{
flag=0;
for i=1:size(imgData,1)
    notWhiteNum=0;
    for j=1:size(imgData,2)
        if imgData(i,j)<240
            notWhiteNum=notWhiteNum+1;
        end
    end    
    if notWhiteNum<(size(imgData,2)/5)
        if flag==1
            heightEnd=i-1;
            break;
        end
        continue;
    end
    
    if flag==0
        flag=1;
        heightStart=i;
    end
end

imgCut=imgData(heightStart:heightEnd,:);
sizeCut=size(imgCut);

flag=0;
for i=1:size(imgCut,2)
    notWhiteNum=0;
    for j=1:size(imgCut,1)
        if imgCut(j,i)<240
            notWhiteNum=notWhiteNum+1;
        end
    end    
    if notWhiteNum<(size(imgCut,1)/5)
        if flag==1
            widthEnd=i-1;
            break;
        end
        continue;
    end
    
    if flag==0
        flag=1;
        widthStart=i;
    end
end
size(imgCut)
imgCut=imgCut(:,widthStart:widthEnd);
%}

imgCut=ProteinCut(imgData, 255, 20);
internalHalf=30;
peaks=[];
imgCutMean=mean(imgCut,1);

[peaks, peaksLoc]=findpeaks(imgCutMean, 'NPeaks',20, 'MinPeakDistance',30, 'MinPeakWidth', 10, 'MinPeakProminence',5);
%{
for i=1:size(imgCutMean,2)
    if i>internalHalf && i<size(imgCutMean,2)-internalHalf
        iMax=imgCutMean(i);
        for j=i-internalHalf:i+internalHalf
            if imgCutMean(j)>iMax
                iMax=imgCutMean(j);
            end
        end
        if iMax==imgCutMean(i)
            if length(peaks)>1&&(i-peaks(1,end)<internalHalf)
                continue;
            end
            add=[i;imgCutMean(i)];
            peaks=[peaks add];
            i=i+internalHalf*2;
        end
    end    
end
%}

figure 
subplot(3,5,1)
imshow (imgCut(:,1:peaksLoc(1)))
for i = 2:size(peaksLoc,2)
    subplot(3,5,i)
    imshow(imgCut(:,peaksLoc(i-1):peaksLoc(i)))
end
segmentNum=i+1;
subplot(3,5,segmentNum)
imshow (imgCut(:,peaksLoc(segmentNum-1):end))

%{
figure;
for j=1:segmentNum-1
    if j==1
        for i = 1:peaksLoc(j)
        hold on;
        subplot(3,5,j)
        plot(imgCut(:,i),'k')
        end
        continue;
    end
    for i = peaksLoc(j-1):peaksLoc(j)
        hold on;
        subplot(3,5,j)
        plot(imgCut(:,i),'k')
    end
end
for i = peaksLoc(j):size(imgCut,2)
        hold on;
        subplot(3,5,segmentNum)
        plot(imgCut(:,i),'k')
end
%}

figure;
plot (255-imgCut(:,247),'k')
%display the peaks' locations&values
format short g
peaks
peaksLoc
size(peaks)

%display the images and plots
figure
subplot(2,1,1)
imshow(imgCut)
title(fileName);

subplot(2,1,2)
plot(imgCutMean, '-')
grid on;
title('Mean');
hold on;
%scatter(peaks(1,:),peaks(2,:))
scatter(peaksLoc, peaks);



