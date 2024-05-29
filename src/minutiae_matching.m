function [Score] = minutiae_matching(Minutiae1, Minutiae2, Orient1, Orient2)
    Score = 0;
    for minutiae1 = Minutiae1
        BestScore = 0;
        for minutiae2 = Minutiae2
            X1 = minutiae1(1);
            X2 = minutiae2(1);
            Y1 = minutiae1(2);
            Y2 = minutiae2(2);
            Dx = X1 - X2;
            Dy = Y1 - Y2;
            D = sqrt(Dx^2 + Dy^2);
            
            Angle1 = Orient1(X1, Y1) / pi * 180;
            Angle2 = Orient2(X2, Y2) / pi * 180;
            AngleD = abs(mod(Angle1 - Angle2 + 180, 360) - 180);

            if(D > 20 || AngleD > 45)
                S = 0;
            else
                S = 1;
            end
            if(S > BestScore)
                BestScore = S;
            end
        end
        Score = Score + BestScore;
    end
    Score = Score / length(Minutiae1);
end