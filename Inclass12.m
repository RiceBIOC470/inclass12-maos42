%Inclass 12. 
%GB comments
1) 100
2) 100
3) 100 think you could have used bwareaopen to help with removal of small bits. Also starting with a lower threshold and then subsequently eroding the image would have also improved. 
4) 100
Overall 100


% Continue with the set of images you used for inclass 11, the same time 
% point (t = 30)

% 1. Use the channel that marks the cell nuclei. Produce an appropriately
% smoothed image with the background subtracted. 

file='011917-wntDose-esi017-RI_f0016.tif';
reader=bfGetReader(file);
x=reader.getSizeX;
y=reader.getSizeY;
zplane=reader.getSizeZ;
chan=reader.getSizeC;
time=reader.getSizeT;

plane1=reader.getIndex(zplane-1,chan-1,29)+1;
img1=bfGetPlane(reader,plane1); %esta es la membrana !!!!! 
imshow(img1,[]) %tiene que haber los corchetes pq si no, daña la img.

img1_sm=imfilter(img1,fspecial('gaussian',4,2));
imshow(img1_sm,[]); %just for checking the smoothing

img1_bg=imopen(img1_sm,strel('disk',150)); 
imshow(img1_bg,[])% just for checking step by step
img1_sm_bgsub=imsubtract(img1_sm,img1_bg);
imshow(img1_sm_bgsub,[0 700]);

% 2. threshold this image to get a mask that marks the cell nuclei. 

nimg=img1_sm_bgsub>100;
imshow(nimg, []); %for checking things % there are around 11 cells

img_label=bwlabel(nimg);
imshow(img_label);
colormap('jet');
caxis([0 149]); %not working :/
pcolor(img_label); shading flat
colormap('jet');

cellproperties=regionprops(nimg,'Area','Centroid','Image','PixelIdxList');
hist([cellproperties.Area]);
xlabel('Area'); ylabel('Frequency');
ids=find([cellproperties.Area]>2000); %Selects the double-cell
imshow(cellproperties(ids(2)).Image);

img1cell=false(1024);
img1cell(cellproperties(ids(1)).PixelIdxList)=true;
imshow(img1cell); % it is only grabbing the double cells, I don't know why I can't "discriminate"/select all the round cells. 

% 3. Use any morphological operations you like to improve this mask (i.e.
% no holes in nuclei, no tiny fragments etc.)

imshow(nimg, []); %for checking things % there are around 11 cells
dilatedimage=(imdilate(nimg,strel('disk',3))); %can't this be saved? and not into just imshow??
%this would make my area more defined for a cell. 

% 4. Use the mask together with the images to find the mean intensity for
% each cell nucleus in each of the two channels. Make a plot where each data point 
% represents one nucleus and these two values are plotted against each other

cellprop2=regionprops(nimg, img1_sm_bgsub, 'MeanIntensity','MaxIntensity','PixelValues','Area','Centroid');
intensities=[cellprop2.MeanIntensity];
areas=[cellprop2.Area];

plot(areas, intensities, 'r.', 'MarkerSize',18);
xlabel('Areas','FontSize',28);
ylabel('Intensities','FontSize',28);

plane2=reader.getIndex(zplane-1,chan-2,29)+1;
img2=bfGetPlane(reader,plane2); %esta es la membrana !!!!! 
imshow(img2,[]) %tiene que haber los corchetes pq si no, daña la img.


%this is for graphin the cell nucleus against the cell membrane
cellprop3=regionprops(img2, img1_sm_bgsub, 'MeanIntensity','MaxIntensity','PixelValues','Area','Centroid');
intensities3=[cellprop3.MeanIntensity];
areas3=[cellprop3.Area];

plot(areas, intensities, 'r.', 'MarkerSize',18);
xlabel('Areas','FontSize',28);
ylabel('Intensities','FontSize',28);



