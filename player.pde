class Player extends Cuboid {
  float vx, vy, vz;//プレイヤーの向きを基準とした速度

  int turning = 0;//回転の状態。符号を向き、絶対値を次に回転できるようになるまでの時間とする
  int jumping = 0;//ジャンプの状態(0:ジャンプできる、1以上:ジャンプしている時間、-1:ジャンプできない)
  boolean grounded;//着地しているか

  PlayerAnimation playerAnimation;
  PlayerShadow playerShadow;

  Player() {
    super(new PVector(0, 0, 0), new PVector(0.20, 0.35, 0.15));
    vx = 0;
    vy = 0;
    vz = 0;

    grounded = false;
    playerAnimation = new PlayerAnimation();
    playerShadow = new PlayerShadow();
  }

  void draw() {
    playerAnimation.draw(grounded);
  }

  void drawShadow() {
    playerShadow.draw();
  }

  void move(Building[] buildings) {
    //横移動
    if (Input.d == Input.a) {//左右キーが両方押されているまたは両方押されていないとき
      vx *= 0.9;//x方向の速度を小さくする
    } else {
      //押されたキーに応じて速度を変える
      if (Input.d) vx += 0.002;
      if (Input.a) vx -= 0.002;
    }
    vx = constrain(vx, -0.02, 0.02);//最大速度を超えないようにする

    //ジャンプ
    if (grounded) {
      if (Input.w && jumping == 0) {
        vy = 0.045;
        jumping = 1;
      }
      if (!Input.w)jumping = 0;
    } else {
      if (Input.w && 0 < jumping) {
        vy+=0.0025;
        jumping++;
        if (jumping > 10)jumping = -1;
      } else {
        jumping = -1;
      }
    }

    //回転開始
    if (turning == 0 && (Input.left != Input.right)) {//回転していないかつaかdのどちらかが押されているとき
      if (Input.left)turning = 75;
      if (Input.right)turning = -75;
    }

    //回転させる
    if (turning > 0) {
      if (turning > 45)rotation+=3;
      turning--;
    }
    if (turning < 0) {
      if (turning < -45)rotation-=3;
      turning++;
    }

    grounded = false;
    for (int i = 0; i < buildings.length; i++) {

      if (buildings[i] == null)continue;

      //通り過ぎたビルを消す
      if (position.z > buildings[i].position.z+buildings[i].half.z+3) {
        buildings[i] = null;
        continue;
      }
      //プレイヤーから遠いときは判定しない
      if (abs(buildings[i].position.z-position.z) > buildings[i].half.z+1)continue;

      if (front(buildings[i])) {
        vz = min(vz, 0);
      }

      if (left(buildings[i])) {
        vx = max(vx, 0);
      }
      if (right(buildings[i])) {
        vx = min(vx, 0);
      }

      if (down(buildings[i])) {
        grounded = true;
      }
      if (up(buildings[i])) {
        vy = min(vy, 0);
      }
    }

    //速度を更新する
    if (grounded) {
      if (vy < 0)vy = 0;
    } else {
      vy-=0.001;
    }
    vz = min(vz+0.001, 0.05);

    //位置を速度分だけ動かす
    position = PVector.add(position, PVector.add(right(vx), up(vy)));
    position.z += vz;

    playerShadow.move(buildings, position, up(-1));
  }
}
