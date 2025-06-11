SceneManager sceneManager;
int record;

static PImage light;

void setup() {
  size(600, 600);//必ず縦横比を1:1にする

  PFont font;
  font = loadFont("CourierNewPSMT-48.vlw");
  textFont(font);

  light = loadImage("light.png");

  sceneManager = new SceneManager(new Title(), new Game(), new Gameover());
}

void draw() {
  translate(width/2, height/2);
  scale(width/400.0);

  sceneManager.update();
}
