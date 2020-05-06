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
    float rand = random(1);
    if (rand < 0.01) {
      x += random(-100,100);
      y += random(-100,100);
    } else {
      x += random(-1,1);
      y += random(-1,1);
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