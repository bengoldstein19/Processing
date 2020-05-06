class Walker {
  float size,theta,t,u;
  PVector location;
  
  Walker() {
    location = new PVector (width/2, height/2);
    t=0;
    u=10000;
  }
  
  void step() {
    size = map(noise(t),0,1,0,10);
    theta = map(noise(u),0,1,0,360);
    
    location.x += size*cos(degrees(theta));
    location.y += size*sin(degrees(theta));
    
    t += 0.01;
    u += 0.01;
  }
  
  void display() {
    stroke(0);
    point(location.x,location.y);
  }
}

Walker w;

void setup() {
  size(640,360);
  background(255);
  w = new Walker();
}

void draw() {
  w.step();
  w.display();
}