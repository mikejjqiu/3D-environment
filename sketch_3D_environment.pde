import java.awt.Robot;

color white = #FFFFFF, black = #000000;
int gridSize;
PImage map;

color stone = #333333, bookshelf = #ffd000;
PImage bookshelves, stones;

Robot rbt;

boolean w, a, s, d;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ;
float h_head_angle, v_head_angle;
boolean skipFrame;

void setup() {
  fullScreen(P3D);
  smooth(4);
  textureMode(NORMAL);
  w = a = s = d = false;
  eyeX = width/2;
  focusX = width/2;
  eyeY = height/2;
  focusY = height/2;
  eyeZ = 0;
  focusZ = 10;
  upX = 0;
  upY = -1;
  upZ = 0;

  map = loadImage("map1.png");
  bookshelves = loadImage("bookshelf.png");
  stones = loadImage("stone.png");
  gridSize = 100;

  //h_head_angle = radians(270);

  try {
    rbt = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }

  skipFrame = false;
}

void draw() {
  background(0);
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ);
  //drawAxis();
  drawFocalPoint();
  controlCamera();
  drawMap();
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c != white) {
        pushMatrix();
        if (c == bookshelf) {
          for (int i = 0; i < height; i+=gridSize) 
            block(x*gridSize, 0, y*gridSize, bookshelves, gridSize);
        }
        if (c == stone) {
          for (int i = 0; i < height; i+=gridSize) 
            block(x*gridSize, -height, y*gridSize, stones, gridSize);
        }
        if (c == black) {
         fill(255);
         translate(x*gridSize, 0, y*gridSize);
         box(100, height, 100);
        }
        popMatrix();
      }
    }
  }
}

void drawFocalPoint() {
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix();
}

void drawAxis() {
  stroke(#96D8F0);
  strokeWeight(1);
  for (int i = -2000*map.width; i <= 2000*map.width; i+=100) {
    line(i, 0, -2000*map.width, i, 0, 2000*map.width);
    line(-2000*map.width, 0, i, 2000*map.width, 0, i);

    line(i, height, -2000*map.width, i, height, 2000*map.width);
    line(-2000*map.width, height, i, 2000*map.width, height, i);
  }
}

void controlCamera() {
  if (w) { 
    eyeX = eyeX + cos(h_head_angle)*10;
    eyeZ = eyeZ + sin(h_head_angle)*10;
  }
  if (s) {
    eyeX = eyeX - cos(h_head_angle)*10;
    eyeZ = eyeZ - sin(h_head_angle)*10;
  }
  if (a) {
    eyeX = eyeX - cos(h_head_angle - PI/2)*10;
    eyeZ = eyeZ - sin(h_head_angle - PI/2)*10;
  }
  if (d) {
    eyeX = eyeX + cos(h_head_angle - PI/2)*10;
    eyeZ = eyeZ + sin(h_head_angle - PI/2)*10;
  }

  if (!skipFrame) {
    h_head_angle = h_head_angle + (pmouseX - mouseX)*0.01;
    v_head_angle = v_head_angle + (pmouseY - mouseY)*0.01;
  }

  if (v_head_angle > PI/2.3) v_head_angle = PI/2.3;
  if (v_head_angle < -PI/2.3) v_head_angle = -PI/2.3;

  focusX = eyeX + cos(h_head_angle)*300;
  focusY = eyeY + tan(v_head_angle)*300;
  focusZ = eyeZ + sin(h_head_angle)*300;

  if (mouseX > width-2) {
    rbt.mouseMove(1, mouseY); 
    skipFrame = true;
  } else if (mouseX < 1) {
    rbt.mouseMove(width-2, mouseY);
    skipFrame = true;
  } else skipFrame = false;
}

void keyPressed() { 
  if (key == 'w' || key == 'W') w = true;
  if (key == 's' || key == 'S') s = true;
  if (key == 'a' || key == 'A') a = true;
  if (key == 'd' || key == 'D') d = true;
}

void keyReleased() {
  if (key == 'w' || key == 'W') w = false;
  if (key == 's' || key == 'S') s = false;
  if (key == 'a' || key == 'A') a = false;
  if (key == 'd' || key == 'D') d = false;
}
