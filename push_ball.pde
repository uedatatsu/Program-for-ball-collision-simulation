//////////////////////////////////////
//
//  Program for ball collision simulation
//  last update: 2018.05.11
//
//////////////////////////////////////

float SPEED=5;  //speed
float R=25;  //radius
int NUMBER=31;  //number of ball
float b_speed=1.01;  //increase rate of speed after collide

int[] flg = new int[1000];
int flg_num;
Ball[] balls=new Ball[NUMBER];

void setup(){
  size(750,750);  //window size
  frameRate(20);
  background(255);  
  noLoop(); 

  float angle = TWO_PI/NUMBER;
  for(int i=0;i<NUMBER;i++){
    float addx=cos(angle*i);
    float addy=sin(angle*i);
    balls[i]=new Ball(width/2+addx*300,height/2+addy*300,SPEED*addx+1,SPEED*addy+1,i,balls);  //start position, start speed
  }  //strat position
}

void draw(){
  fadeToBlack();
  background(255);  //background color
  for(int i=0;i<NUMBER;i++){
    balls[i].clearVector();
  }
  for(int i=0;i<NUMBER;i++){
    flg_num=i;
    Ball ball=(Ball)balls[i];
    ball.collide();
    //println(i +" "+ flg[i] );  //ball num & collide num
    ball.move();
    ball.draw();
    
  }
  //saveFrame("frames/######.tif");  //save capture
}

class Ball 
{
  float x,y;
  float vx,vy;
  PVector target=new PVector();
  PVector impulse=new PVector(1,1);
  int id;
  Ball[] others;

  Ball(float _x,float _y,float _vx,float _vy,int _id, Ball[] _others){
    x=_x;
    y=_y;
    vx=_vx;
    vy=_vy;
    id=_id;
    others=_others;
  }
  
  //moving
  void move(){
    vx*=impulse.x;
    x=x+vx+target.x;
    if(x-R<=0){
      x=R;
      vx*=-1;
    }
    if(x+R>=width){
      x=width-R;
      vx*=-1;
    }
    
    vy*=impulse.y;
    y=y+vy+target.y;
    if(y-R<=0){
      y=R;
      vy*=-1;
    }
    if(y+R>=height){
      y=height-R;
      vy*=-1;
    }
  }
  
  void draw(){
    fill(255);
    for(int i=255;i>0;i--){
      if(flg[flg_num]<=i){
        fill(i*4,0,255-4*i);  //blue to red
      }
    }
    stroke(0);
    ellipse(x,y,R*2,R*2);
  }
  
  void clearVector(){
    target.x=0;
    target.y=0;
    impulse.x=1;
    impulse.y=1;
  }
  
  //collide
  void collide(){
    for(int i=id+1;i<NUMBER;i++){
      Ball otherBall = (Ball)others[i];
      
      float dx=otherBall.x-x;
      float dy=otherBall.y-y;
      float distance=sqrt(dx*dx+dy*dy);
      
      if(distance<=R*2){
        float angle=atan2(dy,dx);
        float push_distance=R*2-distance;
        float push_x=push_distance*cos(angle);
        float push_y=push_distance*sin(angle);
        
        target.x-=push_x;
        target.y-=push_y;
        otherBall.target.x+=push_x;
        otherBall.target.y+=push_y;
        flg[i]++;  //incrase collide num of ball
        flg[id]++;  //incrase collide num of otherBall
        if((vx>=0&&vx-otherBall.vx>=0)||(vx<0&&vx-otherBall.vx<0)){
          impulse.x=-b_speed;
        }
        if(vx*otherBall.vx<=0){
          otherBall.impulse.x=-b_speed;
        }
        if((vy>=0&&vy-otherBall.vy>=0)||(vy<0&&vy-otherBall.vy<0)){
          impulse.y=-b_speed;
        }
        if(vy*otherBall.vy<=0){
          otherBall.impulse.y=-b_speed;
        }
      }
    }
  }
}

void fadeToBlack(){
  noStroke();
  fill(0,60);
  rectMode(CORNER);
  rect(0,0,width,height);
}

//press start
void mousePressed() {
  loop();     
}

  
  

  
  
