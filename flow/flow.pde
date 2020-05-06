class FlowField {
  PVector[][] vectors;
  int cols, rows;
  int resolution;
  int frames;
  FlowField(int r) {
    resolution = r;
    cols = width/r;
    rows = height/r;
    vectors = new PVector[cols][rows];
    frames = 0;
  }
  PVector lookup(PVector lookup) {
    int column = (int) (constrain(lookup.x/resolution, 0, cols - 1));
    int row = (int) (constrain(lookup.y/resolution, 0, rows - 1));
    return vectors[column][row].copy();
  }
  void setValues() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        float theta = map(noise(i * 0.01, j * 0.01, this.frames * 0.01), 0, 1, 0, TWO_PI);
        vectors[i][j] = new PVector(cos(theta), sin(theta));
      }
    }
    frames++;
  }
  void render() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        line(i*resolution, j * resolution, i*resolution + 10*lookup(new PVector(i*resolution, j * resolution)).x, j * resolution + 10*lookup(new PVector(i*resolution, j * resolution)).y);
      }
    }
  }
}

class Vehicle {
  PVector location;
  PVector velocity;
  float maxSpeed;
  float maxForce;
  Vehicle(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    maxSpeed = 8;
    maxForce = 0.2;
  }
  void seek(FlowField flow) {
    PVector desired = flow.lookup(PVector.add(location, PVector.mult(velocity, velocity.mag())));
    desired.normalize().mult(maxSpeed);
    ellipse(PVector.add(location, PVector.mult(velocity, velocity.mag())).x, PVector.add(location, PVector.mult(velocity, 5*velocity.mag())).y, 10, 10);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    velocity.add(steer);
    velocity.limit(maxSpeed);
    location.add(velocity);
    if (location.x > width) {
      location.x = width;
      velocity.x = -velocity.x;
    }
    if (location.x < 0) {
      location.x = 0;
      velocity.x = -velocity.x;
    }
    if (location.y > height) {
      location.y = height;
      velocity.y = -velocity.y;
    }
    if (location.y < 0) {
      location.y = 0;
      velocity.y = -velocity.y;
    }
  }
  void render() {
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading());
    triangle(0, 0, -20, 5, -20, -5);
    popMatrix();
  }
}

FlowField flowfield;
Vehicle vehicle;

void setup() {
  size(640, 480);
  background(255);
  flowfield = new FlowField(10);
  vehicle = new Vehicle(random(width), random(height));
}

void draw() {
  background(255);
  flowfield.setValues();
  flowfield.render();
  vehicle.seek(flowfield);
  vehicle.render();
}