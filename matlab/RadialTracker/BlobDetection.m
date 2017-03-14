function [ XCentroids,YCentroids,N ] = BlobDetection( Img, Background, Contrast, Threshold, MazeCoords, NumFish )

MazeCoords(:,1) = MazeCoords(:,1) - double(int32(max(min(MazeCoords(:,1)),1)));
MazeCoords(:,2) = MazeCoords(:,2) - double(int32(max(min(MazeCoords(:,2)),1)));

ROI = poly2mask(MazeCoords(:,1), MazeCoords(:,2), size(Background,1), size(Background,2));

Background(:,:,1) = Background(:,:,1).*uint8(ROI);
Background(:,:,2) = Background(:,:,2).*uint8(ROI);
Background(:,:,3) = Background(:,:,3).*uint8(ROI);

Img(:,:,1) = Img(:,:,1).*uint8(ROI);
Img(:,:,2) = Img(:,:,2).*uint8(ROI);
Img(:,:,3) = Img(:,:,3).*uint8(ROI);

Diff = (double(Background)-double(Img)).*abs(double(Background)-255).^Contrast;
Diff = Diff(:,:,1) + Diff(:,:,2) + Diff(:,:,3);

H = fspecial('disk',3);
Diff = imfilter(Diff,H,'replicate');
%BW = bwmorph(Diff>Threshold,'thin',Inf);
BW = Diff>Threshold;

Props = regionprops(BW,'Area','Centroid','MajorAxisLength','MinorAxisLength');
[~, IX] = sort([Props.Area],'descend');

if size(IX,2)>NumFish
    
    IX = IX(1:NumFish);
    
end

A = NumFish*[Props(IX).Area]/sum([Props(IX).Area]);
B = floor(A);
C = NumFish-sum(B);
D = A-B;

[~, IX2] = sort(D,'descend');

for j=1:C
    
    B(IX2(j)) = B(IX2(j))+1;
    
end

Test = find(B<1);
B(Test) = [];
IX(Test) = [];

N = B;

Centroids = [Props(IX).Centroid];
XCentroids = Centroids(1:2:size(Centroids,2));
YCentroids = Centroids(2:2:size(Centroids,2));

end

