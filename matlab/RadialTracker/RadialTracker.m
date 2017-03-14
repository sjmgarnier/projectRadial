%% Clean potential previous mess
clear variables;


%% Set the tracker up
[ VidFile, VidPath, Vid, NumFish, NumArm, SampRate ] = TrackerSetup();


%% Prepare background image and zones of interest
if exist([VidPath, 'MazeCoords.mat'], 'file') == 2 
    load([VidPath, 'MazeCoords.mat']);
else
    MazeCoords = GetMazeCoords(VidPath, Vid, NumArm);
end

if exist([VidPath, 'Background.jpg'], 'file') == 2 
    Background = imread([VidPath, 'Background.jpg']);
else
    Background = CreateBackgroundPict(VidPath, Vid, MazeCoords);
end

ArmTypes = cell(1, NumArm + 1);
for i = 1:NumArm
    ArmTypes{i} = ['Arm' num2str(i)];
end
ArmTypes{NumArm + 1} = 'Center';


%% Parameterize the counting algorithm
[Contrast, Threshold] = GetDetectionThreshold(Vid, MazeCoords, Background, NumFish);


%% Run the counting algorithm
IX = round(1:Vid.FrameRate / SampRate:Vid.Duration * Vid.FrameRate);
L = size(IX, 2);
Data = cell(L, NumArm + 2);

Img = read(Vid, 1);
ImgSize = size(Img);
H = int32(max(min(MazeCoords(:,2)), 1)):int32(min(max(MazeCoords(:,2)), ImgSize(1)));
W = int32(max(min(MazeCoords(:,1)), 1)):int32(min(max(MazeCoords(:,1)), ImgSize(2)));

h = waitbar(0, 'Initializing waitbar...');

for i = 1:L
    
    Img = read(Vid, IX(i));
    ImgSize = size(Img);
    Img = Img(H, W, :);
    
    [XCentroids, YCentroids, N] = BlobDetection(Img, Background, Contrast, Threshold, MazeCoords, NumFish);
    
    FishInArms = CountFishInArms(XCentroids, YCentroids, N, NumFish, MazeCoords);
    Data(i, :) = [{i}, num2cell(FishInArms)];
    
    waitbar(i / L, h, sprintf('Computing: %.2f%% done...', 100 * i / L));
    
end

close(h);

Data = [cell(size(ArmTypes,1),size(Data,2)); Data];
Data(1:size(ArmTypes,1),2:size(Data,2)) = ArmTypes;
Data(1:size(ArmTypes,1),1) = {NaN};


%% Save raw and smoothed data in CSV files
dlmcell([VidPath, 'Data.csv'], Data, ' ; ');







