import processing.serial.*;
import java.util.*;

class ToothBrush {

	String[] orientationName = {"backL", "backR", "upL", "upR", 
	                          "downL", "downR", "frontDL", "frontDR", "frontUL", "frontUR"};
	int curOrient = 0;

	float[][] baseVal = { {315, 405, 330}, {330, 272, 322}, {310, 330, 266}, {290, 338, 275},
	                     {330, 350, 398}, {330, 325, 400}, {342, 288, 373}, {320, 395, 366}, {320, 275, 318}, {304, 399, 314} };

	int gCounter = -1;
	float diff[] = {0, 0, 0};

	ToothBrush()

	void serialEvent(Serial myPort) {
	  
	  if (myPort.available() > 0) {
	    inputStr = myPort.readStringUntil('\n');
	    
	    if(inputStr != null) {
	      inputStr = trim(inputStr);
	      if(inputStr.indexOf("###") == 0) {
	          handleAccelerometer(inputStr.substring(3));
	        }
	      }
	    
	  }
	}
}