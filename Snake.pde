//x and y together capture the coordinates (squares really) of the snake as it
//has squares added to the front (when it advances) and removed from the rear 
//when it does not hit the apple).
ArrayList<Integer> x = new ArrayList <Integer>();
ArrayList<Integer> y = new ArrayList <Integer>();

//array list of mines
ArrayList<Integer> mineX = new ArrayList <Integer>();
ArrayList<Integer> mineY = new ArrayList <Integer>();

//random coordinates for mines
int randomNumberMineX;
int randomNumberMineY;

//random coordinates for apple
int randomTempNumberAppleX;
int randomTempNumberAppleY;

//Note that height and width are variables provided by the Processing environment
//so we don't want to override them in our code, hence w and h for variable names.
int w = 30;              //Width of the board
int h = 30;              //Height of the board
int bs = 20;             //block size
/* dx and dy are direction vectors.  The dir variable indexs into dx and dy
to control the direction the snake takes for the next advance. A value of 0
for dir means that dx is 0 and dy is 1, which sends the snake south.  1 sends
the snake north, 2 sends it east and 3 sends it west.  Remember that the 
coordinates increase as we move away from origin in the upper left corner of the 
screen.*/
int [] dx = {0, 0, 1, -1};
int [] dy = {1, -1, 0, 0};
int dir = 2;             //The next direction to take
//Coordinates of the apple.  The snake gets longer each time it "eats" the apple.
int applex = 12;
int appley = 10;
boolean gameover = false;      //flag to show whether game is done or not.
boolean headCrossed = false;   //flag to show if the head crossed itself
boolean mineHit = false;
boolean mineOverlapsMine = false;
boolean mineOverlapsApple = false;
boolean mineOverlapsSnake = false;
boolean validMineLocation = false; //flag to show if a mine location is allowed
boolean validAppleLocation = false;

int [] colors = {#266C1B, #E89E25, #2D3FDE, #C10A35, #EBF018};
final int initialFrameRate = 10;
void setup () {
  //600 = width * bs and height * bs.  If you change any of those three variables,
  //be sure to change the arguments to the size function accordingly.
  size (600, 600);            //size will only take literals, not variables
  x.add(5);              //Just a random starting position for the snake
  y.add(5);
  frameRate (initialFrameRate);              //start slow to make the game easier.
}
void draw () {
  background(255);            //make the background white
  //Create a grid pattern on the screen with vertical and horizontal lines
  for (int i = 0; i < width; i++) {
    line (i*bs, 0, i*bs, height);
  }
  for (int i = 0; i < height; i++) {
    line (0, i * bs, width, i * bs);
  }
  for (int i = 0; i < x.size(); i++) {      //draw the snake
//    fill(0, 255, 0);
    fill(colors[i % colors.length]);
    rect(x.get(i)*bs, y.get(i)*bs, bs, bs);
  }
  if (!gameover) {
    //draw the apple
    fill(255, 0, 0);
    rect(applex * bs, appley * bs, bs, bs);
    
    //draw the mines
    for(int i = 0; i < mineX.size(); i++)
    {
      fill(0, 0, 0);
      rect(mineX.get(i) * bs, mineY.get(i) * bs, bs, bs);
    }
  }    
  if (!gameover) {
    if (frameCount % 5 == 0) {
      x.add(0, x.get(0) + dx[dir]);
      y.add(0, y.get(0) + dy[dir]);
      //Make sure that we do not run off the edge of the board
      if (x.get(0) < 0 || y.get(0) < 0 || x.get(0) >= w || y.get(0) >= h) {
        gameover = true;
      }
      //check if the head is at the same location as any other part of the snake
      for(int i = 1; i < x.size(); i++)
      {
        if(x.get(0) == x.get(i) && y.get(0) == y.get(i))
        {
          headCrossed = true;
        }
      }
      
      //check if head is at the same location as any mine
      for(int i = 0; i < mineX.size(); i++)
      {
        if(x.get(0) == mineX.get(i) && y.get(0) == mineY.get(i))
        {
          mineHit = true;
        }
      }
      
      if(headCrossed || mineHit)
      {
        gameover = true;
      }
      //See if we've hit the apple
      if(x.get(0) == applex && y.get(0) == appley) {
        
        while(!validAppleLocation)
        {
          randomTempNumberAppleX = (int) random(0, w);
          randomTempNumberAppleY = (int) random(0, h);
          
          //check if the temp apple coordinates overlap with an existing mine coordinate
          for(int i = 0; i < mineX.size(); i++)
          {
            if(randomTempNumberAppleX == mineX.get(i) && randomTempNumberAppleY == mineY.get(i))
            {
              validAppleLocation = false;
              break;
            }
            else
            {
              validAppleLocation = true;
            }
          }
          
          //case where there are no mines
          if(mineX.size() == 0)
          {
            validAppleLocation = true;
          }
        }
        applex = randomTempNumberAppleX;      //Reposition the apple
        appley = randomTempNumberAppleY;      //Don't make the snake shorter
        
        validAppleLocation = false;
        
        while(!validMineLocation)
        {
          //since we hit an apple make a mine at a random location. get a random number
          randomNumberMineX = (int) random(0, w);
          randomNumberMineY = (int) random(0, h);
          //need to check if a mine already exists at a location, check apple and snake location
          //check the mine locations
          for(int i = 0; i < mineX.size(); i++)
          {
            if(randomNumberMineX == mineX.get(i) && randomNumberMineY == mineY.get(i))
            {
              mineOverlapsMine = true;
              break;
            }
            else
            {
              mineOverlapsMine = false;
            }
          }
          
          //check apple
          if(randomNumberMineX == applex && randomNumberMineY == appley)
          {
            mineOverlapsApple = true;
          }
          else
          {
            mineOverlapsApple = false;
          }
          
          //check snake
          for(int i = 0; i < x.size(); i++)
          {
            if(randomNumberMineX == x.get(i) && randomNumberMineY == y.get(i))
            {
              mineOverlapsSnake = true;
              break;
            }
            else
            {
              mineOverlapsSnake = false;
            }
          }
          
          if(mineOverlapsMine || mineOverlapsApple || mineOverlapsSnake)
          {
            validMineLocation = false;
          }
          else
          {
            validMineLocation = true;
          }
        
        }
        mineX.add(randomNumberMineX);
        mineY.add(randomNumberMineY);
        
        validMineLocation = false;
      

        frameRate(frameRate + frameRate / 10);
      } else {                      //Trim off the last element in the snake
        x.remove(x.size() - 1);
        y.remove(y.size() - 1);
      }
    }
  } else if (gameover) {
    fill (0);
    textSize(30);
    textAlign(CENTER);
    text("GAME OVER. Press space bar to resume.", width/2, height/2);
    if(keyPressed && key == ' ') {      //user wants to resume
      frameRate(initialFrameRate);      //start over with the speed of the game
      x.clear();
      y.clear();
      mineX.clear();
      mineY.clear();
      x.add(5);
      y.add(5);
      gameover = false;
      headCrossed = false;
      mineHit = false;
    }
  }
}
void keyPressed () {
  /*
  The "a" key starts the snake going left, "d" sends it right, "w" sends it up 
  and "s" sends it down.  The way to remember which is which is by their position
  on the qwerty keyboard.
  
  The dir variable is the index into the dx and dy vectors that we use when we add
  a new set of x,y coordinates to the front of the arraylist of points that represents
  our snake.
  */
  println("Key pressed is: " + key);
  int newdir = (key == 's' || keyCode == DOWN) ? 0 : ((key == 'w' || keyCode == UP) ? 1 : ((key == 'd' || keyCode == RIGHT) ? 2 : ((key == 'a' || keyCode == LEFT) ? 3 : -1)));
  if(x.size() > 1)
  {
    if(newdir == 0 && dir == 1)
    {
      newdir = -1;
    }
    
    if(newdir == 1 && dir == 0)
    {
      newdir = -1;
    }
    
    if(newdir == 2 && dir == 3)
    {
      newdir = -1;
    }
    
    if(newdir == 3 && dir == 2)
    {
      newdir = -1;
    }
    
  }
  if (newdir != -1) dir = newdir;
}
