class Building extends Cuboid {
  PVector p0, p1;//最小の座標・最大の座標

  //生成時に位置と大きさを指定
  Building(PVector p0, PVector p1) {
    super(PVector.lerp(p0, p1, 0.5), PVector.sub(p1, p0).mult(0.5));
    this.p0 = p0;
    this.p1 = p1;
  }

  void draw(float z) {
    if (z <= p0.z-Camera.z || p1.z-Camera.z < z)return;//z座標がビルの範囲に入っていなければ描画しない

    //距離から色と線の太さを計算
    strokeWeight(20/z);
    stroke(0, 0, 0, pow(map(z, Camera.far, Camera.near, 0, 1), 2)*120);
    float t = 1-abs(int((p0.z-Camera.z)*10)*0.1-z);
    fill(255*t, 255*t, 220*t, pow(map(z, Camera.far, Camera.near, 0, 1), 2)*120);

    float s = 400/z;
    if (z <= p0.z-Camera.z+0.1) {
      //ビルの表面に窓枠を描く
      noFill();
      for (int y = 0; y < (p1.y-p0.y)*2; y++) {
        for (int x = 0; x < (p1.x-p0.x)*2; x++) {
          rect((p0.x+x*0.5-Camera.x)*s, -(p0.y+y*0.5-Camera.y)*s, (p0.x+x*0.5+0.5-Camera.x)*s, -(p0.y+y*0.5+0.5-Camera.y)*s);
        }
      }
    } else {
      rect((p0.x-Camera.x)*s, -(p0.y-Camera.y)*s, (p1.x-Camera.x)*s, -(p1.y-Camera.y)*s);
    }
  }
}

class BuildingManager {
  public Building[] buildings;
  private int id;//配列上のビル生成の位置
  private int generatePos;//プレイヤーのビルを生成する位置

  BuildingManager() {
    buildings = new Building[20];
    buildings[0] = new Building(new PVector(-1.5, -3.5, -0.5), new PVector(1.5, -0.5, 20.5));//スタート地点の足場を作る
    id = 1;
    generatePos = 0;
  }

  //ビル生成
  public void generate(float playerX, float playerY, float playerZ) {
    //z座標+4おきにビルを生成
    if (playerZ < generatePos)return;
    generatePos = int(playerZ)+4;

    //画面奥のランダムな位置にビルを作る
    float w = random(1, 4);
    float h = random(1, 4);
    float x = int(playerX + random(-3, 3) - w/2)-0.5;
    float y = int(playerY + random(-3, 3) - h/2)-0.5;
    float z = int(Camera.z+Camera.far)+0.5;
    buildings[id] = new Building(new PVector(x, y, z), new PVector(x+int(w), y+int(h), z+6));

    id = (id+1)%buildings.length;//配列上のビル生成の位置を進める
  }

  //指定したz座標にある全てのビルを描画
  public void draw(float z) {
    for (int i = 0; i < buildings.length; i++) {
      if (buildings[i] == null)continue;
      buildings[i].draw(z);
    }
  }
}
