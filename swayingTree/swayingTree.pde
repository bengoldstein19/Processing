float theta = PI*noise(random(10000))/6;
float t = 0;

void setup() {
  size(640, 360);
}

void draw() {
  background(0);
  float thetaoffset = PI*(noise(t)-0.5)/10;
  t += 0.02;
  background(0);
  frameRate(30);
  stroke(255);
  translate(width/2,height);
  rotate(thetaoffset);
  line(0,0,0,-120);
  translate(0,-120);
  branch(120, t+1000);
}

void branch(float h, float t) {
  t += 1000;
  h *= 0.66;
  if (h > 6) {
    pushMatrix();
    rotate(theta + PI*(noise(t)-0.5)/10);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h, t);
    popMatrix();
    pushMatrix();
    t += 0.01;
    rotate(-theta - PI*(noise(t)-0.5)/10);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h, t);
    popMatrix();
  }
}