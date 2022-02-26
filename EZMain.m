clc
clear all
close all

%% This is the Main function of the Elder Zucker Variant of the Code.

%% Image Overall & Pointwise Significance Reliability Criterion based on Noise
global alphaP;
global noise_var;
global scale_map;
global alpha;
alpha = 0.05;
noise_var = 1;  % Noise Variance to be added in the image

%% Input Image

im1 = SyntheticEdge;
% im2 = imread("car.jpg");
% im2 = imread("bottle.jpg");
% im2 = imread("grill.jpg");
% im2 = imread("lamp.jpg");

% % Grayscale conversion
% im = rgb2gray(im2);

% % Addition of Noise 
im = dip_array(noise(im1,'gaussian',noise_var,0));


% Experiment 1 : Blur Estimate on Synthetic Edge
[estimated_blur] = ElderZuckerEstimation(im,1);
blur = estimated_blur(:,128);
sigma=linspace(1,26.6,256);
figure
plot(sigma,blur)
xlabel('True blur scale')
ylabel('Estimated blur scale')

% % % Experiment 2 : Blur Estimate & Depth Segmentation on Real Images
% [estimated_blur] = ElderZuckerEstimation(im,2);
% [Seg_Im,Threshold] = DepthSegmentation(estimated_blur,2);
% % Displaying Foreground & Background Images
% dipshow(Seg_Im(:,:,1))
% dipshow(Seg_Im(:,:,2))