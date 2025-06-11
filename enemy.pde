class Enemy extends Cuboid {
  private boolean typeX;
  private int drawFrame;

  Enemy(PVector position, boolean typeX) {
    super(position, typeX?new PVector(5, 0.1, 0.1):new PVector(0.1, 5, 0.1));
    this.typeX = typeX;
  }

  public void draw(float z) {
    if (z > position.z-Camera.z)return;

    //1フレームに1回描画
    if (frameCount == drawFrame)return;
    drawFrame = frameCount;

    noStroke();
    fill(200, 50, 50, pow(map(z, Camera.far, Camera.near, 0, 1), 2)*200);
    tint(200, 50, 50, pow(map(z, Camera.far, Camera.near, 0, 1), 2)*255);

    float s = 400/z;
    //rect((position.x-half.x-Camera.x)*s, -(position.y-half.y-Camera.y)*s, (position.x+half.x-Camera.x)*s, -(position.y+half.y-Camera.y)*s);//判定の大きさ確認用
    if (typeX) {
      image(light, (position.x-half.x*1.5-Camera.x)*s, -(position.y-half.y*2-Camera.y)*s, (half.x*3)*s, -(half.y*4)*s);
    } else {
      image(light, (position.x-half.x*2-Camera.x)*s, -(position.y-half.y*1.5-Camera.y)*s, (half.x*4)*s, -(half.y*3)*s);
    }
    noTint();
  }
}

class EnemyManager {
  private ArrayList<Enemy> enemies;
  private float generatePos;

  EnemyManager() {
    enemies = new ArrayList<Enemy>();
    generatePos = 0;
  }

  public void update(Player player) {
    for (int i = 0; i < enemies.size(); i++) {
      //敵に当たったらゲームオーバー
      if (player.front(enemies.get(i))) {
        sceneManager.loadScene(2);
      }
      //通り過ぎた敵を消す
      if (enemies.get(i).position.z < Camera.z) {
        enemies.remove(i);
      }
    }

    //一定間隔ごとに敵を生成
    if (player.position.z < generatePos)return;
    generatePos = int(player.position.z)+(8-0.02*min(player.position.z, 300));

    //縦向きと横向きを同時に追加
    PVector p = new PVector(int(player.position.x+random(-3, 3)), int(player.position.y+random(-3, 3)), player.position.z + Camera.far);
    enemies.add(new Enemy(p, true));
    enemies.add(new Enemy(p, false));
  }

  public void draw(float z) {
    for (Enemy e : enemies) {
      e.draw(z);
    }
  }
}
