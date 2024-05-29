function [Freq] = frequest(BlockIm, BlockOr, BlockSize, WindSze, MinWaveLength, MaxWaveLength)
    HelpB = double(BlockOr(:));

    CosOrient = mean(cos(2 * HelpB));
    SinOrient = mean(sin(2 * HelpB));
    Orient = atan2(SinOrient, CosOrient) / 2;

    RotBlock = imrotate(BlockIm, Orient / pi * 180 + 90);
    Proj = sum(RotBlock);
    Dilation = imdilate(Proj, ones(WindSze));
    Temp = abs(Dilation - Proj);

    PeakThresh = 2;
    MaxPts = (Temp < PeakThresh) & (Proj > mean(Proj));
    MaxInd = find(MaxPts);

    [~, ColsMaxInd] = size(MaxInd);
    
    if(ColsMaxInd < 2)
        Freq = zeros(BlockSize, BlockSize);
        return
    end
    NOPeaks = ColsMaxInd;
    WaveLength = (MaxInd(1, ColsMaxInd) - MaxInd(1, 1)) / (NOPeaks - 1);
    if(WaveLength >= MinWaveLength && WaveLength <= MaxWaveLength)
        Freq = 1 / WaveLength * ones(BlockSize, BlockSize);
        return
    end
    Freq = zeros(BlockSize, BlockSize);
end