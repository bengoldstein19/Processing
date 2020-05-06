WindParticle[] windParticles = new WindParticle[1000];
Ball[] balls = new Ball[20];

void setup() {
  size(500, 500);
  background(255);
  for(int i = 0; i < 1000; i++) {
    windParticles[i] = new WindParticle(20, random(TAU), i*10);
  }
  for (int i = 0; i < 20; i++) {
    balls[i] = new Ball();
  }
}

void draw() {
  background(255);
  for (int i = 0; i < 1000; i++) {
    windParticles[i].update();
    windParticles[i].render();
  }
  strokeWeight(250*(sqrt(2) - 1));
  stroke(0,125);
  fill(255, 0);
  ellipse(width/2, height/2, 250*sqrt(2) + 250, 250*sqrt(2) + 250);
  for (int i = 0; i < balls.length; i++) {
    balls[i].update();
    balls[i].render();
  }
}

class WindParticle {
  PVector location;
  float radius;
  float angle;
  WindParticle(float r, float theta, float frameoffset) {
    angle = theta;
    radius = r;
    location = new PVector(r*cos(theta), r*sin(theta));
    for (int i = 0; i < frameoffset; i++) {
      this.update();
    }
  }
  void update() {
    float dtheta;
    float windspeed = (20 - radius)/50000 + 0.02;
    dtheta = PI/radius;
    float dr = windspeed/dtheta;
    angle = angle + dtheta;
    radius = radius + dr;
    if ((location.x > width/2 && location.y > height/2) || (location.x > width/2 && location.y < -height/2) || (location.x < -width/2 && location.y < -height/2) || (location.x < -width/2 && location.y > height/2)) {
      radius = 20;
    }
    location.x = radius*cos(angle);
    location.y = radius*sin(angle);
  }
  void render() {
    strokeWeight(2);
    stroke(0);
    fill(0,0,255);
    ellipse(width/2 + location.x, height/2 + location.y, 10, 10);
  }
}

class Ball {
  PVector location;
  PVector velocity;
  PVector wind;
  PVector vrelative;
  float radius;
  float angle;
  Ball() {
    float randomnum = random(1);
    if (randomnum > 0.75) {
      location = new PVector(random(100) + 20, random(100) + 20);
    } else if (randomnum > 0.5) {
      location = new PVector(-random(100) - 20, -random(100) - 20);
    } else if (randomnum > 0.25) {
      location = new PVector(-random(100) - 20, random(100) + 20);
    } else {
      location = new PVector(random(100) + 20, -random(100) - 20);
    }
    velocity = new PVector(0, 0);
    radius = location.mag();
    angle = atan2(location.y, location.x);
  }
  void update() {
    radius = location.mag();
    if (radius < 20) {
      if (radius != 0) {
        location = location.normalize().mult(20);
      } else {
        location = new PVector(20, 0);
      }
      radius = 20;
    }
    angle = atan2(location.y, location.x);
    float dtheta = PI/radius;
    float windspeed = (20 - radius)/50000 + 0.02;
    float dr = windspeed/dtheta;
    float rfinal = radius + dr;
    float anglefinal = angle + dtheta;
    wind = new PVector(rfinal*cos(anglefinal) - radius*cos(angle), rfinal*sin(anglefinal) - radius*sin(angle));
    vrelative = new PVector(velocity.x - wind.x, velocity.y - wind.y);
    PVector windForce = vrelative.mult(-0.005);
    strokeWeight(2);
    stroke(0);
    if (location.x > width/2) {
      location.x = width/2;
      velocity.x = -velocity.x;
    }
    if (location.x < -width/2) {
      location.x = -width/2;
      velocity.x = -velocity.x;
    }
    if (location.y > height/2) {
      location.y = height/2;
      velocity.y = -velocity.y;
    }
    if (location.y < -height/2) {
      location.y = -height/2;
      velocity.y = -velocity.y;
    }
    velocity.add(windForce);
    location.add(velocity);
  }
  void render() {
    stroke(0);
    strokeWeight(2);
    fill(255, 0, 0);
    ellipse(location.x + width/2, location.y + height/2, 10, 10);
  }
}