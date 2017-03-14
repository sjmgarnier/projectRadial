function [ ShelterCoords ] = GetShelterCoords( ExpDir,Start,PictList,MazeCoords )

if exist([ExpDir '/ShelterCoords.mat'],'file')==0
    
    Answer = inputdlg('How many shelters are present in the maze?');
    ShelterNum = str2double(Answer{1});
    
    ShelterCoords = nan(ShelterNum*4,4);
    
    Img = imread([ExpDir '/pict/' PictList(Start).name]);
    imshow(Img);
    hold on;
    
    for i=1:ShelterNum
        
        questdlg('Select a shelter','','OK','OK');
        
        Coords = ginput(1);
        
        IN = nan(1,6);
        
        for k=1:6
            
            IN(k) = inpolygon(Coords(1),Coords(2),MazeCoords([(k-1)*4+1:k*4 (k-1)*4+1],1),MazeCoords([(k-1)*4+1:k*4 (k-1)*4+1],2));
            
        end
        
        IN = find(IN);
        
        questdlg('Select the entrance of the shelter','','OK','OK');
        
        Coords = ginput(2);
        
        [X1, Y1] = LineIntersection([Coords(1,:) Coords(2,:)],[MazeCoords((IN-1)*4+1,1) MazeCoords((IN-1)*4+1,2) MazeCoords((IN-1)*4+2,1) MazeCoords((IN-1)*4+2,2)]);
        [X2, Y2] = LineIntersection([Coords(1,:) Coords(2,:)],[MazeCoords((IN-1)*4+3,1) MazeCoords((IN-1)*4+3,2) MazeCoords((IN-1)*4+4,1) MazeCoords((IN-1)*4+4,2)]);
        
        ShelterCoords((i-1)*4+1:i*4,1) = [X1 MazeCoords((IN-1)*4+2,1) MazeCoords((IN-1)*4+3,1) X2];
        ShelterCoords((i-1)*4+1:i*4,2) = [Y1 MazeCoords((IN-1)*4+2,2) MazeCoords((IN-1)*4+3,2) Y2 ];
        
        plot(ShelterCoords([(i-1)*4+1:i*4 (i-1)*4+1],1), ShelterCoords([(i-1)*4+1:i*4 (i-1)*4+1],2), 'g', 'LineWidth',5);
        
        Answer = questdlg('What type of shelter is it?','','Target','Differ on size','Differ on darkness','Target');
        
        if strcmp(Answer,'Target')
            ShelterCoords((i-1)*4+1:i*4,3) = 1;
        elseif strcmp(Answer,'Differ on size')
            ShelterCoords((i-1)*4+1:i*4,3) = 2;
        else
            ShelterCoords((i-1)*4+1:i*4,3) = 3;
        end
        
        ShelterCoords((i-1)*4+1:i*4,4) = IN;
        
    end
    
    save([ExpDir '/ShelterCoords.mat'],'ShelterCoords');
    
    hold off;
    
else
    
    load([ExpDir '/ShelterCoords.mat']);
    
end

end

