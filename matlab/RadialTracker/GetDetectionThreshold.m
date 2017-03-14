function [ Contrast, Threshold ] = GetDetectionThreshold( Vid, MazeCoords, Background, NumFish )

Answer = 'YES';
ImgNum = round(Vid.Duration * Vid.FrameRate / 2);
Contrast = 1;
Threshold = 3500;

while isequal(Answer, 'YES')
    
    Prompt = {['Image to test (max=', num2str(round(Vid.Duration * Vid.FrameRate)), '):'], 'Contrast:', 'Threshold:'};
    DlgTitle = 'Please, fill the form with requested information';
    NumLines = 1;
    Default = {num2str(ImgNum), num2str(Contrast), num2str(Threshold)};
    Answer = inputdlg(Prompt, DlgTitle, NumLines, Default);
    
    Img = read(Vid, str2double(Answer{1}));
    ImgSize = size(Img);
    H = int32(max(min(MazeCoords(:,2)), 1)):int32(min(max(MazeCoords(:,2)), ImgSize(1)));
    W = int32(max(min(MazeCoords(:,1)), 1)):int32(min(max(MazeCoords(:,1)), ImgSize(2)));
    Img = Img(H, W, :);
    
    ImgNum = str2double(Answer{1});
    Contrast = str2double(Answer{2});
    Threshold = str2double(Answer{3});
    
    [XCentroids, YCentroids, N] = BlobDetection(Img, Background, Contrast, Threshold, MazeCoords, NumFish);
    CountFishInArms(XCentroids, YCentroids, N, NumFish, MazeCoords, Img);
    
    Answer = questdlg('Do you want to try with other parameters? If NO, the last values of contrast and threshold that you entered will be used.','','YES','NO','YES');
    
end


