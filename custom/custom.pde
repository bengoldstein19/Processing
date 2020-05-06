class Vehicle {
  PVector velocity;
  PVector position;
  float maxSpeed;
  float maxSteer;
  Vehicle() {
    position = new PVector(width/2, height/2);
    velocity = new PVector(0, 0);
    maxSpeed = 4;
    maxSteer = 2;
  }
  void seek() {
    PVector temppos = new PVector(position.x, position.y);;
    PVector desired = new PVector(0, 0);
    float r = sqrt(sq(temppos.x - width/2) + sq(temppos.y - height/2));
    desired.x = -abs(r - width/2*sin(PVector.sub(temppos, new PVector(width/2, height/2)).heading()))*sin(PVector.sub(temppos, new PVector(width/2, height/2)).heading())/200;
    desired.y = abs(r - width/2*sin(PVector.sub(temppos, new PVector(width/2, height/2)).heading()))*cos(PVector.sub(temppos, new PVector(width/2, height/2)).heading())/200;
    desired.add(temppos.mult(1/(temppos.mag())).mult(abs(r - width/2*sin(PVector.sub(temppos, new PVector(width/2, height/2)).heading()))/200));
    PVector steer = PVector.sub(velocity, desired);
    steer.limit(maxSteer);
    velocity.add(steer);
    velocity.limit(maxSpeed);
    //if (position.x > width) {
    //  position.x = width;
    //  velocity.x = -velocity.x;
    //}
    //if (position.x < 0) {
    //  position.x = 0;
    //  velocity.x = -velocity.x;
    //}
    //if (position.y > height) {
    //  position.y = height;
    //  velocity.y = -velocity.y;
    //}
    //if (position.y < 0) {
    //  position.y = 0;
    //  velocity.y = -velocity.y;
    //}
    position.x = position.x + velocity.x;
    position.y = position.y + velocity.y;
  }
  void render() {
    ellipse(abs(position.x) % 500, abs(position.y) % 500, 20, 20);
  }
}
Vehicle vehicle;
void setup() {
  size(500, 500);
  background(255);
  vehicle = new Vehicle();
}
void draw() {
  background(255);
  vehicle.render();
  vehicle.seek();
}