PVector ball;
PVector vel;
PVector gravity;


void setup()
{
  size(1200,800);
  background (0);
  fill(255);
  stroke(255,0,0);
  ball = new PVector (width/2,25);
  vel = new PVector (1,10);
  gravity = new PVector (0,2);
}

void draw()
{
  ellipse(ball.x, ball.y, 50, 50);
  background(0);
  stroke(255);
  if(ball.y > height - 25 && vel.y > 0)
  {
    vel.y = -vel.y;
  }
  if (ball.y < 25 && vel.y < 0) {
    vel.y = -vel.y;
  }
  if(ball.x < 25 && vel.x < 0)
  {
    vel.x = -vel.x;
  }
  if (ball.x > width - 25 && vel.x > 0) {
    vel.x = -vel.x;
  }
  ball.add(vel);
  vel.add(gravity);
}