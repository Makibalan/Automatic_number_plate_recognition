% import the video file
obj = VideoReader('s2.mp4');
numFrames = 0;
while hasFrame(obj)
    readFrame(obj);
    numFrames = numFrames + 1;
end
disp("NUMBER OF FRAMES=");numFrames
vid = read(obj);

% read the total number of frames
frames = obj.NumFrames;

% file format of the frames to be saved in
ST ='.jpg';

% reading and writing the frames
for x = 1 : frames

	% converting integer to string
	Sx = num2str(x);

	% concatenating 2 strings
	Strc = strcat(Sx, ST);
	Vid = vid(:, :, :, x);
	cd frames

	% exporting the frames
	imwrite(Vid, Strc);
	cd ..
end
% Specify the folder where the files live.
myFolder = 'C:\Users\Makibalan\frames';
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isfolder(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', myFolder);
    uiwait(warndlg(errorMessage));
    myFolder = uigetdir(); % Ask for a new one.
    if myFolder == 0
         % User clicked Cancel
         return;
    end
end
% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.jpg'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    % Now do whatever you want with this file name,
    % such as reading it in as an image array with imread()
    imageArray = imread(fullFileName);
    imshow(imageArray);  % Display image.
    drawnow; % Force display to update immediately.
end
im = imread(fullFileName);
imgray = rgb2gray(im);
imbin = imbinarize(imgray);
im = edge(imgray, 'prewitt');

%Below steps are to find location of number plate
Iprops=regionprops(im,'BoundingBox','Area', 'Image');
area = Iprops.Area;
count = numel(Iprops);
maxa= area;
boundingBox = Iprops.BoundingBox;
for i=1:count
   if maxa<Iprops(i).Area
       maxa=Iprops(i).Area;
       boundingBox=Iprops(i).BoundingBox;
   end
end
im = imcrop(imbin, boundingBox);%crop the number plate area
im = bwareaopen(~im, 500); %remove some object if it width is too long or too small than 500

 [h, w] = size(im);%get width

imshow(im);

Iprops=regionprops(im,'BoundingBox','Area', 'Image'); %read letter
count = numel(Iprops);
noPlate=[]; % Initializing the variable of number plate string.

for i=1:count
   ow = length(Iprops(i).Image(1,:));
   oh = length(Iprops(i).Image(:,1));
   if ow<(h/2) && oh>(h/3)
       letter=Letter_detection(Iprops(i).Image); % Reading the letter corresponding the binary image 'N'.
       noPlate=[noPlate letter]; % Appending every subsequent character in noPlate variable.
   end
end