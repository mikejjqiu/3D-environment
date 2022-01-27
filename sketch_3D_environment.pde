import java.awt.Robot;

color white = #FFFFFF, black = #000000;
int gridSize;
PImage map;

color stone = #333333, bookshelf = #ffd000;
PImage bookshelves, stones, sc, wood;

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
  focusZ = 0;
  upX = 0;
  upY = -1;
  upZ = 0;

  map = loadImage("map1.png");
  bookshelves = loadImage("bookshelf.png");
  stones = loadImage("stone.png");
  sc = loadImage("sc.png");
  wood = loadImage("woodtop.png");

  gridSize = 100;

  h_head_angle = radians(270);

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
  ambientLight(255, 230, 200, width/2, height, width/2);
  directionalLight(255, 255, 255, 0, 1, 0);
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ);

  //drawFocalPoint();
  controlCamera();
  drawMap();
  drawPlain();
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);

      if (c == bookshelf) {
        pushMatrix();
        for (int i = 0; i < 2*gridSize; i+=gridSize) {
          block(x*gridSize, i, y*gridSize, wood, bookshelves, wood, gridSize);
          println(i);
        }
        popMatrix();
      }
      if (c == stone) {
        pushMatrix();
        for (int i = 0; i < 5*gridSize; i+=gridSize)
          block(x*gridSize, i, y*gridSize, stones, gridSize);
        popMatrix();
      }
      if (c == black) {
        pushMatrix();
        for (int i = 0; i < height; i+=gridSize)
          block(x*gridSize, i, y*gridSize, sc, gridSize);
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

void drawPlain() {
  int x = 0, y = 0;
  while (y <= gridSize*map.height) {
    block(x, -gridSize, y, sc, gridSize);
    block(x, height, y, sc, gridSize);
    x += gridSize;
    if (x >= gridSize*map.width) {
      x = 0;
      y += gridSize;
    }
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
