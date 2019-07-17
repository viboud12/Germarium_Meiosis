//// Process individual germaria images to obtain scaled and oriented images.

//dir2 = getDirectory("Choose a Directory");
dir = getDirectory("Choose a Directory"); 
//ids=newArray(nImages); 
//for (i=0;i<nImages;i++) { 
  //      selectImage(i+1);
    //    viboud = getImageID(); 
      //  t = getTitle; 
        
        //print(title); 
        //ids[i]=getImageID;
        
viboud = getImageID(); 
t = getTitle;         

// DAPI
Stack.setPosition(1,40,1);
setMinAndMax(314, 1212);
//FITC
Stack.setPosition(2,40,1);
setMinAndMax(298, 749);
//TRITC
Stack.setPosition(3,40,1);
setMinAndMax(289, 1910);

//saveAs("tiff", dir2 + t); 

Stack.setPosition(1,40,1);
//change text
title = "Rotate embryo with anterior on left and click OK";
  	waitForUser(title);

Stack.setPosition(2,40,1);
//change text
title = "Duplicate with correct slices and click OK";
  	waitForUser(title);
viboud4 = getImageID();  	

Stack.setPosition(1,20,1);
makeRectangle(0, 171, 512, 300);
//change text
title = "Put rectangle around embryo and click OK";
  	waitForUser(title);

  	run("Duplicate...", "duplicate");
viboud5 = getImageID();

//rename(title);
t2 = t + 'crop'; 
        saveAs("tiff", dir + t2); 

        selectImage(viboud4);
        close();
        selectImage(viboud5);
        close();
        selectImage(viboud);
        close();
 