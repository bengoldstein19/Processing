class Graph {
  int[] infectionData;
  int[] recoveryData;
  int bar_width;
  int current_index;
  int len;
  Graph() {
    current_index = 0;
    bar_width = 3;
    len = floor(width / bar_width);
    infectionData = new int[len];
    recoveryData = new int[len];
    for (int i = 0; i < len; i++) {
      recoveryData[i] = 0;
      infectionData[i] = 0;
    }
    infectionData[0] = 1;
  }
  
  void update_data(Community community) {
    if (current_index < len - 1) {
      current_index += 1;
      infectionData[current_index] = community.infected;
      recoveryData[current_index] = community.recovered;
    } else {
      for (int i = 0; i < len - 1; i++) {
        infectionData[i] = infectionData[i+1];
        recoveryData[i] = recoveryData[i+1];
      }
      infectionData[len - 1] = community.infected;
      recoveryData[len - 1] = community.recovered;
    }
  }
  
  void display(Community community) {
    fill(100);
    rect(0, 0, width, community.upper_margin);
    int total = community.numballs;
    for (int i = 0; i < current_index; i++) {
      noStroke();
      fill(0, 255, 0);
      rect(i*width/len, 0, bar_width, community.upper_margin*recoveryData[i]/total);
      fill(0, 0, 255);
      rect(i*width/len, community.upper_margin*recoveryData[i]/total, bar_width, community.upper_margin*(total - recoveryData[i] - infectionData[i])/total);
      fill(255, 0, 0);
      rect(i*width/len, community.upper_margin*(total - infectionData[i])/total, bar_width, community.upper_margin*infectionData[i]/total);
    }
  }
  
}

class Community {
  int infected;
  int recovered;
  float speed;
  int rad;
  int numballs;
  int upper_margin;
  Ball[] balls;
  Community(int numballs_, int rad_, float speed_, int upper_margin_) {
    infected = 1;
    recovered = 0;
    numballs = numballs_;
    rad = rad_;
    speed = speed_;
    numballs = numballs_;
    upper_margin = upper_margin_;
    balls = new Ball[numballs];
    for (int i = 0; i < numballs; i++) {
      balls[i] = new Ball(speed, rad, random(0,width), random(upper_margin, height));
      balls[i].mobile = false;
      if (i % 6 == 0) {
        balls[i].mobile = true;
      }
    }
    balls[0].infected = true;
  }
  
  void update() {
    for (int i = 0; i < numballs; i++) {
      balls[i].update();
      if (balls[i].frames_infected >= 1500/speed && balls[i].infected) {
        balls[i].infected = false;
        balls[i].recovered = true;
        recovered++;
        infected--;
      }
    }
  }
  
  void display() {
    for (int i = 0; i < numballs; i++) {
      balls[i].display();
    }
  }
  
  void detect_collisions() {
    for (int i = 0; i < numballs; i++) {
      Ball balli = balls[i];
      if (balli.x < rad) {
        balls[i].x = rad;
        balls[i].velx = abs(balli.velx);
      } else if (balli.x > width - rad) {
        balls[i].x = width - rad;
        balls[i].velx = (-1)*abs(balli.velx);
      }
      if (balli.y < upper_margin + rad) {
        balls[i].y = upper_margin + rad;
        balls[i].vely = abs(balli.vely);
      } else if (balli.y > height - rad) {
        balls[i].y = height - rad;
        balls[i].vely = (-1)*abs(balls[i].vely);
      }
      for (int j = 0; j < numballs; j++) {
        if (i != j) {
          Ball ballj = balls[j];
          float dist = sqrt((ballj.x - balli.x)*(ballj.x - balli.x) + (ballj.y - balli.y)*(ballj.y - balli.y));
          if (dist < 2*rad) {
            float coordvectorx1 = ballj.x - balli.x;
            float coordvectory1 = ballj.y - balli.y;
            float mag = sqrt(coordvectorx1*coordvectorx1 + coordvectory1*coordvectory1);
            coordvectorx1 = coordvectorx1/mag;
            coordvectory1 = coordvectory1/mag;
            float coordvectorx2 = -coordvectory1;
            float coordvectory2 = coordvectorx1;
            float cofactor_coeff = (1/(coordvectorx1*coordvectory2 - coordvectorx2*coordvectory1));
            float ballivel1 = cofactor_coeff*(balli.velx*coordvectory2 + balli.vely*coordvectorx2);
            float ballivel2 = cofactor_coeff*(balli.vely*coordvectorx1 - balli.velx*coordvectory1);
            float balljvel1 = cofactor_coeff*(ballj.velx*coordvectory2 + ballj.vely*coordvectorx2);
            float balljvel2 = cofactor_coeff*(ballj.vely*coordvectorx1 - ballj.velx*coordvectory1);
            if (!balli.mobile) {
              balljvel1 = abs(balljvel1)*1.01;
            } else if (!ballj.mobile) {
              ballivel1 = -abs(ballivel1)*1.01;
            } else {
              ballivel1 = -abs(balljvel1);
              balljvel1 = abs(ballivel1);
            }
            balls[i].velx = coordvectorx1*ballivel1 + coordvectorx2*ballivel2;
            balls[i].vely = coordvectory1*ballivel1 + coordvectory2*ballivel2;
            balls[j].velx = coordvectorx1*balljvel1 + coordvectorx2*balljvel2;
            balls[j].vely = coordvectory1*balljvel1 + coordvectory2*balljvel2;
            if (balli.infected && !ballj.infected && !ballj.recovered) {
              balls[j].infected = true;
              infected += 1;
            }
            else if (ballj.infected && !balli.infected && !balli.recovered) {
              balls[i].infected = true;
              infected += 1;
            }
          }
        }
      }
    }
  }
}

class Ball {
  boolean infected;
  boolean recovered;
  float x;
  float y;
  float velx;
  float vely;
  float speed;
  int rad;
  int frames_infected;
  boolean mobile;
  
  Ball(float speed_, int rad_, float x_, float y_) {
    infected = false;
    recovered = false;
    speed = speed_;
    rad = rad_;
    x = x_;
    y = y_;
    velx = random((-1)*speed, speed);
    vely = (round(random(0,1))*2 - 1)*sqrt(speed*speed - velx*velx);
    frames_infected = 0;
  }
  
  void update() {
    velx = velx*speed/sqrt(velx*velx + vely*vely);
    vely = vely*speed/sqrt(velx*velx + vely*vely);
    if (!mobile) {
      velx = 0;
      vely = 0;
    }
    x += velx;
    y += vely;
    if (infected) {
      frames_infected++;
    }
  }
  
  void display() {
    noStroke();
    fill(125);
    if (infected) {
      fill(255,0,0);
    } else if (recovered) {
      fill(0,255,0);
    }
    ellipse(x, y, 2*rad, 2*rad);
  }
}

Community community;
Graph graph;
int current_frame;
boolean over;

void setup() {
  size(800,600);
  init();
}

void init() {
  background(255);
  community = new Community(200, 5, 2, 100);
  graph = new Graph();
  current_frame = 0;
  over = false;
}

void draw() {
  if (!over) {
    fill(255);
    rect(0, community.upper_margin, width, height - community.upper_margin);
    community.detect_collisions();
    community.update();
    community.display();
    current_frame++;
    if (current_frame == ceil(20/community.speed)) {
      current_frame = 0;
      graph.update_data(community);
      graph.display(community);
      println(community.infected);
      if (community.infected == 0) {
        over = true;
        background(255);
        text("Click to Restart", width/2, height/2);
      }
    }
  }
}

void mouseClicked() {
  if (over) {
    init();
    over = false;
  }
}