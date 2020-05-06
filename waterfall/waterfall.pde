import java.util.Iterator;

Waterfall waterfall;

void setup() {
  size(1200, 800);
  waterfall = new Waterfall(new PVector(width/2, 20));
  
}

void draw() {
  background(255);
  waterfall.run();
  waterfall.addParticle();
  waterfall.addParticle();
  waterfall.addParticle();
  waterfall.addParticle();
  waterfall.addParticle();
  waterfall.addParticle();
  waterfall.addParticle();
  waterfall.addParticle();
  waterfall.addParticle();
  waterfall.addParticle();
}

class Waterfall {
  ArrayList<Particle> particles;
  PVector location;
  Waterfall(PVector position) {
    location = position;
    particles = new ArrayList<Particle>();
  }
  void run() {
    Iterator<Particle> particleIterator = particles.iterator();
    while (particleIterator.hasNext()) {
      Particle p = particleIterator.next();
      p.run();
      if (p.lifespan < 0) {
        particleIterator.remove();
      }
    }
  }
  
  void addParticle() {
    float random = random(100);
    if (random > 99.8) {
      particles.add(new Fish(new PVector(location.x + random(-250,250), location.y)));
    }
    else if (random < 0.2) {
      particles.add(new Log(new PVector(location.x + random(-250,250), location.y)));
    } else {
      particles.add(new Droplet(new PVector(location.x + random(-250,250), location.y)));
    }
  }
  
}

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  
  Particle(PVector location) {
    position = location;
    lifespan = map(height - location.y, 0, height, 0, 255);
  }
  
  void run() {
    update();
  }
  
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan = map(height - position.y, 0, height, 0, 255);
  }
  
}

class Droplet extends Particle {
  
  Droplet(PVector location) {
    super(location);
    velocity = new PVector(random(-1, 1), 0);
    acceleration = new PVector(0, 0.05);
  }
  
  void run() {
    super.run();
    render();
  }
  
  void render() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(PI);
    noStroke();
    fill(0, 255, 255, lifespan + 40);
    ellipse(0, -10, 20, 20);
    triangle(-10, -10, 10, -10, 0, 40);
    popMatrix();
  }
  
}

class Fish extends Particle {
  
  float randomoffset;
  
  Fish(PVector location) {
    super(location);
    velocity = new PVector(random(-0.25, 0.25), 0);
    acceleration = new PVector(0, 0.01);
    randomoffset = random(10000);
  }
  
  void run() {
    acceleration.x = sin(lifespan + randomoffset)/240;
    super.run();
    render();
  }
  
  void render() {
    pushMatrix();
    translate(position.x, position.y);
    noStroke();
    fill(0, 255, 0);
    ellipse(0, -10, 20, 20);
    triangle(-10, 10, 10, 10, 0, 0);
    popMatrix();
  }
}

class Log extends Particle {
  Log(PVector location) {
    super(location);
    velocity = new PVector(random(-0.25, 0.25), 0);
    acceleration = new PVector(0, 0.08);
  }
  
  void run() {
    super.run();
    render();
  }
  
  void render() {
    pushMatrix();
    translate(position.x, position.y);
    noStroke();
    fill(153, 102, 51);
    rect(-40, -10, 80, 20);
    popMatrix();
  }
}