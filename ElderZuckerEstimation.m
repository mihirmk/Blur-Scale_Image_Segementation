function [estimated_blur] = ElderZuckerEstimation(im,Ex);
%% Elder & Zucker : Edge Detection & Localization
% This method takes an image as input and the corresponding Experiment 
% number. It returns the estimated blur obtained using the methid proposed 
% by Elder & Zucker in their paper.
%  Inputs : im = Image
%           Ex = Variable denoting the experiment
%              = { 1 - Synthetic Edge Image
%                  2 - Natural Image


global alphaP;
global noise_var;
global scale_map;
global alpha;
alpha = 0.05;

alphaP = 1 - (1 - alpha).^(1./length(im));
dim = size(im);
scale_map = zeros(dim);

% Scale-Set for 1st order Gaussian Filters
sigma1 = [16 8 4 2 1 0.5];
grad1 = zeros(dim);
angle = zeros(dim);

% Scale-Set for 1st order Gaussian Filters
sigma2 = [16 8 4 2 1 0.5];
grad2 = zeros(dim);

%% Iterative Edge Detection & Localization for the Scales defined
% earlier
% Step 1 - Edge Detection using 1st order Gradients
for h = 1 : length(sigma1)
    [mag, ang, ~] = detect(sigma1(h), im);
    grad1(mag ~= 0) = 0;
    grad1 = grad1 + mag;
    angle(ang ~= 0) = 0;
    angle = angle + ang;
end

% Step 2 - Edge Localization using 2nd order Gradients
for h = 1 : length(sigma2)
    [grad2mv, scale_map] = localize(sigma2(h), im);
    grad2(grad2mv ~= 0) = 0;
    grad2 = grad2 + grad2mv;
end

% Step 3 - Edge Zero Crossing using 3rd order Gradients
if Ex == 1 
    % For the Synthetic Edge Experiment
    im_edge = [zeros(256,127),ones(256,1), zeros(256,128)];
else
    if Ex == 2
    % For the Natural Image Experiment
    [grad3] = third(4, im);
    im_edge = edge(grad3,'canny');

    end
end

%% Difference in Extremas of 2nd Derivative Gaussians
[x_val,y_val] = find(im_edge ~= 0);
estimated_blur = zeros(dim);
grad_spread = dim(1);

% Orientation of the Current Pixel discretised to 8 directions of Pixels
phi   = [0, 45, 90, 135, 180, 225, 270, 315];
x_dir = [1, 1, 0, -1, -1, -1, 0, 1];
y_dir = [0, 1, 1, 1, 0, -1, -1, -1];

for i = 1 : length(x_val)
    curr_x = x_val(i);
    curr_y = y_val(i);
    curr_angle = 45 * round(rad2deg(angle(curr_x, curr_y))/45);
    curr_max = grad2(x_val(i),y_val(i));
    curr_min = curr_max;
    next_max  = curr_max;
    next_min  = curr_min;
    
    % Dynamic Diretion assignment based on 1st Order Derivative gradient angle
    for k = 1 : length(phi)
        if (curr_angle == phi(k)) || (curr_angle == - (360 - phi(k)))
            p_x = x_dir(k);
            p_y = y_dir(k);
        end
    end
    
    % Track Max Value of 2nd Derivative Edge based on gradient values
    flag = 0;
    while(next_max >= curr_max)
        % Move along the detected edge coordinates
        next_x = curr_x + p_x;
        next_y = curr_y + p_y;
        
        % Jump out of the loop if Image edge is encountered or counter
        % exceeds window
        if next_x < 1 || (next_x > dim(1)) || (next_y < 1) || (next_y > dim(2)) || flag > grad_spread
            break;
        end
        
        % Find the 2nd Derivative Gradient Values at the new point
        % perpendicular to the edge in a artefact width of w pixels
        next_max = grad2(next_x, next_y);
        flag = flag + 1;
        
        % Shift ahead for next detection
        curr_x = next_x;
        curr_y = next_y;
    end
    % Grad2 Maxima locations for a detected artefact
    g2max_x = curr_x;
    g2max_y = curr_y;
    
    % Reseting to initial location
    curr_x = x_val(i);
    curr_y = y_val(i);
    next_x = x_val(i);
    next_y = y_val(i);
    flag = 0;
    
    
    % Track Min Value of 2nd Derivative Edge based on gradient values
    while(next_min <= curr_min)
        % Move along the detected edge coordinates
        next_x = curr_x - p_x;
        next_y = curr_y - p_y;
        
        % Jump out of the loop if Image edge is encountered or counter
        % exceeds window
        if next_x < 1 || (next_x > dim(1)) || (next_y < 1) || (next_y > dim(2)) || flag > grad_spread
            break;
        end
        
        % Find the 2nd Derivative Gradient Values at the new point along
        % the edge in a artefact width of w pixels
        nextmin = grad2(next_x, next_y);
        flag = flag +1;
        
        % Shift ahead for next detection
        curr_x = next_x;
        curr_y = next_y;
    end
    
    % Grad2 Minima locations for a detected artefact
    g2min_x = curr_x;
    g2min_y = curr_y;
    
    
    % Distance of 2nd Derivative Extrema
    d(i) = sqrt((2*(g2max_x - x_val(i)))^2 + (2*(g2max_y - y_val(i)))^2);
    % d(i) = sqrt(((g2max_x - g2min_x))^2 + ((g2max_y - g2min_y))^2);
    
    % Blur Estimate at Current pixel
    estimated_blur(x_val(i),y_val(i)) = sqrt((d(i)/2)^2 - (scale_map(x_val(i),y_val(i))).^2 );
end

end


