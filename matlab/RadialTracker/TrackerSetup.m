function [ VidFile, VidPath, Vid, NumFish, NumArm, SampRate ] = TrackerSetup()

% Request user to select video file
[VidFile, VidPath] = uigetfile('*', 'Select the video to analyze');

% Load video
Vid = VideoReader([VidPath, VidFile]);

% Request user to indicate the number of fish in the maze
Prompt = {'Number of fish in the maze:', 'Number of arms to the maze:', 'Desired sampling rate (images/sec):'};
DlgTitle = '';
NumLines = 1;
Answer = inputdlg(Prompt, DlgTitle, NumLines);

% Prepare data for use outside the function
NumFish = str2double(Answer(1));
NumArm = str2double(Answer(2));
SampRate = str2double(Answer(3));

end

