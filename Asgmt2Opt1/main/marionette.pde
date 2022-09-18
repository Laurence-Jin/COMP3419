public class parts{
  float x,y;
  PImage image;
  
  public parts(PImage im){
    image = im;
  }
  public void setXY(float x , float y){
    this.x = x;
    this.y = y;
  }
  public void show(){
    imageMode(CENTER);
    image(image, x, y);
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
}

public class object{
  parts body;
  parts leftLeg;
  parts leftHand;
  parts rightHand;
  parts rightLeg;
  
  public object(ArrayList<PImage> textures){
    body = new parts(textures.get(0));
    leftLeg = new parts(textures.get(1));
    leftHand = new parts(textures.get(2));
    rightHand = new parts(textures.get(3));
    rightLeg = new parts(textures.get(4));
  }
  
  public void setPoints(ArrayList<PVector> points){
     if (points.get(0) != null) {
        leftHand.setXY(points.get(0).x+350, points.get(0).y+170);
      }   
    if (points.get(1) != null) {
          rightHand.setXY(points.get(1).x+450, points.get(1).y+170);
       }
    if (points.get(2) != null) {
          leftLeg.setXY( points.get(2).x+400, points.get(2).y+200);
       }
    if (points.get(3) != null) {
          rightLeg.setXY( points.get(3).x+400, points.get(3).y+200);
       }
    if (points.get(4) != null) {
          body.setXY( points.get(4).x+400, points.get(4).y+100);
      }
  }
  public void show(){
    body.show();
    leftLeg.show();
    leftHand.show();
    rightHand.show();
    rightLeg.show();
  }
  public boolean identifier(parts part, intelligentObjects i) {
    if(part.getx() < i.textureLengthX() && part.textureLengthX() > i.getx()
      && part.gety() < i.textureLengthY() && part.textureLengthY() > i.gety() ){
      return true;
    }
    return false;
  }
  public boolean collide(intelligentObjects i){
   if (identifier(leftHand,i)) return true;
   if (identifier(leftLeg,i)) return true;
   if (identifier(rightHand,i)) return true;
   if (identifier(rightLeg,i)) return true;
   if (identifier(body,i)) return true;
   return false;
  }
}
