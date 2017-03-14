function [ MazeCoords ] = GetMazeCoords( VidPath, Vid, NumArm )

if ~exist([VidPath, 'MazeCoords.mat'],'file')
    
    questdlg('Select the 4 corners of each arms, starting with arm 1 and rotating clockwise','','OK','OK');
    
    Img = read(Vid, 1);
    imshow(Img);
    hold on;
    
    MazeCoords = nan(NumArm * 4, 2);
    
    for i = 1:NumArm
        
        for j = 1:4
            
            if (j == 1 & (i - 1) * 4 + j > 1)
                
                MazeCoords((i - 1) * 4 + j, :) = MazeCoords((i - 2) * 4 + 4, :);
                
            elseif (i == NumArm & j == 4)
                
                MazeCoords((i - 1) * 4 + j, :) = MazeCoords((1 - 1) * 4 + 1, :);
                
            else
                
                MazeCoords((i - 1) * 4 + j, :) = ginput(1);
                
            end
            
            plot(MazeCoords(:, 1), MazeCoords(:, 2), '+r');
            
        end
        
        for k = 1:i
            
            plot(MazeCoords([(k-1)*4+1:k*4, (k-1)*4+1],1), MazeCoords([(k-1)*4+1:k*4, (k-1)*4+1],2), '-r');
            
        end
        
    end
    
    save([VidPath, '/MazeCoords.mat'],'MazeCoords');
    
    hold off;
    
else
    
    load([VidPath, '/MazeCoords.mat']);
    
end

end

