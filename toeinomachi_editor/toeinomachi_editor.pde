boolean[][] a;//頂点をアニメーションに含む
float[][] x, y;
int keyCount, vertexCount;
int keyFrame[] = {1, 2, 3, 4, 1};//再生する順序
int selectKey = 0;//選択中のキー
int state = 0;//0：編集中、1：再生中、2：ドラッグ中
boolean mouse = false;//マウスが押されているか
int selectVertex;//選択中の頂点

void setup() {
  size(800, 800);
  loadModel();
}

void draw() {
  background(255);
  
  //画面中央を座標(0,0)に設定
  translate(width/2, height/2);

  stroke(0, 0, 0, 0);
  if (state == 1) {//再生中のとき
    background(220, 255, 255);
    float t = (frameCount/4*4*16%width)/(width/float(keyFrame.length-1));//再生時間
    
    //頂点の座標を計算
    float[] vx = new float[vertexCount];
    float[] vy = new float[vertexCount];
    for (int i = 0; i < vertexCount; i++) {
      boolean key0 = false;
      //補間の開始位置を求める
      int start = int(t);
      for (int j = 0; j < keyFrame.length; j++) {
        if (a[keyFrame[(keyFrame.length+start)%keyFrame.length]][i])break;
        if (j == keyFrame.length-1)key0 = true;
        start--;
      }
      //補間の終了位置を求める
      int end = start+1;
      for (int j = 0; j < keyFrame.length; j++) {
        if (a[keyFrame[(keyFrame.length+end)%keyFrame.length]][i])break;
        if (j == keyFrame.length-1)key0 = true;
        end++;
      }
      if (key0) {//開始または終了位置が存在しないとき
        vx[i] = x[0][i];
        vy[i] = y[0][i];
      } else {//開始・終了座標と再生時間をもとに頂点の座標を計算
        int startIdx = (keyFrame.length+start)%keyFrame.length;
        int endIdx = (keyFrame.length+end)%keyFrame.length;
        vx[i] = lerp(x[keyFrame[startIdx]][i], x[keyFrame[endIdx]][i],pow(map(t, start, end,0,1),1));
        vy[i] = lerp(y[keyFrame[startIdx]][i], y[keyFrame[endIdx]][i],pow(map(t, start, end,0,1),1));
      }
      vy[i] += pow((t)%2-1,2)*10;//走るアニメーションなので上下に移動させる
    }
    
    drawModel(a[selectKey], vx, vy);//モデルを描画する
  } else {//再生中ではないとき
    drawModel(a[selectKey], x[selectKey], y[selectKey]);
    drawVertex(a[selectKey], x[selectKey], y[selectKey]);
  }
  //座標軸
  stroke(0, 0, 0, 128);
  line(-width, 0, width, 0);
  line(0, -height, 0, height);
}

//モデルを描画する
void drawModel(boolean[] a, float[] x, float[] y) {
  fill(128);
  beginShape();
  for (int i = 0; i < vertexCount+3; i++) {
    curveVertex(x[i%vertexCount], y[i%vertexCount]);
  }
  endShape();
}

//頂点を描画する
void drawVertex(boolean[] a, float[] x, float[] y) {
  for (int i = 0; i < vertexCount; i++) {
    if (a[i]) {
      fill(100, 200, 255, 128);
    } else {
      fill(255, 255, 255, 128);
    }
    ellipse(x[i], y[i], 10, 10);
  }
}

//モデルを読み込む
void loadModel() {
  Table table = loadTable(dataPath("model/player.csv"));

  vertexCount = table.getRowCount();
  keyCount = table.getColumnCount()/3;
  a = new boolean[20][100];
  x = new float[20][100];
  y = new float[20][100];
  for (int j = 0; j < keyCount; j++) {
    for (int i = 0; i < vertexCount; i++) {
      a[j][i] = table.getInt(i, 3*j + 0) == 1;
      x[j][i] = table.getFloat(i, 3*j + 1);
      y[j][i] = table.getFloat(i, 3*j + 2);
    }
  }
}

//モデルを保存する
void saveModel() {
  Table table = new Table();
  for (int i = 0; i < keyCount*3; i++) {
    table.addColumn();
  }

  for (int i = 0; i < vertexCount; i++) {
    TableRow row = table.addRow();
    for (int j = 0; j < keyCount; j++) {
      row.setInt(3*j + 0, a[j][i]?1:0);
      row.setFloat(3*j + 1, x[j][i]);
      row.setFloat(3*j + 2, y[j][i]);
    }
  }
  saveTable(table, dataPath("model/player.csv"));
  println("Save");
}

void keyTyped() {
  //編集・再生モードの切り替え
  if ((state == 0 || state == 1) && key == 'v') {
    state = 1 - state;
  }

  if (state != 0)return;

  //モデルの保存
  if (key == 's') {
    saveModel();
  }

  //編集するフレームの切り替え
  String numbers = "0123456789";
  if (numbers.indexOf(key) == -1)return;
  if (0 <= Integer.parseInt(str(key)) && Integer.parseInt(str(key)) < keyCount) {
    println(key);
    selectKey = Integer.parseInt(str(key));
  }
}
void mouseClicked() {
  if (state != 0)return;
  for (int i = 0; i < vertexCount; i++) {
    if (dist(mouseX-width/2, mouseY-height/2, x[selectKey][i], y[selectKey][i]) < 10) {
      //右クリックで頂点を増やす
      if (mouseButton == RIGHT && vertexCount < 100) {
        vertexCount++;
        for (int k = 0; k < keyCount; k++) {
          for (int j = vertexCount-1; j > i+1; j--) {
            x[k][j] = x[k][j-1];
            y[k][j] = y[k][j-1];
            a[k][j] = a[k][j-1];
          }
          x[k][i+1] = (x[k][i]+x[k][(i+2)%vertexCount])*0.5;
          y[k][i+1] = (y[k][i]+y[k][(i+2)%vertexCount])*0.5;
          a[k][i+1] = a[k][i];
        }
        break;
      }
      //中クリックで頂点を減らす
      if (mouseButton == CENTER && vertexCount > 3) {
        vertexCount--;
        for (int k = 0; k < keyCount; k++) {
          for (int j = i; j < vertexCount; j++) {
            x[k][j] = x[k][j+1];
            y[k][j] = y[k][j+1];
            a[k][j] = a[k][j+1];
          }
        }
        break;
      }
      //左クリックで頂点の有効化・無効化
      a[selectKey][i] = !a[selectKey][i];
      break;
    }
  }
}

//頂点のドラッグを開始
void mousePressed() {
  if (state!=0)return;
  for (int i = 0; i < vertexCount; i++) {
    if (dist(mouseX-width/2, mouseY-height/2, x[selectKey][i], y[selectKey][i]) < 10) {
      state = 2;
      selectVertex = i;
    }
  }
}
//ドラッグ中
void mouseDragged() {
  if (state != 2)return;
  x[selectKey][selectVertex] += mouseX-pmouseX;
  y[selectKey][selectVertex] += mouseY-pmouseY;
}
//ドラッグ終了
void mouseReleased() {
  if (state == 2)state = 0;
  mouse = false;
}
