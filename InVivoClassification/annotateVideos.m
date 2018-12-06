clear;
clc;

tblAnnotations = readtable('randomTable - Adjusted.xlsx');
% keep = ~cellfun(@isempty,strfind(tblAnnotations.newLabel,'RyR'));
% tblAnnotations = tblAnnotations(keep, :);

annotation = tblAnnotations.annotation;
sublabel = tblAnnotations.newLabel2;
label = tblAnnotations.newLabel;
labels = unique(label);
newPath = table2cell(tblAnnotations(:,2));

catList = categorical({'empty','none','spikes','transient','waves','fluttering','unusable'});
legendImage = imread('legend.png');
catColor = legendImage(12+0:20:140,15,:);
% for count = 1:3
%     catColor2(:,:,count) = [catColor(:,1,count); 255];
% end
legendImage(960,:,:) = 0;
permute(legendImage, [1,2,4,3]);
annotationsDir = ['annotatedVideos' filesep];
if (~exist('annotatedVideos','dir'))
    mkdir(annotationsDir);
end

for i = 1:length(labels)
    if exist([annotationsDir filesep label{2+(i-1)*9} '.mp4'])
        continue
    end
    
    idx = strcmp(label, labels{i});
    classes = annotation(idx);
    % stack = double(readTiff(['Tif' filesep labels{i} '.tif']));
    stack = double(readTiff([newPath{2+(i-1)*9} '\Scene1Interval01.tifBWStack.tif']));
    range = prctile(stack(:), [0,99.5]);
    stack = 255 * (stack - range(1)) / (range(2) - range(1));
%     stack = uint8(stack);
    clear bar
    for j = 1:length(classes)
         bar(j,1,:) = squeeze(catColor(catList==classes(j),:,:));
         %bar(j,1,:) = squeeze(catColor2(catList==classes(j),:,:));
    end
    bar = imresize(bar, [960, 50], 'nearest');
    bar(:,100,:) = 0;
    annotated = cat(2, permute(repmat(stack,[1,1,1,3]), [1,2,4,3]), repmat(bar,[1,1,1,size(stack,3)]));
    interval = 960/81;
    for t = 1:size(stack,3)
        ys = ceil(1+interval*(t-1)):floor(interval*t);
        annotated(ys,end-50:end,:,t) = 255;
    end
    annotated = cat(2, annotated, repmat(legendImage,[1,1,1,size(stack,3)]));
    
    v = VideoWriter([annotationsDir filesep label{2+(i-1)*9}],'MPEG-4');
    v.FrameRate = 14;
    
    open(v)
    for t = 1:size(annotated,4)
        writeVideo(v, annotated(:,:,:,t));
    end
    close(v)
end