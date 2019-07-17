dir = getDirectory("Choose Destination Directory for Input");
dir2 = getDirectory("Choose Destination Directory for Output");
dir3 = getDirectory("Choose Destination Directory for Output");
dir4 = getDirectory("Choose Destination Directory for Output");
run("Clear Results");
run("Set Measurements...", "area mean standard min perimeter integrated median display redirect=None decimal=4");

images = getFileList(dir);
list = getFileList(dir);

for (i=0; i < list.length; i++) {
 inputpath = dir + images[i];
 run("TIFF Virtual Stack...", "open=inputpath");

setBatchMode(true);
roiManager("Reset");

viboud = getImageID();

tx = getTitle();
run("Duplicate...", "duplicate");
viboud2 = getImageID();
getDimensions(a, b, c, d, e);
	for (o = 0; o < d; o++) {
		p = o + 1;
		selectImage(viboud2);
		Stack.setPosition(1,1,p);
		run("Duplicate...", "duplicate slices=p");
		slicex = getImageID();
		runMacro("TMoney_MaskC1_SubC2_.ijm");
		backslice = getImageID();
	}
run("Images to Stack", "method=[Copy (center)] name=Stack title=[] use");
rename("C2_" + tx);
C2backsub = getImageID();
titlec2 = getTitle();

selectImage(viboud2);
getDimensions(a, b, c, d, e);
	for (o = 0; o < d; o++) {
		p = o + 1;
		selectImage(viboud2);
		Stack.setPosition(1,1,p);
		run("Duplicate...", "duplicate slices=p");
		slicex = getImageID();
		runMacro("TMoney_MaskC1_SubC3_.ijm");
		backslice = getImageID();
	}	
run("Images to Stack", "method=[Copy (center)] name=Stack title=[] use");
rename("C3_" + tx);
C3backsub = getImageID();
titlec3 = getTitle();

selectImage(viboud2);
getDimensions(a, b, c, d, e);
	for (o = 0; o < d; o++) {
		p = o + 1;
		selectImage(viboud2);
		Stack.setPosition(1,1,p);
		run("Duplicate...", "duplicate slices=p");
		slicex = getImageID();
		runMacro("TMoney_MaskC1_SubC1_.ijm");
		backslice = getImageID();
		//selectImage(slicex);
		//close();
	}	
run("Images to Stack", "method=[Copy (center)] name=Stack title=[] use");
rename("C1_" + tx);
C1backsub = getImageID();
titlec1 = getTitle();

selectImage(viboud2);
close();
//run("Merge Channels...", "c1=c1 c2=c2 c3=c3 create");

selectImage(viboud);
close();
setBatchMode("exit and display");

run("Merge Channels...", "c1=["+titlec1+"] c2=["+titlec2+"] c3=["+titlec3+"] create ignore");
newviboud = getImageID();
////save to backsub folder

selectImage(newviboud);
rename(tx + "backsub");
Stack.setDisplayMode("grayscale");

setBatchMode(true);

// DAPI
Stack.setPosition(1,3,1);
setMinAndMax(0, 650);
run("Blue");
//FITC
Stack.setPosition(2,3,1);
setMinAndMax(0, 700);
run("Green");
//TRITC
Stack.setPosition(3,3,1);
setMinAndMax(0, 700);
run("Red");

//now that background was subtracted, need to project, segment, quantify and save
selectImage(newviboud);
////save to backsub folder
t2 = "BackSub_" + tx;
rename(t2);
saveAs("tiff", dir2 + t2 + ".tif"); 
selectImage(newviboud);
run("Z Project...", "projection=[Sum Slices]");
SUMviboud = getImageID();
tSUM = "SUM_" + tx;
rename(tSUM);
selectImage(newviboud);
run("Z Project...", "projection=[Max Intensity]");
MAXviboud = getImageID();
tMAX = "MAX_" + tx;
rename(tMAX);

////////////////

// nuclear segmentation

MAXviboud = getImageID();
t = getTitle();
getPixelSize(unit, pixelWidth, pixelHeight);
pixsize = 1/pixelWidth; 

// fluorescence intensity detector high

selectImage(MAXviboud);
run("Duplicate...", "duplicate channels=3");
run("Grays");
getStatistics(area, mean, min, max, std, histogram);
favThresh = min + 0.39*(max-min);
setThreshold(favThresh, max);
run("Convert to Mask");
//run("Despeckle");
//run("Minimum...", "radius=1");
//run("Maximum...", "radius=1");
run("Watershed");
//run("Erode");
rename("IntHigh");
mask2 = getImageID();

// edge mask

selectImage(MAXviboud);
run("Duplicate...", "duplicate channels=3");
run("Grays");
run("Gaussian Blur...", "sigma=1");
run("Deriche...", "alpha=1");
getStatistics(area, mean, min, max, std, histogram);
favThresh = min + 0.43*(max-min);
setThreshold(favThresh, max);
run("Convert to Mask");
//run("Minimum...", "radius=1");
//run("Maximum...", "radius=1");
//run("Watershed");
//run("Despeckle");
rename("Edge");
mask3 = getImageID();

// fluorescence intensity detector low

selectImage(MAXviboud);
run("Duplicate...", "duplicate channels=3");
run("Grays");
getStatistics(area, mean, min, max, std, histogram);
favThresh = min + 0.30*(max-min);
favThresh2 = min + 0.15*(max-min);
setThreshold(favThresh2, favThresh);
run("Convert to Mask");
run("Despeckle");
//run("Minimum...", "radius=1");
//run("Maximum...", "radius=2");
run("Watershed");
rename("IntLow");
mask4 = getImageID();

// combine masks

imageCalculator("Add create", mask4,mask2);
int2 = getImageID();
//run("Erode");

run("Maximum...", "radius=1");
run("Minimum...", "radius=1");
run("Watershed");
imageCalculator("Add create", int2,mask3);
//run("Minimum...", "radius=1");
run("Maximum...", "radius=1");
rename("Int");
run("Watershed");
int1 = getImageID();

selectImage(int2);
close();
selectImage(mask2);
close();
selectImage(mask3);
close();
selectImage(mask4);
close();

//////////////

selectImage(int1);
run("Analyze Particles...", "size=4-14 include add");


//// nuclear measurements


//// add lines here to skip measurements if ROI manager is empty

nROIs = roiManager("count");
if (nROIs > 0) { 
	selectImage(MAXviboud);
run("From ROI Manager");
//FITC
Stack.setPosition(2,1,1);
rename("Nuc_CID_" + tMAX);
roiManager("Measure");

//TRITC
Stack.setPosition(3,1,1);
rename("Nuc_Red_" + tMAX);
roiManager("Measure");

selectImage(SUMviboud);
run("From ROI Manager");
//FITC
Stack.setPosition(2,1,1);
rename("Nuc_CID_" + tSUM);
roiManager("Measure");

//TRITC
Stack.setPosition(3,1,1);
rename("Nuc_Red_" + tSUM);
roiManager("Measure");


selectImage(MAXviboud);
roiManager("Select", 0);
run("Clear Outside", "stack");

selectImage(SUMviboud);
roiManager("Select", 0);
run("Clear Outside", "stack");


selectImage(MAXviboud);
t3 = "NucSeg_" + tMAX;
rename(t3);
saveAs("tiff", dir3 + t3 + ".tif"); 
run("Remove Overlay");
roiManager("Reset");

selectImage(SUMviboud);
t4 = "NucSeg_" + tSUM;
rename(t4);
saveAs("tiff", dir3 + t4 + ".tif"); 
run("Remove Overlay");
roiManager("Reset");

selectImage(MAXviboud);
run("Select None");
run("Duplicate...", "duplicate channels=2");

C2forSeg = getImageID();
run("Add Specified Noise...", "standard=15");
run("Gaussian Blur...", "sigma=2");
run("Probabilistic Segmentation", "false=0.7 noise=1.6 x=3 y=3 x=3 y=3 background padding=Antisymmetric stack");
SEGviboud = getImageID();
selectImage(SEGviboud);
run("Invert LUT");
run("Despeckle");
//run("Watershed");
run("Maximum...", "radius=1");
run("Watershed");
run("Set Scale...", "distance=["+pixsize+"] known=1 unit=unit");
run("Analyze Particles...", "size=0.2-5 exclude add stack");

selectImage(C2forSeg);
close();


//// centromere measurements

//// again skipping following lines if no ROIs
nROIs = roiManager("count");
if (nROIs > 0) { 
	selectImage(MAXviboud);
selectImage(MAXviboud);
run("From ROI Manager");
//FITC
Stack.setPosition(2,1,1);
rename("CID_CID_" + "MAX_" + tx);
roiManager("Measure");

//TRITC
Stack.setPosition(3,1,1);
rename("CID_Red_" + "MAX_" + tx);
roiManager("Measure");

selectImage(SUMviboud);
run("From ROI Manager");
//FITC
Stack.setPosition(2,1,1);
rename("CID_CID_" + "SUM_" + tx);
roiManager("Measure");

//TRITC
Stack.setPosition(3,1,1);
rename("CID_Red_" + "SUM_" + tx);
roiManager("Measure");
                     
} 
}


while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      } 

}

t4 = "Measure_" + tx;
if (nResults==0) exit("Results table is empty");
   saveAs("Measurements", dir4 + t4 + ".xls");


////save to backsub folder
//saveAs("tiff", dir2 + t); 
//setBatchMode("exit & display");

