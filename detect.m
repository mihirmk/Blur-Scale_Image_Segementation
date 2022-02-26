function [r1max, theta, critical] = detect(scale1, image)
global noise_var;
global alphaP;

r1max = dip_array(gradmag(image, scale1));
gvec = dip_array(gradientvector(image,scale1));
theta = atan(gvec(:,:,1)./gvec(:,:,2));
r1abs = abs(r1max);

% Critical Value Function of the resultant gradient response
s1 = noise_var.*(1./(2.*sqrt(2.*pi).*scale1.^2));
critical = s1.*sqrt(-2.*log(alphaP));

% Identifying Gradient and angle of points with magnitude greater than critical value
list = find(r1abs < critical);
r1max(list) = 0;
theta(list) = 0;