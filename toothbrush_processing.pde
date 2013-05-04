


import processing.serial.*;
import java.util.*;

/*------------------------------------------------*/
// size setting
int gameW = 800, gameH = 500;
int graphW = gameW, graphH = 300;
int axisH = 100;
int width = gameW, height = gameH + graphH;

// music setting

/*------------------------------------------------*/

boolean gameStart = false;

Serial myPort;  // Create object from Serial class
String inputStr = "";
String direction = "";

int graphX = 1;

final int left = 0, right = 1,
          back = 2, front = 3,
          down = 4, up = 5;
final int num_of_dir = 6;

int last_detected = 0;
int threshold[] = {290, 380, 340, 440, 340, 410 };
                  //x-, x+, y-, y+, z-, z+
                  //left, right, back, front, down, up
String[] orientationName = {"backL", "backR", "upL", "upR", 
                          "downL", "downR", "frontDL", "frontDR", "frontUL", "frontUR"};
int curOrient = 0;

float[][] baseVal = { {315, 405, 330}, {330, 272, 322}, {310, 330, 266}, {290, 338, 275},
                     {330, 350, 398}, {330, 325, 400}, {342, 288, 373}, {320, 395, 366}, {320, 275, 318}, {304, 399, 314} };

int gCounter = -1;
float diff[] = {0, 0, 0};

int sensor_upper_bound = 500;
int sensor_lower_bound = 200;
int time_delay = 400;


void setup() {
  size(width,height);

//  gameSetting = new GameSetting(gameW, gameH, 10);
  //dance = new Dance(gameW,gameH,20, minim, true);
  
  myPort = new Serial(this, "/dev/tty.usbmodem1411", 9600);
  //size(w,h);
  background(0);

  
  
  
}

void draw() {
  
//  stroke(0);
//  fill(0);
//  rect(0, 0, width, height);
  
  
  
}





void serialEvent(Serial myPort) {
  
  if (myPort.available() > 0) {
    inputStr = myPort.readStringUntil('\n');
    
    if(inputStr != null) {
//      //println(inputStr);
      inputStr = trim(inputStr);
//      
//      //determine whether it's NFC or accelerometer
//      if(inputStr.indexOf("@@@") == 0 ) {
//        println(inputStr);
//        //handleNFC(inputStr.substring(3));
      if(inputStr.indexOf("###") == 0) {
        //only print if game start
//        if(gameStart) {
          handleAccelerometer(inputStr.substring(3));
        }
//      } else {
//        println(inputStr);
//      }
//     
//
//    }


//      if(inputStr != null) {
//        println(inputStr);


//          String[] xyzStr = split(inputStr, '\t');
//  float x = float(xyzStr[0]);
//  float y = float(xyzStr[1]);
//  float z = float(xyzStr[2]);

//  print(xyzStr[0]);
//  print(xyzStr[1]);
//  print(xyzStr[2]);
//      inputStr = trim(inputStr);

//        handleAccelerometer(inputStr);
      }
    
  }
}



void handleAccelerometer(String inputStr) {
  gCounter++;
  
//  println(inputStr);
  String[] xyzStr = split(inputStr, '\t');
//  float x = float(xyzStr[0]);
//  float y = float(xyzStr[1]);
//  float z = float(xyzStr[2]);

//  print(xyzStr[0]);
//  print(xyzStr[1]);
//  print(xyzStr[2]);
  
  if(gCounter%5 == 0){  //recalculate every 5 loop
    curOrient = determineOrient(float(xyzStr[0]), float(xyzStr[1]), float(xyzStr[2]));
    
    float max_diff = 0;
    int max_dir = 0;
    for(int i=0; i<3; i++) {
      print(i+": "+diff[i]+", ");
      if(diff[i] > max_diff) {
        max_diff = diff[i];
        max_dir = i;
        
      }
    }
    
    println();
    
    if(max_diff < 40) {
        max_dir = -1;
    } 
    println("max dir: "+max_dir);
    
    diff[0] = 0;
    diff[1] = 0;
    diff[2] = 0;
    
  }
  
  for(int i=0; i<3; i++) {
    float d = abs(float(xyzStr[i]) - baseVal[curOrient][i]);
//    println(i+": "+d);
    diff[i] += d;
    
  }
  
  //determine direction
//  int now = millis();
  //int values[] = {0,0,0,0,0,0};
//  ArrayList values = new ArrayList();
  
//  if(now - last_detected > time_delay) {
//    for(int i=0; i<num_of_dir; i++) {
//      if(i%2 == 0) {  //left or back or down
//        values.add( threshold[i] - int(xyzStr[i/2]) );
//        
//      } else {  //right or front or up
//        
//        values.add( int(xyzStr[i/2]) - threshold[i] );
//      }
////     print(values.get(i)); 
//    }
//    println();
    
//    int max_value = (Integer)Collections.max(values);

  
  
  
  
//    
//    if(max_value > 0) {
//      int max_dir = values.indexOf(Collections.max(values));
//      //print(Collections.max(values));
//      String sign = "";
//      switch(max_dir) {
//        case 0: sign = "<"; break;
//        case 1: sign = ">"; break;
//        case 2: sign = "v"; break;
//        case 3: sign = "^"; break;  
//        case 4: sign = "o"; break;
//        case 5: sign = "x"; break;
//      }
//      dance.getNewEvent(max_dir);


//      text(sign, graphX, gameH+20);
//      last_detected = millis();
//    
//  }
  
        
  drawSensor(float(xyzStr[0]), float(xyzStr[1]), float(xyzStr[2]));
  //draw_threshold();
  
}

void drawSensor(float x_axis, float y_axis, float z_axis) {
  x_axis = map(x_axis, sensor_lower_bound, sensor_upper_bound, 0, axisH);
  y_axis = map(y_axis, sensor_lower_bound, sensor_upper_bound, 0, axisH);
  z_axis = map(z_axis, sensor_lower_bound, sensor_upper_bound, 0, axisH);
  //x_axis = max(0, min(x_axis, 100));  
  //y_axis = max(0, min(y_axis, 100));  
  //x_axis = max(0, min(z_axis, 100));  
  // draw the line:
  stroke(255,0,0);
  line(graphX, gameH+axisH, graphX, gameH+axisH - x_axis);
 
  stroke(0,255,0);
  line(graphX, gameH+axisH*2, graphX, gameH+axisH*2 - y_axis);
 
  stroke(0,0,255);
  line(graphX, gameH+axisH*3, graphX, gameH+axisH*3 - z_axis);
  
  if( graphX >= width) {
    graphX = 0;
    background(0);
    draw_threshold();
    
  } else {
    graphX ++;
  }  
}


void draw_threshold(){
  
  //draw axis and threshold
  stroke(255);
  float thres_line[] = new float[6];
  for(int i=0; i<num_of_dir; i++) {
    thres_line[i] = map(threshold[i], sensor_lower_bound, sensor_upper_bound, 0, axisH);
    line(0, gameH+(i/2+1)*axisH-thres_line[i], gameW, gameH+(i/2+1)*axisH-thres_line[i]);
    //println("thres"+ str(gameH+(i/2+1)*axisH-thres_line[i]));
    //print("gameW");
    //println(gameW);
    //draw threshold line for 3 axis: from 200, 400, 600
    //e.g. line(0, 200-right_margin, width, 200-right_margin);
  }
}

/*
void keyPressed() {
  switch(keyCode) {
      case LEFT:
        dance.getNewEvent(0);
        break;
      case DOWN:
        dance.getNewEvent(4);
        break;
      case UP:
        dance.getNewEvent(5);
        break;
      case RIGHT:
        dance.getNewEvent(1);
        break;
      case TAB:
        dance.getNewEvent(3);
        break;
      case ENTER:
        findUser(12345); // the RFID card number
        break;
    }
}

*/

int determineOrient(float x, float y, float z) {
//  ArrayList dists = new ArrayList();
  int min = -1;
  float min_val = 99999;
//  println(x+", "+y+", "+z);
  for(int i=0; i<orientationName.length; i++) {
    float dist = dist(x, y, z, baseVal[i][0], baseVal[i][1], baseVal[i][2]);
//    println(i+": "+dist);
//    dists.add(dist);
    if(dist < min_val) {
      min = i;
      min_val = dist;
    }
  }
  
//  int min_dist = (Integer)Collections.min(dists);
  println(orientationName[min]);
  
  return min;
  
}

