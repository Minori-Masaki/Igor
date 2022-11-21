#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.
function MatrixPart(wv,xNum1,xNum2,yNum1,yNum2)
	wave wv;
	variable xNum1,xNum2,yNum1,yNum2;
	make/o/n = (dimsize(wv,0),(xNum2-xNum1+1),(yNum2-yNum1+1),1) PartOfMatrix
	PartOfMatrix[][][][0]=wv[p][q+xNum1][r+yNum1][0]
end