Function MakeROIperCell(ROIwv)
	wave ROIwv;
	wave ObjectROI;

	duplicate/O ROIwv, ObjectROI

	duplicate/O ObjectROI, ROIperCell
	duplicate/O ObjectROI, M_ROIMask
	ROIperCell=0;

	//make riverseROI of ObjectROI
	duplicate/o  ObjectROI, RiverseObjectROI
	ImageThreshold/O/T=0 RiverseObjectROI
	matrixop/o RiverseObjectROI=-(RiverseObjectROI/255-1)
	matrixop/O RiverseObjectROI=uint8(RiverseObjectROI)

	//set button & draw line
	NewImage/K=0 root:ObjectROI
	ModifyGraph margin(left)=80;
	Button button0 title="Add",pos={10,10},proc=ButtonProc_addROI;
	Showtools
	SetDrawLayer ProgFront
	SetDrawEnv linefgc=(0,0,65535),fillpat=0,save
End

Function ButtonProc_addROI(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	switch(ba.eventCode)
		case 2: // mouse up
			wave ObjectROI,M_ROIMask,RiverseObjectROI;
			ImageGenerateROIMask ObjectROI
			M_ROIMask=M_ROIMask * RiverseObjectROI
			ObjectROI=ObjectROI+M_ROIMask
			drawaction delete
			ImageThreshold/O/T=0 M_ROIMask
			matrixop/o M_ROIMask=-(M_ROIMask/255-1)
			matrixop/O M_ROIMask=uint8(M_ROIMask)
			Concatenate/NP=3 {M_ROIMask},ROIperCell
			SetDrawLayer ProgFront
			SetDrawEnv linefgc=(0,0,65535),fillpat=0,save
			break

		case -1: // control being killed
			break

	endswitch	
	return 0
End	



Function ButtonProc_UPlayer(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	switch(ba.eventCode)
		case 2: // mouse up
			wave ROIperCell;