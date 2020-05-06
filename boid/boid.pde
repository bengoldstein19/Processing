class Boid {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float maxforce;
  float maxspeed;
  float r;
  float peripheral;
  float visionlength;
  float alignmult;
  float cohesionmult;
  float separatemult;
  float wallsmult;
  float viewmult;
  int column;
  int row;
  Boid(PVector l, float mf, float ms) {
    location = l.copy();
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    maxforce = mf;
    maxspeed = ms;
    r = 15;
    peripheral = 240;
    visionlength = 10*r;
    viewmult = 1;
    cohesionmult = 1;
    separatemult = 1;
    wallsmult = 1;
    alignmult = 1;
    column = floor(location.x * 11 / width);
    row = floor(location.y * 11 / height);
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  PVector align(ArrayList<Boid> boids) {
    PVector averageVel = new PVector(0, 0);
    int counter = 0;
    for(Boid boid : boids) {
      boolean peripherybool = false;
      if (peripheralmode) {
        float d = PVector.sub(location, boid.location).mag();
        float angle = 0;
        if (velocity.mag() != 0) {
          angle = PVector.angleBetween(velocity, PVector.sub(boid.location, location));
        } else {
          angle = PVector.angleBetween(new PVector(1, 0), PVector.sub(boid.location, location));
        }
        peripherybool = (angle < radians(peripheral/2)) && (d < visionlength);
      } else {
        peripherybool = PVector.dist(boid.location, location) < visionlength;
      }
      if (peripherybool) {
        averageVel.add(boid.velocity);
        counter++;
      }
    }
    if (counter > 0) {
      averageVel.div(counter);
      averageVel.setMag(maxspeed);
      PVector steer = PVector.sub(averageVel, velocity);
      steer.limit(maxforce);
      return steer;
    } else {
      return averageVel;
    }
  }
  
  PVector cohesion(ArrayList<Boid> boids) {
    PVector averageLoc = new PVector(0, 0);
    int counter = 0;
    for(Boid boid : boids) {
      boolean peripherybool = false;
      if (peripheralmode) {
        float d = PVector.sub(location, boid.location).mag();
        float angle = 0;
        if (velocity.mag() != 0) {
          angle = PVector.angleBetween(velocity, PVector.sub(boid.location, location));
        } else {
          angle = PVector.angleBetween(new PVector(1, 0), PVector.sub(boid.location, location));
        }
        peripherybool = (angle < radians(peripheral/2)) && (d < visionlength);
      } else {
        peripherybool = PVector.dist(boid.location, location) < visionlength;
      }
      if (peripherybool) {
        averageLoc.add(boid.location);
        counter++;
      }
    }
    if (counter > 0) {
      averageLoc.div(counter);
      PVector desiredVelocity = PVector.sub(averageLoc, location);
      desiredVelocity.limit(maxspeed);
      PVector steer = PVector.sub(desiredVelocity, velocity);
      steer.limit(maxforce);
      return steer;
    } else {
      return averageLoc;
    }
  }
  
  PVector separate(ArrayList<Boid> boids) {
    float desiredseparation = 2*r;
    PVector sum = new PVector();
    int count = 0;
    for (Boid boid : boids) {
      float d = PVector.sub(location, boid.location).mag();
      boolean peripherybool = false;
      if (peripheralmode) {
        float angle = 0;
        if (velocity.mag() != 0) {
          angle = PVector.angleBetween(velocity, PVector.sub(boid.location, location));
        } else {
          angle = PVector.angleBetween(new PVector(1, 0), PVector.sub(boid.location, location));
        }
        peripherybool = (angle < radians(peripheral/2)) && (d < visionlength);
      } else {
        peripherybool = d < visionlength;
      }
      if (((d > 0) && (d < desiredseparation)) && peripherybool) {
        PVector diff = PVector.sub(location, boid.location);
        diff.normalize().div(d*d);
        sum.add(diff);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.setMag(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return (steer);
    } else {
      return new PVector (0, 0);
    }
  }
  
  PVector walls() {
    PVector steer = new PVector();
    if (location.x < 25) {
      PVector desired = new PVector(maxspeed,velocity.y);
      PVector steerage = PVector.sub(desired, velocity);
      steerage.limit(maxforce);
      steer.add(steerage);
    }
    if (location. x > width - 25) {
      PVector desired = new PVector(-maxspeed,velocity.y);
      PVector steerage = PVector.sub(desired, velocity);
      steerage.limit(maxforce);
      steer.add(steerage);
    }
    if (location.y < 25) {
      PVector desired = new PVector(velocity.x,maxspeed);
      PVector steerage = PVector.sub(desired, velocity);
      steerage.limit(maxforce);
      steer.add(steerage);
    }
    if (location.y > height - 25) {
      PVector desired = new PVector(velocity.x,-maxspeed);
      PVector steerage = PVector.sub(desired, velocity);
      steerage.limit(maxforce);
      steer.add(steerage);
    }
    steer.limit(maxforce);
    return steer;
  }
  
  PVector view(ArrayList<Boid> boids) {
    int count = 0;
    PVector sum = new PVector();
    for (Boid boid : boids) {
      float dist = dist(boid.location.x, boid.location.y, location.x, location.y);
      if (dist > 0 && dist < visionlength) {
        float angle = 0;
        if (velocity.mag() != 0) {
          angle = PVector.angleBetween(velocity, PVector.sub(boid.location, location));
        } else {
          angle = PVector.angleBetween(new PVector(1, 0), PVector.sub(boid.location, location));
        }
        if (angle < peripheral/4) {
          PVector desired = PVector.sub(velocity.normalize(), PVector.sub(boid.location, location).normalize());
          desired.normalize();
          desired.mult(maxspeed);
          PVector steer = PVector.sub(desired, velocity);
          steer.limit(maxforce);
          sum.add(steer);
          count++;
        }
      }
    }
    if (count > 0) {
      sum.div(count);
    }
    sum.setMag(maxforce);
    return sum;
  }
  
  void flock(ArrayList<Boid> boids) {
    column = int(location.x * 10 / width);
    row = int(location.y * 10 / height);
    PVector sep = separate(boids);
    PVector ali = align(boids);
    PVector coh = cohesion(boids);
    PVector view = view(boids);
    PVector wall = walls();
    PVector seek = seek(new PVector(mouseX, mouseY));
    seek.mult(10);
    sep.mult(separatemult);
    ali.mult(alignmult);
    coh.mult(cohesionmult);
    view.mult(viewmult);
    wall.mult(wallsmult);
    applyForce(seek);
    applyForce(view);
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    applyForce(wall);
  }
  
  void update() {
    acceleration.limit(maxforce);
    velocity.add(acceleration);
    velocity.setMag(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
    if (location.x < 0) {
      location.x = width;
      //velocity.x = -velocity.x;
    }
    if (location.y < 0) {
      location.y = height;
      //velocity.y = -velocity.y;
    }
    if (location.x > width) {
      location.x = 0;
      //velocity.x = -velocity.x;
    }
    if (location.y > height) {
      location.y = 0;
      //velocity.y = -velocity.y;
    }
  }
  
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target,location);  // A vector pointing from the position to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }
  
  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    display();
  }
  
  void display() {
    pushMatrix();
    stroke(0);
    if (peripheralmode) {
      fill(100);
    } else {
      fill(0, 255, 0);
    }
    translate(location.x, location.y);
    rotate(velocity.heading());
    triangle(0, 0, -r, r*0.25, -r, r*-0.25);
    if (shouldDisplay) {
      stroke(0, 0, 255);
      fill(0, 0, 255, 40);
      arc(0, 0, visionlength*2, visionlength*2, -radians(peripheral/2), radians(peripheral/2));
      line(0, 0, visionlength*cos(-radians(peripheral/2)), visionlength*sin(-radians(peripheral/2)));
      line(0, 0, visionlength*cos(radians(peripheral/2)), visionlength*sin(radians(peripheral/2)));
      rotate(-velocity.heading());
    }
    
    //stroke(255, 0, 0);
    //line(0, 0, 10*acceleration.x, 10*acceleration.y);
    popMatrix();
  }
}

class Flock {
  ArrayList<Boid> boids;
  
  Flock() {
    boids = new ArrayList<Boid>();
  }
  
  void run() {
    for (Boid boid : boids) {
      //boid.run(grid[boid.row][boid.column]);
      boid.run(boids);
    }
  }
  
  void addBoid(Boid boid) {
    boids.add(boid);
  }
}

boolean peripheralmode = true;
boolean shouldDisplay = true;
Flock flock;
import controlP5.*;
ControlP5 cp5;
float sliderwalls;
float sliderview;
float slidercohesion;
float sliderseparate;
float slideralign;
ArrayList<Boid>[][] grid;

void setup() {
  size(800, 600);
  background(249);
  peripheralmode = true;
  shouldDisplay = false;
  flock = new Flock();
  grid = new ArrayList[11][11];
  for (int i = 0; i < 3; i++) {
    Boid b = new Boid(new PVector(width/2 + random(0.001), height/2 + random(0.001)), 0.1, 1);
    flock.addBoid(b);
  }
  for (int i = 0; i < 11; i++) {
    for (int j = 0; j < 11; j++) {
      grid[i][j] = new ArrayList<Boid>();
    }
  }
  stroke(0);
  fill(0);
  cp5 = new ControlP5(this);
   
  cp5.addSlider("slidercohesion")
     .setPosition(20,20)
     .setSize(80,20)
     .setRange(0,10)
     .setValue(1)
     .setColorCaptionLabel(0) 
     .setColorValueLabel(0);
     ;
     
     
  cp5.addSlider("sliderseparate")
     .setPosition(20,70)
     .setSize(80,20)
     .setRange(0,10)
     .setValue(1)
     .setColorCaptionLabel(0)
     .setColorValueLabel(0);
     ;
     
     cp5.addSlider("slideralign")
     .setPosition(20,120)
     .setSize(80,20)
     .setRange(0,10)
     .setValue(1)
     .setColorCaptionLabel(0)
     .setColorValueLabel(0);
     ;
     
     
  cp5.addSlider("sliderwalls")
     .setPosition(20,170)
     .setSize(80,20)
     .setRange(0,10)
     .setValue(1)
     .setColorCaptionLabel(0)
     .setColorValueLabel(0);
     ;
     
     cp5.addSlider("sliderview")
     .setPosition(20,220)
     .setSize(80,20)
     .setRange(0,10)
     .setValue(1)
     .setColorCaptionLabel(0)
     .setColorValueLabel(0);
     ;
  
  cp5.getController("slidercohesion").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("slidercohesion").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
  cp5.getController("sliderseparate").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("sliderseparate").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
 
  cp5.getController("slideralign").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("slideralign").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
  cp5.getController("sliderwalls").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("sliderwalls").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
  cp5.getController("sliderview").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("sliderview").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
 
}

void draw() {
  noStroke();
  fill(255, 20);
  rect(0, 0, width, height);
  stroke(0);
  for (int i = 0; i < 11; i++) {
    line(i*width/11, 0, i*width/11, height);
    line(0, i*height/11, width, i*height/11);
  }
  flock.run();
  for (int i = 0; i < 11; i++) {
    for (int j = 0; j < 11; j++) {
      grid[i][j] = new ArrayList<Boid>();
    }
  }
  for (Boid boid: flock.boids) {
    boid.alignmult = slideralign;
    boid.separatemult = sliderseparate;
    boid.cohesionmult = slidercohesion;
    boid.viewmult = sliderview;
    boid.wallsmult = sliderwalls;
    grid[boid.column][boid.row].add(boid);
  }
}

void keyPressed() {
  if (key == ' ') {
    peripheralmode = !peripheralmode;
    if (peripheralmode) {
      for (Boid boid : flock.boids) {
        boid.peripheral = 240;
      }
    } else {
      for (Boid boid : flock.boids) {
        boid.peripheral = 360;
      }
    }
  }
  if (key == 'd') {
    shouldDisplay = !shouldDisplay;
  }
  if (key == 'r') {
    background(249);
    flock = new Flock();
    for (int i = 0; i < 3; i++) {
      Boid b = new Boid(new PVector(width/2 + random(0.001), height/2 + random(0.001)), 0.1, 1);
      flock.addBoid(b);
    }
  }
}

void mousePressed() {
  Boid b = new Boid(new PVector(mouseX, mouseY), 0.1, 1);
  flock.addBoid(b);
}