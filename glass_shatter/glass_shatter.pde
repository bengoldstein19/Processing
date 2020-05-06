import java.util.Iterator;
import processing.sound.*;

ArrayList<ParticleSystem> systems;
ArrayList<GlassItem> glassitems;
boolean hammering;
int hammeringcount;
SoundFile file;

void setup() {
  size(1200, 800);
  background(255);
  strokeWeight(2);
  systems = new ArrayList<ParticleSystem>();
  glassitems = new ArrayList<GlassItem>();
  int numwindows = floor(random(5, 10));
  for (int i = 0; i < numwindows; i++) {
    glassitems.add(new GlassItem(random(width - 200), random(height - 200), random(100, 250), random(100, 250)));
  }
  hammering = false;
  hammeringcount = 0;
  file = new SoundFile(this, "glass.mp3");
}

void drawHammer() {
  pushMatrix();
  float thetaoffset = -PI/6;
  if (hammering) {
    thetaoffset = abs((hammeringcount - 10))*(-PI/60);
    hammeringcount++;
    if (hammeringcount == 21) {
      hammering = false;
      hammeringcount = 0;
    }
  }
  translate(mouseX, mouseY + 60);
  rotate(PI/3 + thetaoffset);
  stroke(0);
  fill(165, 42, 42);
  rect(-33, 5, 10, -60);
  fill(175);
  rect(-48, -65, 40, 10);
  popMatrix();
  fill(0, 255, 255, 120);
}

void init() {
  systems = new ArrayList<ParticleSystem>();
  glassitems = new ArrayList<GlassItem>();
  int numwindows = floor(random(5, 10));
  for (int i = 0; i < numwindows; i++) {
    glassitems.add(new GlassItem(random(200, width - 200), random(200, height - 200), random(100, 250), random(100, 250)));
  }
}

void draw() {
  background(255);
  for (ParticleSystem ps: systems) {
    ps.run();
  }
  for (GlassItem gi: glassitems) {
    gi.render();
  }
  Iterator<ParticleSystem> it = systems.iterator();
  while(it.hasNext()) {
    ParticleSystem ps = it.next();
    if (ps.particles.size() < 1) {
      it.remove();
    }
  }
  Iterator<GlassItem> iterator = glassitems.iterator();
  while(iterator.hasNext()) {
    GlassItem gi = iterator.next();
    if (!gi.unclicked) {
      iterator.remove();
    }
  }
  drawHammer();
}

class GlassItem {
  float posx;
  float posy;
  float boxw;
  float boxh;
  boolean unclicked;
  GlassItem(float x, float y, float w, float h) {
    posx = x;
    posy = y;
    boxw = w;
    boxh = h;
    unclicked = true;
  }
  void render() {
    if (unclicked) {
      stroke(0);
      fill(0, 255, 255, 120);
      rect(posx, posy, boxw, boxh);
    }
  }
}

class ParticleSystem {
  ArrayList<Particle> particles;
  ParticleSystem(float x, float y, float boxwidth, float boxheight) {
    file.play();
    particles = new ArrayList<Particle>();
    for (int i = 0; i < 15; i++) {
      for (int j = 0; j < 15; j ++) {
        float xcoord = i*boxwidth/15 + x;
        float ycoord = j*boxheight/15 + y;
        PVector radius = new PVector(xcoord - x - boxwidth/2, ycoord - y - boxheight/2);
        particles.add(new Particle(xcoord, ycoord, radius.x/20 + random(-5, 5), radius.y/20 + random(-5, 5)));
      }
    }
  }
  
  void run() {
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
  PVector position;
  PVector velocity;
  PVector acceleration;
  PShape shape;
  float angle;
  float angularvel;
  float angularacc;
  float lifespan;
  Particle(float x, float y, float vox, float voy) {
    position = new PVector(x,y);
    velocity = new PVector(vox, voy);
    acceleration = new PVector(0, 0.5);
    shape = createShape();
    shape.beginShape();
    int numsides = floor(random(3, 12));
    for (int i = 0; i < numsides; i++) {
      float r = random(5,15);
      float theta = TWO_PI*i/numsides;
      shape.vertex(r*cos(theta), r*sin(theta));
    }
    shape.endShape(CLOSE);
    angle = 0;
    angularvel = random(-0.01, 0.01);
    angularacc = random(-0.005, 0.005);
    lifespan = 255;
  }
  
  void run() {
    update();
    render();
  }
  
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    angularvel += angularacc;
    angle += angularvel;
    lifespan -= 2.0;
  }
  
  boolean isDead() {
    if (lifespan < 0) {
      return true;
    } else {
      return false;
    }
  }
  
  void render() {
    stroke(0);
    strokeWeight(2);
    fill(0, 255, 255, 120);
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    shape(shape, 0, 0);
    popMatrix();
  }
}

void mouseClicked() {
  hammering = true;
  for (GlassItem item: glassitems) {
    if (((mouseX > item.posx) && (mouseX < item.posx + item.boxw)) && ((mouseY > item.posy) && (mouseY < item.posy + item.boxh))) {
      item.unclicked = false;
      systems.add(new ParticleSystem(item.posx, item.posy, item.boxw, item.boxh));
    }
  }
}

void keyPressed() {
  if (key == 'g') {
    init();
  }
}