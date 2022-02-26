%Depth estimation & segmentation%
%Input: an array the size of the original image with blur estimate values
%at the corresponding edge locations, The amount of segments (assuming the
%object is in the foreground and focussed on
%Output: Segmented contour maps
function [Seg_Im,Threshold] = DepthSegmentation(BlurEst,Segments)
FocusMargin = ((max(max(BlurEst))-min(min(BlurEst)))/(Segments));   %set a margin to determine what values of blur are considered within a segment
Margin = 2; %Margin specific for foreground background seperation
Seg_Im=zeros(size(BlurEst,1),size(BlurEst,2));  %Initialise the output array
Threshold=zeros(Segments-1,1);
if Segments == 2
    Threshold = min(min(BlurEst)) + Margin;
    Seg_Im(:,:,1) = (0 < BlurEst) & (BlurEst < Threshold);
    Seg_Im(:,:,2) = BlurEst >= Threshold;
else
    for s = 1:Segments-1
        Threshold(s) = min(min(BlurEst)) + s*FocusMargin + 0.1;  %set threshold
        if s ==1
            Seg_Im(:,:,s) = (0 < BlurEst) & (BlurEst < Threshold(s));    %find elements within threshold
        else
            Seg_Im(:,:,s) = (Threshold(s-1) < BlurEst) & (BlurEst < Threshold(s));    %find elements within threshold
        end
        if s==Segments-1
            Seg_Im(:,:,s+1) = (BlurEst > Threshold(s)); %Consider all leftover blur values as final segment
            
        end
    end
end  
end