I = imread("../pictures/101_1.tif");

BlockSize = 16;

INorm = normalization(I);

[INorm, Mask] = segmentation(INorm, 0.4, 16);
OrientImage = orientation(INorm, 1, 7, 7);
Frequency = frequency(INorm, BlockSize, OrientImage, Mask);
GaborFilt = gabor_filter(I, OrientImage, Frequency);
%%
[Skeletonized, Endpoints, Bifurcations] = minutiae_extraction(GaborFilt, Mask);

[YEndpoints, XEndpoints] = find(Endpoints);
[YBifurcations, XBifurcations] = find(Bifurcations);
% imshow(Skeletonized)
% hold on
% plot(XEndpoints, YEndpoints, 'r*'); % Plot endpoints in red
% plot(XBifurcations, YBifurcations, 'g*'); % Plot bifurcations in green