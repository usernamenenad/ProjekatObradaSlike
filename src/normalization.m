function [I] = normalization(I)
    I = im2double(I);
    HelpI = I(:);
    I = (I - mean(HelpI)) ./ std(HelpI);
end