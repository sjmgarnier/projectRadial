function [ Background ] = CreateBackgroundPict( VidPath, Vid, MazeCoords )

PictSize = size(read(Vid, 1));

if ~exist([VidPath, '/Background.jpg'], 'file')
    
    h = waitbar(0, 'Initializing waitbar...');
    
    Background = zeros(int32(min(max(MazeCoords(:, 2)), PictSize(1))) - ...
        int32(max(min(MazeCoords(:, 2)),1)) + 1, ...
        int32(min(max(MazeCoords(:, 1)), PictSize(2))) - ...
        int32(max(min(MazeCoords(:, 1)),1)) + 1, ...
        PictSize(3));
    
    for i = 1:100
        
        r = 1 + round((i - 1) * (Vid.Duration * Vid.FrameRate / 100));
        
        Img = read(Vid, r);
        Img = Img(int32(max(min(MazeCoords(:,2)),1)):int32(min(max(MazeCoords(:,2)),PictSize(1))), ...
            int32(max(min(MazeCoords(:,1)),1)):int32(min(max(MazeCoords(:,1)),PictSize(2))), :);
        
        Background = Background + double(Img);
        
        waitbar(i / 100, h, sprintf('Computing background image: %d%% done...', i))
        
    end
    
    imwrite((Background / 100) / 255,[VidPath, '/Background.jpg']);
    
    Background = uint8(Background / 100);
    
    close(h);
    
else
    
    Background = imread([VidPath, '/Background.jpg']);
    
end

end

