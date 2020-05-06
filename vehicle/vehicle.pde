Vehicle vehicle;
Vehicle vehicle2;
Target target;

class Target {
  PVector location;
  float velocityy;
  float velocityx;
  float accelerationx;
  float accelerationy;
  float maxSpeed;
  float frames;
  float count;
  Target() {
    location = new PVector(width/2, height/2);
    velocityy = 0;
    velocityx = 0;
    accelerationx = 0;
    accelerationy = 0;
    maxSpeed = 1;
    count = 0;
  }
  void update() {
    accelerationx = 0.1*(noise(count) - 0.5);
    accelerationy = 0.1*(noise(count + 10000) - 0.5);
    count = count + 0.01;
    velocityx += accelerationx;
    velocityy += accelerationy;
    PVector vel = new PVector(velocityx, velocityy);
    vel.limit(4);
    location.add(vel);
    if (location.x < 0) {
      location.x = 0;
      velocityx = -velocityx;
    }
    if (location.y < 0) {
      location.y = 0;
      velocityy = -velocityy;
    }
    if (location.x > width) {
      location.x = width;
      velocityx = -velocityx;
    }
    if (location.y > height) {
      location.y = height;
      velocityy = -velocityy;
    }
  }
  void render() {
    ellipse(location.x, location.y, 20, 20);
  }
}


class Vehicle {
 
  PVector location;
  PVector velocity;
  PVector acceleration;

  float r;
  float maxforce;
  float maxspeed;
  float turnrad;
 
  Vehicle(float x, float y) {
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    location = new PVector(x,y);
    r = 5.0;
    maxspeed = 0.2;
    maxforce = 0.1;
    turnrad = 400;
  }
 
  void update() {
    maxspeed = 10*(1 - sqrt(sq(location.x - width/2) + sq(location.y - height/2))/(250*sqrt(2)));
    maxforce = 5*(1 - sqrt(sq(location.x - width/2) + sq(location.y - height/2))/(250*sqrt(2)));
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    if (location.x < 0) {
      location.x = 0;
      velocity.x = -velocity.x;
    }
    if (location.y < 0) {
      location.y = 0;
      velocity.y = -velocity.y;
    }
    if (location.x > width) {
      location.x = width;
      velocity.x = -velocity.x;
    }
    if (location.y > height) {
      location.y = height;
      velocity.y = -velocity.y;
    }
    acceleration.mult(0);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  void flee(Target target) {
    float distance = PVector.sub(target.location, location).mag();
    PVector locationtoseek = new PVector(target.location.x + distance*target.velocityx/maxspeed, target.location.y + distance*target.velocityy/maxspeed);
    PVector desired = PVector.sub(locationtoseek, location);
    desired.normalize();
    desired.mult(-maxspeed);
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }
 
  void seek(Target target) {
    float distance = PVector.sub(target.location, location).mag();
    PVector locationtoseek = new PVector(target.location.x + distance*target.velocityx/maxspeed, target.location.y + distance*target.velocityy/maxspeed);
    PVector desired = PVector.sub(locationtoseek, location);
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired,velocity);
    if (PVector.sub(location, locationtoseek).mag() < 5) {
      steer.mult(0);
    }
    steer.limit(maxforce);
    applyForce(steer);
    if (PVector.sub(location, locationtoseek).mag() < 100) {
      velocity.normalize().mult(map(PVector.sub(location, locationtoseek).mag(), 0, 100, 0, maxspeed));
    } else {
      velocity.mult(maxspeed);
    }
  }
 
  void display() {
    float theta = velocity.heading() + PI/2;
    fill(175);
    stroke(0);
    pushMatrix();
    translate(location.x,location.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();
  }
}

void setup() {
  size(640, 400);
  background(255);
  vehicle = new Vehicle(320, 200);
  vehicle2 = new Vehicle(320, 200);
  target = new Target();
}

void draw() {
  background(255);
  target.update();
  target.render();
  vehicle.seek(target);
  vehicle2.flee(target);
  vehicle.update();
  vehicle.display();
  vehicle2.update();
  vehicle2.display();
}