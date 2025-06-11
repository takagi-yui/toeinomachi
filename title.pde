class Title extends Scene {
  PImage logo;
  float fade;
  void onEnter() {
    rectMode(CORNERS);//ビル描画時に両端の座標で指定
    logo = loadImage("logo.png");
    logo.resize(int(logo.width*0.8), int(logo.height*0.8));
    fade = -1;
  }

  void onUpdate() {
    //背景
    noStroke();
    for (int y = 0; y < 20; y++) {
      for (int x = 0; x < 20; x++) {
        fill(220-255 * (noise(x/5.0, y/5.0, frameCount/300.0)-0.6)*int(noise(x/5.0, y/5.0, frameCount/300.0)/0.6));
        rect(-200+x*20, -200+y*20, (x+1) * 20, (y+1) * 20);
      }
    }
    image(logo, -logo.width/2, -120);

    tint(255, 100);
    image(light, -200, 30, 400, 60);
    noTint();

    //スタートの文字
    fill(100, 128+sin(frameCount/30.0)*100);
    noStroke();
    textAlign(CENTER, CENTER);
    textSize(36);
    text("START", 0, 60);

    //フェードアウト
    if (fade >= 0) {
      fade += 10;
      fill(220, fade);
      rect(-400, -400, 800, 800);
      if (fade >= 255)sceneManager.loadScene(1);//暗くなったらゲーム画面に移動
    }
  }
  void clicked() {
    fade = 0;//フェードアウト開始
  }
}
