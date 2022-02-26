function [BlurMap]=Bouma(Im,Edgemap,ex)

dipim = dip_image(Im);
sigma_a = 2;
sigma_b = 1.4*sigma_a;
La = dip_array(gradmag(dipim,sigma_a));
Lb = dip_array(gradmag(dipim,sigma_b));
if ex ==0
    P = (La./Lb).^2;
    for i = 1:size(Im,1)
        for j = 1:size(Im,2)
            BlurMap(i,j)=Edgemap(i,j)*sqrt((sigma_b^2-P(i,j)*sigma_a^2)/(P(i,j)-1));
        end
    end
elseif ex ==1
Sa = dip_array(gaussf(dipim,sigma_a,'best'));
Sb = dip_array(gaussf(dipim,sigma_b,'best'));
Theta = atan((dip_array(gradientvector(dipim,sigma_a))(:,:,1))./dip_array(gradientvector(dipim,sigma_a))(:,:,2));


[x_val,y_val] = find(Edgemap ~= 0);            
grad_spread = 15;   % Maximum Artefact edge Gradient variation Considered
estimated_blur = zeros(dim);
% Orientation of the Current Pixel discretised to 8 directions of Pixels
phi   = [0, 45, 90, 135, 180, 225, 270, 315];
x_dir = [1, 1, 0, -1, -1, -1, 0, 1];
y_dir = [0, 1, 1, 1, 0, -1, -1, -1];
for i = 1 : length(x_val)
    curr_x = x_val(i);
    curr_y = y_val(i);
    curr_angle = 45 * round(rad2deg(angle(curr_x, curr_y))/45);
    % Dynamic Diretion assignment based on 1st Order Derivative gradient angle
    for k = 1 : length(phi)
        if (curr_angle == phi(k)) || (curr_angle == - (360 - phi(k))) || (curr_angle == - phi(k))
            p_x = x_dir(k);
            p_y = y_dir(k);
        end
    end
    for nx = gradspread : gradspread + 7
        % Move along the detected edge coordinates
        o_n_x = curr_x + p_x;
        o_n_y = curr_y + p_y;
        if o_n_x < 1 || (o_n_x > dim(1)) || (o_n_y < 1) || (o_n_y > dim(2))
            break;
        end
        o_val(nx) = Im(o_n_x,o_n_y); 
        i_n_x = curr_x - p_x;
        i_n_y = curr_y - p_y;
        if i_n_x < 1 || (i_n_x > dim(1)) || (i_n_y < 1) || (i_n_y > dim(2))
            break;
        end
        i_val(nx) = Im(i_n_x,i_n_y);              
    end
    u1_m(i) = mean(o_val);
    u2_m(i) = mean(i_val);
end
            
            
%%
SynthEdg = 255*[ones(256,127),0.5*ones(256,1), zeros(256,128)];
SynthEdge = imgaussfilt(SynthEdg,15);
SynthIm = dip_image(SynthEdge);
sigma_a = 2;
sigma_b = 2.8;
Sa = imgaussfilt(SynthEdge,sigma_a);
Sb = imgaussfilt(SynthEdge,sigma_b);
La = dip_array(gradmag(SynthIm,sigma_a));
Lb = dip_array(gradmag(SynthIm,sigma_b));
P=(La(:,128)./Lb(:,128)).^2;
blur = sqrt((sigma_b^2 -P * sigma_a^2)./(P-1));
end