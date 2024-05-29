function [INorm, Mask] = segmentation(I, Threshold, BlockSize)
    I = double(I);
    [Rows, Cols] = size(I);
    Threshold = Threshold * std(I(:));
    ImageStd = zeros(Rows, Cols);

    for i = 1:BlockSize:Rows
        for j = 1:BlockSize:Cols
            Box = [i, j, min(i + BlockSize - 1, Rows), min(j + BlockSize - 1, Cols)];
            HelpI = I(Box(1):Box(3), Box(2):Box(4));
            ImageStd(Box(1):Box(3), Box(2):Box(4)) = std(HelpI(:));
        end
    end
    
    Mask = ImageStd > Threshold;
    INorm = (I - mean(I(:))) / std(I(:));
    Rigids = INorm(Mask == 1);
    INorm = (INorm - mean(Rigids(:))) / std(Rigids(:));
end

