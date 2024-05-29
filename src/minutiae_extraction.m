function [Skeletonized, Endpoints, Bifurcations] = minutiae_extraction(I, Mask)
    Binarized = imbinarize(I, 'adaptive', 'ForegroundPolarity', 'bright', 'Sensitivity', 0.6) .* Mask;
    Skeletonized = bwmorph(Binarized, 'skeleton', Inf);
    Endpoints = bwmorph(Skeletonized, 'endpoints');
    Bifurcations = bwmorph(Skeletonized, 'branchpoints');
    Bifurcations = bwareaopen(Bifurcations, 1);
    Bifurcations = bwmorph(Bifurcations, 'clean');
end