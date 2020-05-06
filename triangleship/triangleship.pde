import java.util.Iterator;

ParticleSystem ps;
Ship ship;

void setup() {
  size(640, 360);
  ps = new ParticleSystem(new PVector(width/2, 50));
  ship = new Ship(new PVector(width/2, height/2));
}

void draw() {
  background(255);
  fill(0);
  text("A and D turn, W thrusts", width/2, 30);
  ship.run();
}

class Ship {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float theta;
  boolean thrusterson;
  boolean apressed;
  boolean dpressed;
  boolean wpressed;
  
  Ship(PVector position) {
    location = position.get();
    velocity = new PVector();
    acceleration = new PVector();
    theta = 0;
    apressed = false;
    dpressed = false;
    wpressed = false;
  }
  
  void run() {
    update();
    render();
  }
  
  void update() {
    acceleration.x= 0;
    acceleration.y = 0;
    thrusterson = false;
      if (apressed) {
        theta += -0.1;
      } if (dpressed) {
        theta += 0.1;
      } if (wpressed) {
        acceleration.x += 0.033*cos(theta);
        acceleration.y += 0.033*sin(theta);
        thrusterson = true;
      }
      acceleration.x += -velocity.x/240;
      acceleration.y += -velocity.y/240 + 0.01;
      velocity.add(acceleration);
      location.add(velocity);
      location.x = location.x % width;
      location.y = location.y % height;
      if (location.x < 0) {
        location.x += width;
      }
      if (location.y < 0) {
        location.y += height;
      }
    }
  
  void render() {
    ps.run();
    stroke(0);
    fill(175);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    triangle(20, 0, -20, 40/sqrt(3), -20, -40/sqrt(3));
     if (thrusterson) {
      fill(255, 0, 0);
    }
    rect(-24, -40/sqrt(3) + 4, 4, 40/sqrt(3) - 8);
    rect(-24, 4, 4, 40/sqrt(3) - 8);
    popMatrix();
  }
  
}
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  
  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }
  
  void addParticle() {
    particles.add(new Particle(origin));
  }
  
  void run() {
    origin.x = ship.location.x  - 20*cos(ship.theta);
    origin.y = ship.location.y - 20*sin(ship.theta);
    if (ship.thrusterson) {
      addParticle();
    }
    Iterator<Particle> it = particles.iterator();
    while (it.hasNext()) {
      Particle p = it.next();
      p.run();
      if (p.isDead()) {
        it.remove();
      }
    }
  }
  
}

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float mass;
  float theta;
  float avel;
  float aacc;
  Particle(PVector l) {
    acceleration = new PVector(0,0.05);
    float magvel = random(-4, -2);
    float thetaoffset = random(-PI/6, PI/6);
    velocity = new PVector(magvel*cos(ship.theta + thetaoffset),magvel*sin(ship.theta + thetaoffset));
    location = l.get();
    lifespan = 255.0;
    theta = 0;
    avel = random(-0.1, 0.1);
    aacc = random(-0.005, 0.005);
  }
  
  void applyforce(PVector force) {
    acceleration.x += force.x/mass;
    acceleration.y += force.y/mass;
  }
 
  void run() {
    update();
    display();
  }
 
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 2.0;
    avel += aacc;
    theta += avel;
  }
 
  void display() {
    stroke(0,lifespan);
    fill(0,lifespan);
    pushMatrix();
    translate(location.x,location.y);
    rotate(theta);
    ellipse(0,0,16,8);
    popMatrix();
  }
 
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

void keyReleased() {
    ship.apressed = false;
    ship.wpressed = false;
    ship.dpressed = false;
}

void keyPressed() {
  if (key == 'a') {
    ship.apressed = true;
    ship.wpressed = false;
    ship.dpressed = false;
  }
  if (key == 'w') {
    ship.apressed = false;
    ship.wpressed = true;
    ship.dpressed = false;
  }
  if (key == 'd') {
    ship.apressed = false;
    ship.wpressed = false;
    ship.dpressed = true;
  }
}