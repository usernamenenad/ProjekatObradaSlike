function [GaborFilt] = gabor_filter(I, Orientation, Frequency)
    GaborFilt = zeros(size(I));

    WaveLengths = transpose(1 ./ unique(Frequency(Frequency > 0)));
    Orients = 0:3:180;
    for theta = Orients
        for lambda = WaveLengths
            gaborFilter = gabor(lambda, theta, 'SpatialAspectRatio', 0.5, 'SpatialFrequencyBandwidth', 4);
            filtered = imgaborfilt(I, gaborFilter);
            GaborFilt = GaborFilt + filtered;
        end
    end
    GaborFilt = 255 - im2uint8(mat2gray(GaborFilt));
end