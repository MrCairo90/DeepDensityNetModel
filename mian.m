%% Get input/output file paths 
inputDataPath = "./ExampleData/SyntheticDataInput";
outputGroundTruthDataPath = "./ExampleData/SyntheticDataInputGroundTruth";
netPath = './DeepDensity.mat';

inputFileNames = dir(fullfile(inputDataPath, '*.mat'));
inputFileNames = orderfields(inputFileNames);
inputFilesSize = size(inputFileNames);

outputFiles = dir(fullfile(outputGroundTruthDataPath, '*.mat'));
outputFiles = orderfields(outputFiles);
outputFilesSize = size(outputFiles);

% Load the net
net = load(netPath);
net = net.(subsref(fieldnames(net),substruct('{}',{1}))); 

% Test the net on the synthetic fringe images, show the results on the
% plots with the ground truth output
for i=1:1:inputFilesSize(1)
    tempInputFileName = strcat(...
            inputFileNames(i).folder, '\', inputFileNames(i).name);
    tempOutputFileName = strcat(...
            outputFiles(i).folder, '\', outputFiles(i).name);
    
    tempInput = load(tempInputFileName);
    tempInput = tempInput.(subsref(fieldnames(tempInput),substruct('{}',{1}))); 
    
    tempOutputGroundTruth = load(tempOutputFileName);
    tempOutputGroundTruth = tempOutputGroundTruth.(subsref(fieldnames(tempOutputGroundTruth),substruct('{}',{1}))); 

    figure('Renderer', 'painters', 'Position', [10 10 1400 400]) 
    
    % Plot the input fringe image
    subplot(1,3,1)
    imagesc(tempInput)
    title(strcat('Input synthetic fringe image #', num2str(i)))

    % Plot the ground truth output
    subplot(1,3,2)
    imagesc(tempOutputGroundTruth)
    title(strcat('Output ground truth density image #', num2str(i)))
    
    % Plot the net output
    subplot(1,3,3)
    tempInputSize = size(tempInput);
    netInput = zeros(tempInputSize(1), tempInputSize(2), 1, 1);
    netInput(:, :, 1, 1) = tempInput;
    imagesc(predict(net, netInput))
    title('Net output')

end
