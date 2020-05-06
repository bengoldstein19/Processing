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
    float size = 0;
    boolean working = true;
    while(working) {
      size = random(10);
      float prob = size * size/100;
      float test = random(10);
      if (test < prob) {
        working = false;
      }
    }
    x += random(-size,size);
    y += random(-size,size);
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