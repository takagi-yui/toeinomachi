class PlayerAnimation {
  private Keyframe[] timeline;//キーフレームをアニメーションさせる順番に並べたもの
  private int keyCount;//タイムラインのキーの数
  private int vertexCount;//モデルの頂点数
  private float time;//現在のアニメーション再生位置

  PlayerAnimation() {
    //ファイルからアニメーション情報を読み込む
    Table table = loadTable(dataPath("player.csv"));
    keyCount = table.getColumnCount()/2;
    vertexCount = table.getRowCount();
    timeline = new Keyframe[keyCount];

    for (int k = 0; k < keyCount; k++) {
      timeline[k] = new Keyframe(vertexCount);
      for (int v = 0; v < vertexCount; v++) {
        timeline[k].x[v] = table.getFloat(v, 2*k);
        timeline[k].y[v] = table.getFloat(v, 2*k + 1);
      }
    }
    time = 0;
  }

  public void draw(boolean grounded) {
    //空中にいるときはポーズを切り替えて、アニメーションをゆっくり進める
    if (grounded) {
      time = (time+0.1)%keyCount;
    } else {
      if (int(time)%2 == 1)time = (int(time)+1)%keyCount;
      time = lerp(time, int(time)+1, 0.02);
    }

    //頂点の位置を計算
    float[] vx = new float[vertexCount];
    float[] vy = new float[vertexCount];
    for (int i = 0; i < vertexCount; i++) {
      vx[i] = lerp(timeline[int(time)].x[i], timeline[(int(time)+1)%keyCount].x[i], pow(time%1, 1.5));
      vy[i] = lerp(timeline[int(time)].y[i], timeline[(int(time)+1)%keyCount].y[i], pow(time%1, 1.5));
      vy[i] += pow((time)%2-1, 2)*10;//全体を上下に動かす
    }

    //色指定
    strokeWeight(3);
    stroke(183, 245, 255, 128);
    fill(183, 245, 255);

    //縮小して描画
    beginShape();
    for (int i = 0; i < vertexCount+3; i++) {
      curveVertex(vx[i%vertexCount]*0.25, vy[i%vertexCount]*0.25);
    }
    endShape();
  }
}

class Keyframe {
  float[] x, y;
  Keyframe(int vertexCount) {
    x = new float[vertexCount];
    y = new float[vertexCount];
  }
}
