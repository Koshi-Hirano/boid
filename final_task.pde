import processing.opengl.*;

float width_box = 700;
float height_box = 700;
float depth_box = 700;
int count = 0;
int MAX_COUNT = 3600;
  
void DrawBox(){
  pushMatrix();
    noFill();
    stroke(220);
    strokeWeight(5);
    box(width_box, height_box, depth_box);
  popMatrix();
}

class Boint {
  PVector pos;
  PVector v;
  int id;
  float radius = 20;
  color c;
  PVector v1 = new PVector(0, 0, 0);
  PVector v2 = new PVector(0, 0, 0);
  PVector v3 = new PVector(0, 0, 0);
  
  Boint(PVector position, PVector velocity, int identity, color co){
    pos = new  PVector(position.x, position.y, position.z);
    v = new PVector(velocity.x, velocity.y, velocity.z);
    id = identity;
    c = co;
  }
  
  void Update(){
    int MAX_SPEED = 4;
    v.x += 0.001 * v1.x + 0.8 * v2.x + 0.1 * v3.x;
    v.y += 0.001 * v1.y + 0.8 * v2.y + 0.1 * v3.y;
    v.z += 0.001 * v1.z + 0.8 * v2.z + 0.1 * v3.z;
    
    float movement = sqrt(v.x*v.x + v.y*v.y + v.z*v.z);
    if(movement > MAX_SPEED){
      v.x = (v.x / movement) * MAX_SPEED;
      v.y = (v.y / movement) * MAX_SPEED;
      v.z = (v.z / movement) * MAX_SPEED;
    }
    
    pos.x += v.x;
    pos.y += v.y;
    pos.z += v.z;
    
    if(pos.x < -width_box/2){
      pos.x = width_box + pos.x;
    }
    else if(width_box/2 < pos.x){
      pos.x = pos.x - width_box;
    }
    
    if(pos.y < -height_box/2){
      pos.y = height_box + pos.y;
    }
    else if(height_box/2 < pos.y){
      pos.y = pos.y - height_box;
    }
    
    if(pos.z < -depth_box/2){
      pos.z = depth_box + pos.z;
    }
    else if(depth_box/2 < pos.z){
      pos.z = pos.z - depth_box;
    }
  }
  
  void Draw(ArrayList<Boint> boids){
    v1.set(0, 0, 0);
    v2.set(0, 0, 0);
    v3.set(0, 0, 0);
    
    GetToCenterVector(boids);
    GetAvoidanceVector(boids);
    GetAverageVelocityVector(boids);
    Update();
    //描画
    pushMatrix();
      translate(pos.x, pos.y, pos.z);
      noStroke();
      fill(c);
      sphere(10);
    popMatrix();
    
  }
  
  void GetToCenterVector(ArrayList<Boint> boids) {
     PVector center = new PVector(0, 0, 0);
     
     for(int i = 0; i < num; i++){
       Boint boint = boids.get(i);
       if(id != boint.id){
         center.x += boint.pos.x;
         center.y += boint.pos.y;
         center.z += boint.pos.z;
       }
     }
     
     center.x /= num - 1;
     center.y /= num - 1;
     center.z /= num - 1;
     
     v1.x = center.x - pos.x;
     v1.y = center.y - pos.y;
     v1.z = center.z - pos.z;
  }
  
  void GetAvoidanceVector(ArrayList<Boint> boids){
    float DIST_THRESHOLD = radius;
    
    for(int i = 0; i < num; i++){
      if(id != i){
        Boint boint = boids.get(i);
        float dist = sqrt(sq(pos.x - boint.pos.x) + sq(pos.y - boint.pos.y) + sq(pos.z - boint.pos.z));
        if(dist < DIST_THRESHOLD){
          v2.x -= boint.pos.x - pos.x;
          v2.y -= boint.pos.y - pos.y;
          v2.z -= boint.pos.z - pos.z;
        }
      }
    }
  }
  
  void GetAverageVelocityVector(ArrayList<Boint> boids){
    PVector avgV = new PVector(0, 0, 0);
    
    for(int i = 0; i < num; i++){
      if(id != i){
        Boint boint = boids.get(i);
        avgV.x += boint.v.x;
        avgV.y += boint.v.y;
        avgV.z += boint.v.z;
      }
    }
    
    avgV.x /= num - 1;
    avgV.y /= num - 1;
    avgV.z /= num - 1;
    v3.x = avgV.x - v.x;
    v3.y = avgV.y - v.y;
    v3.z = avgV.z - v.z;
  }
}

ArrayList<Boint> boids_blue = new ArrayList<Boint>();
ArrayList<Boint> boids_yellow = new ArrayList<Boint>();
ArrayList<Boint> boids_green = new ArrayList<Boint>();
int num = 50;

void setup(){
  size(2000, 1000, OPENGL);
  smooth();
  
  for(int i = 0; i < num; i++){
    PVector position = new PVector(random(-width_box/2, width_box/2), random(-height_box/2, height_box/2), random(-depth_box/2, depth_box/2));
    PVector velocity = new PVector(2, 2, 2);
    int identity = i;
    color c = color(0, 0, 255);
    boids_blue.add(new Boint(position, velocity, identity, c));
  }
  
  for(int i = 0; i < num; i++){
    PVector position = new PVector(random(-width_box/2, width_box/2), random(-height_box/2, height_box/2), random(-depth_box/2, depth_box/2));
    PVector velocity = new PVector(2, 2, 2);
    int identity = i;
    color c = color(255, 255, 0);
    boids_yellow.add(new Boint(position, velocity, identity, c));
  }
  
  for(int i = 0; i < num; i++){
    PVector position = new PVector(random(-width_box/2, width_box/2), random(-height_box/2, height_box/2), random(-depth_box/2, depth_box/2));
    PVector velocity = new PVector(2, 2, 2);
    int identity = i;
    color c = color(0, 255, 0);
    boids_green.add(new Boint(position, velocity, identity, c));
  }
}

void draw(){
  background(0);
  lights();
  
  count++;
  if(count > MAX_COUNT){
     count = 0;
  }
  
  DrawBox();
  
  for(int i = 0; i < num; i++){
    Boint boint = boids_blue.get(i);
    boint.Draw(boids_blue);
  }
  for(int i = 0; i < num; i++){
    Boint boint = boids_yellow.get(i);
    boint.Draw(boids_yellow);
  }
  for(int i = 0; i < num; i++){
    Boint boint = boids_green.get(i);
    boint.Draw(boids_green);
  }
  
  //カメラ
  float r = 1000;
  float angle = (float)count/MAX_COUNT * 360.0;
  float rad = angle / 180.0 * PI;
  float x = r * cos(rad);
  float z = r * sin(rad);
  camera(x, 0, z, 0, 0, 0, 0, 1, 0);
}
