function [Frequency] = frequency(I, BlockSize, OrientImage, Mask)
    [Rows, Cols] = size(I);
    Frequency = zeros(Rows, Cols);

    for i = 1:BlockSize:Rows - BlockSize
        for j = 1:BlockSize:Cols - BlockSize
            Box = [i, j, min(i + BlockSize - 1, Rows), min(j + BlockSize - 1, Cols)];
            BoxIm = I(Box(1):Box(3), Box(2):Box(4));
            BoxOrIm = OrientImage(Box(1):Box(3), Box(2):Box(4));
            Frequency(Box(1):Box(3), Box(2):Box(4)) = frequest(BoxIm, BoxOrIm, BlockSize, 5, 5, 15);
        end
    end
    Frequency = Frequency .* Mask;
    % FreqHelp = Frequency(:);
    % GreaterThanZero = FreqHelp(FreqHelp > 0);
    % MeanFreq = mean(GreaterThanZero);
    % 
    % Frequency = MeanFreq .* Mask;
end