boolean debug = true;

Path path;

ArrayList<Follower> followers;

void setup() {
  size(640, 360);
  path = new Path();
  followers = new ArrayList<Follower>();
  for (int i = 0; i < 5; i++) {
    followers.add(new Follower(new PVector(random(width), random(height)), 2, 0.1));
  }
}

void draw() {
  background(255);
  path.display();
  for (Follower car : followers) {
    car.separate(followers);
    car.follow(path);
    car.run();
    car.borders(path);
  }
  
  fill(0);
  text("Hit space bar to toggle debugging lines.", 10, height-30);
}

public void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  } else if (key == 'r') {
    path = new Path();
  }
}

public void mousePressed() {
  followers.add(new Follower(new PVector(mouseX, mouseY), 2, 0.1));
}

class Path {
  ArrayList<PVector> points;
  float radius;
  float numpointsminusone;
  float horizrad;
  float vertrad;
  
  Path() {
    radius = 20;
    horizrad = width/2 - random(10)*width/40;
    vertrad = height/2 - random(10)*height/40;
    numpointsminusone = 60;
    points = new ArrayList<PVector>();
    for (int i = 0; i < numpointsminusone + 1; i++) {
      //addPoint(width/2 + horizrad*cos(i*TWO_PI/numpointsminusone), height/2 + vertrad*sin(i*TWO_PI/numpointsminusone));
      float t = i*TAU/numpointsminusone;
      float a = width/2 - 40;
      addPoint(a*cos(t)/(sq(sin(t)) + 1) + width/2, height/2 + a*sin(t)*cos(t)/(1 + sq(sin(t))));
    }
    //addPoint(0, random(height));
    //addPoint(random(width/2), random(height));
    //addPoint(random(width/2) + width/2, random(height));
    //addPoint(width, random(height));
  }
  
  void addPoint(float x, float y) {
    PVector point = new PVector(x,y);
    points.add(point);
  }
  
  void display() {
    stroke(0, 100);
    strokeWeight(radius*2);
    noFill();
    beginShape();
    for (PVector v : points) {
      vertex(v.x,v.y);
    }
    endShape();
    stroke(0);
    strokeWeight(1);
    noFill();
    beginShape();
    for (PVector v : points) {
      vertex(v.x,v.y);
    }
    endShape();
  }
}


class Follower {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float maxspeed;
  float maxforce;
  float trumaxsteer;
  float r;
  Follower(PVector l, float ms, float mf) {
    location = new PVector(l.x, l.y);
    acceleration = new PVector(0, 0);
    maxspeed = ms;
    maxforce = mf;
    trumaxsteer = mf;
    if (height > height/2) {
      velocity = new PVector(random(0.01), random(0.01));
    } else {
      velocity = new PVector(random(0.01), random(0.01));
    }
    r = 4;
  }
  
  void separate(ArrayList<Follower> vehicles) {
    float desiredseparation = 5*r;
    PVector sum = new PVector();
    int count = 0;
    
    for (Follower other : vehicles) {
      float d = PVector.dist(location, other.location);
      
      if ((d > 0) && (d < desiredseparation)) {
        PVector diff = PVector.sub(location, other.location);
        diff.normalize().div(d/desiredseparation);
        sum.add(diff);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.setMag(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce*2);
      acceleration.add(steer);
    }
  }
  
  public void run() {
    update();
    render();
  }
  
  void follow(Path p) {
    PVector future = velocity.copy();
    future.normalize().mult(50);
    future.add(location);
    PVector normal = null;
    PVector target = null;
    float worldRecord = 1000000;
 
    for (int i = 0; i < p.points.size()-1; i++) {
      PVector a = p.points.get(i);
      PVector b = p.points.get(i+1);
      PVector normalPoint = getNormalPoint(future, a, b);
      if (normalPoint.x < a.x || normalPoint.x > b.x) {
        normalPoint = b.copy();
      }
 
      float distance = PVector.dist(future, normalPoint);
 
      if (distance <= worldRecord) {
        worldRecord = distance;
        normal = normalPoint.copy();
        PVector dir = PVector.sub(b, a);
        dir.normalize();
        dir.mult(worldRecord/velocity.mag());
        target = normalPoint.copy();
        target.add(dir);
      }
    };
    float distance = PVector.dist(future, normal);
    if (distance > p.radius) {
      seek(target, maxforce);
    } else {
      float maxsteer = trumaxsteer*(worldRecord/p.radius);
      seek(target, maxsteer);
    }
    if (debug) {
      fill(0);
      stroke(0);
      line(location.x, location.y, future.x, future.y);
      ellipse(future.x, future.y, 4, 4);

      // Draw normal position
      fill(0);
      stroke(0);
      line(future.x, future.y, normal.x, normal.y);
      ellipse(normal.x, normal.y, 4, 4);
      stroke(0);
      if (distance > p.radius) fill(255, 0, 0);
      noStroke();
      ellipse(target.x, target.y, 8, 8);
    }
  }
  
  PVector getNormalPoint(PVector point, PVector starting, PVector ending) {
    PVector startToPoint = PVector.sub(point, starting);
    PVector startToEnd = PVector.sub(ending, starting);
    startToEnd.normalize();
    float dotproduct = startToPoint.dot(startToEnd);
    startToEnd.mult(dotproduct);
    PVector normalP = PVector.add(starting, startToEnd);
    return normalP;
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  void seek(PVector destination, float maxf) {
    PVector desiredvel = PVector.sub(destination, location);
    if (desiredvel.mag() == 0) return;
    desiredvel.normalize();
    desiredvel.mult(maxspeed);
    PVector steer = PVector.sub(desiredvel, velocity);
    steer.limit(maxf);
    applyForce(steer);
  }
  
  void render() {
    float theta = velocity.heading()  + HALF_PI;
    fill(175);
    stroke(0);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    beginShape(PConstants.TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, 2*r);
    endShape();
    popMatrix();
  }
  
  void borders(Path p) {
    if (location.x > p.points.get(p.points.size() - 1).x + r) {
      location.x = p.points.get(0).x - r;
      location.y = p.points.get(0).y + (location.y - p.points.get(p.points.size() - 1).y);
    }
  }
  
}