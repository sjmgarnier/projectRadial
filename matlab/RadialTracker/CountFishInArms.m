function [ FishInArms ] = CountFishInArms( XCentroids, YCentroids, N, NumFish, MazeCoords, Img )

NumArm = size(MazeCoords, 1) / 4;

MazeCoords(:,1) = MazeCoords(:,1) - double(int32(max(min(MazeCoords(:,1)),1)));
MazeCoords(:,2) = MazeCoords(:,2) - double(int32(max(min(MazeCoords(:,2)),1)));

FishInArms = nan(1, NumArm + 1);

for i = 1:NumArm
    
    XArm = MazeCoords((i-1)*4+1:i*4, 1);
    YArm = MazeCoords((i-1)*4+1:i*4, 2);
    
    IN = inpolygon(XCentroids, YCentroids, XArm, YArm);
    
    FishInArms(i) = sum(N(IN));
    
end

FishInArms(NumArm + 1) = NumFish - sum(FishInArms(1:NumArm));

if exist('Img','var')
    
    imshow(Img);
    hold on;
    
    for i = 1:NumArm
        
        text(mean(MazeCoords((i-1)*4+1:i*4,1)), mean(MazeCoords((i-1)*4+1:i*4,2)), ...
            num2str(FishInArms(i)),'Color','red','FontSize',24, ...
            'HorizontalAlignment','center','VerticalAlignment','middle');
        plot(MazeCoords([(i-1)*4+1:i*4 (i-1)*4+1],1), ...
            MazeCoords([(i-1)*4+1:i*4 (i-1)*4+1],2), 'r', 'LineWidth',2);
        
    end
    
    text(mean(MazeCoords([1:4:size(MazeCoords, 1), 4:4:size(MazeCoords, 1)], 1)), ...
        mean(MazeCoords([1:4:size(MazeCoords, 1), 4:4:size(MazeCoords, 1)], 2)), ...
        num2str(FishInArms(7)),'Color','red','FontSize',24,'HorizontalAlignment','center','VerticalAlignment','middle');
    
    hold off;
    
end

end

