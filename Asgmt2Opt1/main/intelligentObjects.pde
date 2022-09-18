public class intelligentObjects{
  float x,y = 0;
  PImage image;
  boolean direction = false;
  boolean owl = false;
  boolean fromTopLeft = false;
  boolean fromTopRight = false;
  boolean fromBottomLeft = false;
  boolean fromBottomRight = false;
 
  public intelligentObjects(PImage im,float y, boolean lr){
    if(lr){
       x = 1280+im.width;
    }else{
      x = x-im.width;
    }
    this.y = y;
    image = im;
    direction = lr;
  }
  
  public void update(){
    if(owl == true){
      if(fromTopLeft){
         x += 10;
         y += 10;
      }else if(fromTopRight){
         x -= 10; 
         y += 10;
      }else if(fromBottomLeft){
         x += 10; 
         y -= 10;
      }else if(fromBottomRight){
         x -= 10; 
         y -= 10;
      }     
    }
    else
    {
      if(direction)
      {
         x -= 10; 
      }
      else 
      {
         x += 10; 
      }  
    }
    image(image, x, y);   
  }
  public void setCorner(int x , int y){
    if (x == 0 && y == 0){
      fromTopLeft = true;
    }else if(x == 1280 && y == 0){
      fromTopRight = true;
    }else if(x == 0 && y == 720){
      fromBottomLeft = true;
    }else if(x == 1280 && y == 720){
      fromBottomRight = true;
    }
    
    this.x = x;
    this.y = y;
    owl = true;
  }
  
  public float getx(){
    return this.x;
  }
  public float gety(){
    return this.y;
  }
  public float textureLengthX(){
    return x + image.width;
  }
  
  public float textureLengthY(){
    return y + image.height;
  }
  
  public boolean collide(intelligentObjects i){
    if(getx() < i.textureLengthX() && textureLengthX() > i.getx()
        && gety() < i.textureLengthY() && textureLengthY() > i.gety() ){
        return true;
      }
      return false;
  }
  public boolean isowl(){
    return owl;
  }
  public void evolve(PImage im){
      this.image = im;
  }
  public boolean outScreen(){
    if(x < 0-image.width || y < 0-image.height || x > 1280+image.width || y > 720+image.height){
      return true;
    } 
    return false;
  }
}
