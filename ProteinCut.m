function [imgCut]=ProteinCut(image, gray, divisor)

flag=0;
for i=1:size(image,1)
    notWhiteNum=0;
    for j=1:size(image,2)
        if image(i,j)<gray
            notWhiteNum=notWhiteNum+1;
        end
    end    
    if notWhiteNum<(size(image,2)/divisor)
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

imgCut=image(heightStart:heightEnd,:);

flag=0;
for i=1:size(imgCut,2)
    notWhiteNum=0;
    for j=1:size(imgCut,1)
        if imgCut(j,i)<gray
            notWhiteNum=notWhiteNum+1;
        end
    end    
    if notWhiteNum<(size(imgCut,1)/divisor)
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

imgCut=imgCut(:,widthStart:widthEnd);

end