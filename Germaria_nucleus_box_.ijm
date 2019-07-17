//// With an active image, this plugin places a box around a 

viboud = getImageID();
t = getTitle();


//setBatchMode(true);

Stack.setPosition(3, 20, 1);
makeRectangle(225, 145, 35, 35);
for (i=0; i < 16; i++) {
	//j = i+1;

// setting directories for cell types in germaria
dir3 = getDirectory("Choose Destination Directory for germaria cell type");
//dir4 = getDirectory("Choose Destination Directory for region 2B cells");
//dir5 = getDirectory("Choose Destination Directory for region 2 cells");

selectImage(viboud);
title = "Put rectangle around nucleus and click OK";
  	waitForUser(title);
//setBatchMode(true);  	
// a=channel, b=slice, c=frame
// with 3 slices on either side, we're assuming an approximate size of 6um in diameter per nucleus
Roi.getBounds(x,y,width,height);
Stack.getPosition(a, b, c);
b1 = b - 3;
b2 = b + 3;
run("Duplicate...", "duplicate slices=b1-b2");
run("Duplicate...", "duplicate");
viboud4 = getImageID();
tpath = File.getName(dir3);
t5 = tpath + t + i + '_RAW';
saveAs("Tiff", dir3 + t5 + ".tif");


selectImage(viboud4);
close();
selectImage(viboud);
makeRectangle(x, y, 35, 35);
Stack.setPosition(3, b, 1);
}