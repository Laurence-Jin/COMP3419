import processing.video.*;
import processing.sound.*;
 
Movie originalMovie;
Movie backgroundMovie;

PImage binaryImg;
PImage improvedImg;
PImage backgroundImg;

SoundFile MeiAttack;
SoundFile bird;

int framenumber = 0;
object Emma;
ArrayList<PImage> resource;
ArrayList<intelligentObjects> obj;
PImage explosion;
PImage MeiEx;



// refer to: https://processing.org/reference/libraries/video/movieEvent_.html
void movieEvent(Movie m) {
  if(m == originalMovie){
    m.read();
    //make the image optimal for reading points
    binaryImg = segmentMarkers(m);
    improvedImg = Enhancement(binaryImg);
    
    //binaryImg.save(sketchPath("") + "binary/image" + framenumber + ".png");
    //improvedImg.save(sketchPath("") + "seg/image" + framenumber + ".png");
    framenumber++;
  }else if(m == backgroundMovie){
    m.read();
    backgroundImg = m;
  }
  
}

PImage segmentMarkers(PImage video){
  
  PImage blank = new PImage(video.width, video.height);
  
  //apply 3 filter in order to take out the non reds.
  boolean Red = false;
  boolean Face = true;
  boolean Brown = true;
  
  //usual for loop to get pixel colour 
  for(int x = 0; x < video.width; x++){
    for(int y = 0; y < video.height; y++){
      int loc = x + y * video.width;
      color c = video.pixels[loc];
     
      //the pixel should be in range 150 < red < 255 , 130 < green < 200 and 45 < blue < 125 according to eyedrop
       Red = red(c) > 150
            && green(c) > 37
            && green(c) < 200
            && blue(c) > 30
            && blue(c) < 125;
      
      Face = red(c) > 190
              && red(c) < 255
              && green(c) > 132
              && green(c) < 200
              && blue(c) > 45
              && blue(c) < 125;
              
      Brown = red(c) > 150
              && red(c) < 200
              && green(c) > 83
              && green(c) < 165
              && blue(c) > 40
              && blue(c) < 115;
      
      // if the pixel correct has color mark it white on the new image
      if(Red && !Face && !Brown){ 
        blank.pixels[loc] = color(255,255,255);
      }
    }
  }
  // return the new image with the white markers on it
  return blank;
}

//don't think this is needed? it helps to get rid of noises
PImage Enhancement(PImage bin){
  PImage improvement = new PImage(bin.width, bin.height);
  
  // erode to get rid of noises
  improvement = Erode(bin);  
  for(int i = 0; i < 2; i++){
    improvement = Erode(improvement);
  } 
  
  // dilate image 8 times
  for(int i = 0; i < 7; i++){
    improvement = Dilation(improvement);
  } 
  return improvement;
}
//gather 4 points on monkey
ArrayList<PVector> PointGather(PImage dilated){
  color white = color(255,255,255);
  
  ArrayList<PVector> markers = new ArrayList<PVector>(5);
  
  int maxX = 0; 
  int maxY = 0;
  int minX = Integer.MAX_VALUE;
  int minY = Integer.MAX_VALUE;
  loadPixels();  
  for(int x = 0; x < dilated.width; x++){
    for(int y = 0; y < dilated.height; y++){
      int loc = x + y * dilated.width;
      color c = dilated.pixels[loc];
      if (c == white){
        if (x > maxX ){
            maxX = x;
        }else if ( x < minX ){
            minX = x;
        }       
        if(y > maxY ){
            maxY = y;
        }else if ( y < minY ){
            minY = y;
        }
      }   
    }
  }
  
  int midx = (maxX + minX)/2;
  int midy = (minY + maxY)/2;
  
  boolean tl = false;
  boolean tr = false;
  boolean bl = false;
  boolean br = false;
  int thred_BL = 18;
  int thred_BR = 15;
  //top left 
  TopLeftLoop:
  for(int i = minX; i < midx; i++){
    for(int j = minY; j < midy; j++){
      int loc = i + j * dilated.width;
      color c = dilated.pixels[loc];
      if(c == white){
        markers.add(new PVector(i,j));
        tl = true;
        break TopLeftLoop;
      }
    }
  }
  if (tl == false){
     markers.add(new PVector(minX, minY));
  }
  
  //top right 
  TopRightLoop:
  for(int i = maxX; i > midx; i--){
    for(int j = minY; j < midy; j++){
      int loc = i + j * dilated.width;
      color c = dilated.pixels[loc];
      if(c == white){
        //println("top right found");
        markers.add(new PVector(i,j));
        tr = true;
        break  TopRightLoop;
        
      }
    }
  }
  if(tr == false){
    markers.add(new PVector(maxX, minY));
  } 
  
  //bottom left 
  //sometimes it overlaps with top left 
  //set a threshold value, 18 seems to produce the best  
  BottomLeftLoop:
  for(int i = minX; i < midx-thred_BL; i++){
    for(int j = maxY; j > midy+thred_BL; j--){
      int loc = i + j * dilated.width;
      color c = dilated.pixels[loc];
      
      if(c == white){
        //println("bottom left found");
        markers.add(new PVector(i,j));
        bl = true;
        break BottomLeftLoop;
        
      }
    }
  }
  if(!bl){ 
    markers.add(new PVector(minX, maxY));
  }
  
  //bottom right 
  BottomRightLoop:
  for(int i = maxX; i > midx+thred_BR; i--){
    for(int j = maxY; j > midy+thred_BR; j--){
      int loc = i + j * dilated.width;
      color c = dilated.pixels[loc];
     
      if(c == white){
        //println("bottom right found");
        br = true;
        markers.add(new PVector(i,j));
        break BottomRightLoop;
      }
    }
  }
  if(!br){
    markers.add(new PVector(maxX, maxY)); 
  } 
  
  //then we get the center marker
  markers.add(new PVector((maxX+minX)/2,(minY+maxY)/2));
  return markers;
}

void replaceMonkey(PImage image){
  ArrayList<PVector> points = PointGather(image);
  //println(points);
  Emma.setPoints(points);
  Emma.show();
}

void addObjects(){
  int rand = (int)random(0, 4);
  int randy = (int)random(60, 690);
  boolean direction = Math.random() < 0.5;
  int buffer = (int)random(0,2);//rando
  
  int randCornerX = 0;
  int randCornerY = 0;
  
  //println(rand);
  if (rand == 1){
    randCornerX = 1280; 
  }else if (rand == 2){
    randCornerY = 720;
  }else if(rand == 3){
    randCornerX = 1280;
    randCornerY = 720;
  }
  
  PImage texture = null;
  intelligentObjects temp = null;
  if((framenumber % 15) == 0){
    if(buffer == 0){
      texture = resource.get(5);
      temp = new intelligentObjects(texture,randy,direction);
      
    }
    if(buffer == 1){
      texture = resource.get(6);
      
      temp = new intelligentObjects(texture,randy,true);
      temp.setCorner(randCornerX, randCornerY);
    }
  }
  if(temp != null){
    obj.add(temp);
  }
  
  ArrayList<intelligentObjects> delete = new ArrayList<intelligentObjects>();
  
  //collision between owl senpai and coronet
  for(intelligentObjects i : obj){
    for(intelligentObjects k : obj){
      
      if(i.collide(k) == true && k != i){
        //check if either of them is owl
        //yes then evolve
        if(i.isowl() == true){
          i.evolve(explosion);
          delete.add(k);
        }
        if(k.isowl() == true){
          delete.add(i);
          k.evolve(explosion);
        }
        bird.play();
        break;
      }
    }  
  }
  
  obj.removeAll(delete);
  delete.clear();
  
  //any collision with Emma
  for(intelligentObjects i : obj){
    if(Emma.collide(i) == true && i.isowl() == false) {
      delete.add(i);
      image(MeiEx,i.getx(),i.gety());
      MeiAttack.play();
      break;
    }
    else if (Emma.collide(i) && i.isowl()) {    
      break;
    }  
  }
  
  obj.removeAll(delete);
  delete.clear();
  
  //delete stuff out of screen
  for(intelligentObjects i : obj) {
      if(i.outScreen() == true){
        delete.add(i);
      }
  }
  obj.removeAll(delete);
  delete.clear();
  
  //update the new co-ordinates for alive stuff
  for(intelligentObjects i : obj) {
      i.update();
  }
}
void settings() {
  size(1280, 720);
}
void setup(){
  originalMovie = new Movie(this, sketchPath("monkey.mov"));
  backgroundMovie = new Movie(this, "Chinatown.mov");
  //backgroundImg = loadImage("background.png");
  
  resource = new ArrayList<PImage>(7);
  resource.add(loadImage("resource/EmmaBody.png"));
  resource.add(loadImage("resource/EmmaLeftLeg.png"));
  resource.add(loadImage("resource/EmmaLeftArm.png"));
  resource.add(loadImage("resource/EmmaRightArm.png"));
  resource.add(loadImage("resource/EmmaRightLeg.png"));
  resource.add(loadImage("resource/Mei.png"));
  resource.add(loadImage("resource/Owl.png"));
  
  explosion = loadImage("resource/OwlProtect.png");
  MeiEx = loadImage("resource/MadMei.png");
  Emma = new object(resource);
  obj = new ArrayList<intelligentObjects>(1);
 
  MeiAttack = new SoundFile(this, "data/Meiattack.wav");
  bird = new SoundFile(this, "data/bird.wav");
  //frameRate(30);
  originalMovie.play();
  originalMovie.volume(0);
  
  backgroundMovie.play();
  backgroundMovie.volume(1);
 
}
void draw(){
  float time = originalMovie.time();
  float duration = originalMovie.duration();

  if(time == duration){
    exit();
  }
  background(0);
  if (backgroundImg != null ){
    image(backgroundImg,640,360,1280,720);
    
  }
  if(improvedImg != null ) {
    replaceMonkey(improvedImg);
  }
  addObjects();
}
