Fly[] flies = new Fly[10];
int t;

void setup() {
  size(800,800);
  t = 0;
  background(0,0,255);
  for (int i = 0; i < flies.length; i++) {
    flies[i] = new Fly();
  }
}

void draw() {
  background(0,0,255);
  fill(52.9 * 2.55, 80.8 * 2.55, 92.2 * 2.55);
  quad(0,0,width,0,width,height/4,0,height/4);
  fill(255,255 - 0.25*abs(width/2 - t % (width - 40)),0);
  ellipse(20 + t % (width - 40), 65 + 0.25*abs(width/2 - 20 - t % (width - 40)),150,150);
  fill(0,255,0);
  quad(0,height/4,width,height/4,width,height/2,0,height/2);
  for (int i = 0; i < flies.length; i++) {
    flies[i].update();
    flies[i].checkedges();
    flies[i].render();
  }
  t++;
}

class Fly {
  PVector velocity;
  PVector location;
  PVector acceleration;
  int t;
  int moveroffset;
  float direction;
  
  Fly() {
    moveroffset = int(random(10000));
    t = 0;
    acceleration = new PVector (noise(moveroffset), noise(100*moveroffset));
    velocity = new PVector (random(2)-1,random(2)-1);
    location = new PVector (random(width), random(height/2));
    direction = acos(velocity.x/sqrt(velocity.x*velocity.x + velocity.y*velocity.y));
  }
  
  void update() {
    acceleration.x = 2*noise(2*t + moveroffset) - 1;
    acceleration.y = 2*noise(2*t + 100*moveroffset) - 1;
    velocity.add(acceleration);
    if (mag(velocity.x, velocity.y) > 10) {
      velocity.x = velocity.x * sqrt(10)/mag(velocity.x, velocity.y);
      velocity.y = velocity.y * sqrt(10)/mag(velocity.x, velocity.y);
    }
    float random = random(100);
    if (random > 99.8){
      velocity.x = -velocity.x;
      velocity.y = -velocity.y;
    }
    if ((velocity.x == 0) && (velocity.y == 0)) {
      direction = 0;
    }
    else if (velocity.y >= 0) {
      direction = acos(velocity.x/sqrt(velocity.x*velocity.x + velocity.y*velocity.y));
    } else {
      direction = -acos(velocity.x/sqrt(velocity.x*velocity.x + velocity.y*velocity.y));
    }
    location.add(velocity);
    t++;
  }
  
  void checkedges() {
    if (location.x > width){
      velocity.x = -velocity.x;
      location.x = width - 0.01;
    }
    else if (location.x < 0) {
      velocity.x = -velocity.x;
      location.x = 0.01;
    }
    if (location.y > height/2) {
      velocity.y = -velocity.y;
      location.y = height/2 - 0.01;
    }
    else if (location.y < 0) {
      velocity.y = -velocity.y;
      location.y = 0.01;
    }
  }
  void render() {
    stroke(255,0,0);
    fill(0,255,0);
    ellipse(location.x + 40*cos(direction), location.y + 40*sin(direction), 10, 10);
    stroke(0);
    fill(255,0,255);
    quad(location.x, location.y, location.x + 20*cos(direction + PI/2) + 5*cos(PI + direction), location.y + 20*sin(direction + PI/2) + 5*sin(PI + direction), location.x + 40*cos(direction + PI/2), location.y + 40*sin(direction + PI/2), location.x + 20*cos(direction + PI/2) - 5*cos(PI + direction), location.y + 20*sin(PI/2 + direction) - 5*sin(PI + direction));
    quad(location.x, location.y, location.x - 20*cos(direction + PI/2) + 5*cos(PI + direction), location.y - 20*sin(direction + PI/2) + 5*sin(PI + direction), location.x - 40*cos(direction + PI/2), location.y - 40*sin(direction + PI/2), location.x - 20*cos(direction + PI/2) - 5*cos(PI + direction), location.y - 20*sin(PI/2 + direction) - 5*sin(PI + direction));
    line(location.x + 40*cos(direction), location.y + 40*sin(direction), location.x - 40*cos(direction), location.y -40*sin(direction));
    line(location.x + 40*cos(direction + PI/2), location.y + 40*sin(direction + PI/2), location.x - 40*cos(direction + PI/2), location.y -40*sin(direction + PI/2));
  }
}