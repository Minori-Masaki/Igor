#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.
//Author: Minori Masaki
//Select an appropriate ROIs and find the mean

Function MakeROIperCell(ROIwv)
	wave ROIwv;
	wave ObjectROI;

	duplicate/O ROIwv, ObjectROI

	duplicate/O ObjectROI, ROIperCell
	duplicate/O ObjectROI, M_ROIMask
	M_ROIMask=0;

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

Function CellMean(Fitimage)
	wave Fitimage;
	wave ROIperCell;
	variable i,j,k;
	make/o/n=(dimsize(ROIperCell,2),3) temp00_mean
	temp00_mean=0

	k=0
	do
		i=0
		do
			j=0
			do
				if(ROIperCell[i][j][k]==0)
				temp00_mean[k][0]+=Fitimage[i][j]
				temp00_mean[k][1]+=1
				endif
				j+=1
			while(j<dimsize(ROIperCell,1))
			i+=1
		while(i<dimsize(ROIperCell,0))
		temp00_mean[k][2]=temp00_mean[k][0]/temp00_mean[k][1]
		k+=1
	while(k<dimsize(ROIperCell,2))
end


Function CheckROIPerCell()
	wave ROIperCell;
	variable Imagenum;
	NewImage/K=0 root:ROIperCell
	ModifyGraph width=0,height={Aspect,dimsize(ROIperCell,1)/dimsize(ROIperCell,0)};
	ModifyGraph margin(left)=80;
	AutoPositionWindow/E
	Imagenum=0
	Button button0 title="UP",pos={10,10},proc=ButtonProc_UPlayer;
	Button button1 title="DOWN",pos={10,30},proc=ButtonProc_DOWNlayer;
	Valdisplay var0 value=_NUM:Imagenum, pos={25,60}, size={20,10}
End

Function ButtonProc_UPlayer(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	switch(ba.eventCode)
		case 2: // mouse up
			wave ROIperCell;
			variable/G Imagenum;
			ImageNum+=1;
			ModifyImage ROIperCell, plane=Imagenum;
			Valdisplay var0 value=_NUM:Imagenum;
			break

		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_DOWNlayer(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	switch(ba.eventCode)
		case 2: // mouse up
			wave ROIperCell;
			variable/G Imagenum;
			ImageNum-=1;
			ModifyImage ROIperCell, plane=Imagenum;
			Valdisplay var0 value=_NUM:Imagenum;
			break

		case -1: // control being killed
			break
	endswitch
	return 0
End
