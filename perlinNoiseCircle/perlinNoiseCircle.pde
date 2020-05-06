void setup() {
  size(640,360);
  background(255);
}

float t = 0;
float u = 1000000;

void draw() {
  background(255);
  float n = noise(t);
  n = map(n,0,1,0,width);
  float m = noise(u);
  m = map(m,0,1,0,height);
  ellipse(n,m,16,16);
  t+=0.01;
  u+=0.01;
}