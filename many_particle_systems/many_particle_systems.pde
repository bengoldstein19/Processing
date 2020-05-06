import java.util.Iterator;

ArrayList<ParticleSystem> systems;

void setup() {
  size(640, 360);
  systems = new ArrayList<ParticleSystem>();
}

void draw() {
  background(255);
  Iterator<ParticleSystem> iterator = systems.iterator();
  while(iterator.hasNext()) {
    ParticleSystem sys = iterator.next();
    sys.run();
    sys.addParticle();
    if (sys.particles.size() == 0) {
      iterator.remove();
    }
  }
}

void mousePressed() {
  systems.add(new ParticleSystem(new PVector(mouseX,mouseY)));
}

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  boolean nonedead;
  
  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
    nonedead = true;
  }
  
  void addParticle() {
    if (nonedead) {
      particles.add(new Particle(origin));
    }
  }
  
  void run() {
    Iterator<Particle> it = particles.iterator();
    while (it.hasNext()) {
      Particle p = it.next();
      p.run();
      if (p.isDead()) {
        it.remove();
        nonedead = false;
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
    velocity = new PVector(random(-1.5, 1.5), random(-1.5, 0.5));
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