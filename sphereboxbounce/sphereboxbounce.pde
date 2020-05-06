PVector position;
PVector velocity;
void setup() {
  size(800,800,P3D);
  background(255);
  position = new PVector (75, 75, 75);
  velocity = new PVector (0.1,0.1,0.1);
}

void draw() {
  background(255);
  stroke(0);
  rotateX(PI/3);
  text(str(position.x), 400,100);
  text(str(position.y), 400,150);
  text(str(position.z), 400,200);
  translate(400,400);
  line(10,10,10,150,10,10);
  line(10,10,10,10,150,10);
  line(10,150,10,150,150,10);
  line(150,10,10,150,150,10);
  line(10,10,150,150,10,150);
  line(10,10,150,10,150,150);
  line(10,150,150,150,150,150);
  line(150,10,150,150,150,150);
  line(10,10,50,10,50,150);
  line(10,150,10,10,150,150);
  line(150,10,10,150,10,150);
  line(150,150,0,150,150,150);
  if ((position.z > 530) || (position.z < 430)) {
    velocity.add(0,0,-2);
  }
  else if ((position.y > 530) || (position.y < 430)) {
    velocity.add(0,-2,0);
  }
  else if ((position.x > 530) || (position.x < 430)) {
    velocity.add(-2,0,0);
  }
  position.add(velocity);
  translate(position.x, position.y, position.z);
  sphere(20);
}