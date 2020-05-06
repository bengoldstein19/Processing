PaintDot paintdot; //Tells code you will make a PaintDot called paintdot

void setup() {
  size(600, 400); //makes window 600 by 400
  background(255); //draws white background
  paintdot = new PaintDot(); //creates a paintdot with values of all zero for x, y, r, g, b
  //We will reuse this paintdot each time so we don't have to make new ones every time we draw one
  //This increases performance, making a lot of objects is not best practices
  
  //draw 100k dots
  for (int i = 0; i < 100000; i++) {
    drawDot();
  }
}

//Don't need to do anything repeatedly here
//void draw() {
//  drawDot(); //draw a dot 60 times per second
//}

//code to draw a dot
void drawDot() {
  //Generate 5 gaussian numbers, one for each degree of freedom of the paintdot
  for (int i = 0; i < 5; i++) {
    float gaussNum = (float) randomGaussian(); //Generates number on gaussian distribution, mean = 0 sd = 1
    if (i == 0) { //Code to generate x coordinate of dot
      float sd = width/8; //standard deviation is width/8
      float mean = width/2; //mean is center
      paintdot.x = gaussNum*sd + mean; //dilates and translates point to fit new sd and mean, and sets paintdots x property to that
    } else if (i == 1) { //Code to generate y coordinate of dot
      float sd = height/8; //standard deviation is height/8
      float mean = height/2; //mean is center
      paintdot.y = gaussNum*sd + mean; //dilates and translates point to fit new sd and mean, and sets paintdots y property to that
    } else if (i == 2) { //Code to generate red constant of paintdot
      float sd = 255/32; //standard deviation is 1/32 of range of possibilities
      float mean = 175; //mean is red component of turquoise
      paintdot.r = gaussNum*sd + mean; //dilates and translates, and sets paintdots r property to that
    }
    else if (i == 3) { //code to generate green constant of paintdot
      float sd = 255/32; //standard deviation is 1/32 of range of possibilities
      float mean = 238; //mean is green component of turquoise
      paintdot.g = gaussNum*sd + mean; //dilates and translates, sets paintdots g property to that
    }
    else if (i == 4) { //code to generate blue constant of paintdot
      float sd = 255/32; //standard deviation is 1/32 of range of possibilities
      float mean = 238; //mean is blue component of turquoise
      paintdot.b = gaussNum*sd + mean; //dilates and translates, sets paintdots b property to that
    }
  }
  paintdot.display(); //calls display function from paintdot class to draw paintdot
}

class PaintDot { //paintdot class

//location and color properties
  float x;
  float y;
  float r;
  float g;
  float b;
  
  //initialization code sets each property to zero to start
  PaintDot() {
    x = 0;
    y = 0;
    r = 0;
    g = 0;
    b = 0;
  }
  //draws points of appropriate color at appropriate location to display
  void display() {
    noStroke();
    fill(r, g, b);
    ellipse(x, y, 1, 1);
  }
}