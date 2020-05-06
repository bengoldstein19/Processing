void setup()
{
  size(1200, 800);
  background (0);
  fill (255);
  stroke(255, 0, 0);
}
boolean gameover = false;
int xpaddle = 600;
float xball = 600;
float y = 25;
float xvel = random(3,9);
float yvel = random(3,9);
int score = 0;
void draw()
{
  if (gameover == false)
  {
    background (0);
    textSize(40);
    text(score, 600, 100);
    rect(xpaddle - 125, 790, 250, 10);
    if (keyPressed)
    {
      if (key == CODED)
      {
        if (xpaddle > 125 & keyCode == LEFT)
        {
          xpaddle= xpaddle - 12;
        }
        if (xpaddle < 1075 & keyCode == RIGHT)
        {
          xpaddle = xpaddle + 12;
        }
      }
    }
    xvel = xvel +.01;
    yvel = yvel + .01;
    ellipse(xball,y,50,50);
    xball = xball + xvel;
    y = y + yvel;
    if(xball <= 25)
    {
      xvel = -xvel;
    } //abbie is a butt
    if (xball >= 1175)
    {
      xvel = -xvel;
    }
    if (y <= 25)
    {
      yvel = -yvel;
    }
    if (y >= 775)
    {
      if (abs(xball - xpaddle) < 150)
      {
        yvel = -yvel;
        score = score + 1;
      }
      else
      {
        xball = 600;
        y = 25;
        xvel = 0;
        yvel = 0;
        xpaddle = 0;
        textSize(50);
        text ("Game Over, Press B to Play Again", 200, 400);
        gameover = true;
      }
    }
    if (xvel > 0)
    {
      xvel = xvel + .005;
    }
    else if (xvel < 0)
    {
      xvel = xvel -.005;
    }
    if (yvel > 0)
    {
      yvel = yvel + .005;
    }
    else if (yvel < 0)
    {
      yvel = yvel -.005;
    }
  }
  else if (gameover == true)
  {
    if(keyPressed)
    {
       if(key == 'b' | key =='B')
       {
         score = 0;
         xpaddle = 600;
         y = 25;
         xball = 600;
         xvel = random(3,9);
         yvel = random(3,9);
         gameover = false;
       }
     }
   }
}  
    