import java.util.Arrays;

/* the use of augmented matrix instead of usual [0,1,0
                                                 1,1,1
                                                 0,1,0]
*/
PImage Erode(PImage img) { 
  PImage newImg = new PImage(img.width, img.height);
  
  color white = color(255,255,255);
  color black = color(0,0,0);
  boolean flag = false; //flag to add to image
  boolean[] Matrix = new boolean[5];
      
  for(int i = 1; i < img.height-1; i++) {
   for(int j = 1; j < img.width-1; j++) {
     flag = true;
     Arrays.fill(Matrix, false);
     
     if(img.pixels[j + (i-1)*img.width] == white) Matrix[0] = true;
     if(img.pixels[j-1 + i*img.width] == white) Matrix[1] = true;
     if(img.pixels[j + i*img.width] == white) Matrix[2] = true;
     if(img.pixels[j+1 + i*img.width] == white) Matrix[3] = true;
     if(img.pixels[j + (i+1)*img.width] == white) Matrix[4] = true;
  
    for (int x = 0; x < 5; x++) {
      if(Matrix[x] == true) {
        flag = true;
      }
      else {
        flag = false;
        break;
      }
     }
     if (flag == true) {
       newImg.pixels[j + i*img.width] = white;
     }
     else {
       newImg.pixels[j + i*img.width] = black;
    }   
   }
  }
  return newImg;
}

PImage Dilation(PImage img) {
  //mode 0 = erode, 1 = dilate 
  PImage newImg = new PImage(img.width, img.height);
  
  color white = color(255,255,255);
  color black = color(0,0,0);
  boolean flag = false; //flag to add to image
      
  for(int i = 1; i < img.height-1; i++) {
   for(int j = 1; j < img.width-1; j++) {
     
     flag = false;
        
     if(img.pixels[j + (i-1)*img.width] == white) flag = true;
     if(img.pixels[j-1 + i*img.width] == white) flag = true;
     if(img.pixels[j + i*img.width] == white) flag = true;
     if(img.pixels[j+1 + i*img.width] == white) flag = true;
     if(img.pixels[j + (i+1)*img.width] == white) flag = true;
  
     if (flag == true) {
       newImg.pixels[j + i*img.width] = white;
     }
     else {
       newImg.pixels[j + i*img.width] = black;
      }   
    }
  }
  return newImg;
}

  
