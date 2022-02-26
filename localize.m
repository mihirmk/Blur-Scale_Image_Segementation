function [r2max, scale_map] = localize(scale2, image)
global noise_var;
global alphaP;
global scale_map;

r2max = dip_array(gradmag(gradmag(image, scale2),scale2));
r2abs = abs(r2max);

% Critical Value Function of the resultant gradient response
sigma2 = noise_var.*((4.*sqrt(pi/3).*scale2.^3).^-1);
critical = sqrt(2) .* sigma2 .* (erfinv(1-alphaP));

% Identifying Gradient and angle of points with magnitude less than critical value
list = find(r2abs < critical);
r2max(list) = 0;

% Identifying Gradient and angle of points with magnitude greater than critical value
list = find(r2abs >= critical);
scale_map(list) = scale2;

