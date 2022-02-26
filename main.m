% [Syn,Blur_scales] = SynthMap(256,256,8,26,1);
% [Synth,Threshold]=DepthSegmentation(Syn,8);
% imagesc(Syn);
% for i = 1:8
%     figure
%     imshow(Synth(:,:,i))
% end
%%
[Edge]=SyntheticEdge;
EdgeIm=dip_image(Edge);
Edgemap = [zeros(256,127),ones(256,1), zeros(256,128)];
[Blur]=Bouma(Edge,Edgemap,0);
[Blur2]=Bouma(Edge,Edgemap,1);
sigma=linspace(1,26.6,256);

for i = [1,2,4]
    EdgeN=dip_array(noise(EdgeIm,'gaussian',i));
    Blur=Bouma(EdgeN,Edgemap,0);
    Blur2=Bouma(EdgeN,Edgemap,1);
    figure
plot(sigma,Blur(:,128))
xlabel('True blur scale')
ylabel('Estimated blur scale')

figure
plot(sigma,Blur2(:,128))
xlabel('True blur scale')
ylabel('Estimated blur scale')
end
%%
% im1 = imread("Car.jpg");
% im=rgb2gray(im1);
% Edge_map = edge(im,'canny');
% Blur_est=Bouma(im,Edge_map,0);
% % Blur_est1=Bouma(im,Edge_map,1);
% [Seg,T]=DepthSegmentation(abs(Blur_est),2);
% % [Seg1,~]=DepthSegmentation(Blur_est1,2);
% dipshow(Seg(:,:,1))
% dipshow(Seg(:,:,2))
