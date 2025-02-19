import processing.serial.*;

Serial myPort;

String serialIn;
String[] qInString = {"0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", };
float[] qIn = {0, 0, 0, 0};
float x, y, z;
float[] newVector = {0, 0, 0};
float timestep = 10;
public class quat {
  public float theta=1;
  public float[] vector = {0, 0, 0};
}

public class vector {
  public float x=0, y=0, z=0;
}

quat vect1;
float[] w={2*PI/sqrt(3), 2*-PI/sqrt(3), 2*-PI/sqrt(3)};
//quat q3;
float[][] matrixA = {{1, 0, 0},
  {0, -1, 0},
  {0, 0, 1}};
float[][] I =       {{1, 0, 0},
  {0, 1, 0},
  {0, 0, 1}};

int i = 0;

float[] measuredGrav = {0, 0, 0};
float[] estimatedGrav = {0, 0, 0};

void setup() {
  size(2600, 1440, P3D);
  vect1 = new quat();
  vect1.theta=0.7071;
  vect1.vector[0]=0;
  vect1.vector[1]=0;
  vect1.vector[2]=0.7071;
  //q3 = new quat();

  stroke(100);
  strokeWeight(2);

  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 115200);
}

void draw() {
  
  if (myPort.available() != 0) {
    print("H|I");
    serialIn = myPort.readStringUntil('\n');         // read it and store it in val
    print(serialIn);
    if (serialIn!=null && !serialIn.isEmpty()) {
      clearScreen();
      print(serialIn);
      String[] packets = serialIn.split(";");
      for (int i = 0; i < packets.length - 1; i++) {
        String[] subPacket = packets[i].split(",");
        //println(subPacket.);
        if (subPacket.length == 5) {
          quat tempQuat;
          tempQuat= new quat();
          String tempTag = subPacket[4];
          tempQuat.theta = parseFloat(subPacket[0]);
          tempQuat.vector[0] = parseFloat(subPacket[1]);
          tempQuat.vector[1] = parseFloat(subPacket[2]);
          tempQuat.vector[2] = parseFloat(subPacket[3]);
          drawQuat(tempQuat, (i+1)*100, tempTag);
        }
        else if (subPacket.length == 4) {
          float[] tempVect = {parseFloat(subPacket[0]),parseFloat(subPacket[1]),parseFloat(subPacket[2])};
          drawVect(tempVect, 10, subPacket[3]);
        }
      }
    }
  }  // Until data is available,

  /*
   if (qInString.length > 7) {
   vect1.theta = parseFloat(qInString[0]);
   vect1.vector[0] = parseFloat(qInString[1]);
   vect1.vector[1] = parseFloat(qInString[2]);
   vect1.vector[2] = parseFloat(qInString[3]);
   drawQuat(vect1, 100);
   vect1.theta = parseFloat(qInString[4]);
   vect1.vector[0] = parseFloat(qInString[5]);
   vect1.vector[1] = parseFloat(qInString[6]);
   vect1.vector[2] = parseFloat(qInString[7]);
   drawQuat(vect1,200);
   }
   */
}

void drawQuat(quat qIn, int lengthus, String tag) {
  matrixA[0] = rotateVector(I[0], qIn);
  matrixA[1] = rotateVector(I[1], qIn);
  matrixA[2] = rotateVector(I[2], qIn);

  strokeWeight(5);
  fill(255, 0, 0);
  drawVect(matrixA[0], lengthus, tag);
  fill(0, 255, 0);
  drawVect(matrixA[1], lengthus,tag);
  fill(0, 0, 255);
  drawVect(matrixA[2], lengthus,tag);
  
  


  strokeWeight(1);
  fill(255, 255, 255);
}

void drawVect(float[] vectorIn, int lengthus, String tag) {
  pushMatrix();
  translate(width/2, height/2, 0);
  
  rotateY(PI/2);
  rotateX(PI/2);
  
  stroke(100);
  line(0, 0, 0, lengthus*vectorIn[0], lengthus*vectorIn[1], lengthus*vectorIn[2]);
  translate(lengthus*vectorIn[0], lengthus*vectorIn[1], lengthus*vectorIn[2]);
  //noStroke();
  
  strokeWeight(0.15);
  stroke(0);
  sphereDetail(8);
  
  sphere(15);
  stroke(100);
  strokeWeight(5);
  
  rotateX(-PI/2);
  rotateY(-PI/2);
  
  textSize(20);
  text(tag, 20,0,0);
  popMatrix();
}

void printQuat(quat Qin) {
  print(Qin.theta);
  print(" \t");
  print(Qin.vector[0]);
  print(" \t");
  print(Qin.vector[1]);
  print(" \t");
  print(Qin.vector[2]);
  println(" \t");
}



quat qHP(quat q1, quat q2) {
  quat qOut = new quat();
  qOut.theta    = q1.theta*q2.theta     - q1.vector[0]*q2.vector[0] - q1.vector[1]*q2.vector[1] - q1.vector[2]*q2.vector[2];

  qOut.vector[0]= q1.theta*q2.vector[0] + q1.vector[0]*q2.theta     + q1.vector[1]*q2.vector[2] - q1.vector[2]*q2.vector[1];

  qOut.vector[1]= q1.theta*q2.vector[1] - q1.vector[0]*q2.vector[2] + q1.vector[1]*q2.theta     + q1.vector[2]*q2.vector[0];

  qOut.vector[2]= q1.theta*q2.vector[2] + q1.vector[0]*q2.vector[1] - q1.vector[1]*q2.vector[0] + q1.vector[2]*q2.theta;
  return qNormalize(qOut);
  //return qOut;
}

quat qHPNN(quat q1, quat q2) {
  quat qOut = new quat();
  qOut.theta    = q1.theta*q2.theta     - q1.vector[0]*q2.vector[0] - q1.vector[1]*q2.vector[1] - q1.vector[2]*q2.vector[2];

  qOut.vector[0]= q1.theta*q2.vector[0] + q1.vector[0]*q2.theta     + q1.vector[1]*q2.vector[2] - q1.vector[2]*q2.vector[1];

  qOut.vector[1]= q1.theta*q2.vector[1] - q1.vector[0]*q2.vector[2] + q1.vector[1]*q2.theta     + q1.vector[2]*q2.vector[0];

  qOut.vector[2]= q1.theta*q2.vector[2] + q1.vector[0]*q2.vector[1] - q1.vector[1]*q2.vector[0] + q1.vector[2]*q2.theta;

  return qOut;
}

quat vToQ(float[] vIn) {
  quat qOut = new quat();
  qOut.theta     = cos(sqrt(vIn[0]*vIn[0]+vIn[1]*vIn[1]+vIn[2]*vIn[2])/2);
  qOut.vector[0] = vIn[0]*sin(sqrt(vIn[0]*vIn[0]+vIn[1]*vIn[1]+vIn[2]*vIn[2])/2)/sqrt(vIn[0]*vIn[0]+vIn[1]*vIn[1]+vIn[2]*vIn[2]);
  qOut.vector[1] = vIn[1]*sin(sqrt(vIn[0]*vIn[0]+vIn[1]*vIn[1]+vIn[2]*vIn[2])/2)/sqrt(vIn[0]*vIn[0]+vIn[1]*vIn[1]+vIn[2]*vIn[2]);
  qOut.vector[2] = vIn[2]*sin(sqrt(vIn[0]*vIn[0]+vIn[1]*vIn[1]+vIn[2]*vIn[2])/2)/sqrt(vIn[0]*vIn[0]+vIn[1]*vIn[1]+vIn[2]*vIn[2]);
  return qOut;
}

quat qNormalize(quat qIn) {
  quat qOut = new quat();
  float magnitude = qMagnitude(qIn);
  qOut.theta     = qIn.theta/magnitude;
  qOut.vector[0] = qIn.vector[0]/magnitude;
  qOut.vector[1] = qIn.vector[1]/magnitude;
  qOut.vector[2] = qIn.vector[2]/magnitude;
  return qOut;
}

float qMagnitude(quat qIn) {
  return sqrt(qIn.theta*qIn.theta+qIn.vector[0]*qIn.vector[0]+qIn.vector[1]*qIn.vector[1]+qIn.vector[2]*qIn.vector[2]);
}

quat conj(quat qIn) {
  quat qOut = new quat();
  qOut.theta=qIn.theta;
  qOut.vector[0]=-qIn.vector[0];
  qOut.vector[1]=-qIn.vector[1];
  qOut.vector[2]=-qIn.vector[2];
  return qOut;
}

quat qAdd(quat qIn1, quat qIn2) {
  quat qOut = new quat();
  qOut.theta=qIn1.theta+qIn2.theta;
  qOut.vector[0]=qIn1.vector[0]+qIn2.vector[0];
  qOut.vector[1]=qIn1.vector[1]+qIn2.vector[1];
  qOut.vector[2]=qIn1.vector[2]+qIn2.vector[2];
  return qOut;
}

quat qScale(quat qIn, float scale) {
  quat qOut = new quat();
  qOut.theta=qIn.theta*scale;
  qOut.vector[0]=qIn.vector[0]*scale;
  qOut.vector[1]=qIn.vector[1]*scale;
  qOut.vector[2]=qIn.vector[2]*scale;
  return qOut;
}

quat vectorToQ(float[] vectorIn) {
  quat qOut = new quat();
  qOut.vector = vectorIn;
  qOut.theta = 0;
  //printQuat(qOut);
  return qOut;
}

quat applyW(quat qIn, float[] angularVelocity, float timestep) {
  timestep /= 1000;
  quat qOut = new quat();
  quat qW = new quat();
  qW = vectorToQ(angularVelocity);
  qOut = qAdd(qIn, qScale(qHPNN(qW, qIn), (timestep/2)));
  return qNormalize(qOut);
  //return qOut;
}

float[] rotateVector(float[] vectorIn, quat qIn) {
  float[] vOut;
  quat qV = new quat();
  qV = vectorToQ(vectorIn);
  //printQuat(qV);
  qV = qHP(qIn, qHP(qV, conj(qIn)));
  vOut = qV.vector;
  return vOut;
}

void clearScreen() {
  fill(0);
  pushMatrix();
  translate(0, 0, -1000);
  rect(-1000, -1000, 10000, 10000);
  popMatrix();
  fill(100);
  pushMatrix();
  translate(height/2, width/2, 0);
  sphere(3);
  popMatrix();
}
