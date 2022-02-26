function [BlurMap]=Bouma(Im,Edgemap,ex)
BlurMap = zeros(size(Edgemap,1),size(Edgemap,2));
dipim = dip_image(Im);
sigma_a = 2;
sigma_b = 12*sigma_a;
La = dip_array(gradmag(dipim,sigma_a));
Lb = dip_array(gradmag(dipim,sigma_b));
if ex ==0
    P = (La./Lb).^2;
    for i = 1:size(Im,1)
        for j = 1:size(Im,2)
            if Edgemap(i,j)==1
                BlurMap(i,j)=sqrt((sigma_b^2-P(i,j)*sigma_a^2)/(P(i,j)-1));
            end
        end
    end
%     BlurMap = Edgemap.*sqrt((sigma_b-P.*(sigma_a.^2))./(P-1));
elseif ex ==1
Sa = dip_array(gaussf(dipim,sigma_a,'best'));
Sb = dip_array(gaussf(dipim,sigma_b,'best'));
Gradvec=dip_array(gradientvector(dipim,sigma_a));
Theta = atan(Gradvec(:,:,1)./Gradvec(:,:,2));
r = 3;
dist = 6;
for i=1:size(Im,1)
    for j=1:size(Im,2)
        if Edgemap(i,j)==1
            ys1 = round(i-cos(Theta(i,j))*dist);
            xs1 = round(j-sin(Theta(i,j))*dist);
            ys2 = round(i+cos(Theta(i,j))*dist);
            xs2 = round(j+sin(Theta(i,j))*dist);
            y1=[ys1-r:ys1+r];
            y2=[ys2-r:ys2+r];
            x1=[xs1-r:xs1+r];
            x2=[xs2-r:xs2+r];
            if CheckOutOfBounds(size(Im,1),size(Im,2),y1,y2,x1,x2)==1
                continue
            else
            area1=Im(y1,x1);
            area2=Im(y2,x2);
            
            U1 = mean(mean(area1));
            U2 = mean(mean(area2));
            
            if U1 <= U2
                P(i,j)=((La(i,j)*exp(-(erfinv(2*(Sb(i,j)-U1)/(U2-U1)-1))^2))/(Lb(i,j)*exp(-(erfinv(2*(Sa(i,j)-U1)/(U2-U1)-1))^2)))^2;
            elseif U1 > U2
                P(i,j)= ((La(i,j)*exp(-(erfinv(2*(Sb(i,j)-U2)/(U1-U2)-1))^2))/(Lb(i,j)*exp(-(erfinv(2*(Sa(i,j)-U2)/(U1-U2)-1))^2)))^2;              
            end
            BlurMap(i,j)= sqrt((sigma_b^2-P(i,j)*sigma_a^2)/(P(i,j)-1));
            end
        end
    end
end
end
end
% %%
% SynthEdg = 255*[ones(256,127),0.5*ones(256,1), zeros(256,128)];
% SynthEdge = imgaussfilt(SynthEdg,10);
% SynthIm = dip_image(SynthEdge);
% sigma_a = 2;
% sigma_b = 2.8;
% La = dip_array(gradmag(SynthIm,sigma_a));
% Lb = dip_array(gradmag(SynthIm,sigma_b));
% P=(La(:,128)./Lb(:,128)).^2;
% blur = sqrt((sigma_b^2 -P * sigma_a^2)./(P-1));
% Sa = imgaussfilt(SynthEdge,sigma_a);
% Sb = imgaussfilt(SynthEdge,sigma_b);
