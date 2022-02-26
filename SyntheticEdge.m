function [blurSynth]=SyntheticEdge
% SynthEdge = [0.95*ones(256,127),0.7*ones(256,1), 0.45*ones(256,128)];
% imshow(SynthEdge)
% SynthEdge_blurred=[0.95*ones(256,127),0.7*ones(256,1), 0.45*ones(256,128)];
% for i = 1:size(SynthEdge,1)
%    sig = i/10+1;
%    b = round(3*sig);
%    G=zeros(2*b+1);
%    for x= -b:b
%        for y = -b:b
%             G(y+b+1,x+b+1)=1/(2*pi*sig^2)*exp(-(x^2+y^2)/(2*sig^2));
%        end
%    end
%    for j = -round(sig):round(sig)
%        if i-b <= 0 || i+b >= 256
%           SynthEdge_blurred(i,128+j)= sum(sum(G.*SynthEdge(128-b:128+b,128-b+j:128+b+j)));
%        else
%           SynthEdge_blurred(i,128+j)= sum(sum(G.*SynthEdge(i-b:i+b,128-b+j:128+b+j)));
%        end
%    end
% end
% SynthEdge_blurred=imgaussfilt(SynthEdge_blurred,1);
% 
% figure
% imshow(SynthEdge_blurred)

SynthEdge = 255.*[0.95*ones(256,127),0.7*ones(256,1), 0.45*ones(256,128)];
blurSynth=zeros(size(SynthEdge,1),size(SynthEdge,2));
for i=1:size(SynthEdge,1)
    sig = i/10+1;
    Blurredlayer = dip_array(gaussf(dip_image(SynthEdge(1,:)),sig,'best'));
    blurSynth(i,:)=Blurredlayer;
end
end
