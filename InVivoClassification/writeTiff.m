function writeTiff( video, filename )
imwrite(video(:,:,1), filename)
for k = 2:size(video,3)
    imwrite(video(:,:,k), filename, 'writemode', 'append');
end
end

