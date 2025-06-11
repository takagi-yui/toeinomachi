class Game extends Scene {
  Player player;
  BuildingManager buildingManager;
  EnemyManager enemyManager;
  int fade;

  void onEnter() {
    player = new Player();
    buildingManager = new BuildingManager();
    enemyManager = new EnemyManager();
    record = 0;
    fade = 255;//暗い状態からスタート
  }
  void onUpdate() {
    background(220, 220, 220);

    pushMatrix();
    rotate(radians(-player.rotation));//プレイヤーの向きに合わせて座標系を回転

    drawStage(Camera.far, Camera.near+2);//プレイヤーより奥のビル

    //一時的に座標系を回転なしに戻し、プレイヤーを描画
    popMatrix();
    player.draw();
    pushMatrix();
    rotate(radians(-player.rotation));

    drawStage(Camera.near+2, Camera.near);//プレイヤーより手前のビル

    player.drawShadow();

    //プレイヤーを移動させる
    player.move(buildingManager.buildings);

    buildingManager.generate(player.position.x, player.position.y, player.position.z);
    enemyManager.update(player);

    //プレイヤーの位置に合わせてカメラを移動させる
    Camera.x = player.position.x;
    Camera.y = player.position.y;
    Camera.z = player.position.z-2;

    record = int(player.position.z*2);//距離の更新

    //ステージから落ちたらゲームオーバー
    if (player.vy < -0.2) {
      sceneManager.loadScene(2);
    }

    //距離を表示する
    popMatrix();
    fill(255);
    textSize(36);
    textAlign(LEFT, CENTER);
    text(record + "m", -195, -180);

    //フェードイン
    if (fade >= 0) {
      fade -= 5;
      fill(220, fade);
      rect(-400, -400, 800, 800);
    }
  }
  void clicked() {
  }

  public void drawStage(float startZ, float endZ) {
    //奥から順にビルと敵を描画する
    for (float z = startZ; z > endZ; z-=0.1) {
      buildingManager.draw(z);
      enemyManager.draw(z);
    }
  }
}
