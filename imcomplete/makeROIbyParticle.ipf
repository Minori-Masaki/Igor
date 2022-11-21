function makeROIbyParticle(particlewv,oriwv)
wave particlewv,oriwv;
variable xNum,yNum;
variable i,j;

Silent 1; PauseUpdate
xnum=dimsize(particlewv,0)
ynum=dimsize(particlewv,1)
duplicate/O oriwv CircleROIImage
killwindow/z CircleROIImage0
NewImage/n=CircleROIImage0 CircleROIImage

for(j=0;j<ynum;j+=1)
 for(i=0;i<xnum;i+=1)
  if(particlewv[i][j]==18)
   setdrawenv/w=CircleROIImage0 linefgc=(32639,65535,54484) 
   drawline/w=CircleROIImage0 (i+1)/xnum,(j)/ynum,(i+1)/xnum,(j+1)/ynum
   endif
 endfor
endfor
end



//This function check ROI on Image.
function CircleObjectROI(OriginalImage,ObjectROI)
wave OriginalImage,ObjectROI;
variable xNum,yNum;
variable i,j;

duplicate/O ObjectROI, EdgeImage
ImageEdgeDetection/O/S=1/M=1 Canny EdgeImage
xNum=dimsize(EdgeImage,0)
yNum=dimsize(EdgeImage,1)

duplicate/O OriginalImage, CircleObjectImage
killwindow/z CircleObjectImage0
NewImage/n=CircleObjectImage0 CircleObjectImage

for(i=0;i<xNum;i+=1)
 for(j=0;j<yNum;j+=1)
  if(EdgeImage[i][j]==0)
   setdrawenv/w=CircleObjectImage0 linefgc=(32639,65535,54484) 
   drawline/w=CircleObjectImage0 (i+1)/xNum,(j)/yNum,(i+1)/xNum,(j+1)/yNum
   endif
 endfor
endfor
end