float middleLineY;
int middleLineWidth = 15;
boolean moving1, moving2, moving3, moving4;
float screenSpeed = 10;
float carSpeed = 5;
float x = 0;
PImage car;
int carHeight = 100;
int carWidth = 200;
float wheelAngle;
float carAngle;
float x_car = -400;
float y_car;
float x_car_speed;
float y_car_speed;
float a = 0;
final float MAX_WHEEL_ANGLE = 0.5;
final float MAX_ERROR = 900;

float error, err;
float Kp = 10; 
float Ki = 0.1;
float Kd = 0.1;
final float MAX_KP = 50;
final float MAX_KI = 1;
final float MAX_KD = 1;
final float MIN_KP = 0;
final float MIN_KI = 0;
final float MIN_KD = 0;
float kpy, kiy, kdy;
float work;
float lastTime, errSum, lastErr, dErr;
float MAX_SLIDER = height-155;
float MIN_SLIDER = height-25;
boolean manual = true;
boolean reset = false;
int count1 = 0;
int count2 = 0;
float auto_speed = 0.01;
float randNum;

void setup() {
  size(1800, 900);
  middleLineY = height/2;
  y_car = height/2;
  MAX_SLIDER = height-155;
  MIN_SLIDER = height-25;
  //y_car=height;
  a = 0;
  background(51);
  drawDashedLine(x, middleLineY+10);
  drawDashedLine(x, middleLineY-10);
  car = loadImage("blue_car.png");
  imageMode(CENTER);
  kpy = map(Kp, MIN_KP, MAX_KP, MIN_SLIDER, MAX_SLIDER);
  kiy = map(Ki, MIN_KI, MAX_KI, MIN_SLIDER, MAX_SLIDER);
  kdy = map(Kd, MIN_KI, MAX_KI, MIN_SLIDER, MAX_SLIDER);
  randNum = random(100, height-500);
}

void draw() {
  if(manual){
    if(moving1 || (mouseY >= middleLineY - 40 && mouseY <= middleLineY + 40)) {
      if(mousePressed){
        moving1 = true;
        middleLineY = pmouseY;
        }
    }
  }
  else{
    middleLineY = map(a, -4, 4, 100, height-100);
    a += auto_speed*(sin(random(0, 2*PI)) + sin(random(0, 2*PI)) + sin(random(0, 2*PI)) + sin(random(0, 2*PI)));
  }
  if(moving2 || (mouseX>=width-310 && mouseX<=width-280 && mouseY >= kpy-5 && mouseY <= kpy+25)){
    if(mousePressed){
        moving2 = true;
        if(pmouseY <= MIN_SLIDER && pmouseY >= MAX_SLIDER) {
        kpy = pmouseY; }
    }
  }
  if(moving3 || (mouseX>=width-190 && mouseX<=width-160 && mouseY >= kiy-5 && mouseY <= kiy+25)){
    if(mousePressed){
        moving3 = true;
        if(pmouseY <= MIN_SLIDER && pmouseY >= MAX_SLIDER) {
        kiy = pmouseY; }
    } 
  }
  if(moving4 || (mouseX>=width-70 && mouseX<=width-40 && mouseY >= kdy-5 && mouseY <= kdy+25)){
    if(mousePressed) {
      moving4 = true;
      if(pmouseY <= MIN_SLIDER && pmouseY >= MAX_SLIDER) {
        kdy = pmouseY;
      }
    }
  }
  if(mousePressed && (mouseX>=20 && mouseX<=105 && mouseY >= height -100 && mouseY <= height - 10)) count1++;
  if(mousePressed && (mouseX>=135 && mouseX<=220 && mouseY >= height -100 && mouseY <= height - 10)) {
    count2++;
    reset = true;
  }
  background(51);
  drawDashedLine(x, middleLineY+75);
  drawDashedLine(x, middleLineY-75);
  carSpeed = ((width*3)/7-x_car)*0.01+10;
  drawCar(x_car, y_car, carAngle);
  PID_Sliders(kpy, kiy, kdy);
  drawErrorLine();
  error = middleLineY - y_car;
  cornerInfo((int) error, (int) carSpeed);
  bottomButtons(manual,reset);
  x -= screenSpeed;
  err = map(error, -MAX_ERROR, MAX_ERROR, -MAX_WHEEL_ANGLE, MAX_WHEEL_ANGLE);
  work = PIDwork(Kp, Ki, Kd, err);
  wheelAngle = work;
  carAngle = wheelAngle/2;
  x_car -= vX_car(carAngle, screenSpeed, carSpeed);
  y_car += vY_car(carAngle, screenSpeed, carSpeed);

}


void PID_Sliders(float Kpy, float Kiy, float Kdy) {
  fill(255);
  rect(width-410, height-190, width, height);
  fill(20,20,20);
  rect(width-400, height-180, width, height);
  textSize(25);
  fill(255);
  text("Kp:", width-380, height-145);
  text("Ki:", width-260, height-145);
  text("Kd:", width-140, height-145);
  textSize(18);
  text(Kp, width-380, height-100);
  text(Ki, width-260, height-100);
  text(Kd, width-140, height-100);
  fill(160);
  rect(width-310, height-160, 10, 140, 5);
  rect(width-190, height-160, 10, 140, 5);
  rect(width-70, height-160, 10, 140, 5);
  
  
  ellipseMode(CENTER);
  fill(0,0,255);
  ellipse(width-305, Kpy, 20, 20);
  Kp = map(Kpy, MIN_SLIDER, MAX_SLIDER, MIN_KP, MAX_KP);
  fill(0,255,0);
  ellipse(width-185, Kiy, 20, 20); 
  Ki = map(Kiy, MIN_SLIDER, MAX_SLIDER, MIN_KI, MAX_KI);
  fill(255,0,0);
  ellipse(width-65, Kdy, 20, 20);
  Kd = map(Kdy, MIN_SLIDER, MAX_SLIDER, MIN_KD, MAX_KD);
}

void bottomButtons(boolean manual, boolean reset){
  fill(255);
  int h = 150;
  rect(0,height-h, 250, h);
  fill(31);
  h -= 10;
  rect(0,height-h, 240, h);
  fill(255);
  text("Random", 15, height -110);
  text("Reset", 145, height - 110);
  h -= 40;
  if(manual) fill(60);
  else fill(190);
  rect(20, height-h, 85,85);
  if(reset) fill(60);
  else fill(190);
  rect(135, height-h, 85,85);
}

void cornerInfo(int error, int carSpeed){
  fill(255);
  rect(0,0,210,100);
  fill(30);
  rect(0,0,200,90);
  typeError(error);
  typeCarSpeed(carSpeed);
}

void typeError(float error){
  fill(255,0,0);
  textSize(25);
  String erStr = "Error: " + (int)error;
  text(erStr, 10, 30);
}

void typeCarSpeed(float speed){
  fill(255,0,0);
  textSize(25);
  String erStr = "Car Speed: " + (int)speed;
  text(erStr, 10, 60);
}

void drawErrorLine(){
  if(abs(middleLineY - y_car)>1){
  fill(255,0,0);
  if(middleLineY < y_car) rect(x_car-2, middleLineY, 4, abs(middleLineY - y_car));
  if(y_car < middleLineY) rect(x_car-2, y_car, 4, abs(middleLineY - y_car));
  }
}


float PIDwork(float Kp, float Ki, float Kd, float error){
   long now = millis();
   float timeChange = (float)(now - lastTime);
   errSum += (error * timeChange);
   dErr = (error - lastErr) / timeChange;
   lastErr = error;
   lastTime = now; 
   return Kp * error + Ki * errSum + Kd * dErr;
}


float vX_car(float a, float v1, float v2) {
  return v1 - cos(a)*v2;
}

float vY_car(float a, float v1, float v2) {
  return sin(a)*v1;
}

void drawCar(float x_pos, float y_pos, float rot) {
  pushMatrix();
  translate(x_pos, y_pos);
  rotate(rot);
  image(car, 0, 0, carWidth, carHeight);
  popMatrix();
}

void mouseReleased() {
   moving1 = false; 
   moving2 = false; 
   moving3 = false;
   moving4 = false;
   if(count1 > 0){
     manual = !manual;
     count1 = 0;
   }
   if(count2 > 0){
     count2 = 0;
     reset();
     reset = false;
   }
}

void reset()
{
  Kp = 10; 
  Ki = 0.1;
  Kd = 0.1;
  kpy = map(Kp, MIN_KP, MAX_KP, MIN_SLIDER, MAX_SLIDER);
  kiy = map(Ki, MIN_KI, MAX_KI, MIN_SLIDER, MAX_SLIDER);
  kdy = map(Kd, MIN_KI, MAX_KI, MIN_SLIDER, MAX_SLIDER);
  PID_Sliders(kpy, kiy, kdy);
  middleLineY = height/2;
  y_car = height/2;
  x_car = -400;
  manual = true;
}
void drawDashedLine(float x,float y) {
  for(float i = x; i < 10000; i += 90) {
     fill(255);
     rect(i, y - middleLineWidth/2, 40, middleLineWidth);
     
  }
}
