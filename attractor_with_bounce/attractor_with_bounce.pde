class Attractor {
  PVector location;
  float mass;
  float radius;
  Attractor(float x, float y, float m, float r) {
    location = new PVector(x, y);
    mass = m;
    radius = r;
  }
  void render() {
    ellipse(location.x, location.y, 2*radius, 2*radius);
  }
}

class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float radius;
  float dragConstant;
  Mover(float x, float y, float m, float r, float b) {
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = m;
    radius = r;
    dragConstant = b;
  }
  
  void checkEdges() { //bounce off walls
    if (location.x < radius) {
      location.x = radius;
      velocity.x = -velocity.x;
    }
    if (location.x > width - radius) {
      location.x = width - radius;
      velocity.x = -velocity.x;
    }
    if (location.y < radius) {
      location.y = radius;
      velocity.y = -velocity.y;
    }
    if (location.y > height - radius) {
      location.y = height - radius;
      velocity.y = -velocity.y;
    }
  }
  
  void checkCollision() { //COMPLICATED CODE to bounce off edge of attractor
    if (PVector.sub(location, a.location).mag() < radius + a.radius) {
      PVector vRadial = PVector.sub(a.location, location).normalize().mult(PVector.dot(PVector.sub(a.location, location).normalize(), velocity));
      PVector vPerp = PVector.sub(velocity, vRadial);
      velocity = PVector.sub(vPerp, vRadial);
      location = PVector.add(PVector.sub(location, a.location).normalize().mult(radius + a.radius), new PVector(width/2, height/2));
    }
  }
  
  void applyForce(PVector force) { //add force to acceleration
    acceleration.add(PVector.mult(force, 1/mass));
  }
  
  void update() { //euler integration and reset acceleration
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void render() {
    ellipse(location.x, location.y, 2*radius, 2*radius); //draws mover at location
  }
}

Attractor a;
Mover m;
float newx;
float oldx;
float newy;
float oldy;

void setup() {
  size(600, 400);
  background(0);
  a = new Attractor(width/2, height/2, 20, 20); //positioned in center mass 20 radius 20
  m = new Mover(random(width), random(height), 2, 10, 0.05); //positioned in center, mass of 2, drag constant .05
  fill(0, 100);
  strokeWeight(2);
  newx = 0;
  newy = 0;
  oldy = 0;
  oldx = 0;
}

void draw() {
  background(255);
  PVector force = PVector.sub(a.location, m.location); //gets vector connecting centers of bodies
  force.normalize(); //makes unit vector
  force.mult(a.mass); //multiplies by each mass following real proportionality of gravity to product of masses
  force.mult(m.mass);
  force.div(sq(PVector.sub(a.location, m.location).mag())); //divides by square of distance (inverse square law)
  force.mult(50);  //change number to adjust gravity strength
  PVector dragForce = m.velocity.copy();
  dragForce.mult(-m.dragConstant);
  m.applyForce(force); //applies the force to the mover
  m.applyForce(dragForce);
  m.checkEdges(); //bounces off walls
  m.checkCollision(); //bounces off attractor
  m.update(); //update mover
  if (mousePressed) { //drag to move mover
    oldx = newx;
    newx = m.location.x;
    oldy = newy;
    newy = m.location.y;
    m.location.x = mouseX;
    m.location.y = mouseY;
    m.velocity.mult(0);
  } else {
    if (newy != 0) {
      m.velocity.x = newx - oldx;
      m.velocity.y = newy - oldy;
      m.velocity.div(2);
      newy = 0;
      oldy = 0;
      newx = 0;
      oldx = 0;
    }
  }
  a.render(); //draw attractor
  m.render(); //draw mover
}