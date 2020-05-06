ArrayList<Vehicle> vehicles;
 
void setup() {
  size(800, 400);
  background(255);
  vehicles = new ArrayList<Vehicle>();
  for (int i = 0; i < 100; i++) {
    vehicles.add(new Vehicle(random(width),random(height)));
  }
}

void draw() {
  background(255);
  for (Vehicle v : vehicles) {
    v.applyBehaviors(vehicles);
    v.update();
    v.display();
  }
}

class Vehicle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float maxspeed;
  float maxforce;
  float r;
  float red;
  float green;
  float blue;
  float t;
  Vehicle(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    maxspeed = 4;
    maxforce = 0.4;
    r = 20;
    red = random(255);
    green = random(255);
    blue = random(255);
    t = random(10000);
  }
  
  void applyBehaviors(ArrayList<Vehicle> vehicles) {
    PVector separate = separate(vehicles);
    PVector seek = seek(mouseX, mouseY);
    separate.mult(2*noise(t)*abs(sin(t)));
    seek.mult(5*noise(t + 1000000)*abs(cos(t)));
    acceleration.add(separate);
    acceleration.add(seek);
  }
  void update() {
    acceleration.limit(maxforce);
    velocity.add(acceleration);
    location.add(velocity);
    velocity.limit(maxspeed);
    acceleration.mult(0);
    if (location.x < 0) {
      location.x  = width;
      //velocity.x = -velocity.x;
    }
    if (location.y < 0) {
      location.y  = height;
      //velocity.y = -velocity.y;
    }
    if (location.x > width) {
      location.x  = 0;
      //velocity.x = -velocity.x;
    }
    if (location.y > height) {
      location.y  = 0;
      //velocity.y = -velocity.y;
    }
    t = t + 0.1;
  }
  PVector seek(float x, float y) {
    PVector endpoint = new PVector(x, y);
    PVector desired = findTruDiff(endpoint, location);
    desired.limit(maxspeed);
    PVector steer = findTruDiff(desired, velocity);
    steer.limit(maxforce);
    if (findTruDiff(location, endpoint).mag() < 5*r) {
      steer.limit(maxforce*findTruDiff(location, endpoint).mag()/(5*r));
    }
    return (steer);
  }
  
  void cohesion(ArrayList<Vehicle> vehicles) {
    float desiredseparation = 2*r;
    PVector sum = new PVector();
    int count = 0;
    
    for (Vehicle other : vehicles) {
      float d = findTruDiff(location, other.location).mag();
      
      if ((d > 0) && (d > desiredseparation)) {
        PVector diff = findTruDiff(location, other.location);
        diff.normalize().mult(-desiredseparation/d);
        sum.add(diff);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.setMag(maxspeed);
      PVector steer = findTruDiff(sum, velocity);
      steer.limit(maxforce);
      acceleration.add(steer);
    }
  }
  
  PVector separate(ArrayList<Vehicle> vehicles) {
    float desiredseparation = 2*r;
    PVector sum = new PVector();
    int count = 0;
    
    for (Vehicle other : vehicles) {
      float d = findTruDiff(location, other.location).mag();
      
      if ((d > 0) && (d < desiredseparation)) {
        PVector diff = findTruDiff(location, other.location);
        diff.normalize().div(d/desiredseparation);
        sum.add(diff);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.setMag(maxspeed);
      PVector steer = findTruDiff(sum, velocity);
      steer.limit(maxforce);
      return (steer);
    } else {
      return new PVector (0, 0);
    }
  }
  void display() {
    fill(red, green, blue);
    ellipse(location.x, location.y, r, r);
  }
}

PVector findTruDiff(PVector a, PVector b) {
  float radiusx = width/TWO_PI;
  float radiusy = height/TWO_PI;
  PVector circleVectorAx = new PVector(radiusx*cos(a.x*TWO_PI/width), radiusx*sin(a.x*TWO_PI/width));
  PVector circleVectorBx = new PVector(radiusx*cos(b.x*TWO_PI/width), radiusx*sin(b.x*TWO_PI/width));
  float xDiff = (circleVectorAx.heading() - circleVectorBx.heading())*radiusx;
  PVector circleVectorAy = new PVector(radiusy*cos(a.y*TWO_PI/height), radiusy*sin(a.y*TWO_PI/height));
  PVector circleVectorBy = new PVector(radiusy*cos(b.y*TWO_PI/height), radiusy*sin(b.y*TWO_PI/height));
  float yDiff = (circleVectorAy.heading() - circleVectorBy.heading())*radiusy;
  return new PVector(xDiff, yDiff);
}