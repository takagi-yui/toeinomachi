class Gameover extends Scene {
  PImage screen;//画面を画像にしたもの

  void onEnter() {
    //終了時の画面を背景にする
    loadPixels();
    screen = createImage(width, height, RGB);
    screen.pixels = pixels;
    screen.updatePixels();
  }

  void onUpdate() {
    background(screen);

    //上から画面を暗くする
    noStroke();
    for (int y = 0; y < 20; y++) {
      for (int x = 0; x < 20; x++) {
        fill(100, 100, 100, -200 + min(frame, 50)*4 +noise(x/5.0, y/5.0, frameCount/300.0)*80 + (20-y)*10);
        rect(-200+x*20, -200+y*20, -200 + (x+1) * 20, -200 + (y+1) * 20);
      }
    }

    //文字
    textAlign(CENTER, CENTER);

    fill(255, 255, 255, -60+frame*3);
    textSize(48);
    text("GAME OVER", 0, -66);

    fill(255, 255, 255, -120+frame*3);
    textSize(36);
    text("RESULT:" + record + "m", 0, 66);
  }

  //クリックでタイトルに戻る
  void clicked() {
    if (frame > 100) {
      sceneManager.loadScene(0);
    }
  }
}
