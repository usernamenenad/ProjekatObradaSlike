function [OrientImage] = orientation(I, GradSigma, BlockSigma, OrientSmoothSigma)
    Sze = fix(6 * GradSigma);
    if rem(Sze, 2) == 0
        Sze = Sze + 1;
    end
    GaussianKernel = fspecial('gaussian', round(Sze), GradSigma);
    FilterGauss = GaussianKernel * transpose(GaussianKernel);
    [FilterGradX, FilterGradY] = gradient(FilterGauss);
    GradX = conv2(I, FilterGradX, "same");
    GradY = conv2(I, FilterGradY, "same");

    GradX2 = GradX .^ 2;
    GradY2 = GradY .^ 2;
    GradXY = GradX .* GradY;

    Sze = fix(6 * BlockSigma);
    GaussianKernel = fspecial('gaussian', round(Sze), BlockSigma);
    FilterGauss = GaussianKernel * transpose(GaussianKernel);

    GradX2 = imfilter(GradX2, FilterGauss);
    GradY2 = imfilter(GradY2, FilterGauss);
    GradXY = 2 * imfilter(GradXY, FilterGauss);
    
    Denom = sqrt(GradXY .^ 2 + (GradX - GradY) .^ 2) + 0.00001;
    Sin2Theta = GradXY ./ Denom;
    Cos2Theta = (GradX2 - GradY2) ./ Denom;

    Sze = fix(6 * OrientSmoothSigma);
    if rem(Sze, 2) == 0
        Sze = Sze + 1;
    end
    GaussianKernel = fspecial('gaussian', round(Sze), OrientSmoothSigma);
    FilterGauss = GaussianKernel * transpose(GaussianKernel);
    Sin2Theta = imfilter(Sin2Theta, FilterGauss);
    Cos2Theta = imfilter(Cos2Theta, FilterGauss);
    
    OrientImage = (pi + atan2(Sin2Theta, Cos2Theta)) / 2;
end

