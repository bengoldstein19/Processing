class Walker {
  float x;
  float y;
  Walker() {
    x = width/2;
    y= height/2;
  }
  void display() {
    stroke(0);
    point(x,y);
  }
  void step() {
    float random = random(1);
    if (random < .5) {
      float disty = mouseY-y;
      float distx = mouseX-x;
      float temp = distx;
      distx = distx/(sqrt(disty*disty+distx*distx)+.0001);
      disty = disty/(sqrt(disty*disty+temp*temp)+.0001);
      x += distx;
      y += disty;
    } else if (random < .625) {
      y++;
    } else if (random < .75) {
      y--;
    } else if (random < .875) {
      x++;
    } else {
      x--;
    }
  } 
}

Walker w;
void setup() {
  size(640,360);
  w = new Walker();
  background(255);
}

void draw() {
  w.step();
  w.display();
}