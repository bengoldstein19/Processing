import java.util.Iterator;
ParticleSystem ps;

void setup() {
  size(1200, 800);
  ps = new ParticleSystem();
}

void draw() {
  background(255);
  ps.run();
}

class ParticleSystem {
  ArrayList<Particle> particles;
  ParticleSystem() {
    particles = new ArrayList<Particle>();
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        boolean bool = true;
        if (random(1000) > 500) {
          bool = false;
        }
        particles.add(new Particle(new PVector(i*width/4 + width/9, j*height/4 + height/8), bool));
      }
    }
  }
  
  void run() {
    for (int i = 0; i < 16; i++) {
      particles.get(i).resetForces();
      Particle particleOne = particles.get(i);
      //particleOne.applyForce(new PVector(-0.002*particleOne.velocity.x, -0.002*particleOne.velocity.y));
      for (int j = 0; j < 16; j++) {
        if (i != j) {
          Particle particleTwo = particles.get(j);
          PVector radius = new PVector(particleTwo.position.x - particleOne.position.x, particleTwo.position.y - particleOne.position.y);
          float rsquared = radius.x*radius.x + radius.y*radius.y;
          float r = sqrt(rsquared);
          if (r > 45) {
            radius.normalize();
            float forcemag = 2*particleOne.charge*particleTwo.charge/rsquared;
            PVector force = new PVector(-forcemag*radius.x, -forcemag*radius.y);
            particleOne.applyForce(force);
          } else if (r < 40) {
            PVector distanceVect = PVector.sub(particleTwo.position, particleOne.position);
            float distanceVectMag = distanceVect.mag();
            float minDistance = 40;
            float distanceCorrection = (minDistance - distanceVectMag)/2;
            PVector d = distanceVect.copy();
            PVector correctionVector = d.normalize().mult(distanceCorrection);
            particleTwo.position.add(correctionVector);
            particleOne.position.sub(correctionVector);
            
            float theta = distanceVect.heading();
            float sine = sin(theta);
            float cosine = cos(theta);
            PVector[] bTemp = {
              new PVector(), new PVector()
            };
            
            bTemp[1].x = cosine * distanceVect.x + sine * distanceVect.y;
            bTemp[1].y = cosine*distanceVect.y - sine * distanceVect.x;
            
            PVector[] vTemp = {
              new PVector(), new PVector()
            };
            
            vTemp[0].x = cosine * particleOne.velocity.x + sine * particleOne.velocity.y;
            vTemp[0].y = cosine* particleOne.velocity.y - sine*particleOne.velocity.x;
            vTemp[1].x = cosine * particleTwo.velocity.x + sine * particleTwo.velocity.y;
            vTemp[1].y = cosine * particleTwo.velocity.y - sine * particleTwo.velocity.x;
            
            PVector[] vFinal = {
              new PVector(), new PVector()
            };
            
            vFinal[0].x = vTemp[1].x;
            vFinal[0].y = vTemp[0].y;
            
            vFinal[0].x = vTemp[1].x;
            vFinal[1].y = vTemp[1].y;
            
            bTemp[0].x += vFinal[0].x;
            bTemp[1].x += vFinal[1].x;
            
            PVector[] bFinal = {
              new PVector(), new PVector()
            };
            
            bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
            bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
            bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
            bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;
            
            particleTwo.position.x = particleOne.position.x + bFinal[1].x;
            particleTwo.position.y = particleOne.position.y + bFinal[1].y;
            
            particleOne.position.add(bFinal[0]);
            
            particleOne.velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
            particleOne.velocity.x = cosine * vFinal[0].y + sine * vFinal[0].x;
            particleTwo.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
            particleTwo.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;

          }
        }
      }
      particleOne.run();
    }
  }
  
}

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  int charge;
  boolean ispositive;
  PShape shape;
  boolean collided;
  
  Particle(PVector location, boolean poscharge) {
    position = location;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    charge = ceil(random(9));
    ispositive = poscharge;
    if (ispositive) {
      shape = createShape();
      shape.beginShape();
      shape.vertex(-18, -4);
      shape.vertex(-4, -4);
      shape.vertex(-4, -18);
      shape.vertex(4, -18);
      shape.vertex(4, -4);
      shape.vertex(18, -4);
      shape.vertex(18, 4);
      shape.vertex(4, 4);
      shape.vertex(4, 18);
      shape.vertex(-4, 18);
      shape.vertex(-4, 4);
      shape.vertex(-18, 4);
      shape.endShape(CLOSE);
    } else {
      charge = -charge;
      shape = createShape();
      shape.beginShape();
      shape.vertex(-18, -4);
      shape.vertex(-18, 4);
      shape.vertex(18, 4);
      shape.vertex(18, -4);
      shape.endShape(CLOSE);
    }
  }
  
  void run() {
    update();
    render();
  }
  
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    if (position.x > width - 20) {
      position.x = width - 20;
      velocity.x = -velocity.x;
    }
    if (position.x < 20) {
      position.x = 20;
      velocity.x = -velocity.x;
    }
    if (position.y > height - 20) {
      position.y = height - 20;
      velocity.y = -velocity.y;
    }
    if (position.y < 20) {
      position.y = 20;
      velocity.y = -velocity.y;
    }
  }
  
  void render() {
    pushMatrix();
    translate(position.x, position.y);
    stroke(0);
    if (ispositive) {
      fill(255, 0, 0);
    } else {
      fill(0, 255, 255);
    }
    ellipse(0, 0, 40, 40);
    noStroke();
    fill(255);
    shape(shape, 0, 0);
    fill(0);
    text(charge, 0, 40);
    popMatrix();
  }
  
  void applyForce(PVector force) {
    acceleration.x += force.x;
    acceleration.y += force.y;
  }
  
  void resetForces() {
    acceleration.x = 0;
    acceleration.y = 0;
  }
  
}