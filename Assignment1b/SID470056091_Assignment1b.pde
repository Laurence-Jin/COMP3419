ArrayList<Ball> balls = new ArrayList<Ball>(12);
float BALLNUMS = 6; //texture number
float HORIENELOST = 0.6;
float VERTENELOST = 0.8;
float COLLENELOST = 0.05;

class Ball {
  PShape globe;
  PImage img;
  int x, y, z;
  float speedX, speedY, speedZ;
  boolean Ymove;
  boolean XZmove;
  int diameter;
  
  Ball(int x, int y) {
    this.x = x;
    this.y = y;
    this.z = 0;
    diameter = 25;
    speedX =random(-5,5);
    speedY =random(-6,2);
    speedZ =random(0,10);  
    Ymove = true; //horizontal move
    XZmove = true; //vertical move
    int random_number = int(random(BALLNUMS));
    img = loadImage(random_number+".jpg");
    globe = createShape(SPHERE, diameter);
    globe.setStroke(false);
    globe.setTexture(img);
  } 
 
  void run() { 
    display();
    collide();
    if (Ymove) {
      gravity_Y();
    }
    if (XZmove) {
      gravity_XZ();
    }  
  }
  void collide() {
    for (Ball ball: balls) {
      int dx = ball.x - x;
      int dy = ball.y - y;
      float distance = sqrt(dx*dx + dy*dy);
      
      if (distance < diameter) {
        float angle = atan2(dy,dx);
        float targetX = x + cos(angle)*diameter;
        float targetY = y + sin(angle)*diameter;
        
        //the change of speed
        float speedCX = (targetX - ball.x) * COLLENELOST ;
        float speedCY = (targetY - ball.y) * COLLENELOST;
        
        speedX -= speedCX;
        speedY -= speedCY;
        ball.speedX += speedCX;
        ball.speedY += speedCY;   
      }
    }
  }
  void display() {
    pushMatrix();
    translate(x,y,z);
    shape(globe,0,0);
    popMatrix();
  }
  void gravity_Y() {
    float temp = speedY;
    speedY += 1; //accelerate gravity
    y += speedY;
    if (y >= width) {
      y = width;
      speedY = -speedY*VERTENELOST; //vertical enegry lose
    }
    if (y <= 0) {
      y = 0;
      speedY = -speedY*VERTENELOST;
    }
    if (abs(temp) < 8 && abs(speedY) < 8 && y > width-5) {
      Ymove = false;
    }
  }
  void gravity_XZ() {
    x += speedX;
    z += speedZ;
    if (!Ymove) {
      speedZ = -speedZ*HORIENELOST;
      speedX = -speedX*HORIENELOST;
    }
    if (z <= -width) {
      z = -width;
      speedZ = -speedZ*HORIENELOST; 
    }
    else if (z >= 0){
      z = 0;
      speedZ = -speedZ*HORIENELOST;
    }
    if (x >= width) {
      x = width;
      speedX = -speedX*HORIENELOST;
    }
    else if (x <= 0) {
      x = 0;
      speedX = -speedX*HORIENELOST;
    }
    if (!Ymove && abs(speedX) < 1.5 && abs(speedZ) < 1.5) {
      XZmove = false;
    }
  }  
}

void setup(){
  size(640, 640, P3D);
}

void draw(){
  background(0);
  pushMatrix();
  translate(width/2, height/2, -height/2);
  stroke(255);
  noFill();
  box(width);
  popMatrix();
  if (mousePressed) {
    balls.add(new Ball(mouseX, mouseY));
  }
  for(Ball b: balls) b.run();
}
