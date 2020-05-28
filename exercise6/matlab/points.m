function [p] = points(I1, I2)
    points1 = detectKAZEFeatures(I1);
    points2 = detectKAZEFeatures(I2);
    [features1,valid_points1] = extractFeatures(I1,points1);
    [features2,valid_points2] = extractFeatures(I2,points2);
    indexPairs = matchFeatures(features1,features2);
    matchedPoints1 = valid_points1(indexPairs(:,1),:)
    matchedPoints2 = valid_points2(indexPairs(:,2),:)
    figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
    p1 = matchedPoints1.Location;
    p2 = matchedPoints2.Location;
    p = [p1, p2];
    %m = [matchedPoints1, matchedPoints2]
    
    %p1 = detectFASTFeatures(I1);
    %m = [p1.Location(:,1), p1.Location(:, 2)];
    %p = writematrix(m)
    
end 
