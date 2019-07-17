//// Need to annotate!!!


viboud3 = getImageID();
selectImage(viboud3);
	//Stack.setPosition(1,n,1);
	// added channel 2 for transcription quant - H2A:RFP
	run("Duplicate...", " duplicate channels=1 title=NE");
	getStatistics(area, mean, min, max, std, histogram);
	// 0.15
	favThresh = min + 0.05*(max-min);
	setThreshold(favThresh, max);
	run("Convert to Mask");
	run("Erode");
	run("Dilate");
	OuterNucMask = getImageID();
	selectImage(viboud3);
	// added channel 2 for transcription quant - H2A:RFP
	run("Duplicate...", " duplicate channels=1 title=chromatin");
	getStatistics(area, mean, min, max, std, histogram)
	//0.2
	favThresh = min + 0.20*(max-min);
	setThreshold(favThresh, max);
	run("Convert to Mask");
	run("Erode");
	run("Dilate");
	InnerNucMask = getImageID();
	imageCalculator("Subtract create stack", OuterNucMask,InnerNucMask);
	//run("Analyze Particles...", "size=5-20 add stack");
	run("32-bit");
	Cytoplasm = getImageID();
	getStatistics(area, mean, min, max, std, histogram);
	favThresh = min + 0.42*(max-min);
	setThreshold(favThresh, max);
	run("NaN Background");
	run("Divide...", "value=255");
	//run("NaN Background");
	cytoplasmMask = getImageID();
	selectImage(viboud3);
	run("Duplicate...", " duplicate channels=1");
	Raw = getImageID();
	imageCalculator("Multiply create 32-bit stack", Raw,cytoplasmMask);
	Background = getImageID();
	
	selectImage(OuterNucMask);
	close();
	selectImage(InnerNucMask);
	close();
	//selectImage(Raw);
	//close();
	selectImage(Cytoplasm);
	close();
	selectImage(Background);
	getStatistics(area, mean, min, max, std, histogram);
	selectImage(Raw);
	run("Subtract...", "value=mean");
	//print(mean);
	selectImage(Background);
	close();
	selectImage(viboud3);
	close();




	