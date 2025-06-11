abstract class Cuboid {
  public PVector position;
  public float rotation = 0;

  //大きさの半分
  protected PVector half;

  //面ごとの当たり判定の大きさ
  protected float x0size = 0.6, y0size = 0.6, z0size = 0.6;
  protected float x1size = 0.6, y1size = 0.6, z1size = 0.6;

  Cuboid(PVector position, PVector half) {
    this.position = position;
    this.half = half;
  }

  //当たり判定
  public boolean right(Cuboid cuboid) {
    if (hitX(cuboid, x1size, half.x)) {
      do {
        position.add(right(-0.01));
      } while (hitX(cuboid, x1size, half.x));
      position.add(right(0.01));
      return true;
    }
    return false;
  }
  public boolean left(Cuboid cuboid) {
    if (hitX(cuboid, x0size, -half.x)) {
      do {
        position.add(right(0.01));
      } while (hitX(cuboid, x0size, -half.x));
      position.add(right(-0.01));
      return true;
    }
    return false;
  }
  private boolean hitX(Cuboid cuboid, float s, float x) {
    if (cuboid.inside(worldPos(x, -half.y*s, -half.z*s)))return true;
    if (cuboid.inside(worldPos(x, -half.y*s, half.z*s)))return true;
    if (cuboid.inside(worldPos(x, -half.y*s, 0)))return true;
    if (cuboid.inside(worldPos(x, half.y*s, -half.z*s)))return true;
    if (cuboid.inside(worldPos(x, half.y*s, half.z*s)))return true;
    if (cuboid.inside(worldPos(x, half.y*s, 0)))return true;
    if (cuboid.inside(worldPos(x, 0, -half.z*s)))return true;
    if (cuboid.inside(worldPos(x, 0, half.z*s)))return true;
    if (cuboid.inside(worldPos(x, 0, 0)))return true;
    return false;
  }

  public boolean down(Cuboid cuboid) {
    if (hitY(cuboid, y0size, -half.y)) {
      do {
        position.add(up(0.01));
      } while (hitY(cuboid, y0size, -half.y));
      position.add(up(-0.01));
      return true;
    }
    return false;
  }
  public boolean up(Cuboid cuboid) {
    if (hitY(cuboid, y1size, half.y)) {
      do {
        position.add(up(-0.01));
      } while (hitY(cuboid, y1size, half.y));
      position.add(up(0.01));
      return true;
    }
    return false;
  }
  private boolean hitY(Cuboid cuboid, float s, float y) {
    if (cuboid.inside(worldPos(-half.x*s, y, -half.z*s)))return true;
    if (cuboid.inside(worldPos(-half.x*s, y, half.z*s)))return true;
    if (cuboid.inside(worldPos(-half.x*s, y, 0)))return true;
    if (cuboid.inside(worldPos(half.x*s, y, -half.z*s)))return true;
    if (cuboid.inside(worldPos(half.x*s, y, half.z*s)))return true;
    if (cuboid.inside(worldPos(half.x*s, y, 0)))return true;
    if (cuboid.inside(worldPos(0, y, -half.z*s)))return true;
    if (cuboid.inside(worldPos(0, y, half.z*s)))return true;
    if (cuboid.inside(worldPos(0, y, 0)))return true;
    return false;
  }

  public boolean front(Cuboid cuboid) {
    if (hitZ(cuboid, z1size, half.z)) {
      do {
        position.z-=0.01;
      } while (hitZ(cuboid, z1size, half.z));
      position.z+=0.01;
      return true;
    }
    return false;
  }
  public boolean back(Cuboid cuboid) {
    if (hitZ(cuboid, z0size, -half.z)) {
      do {
        position.z+=0.01;
      } while (hitZ(cuboid, z0size, -half.z));
      position.z-=0.01;
      return true;
    }
    return false;
  }
  private boolean hitZ(Cuboid cuboid, float s, float z) {
    if (cuboid.inside(worldPos(-half.x*s, -half.y*s, z)))return true;
    if (cuboid.inside(worldPos(-half.x*s, half.y*s, z)))return true;
    if (cuboid.inside(worldPos(-half.x*s, 0, z)))return true;
    if (cuboid.inside(worldPos(half.x*s, -half.y*s, z)))return true;
    if (cuboid.inside(worldPos(half.x*s, half.y*s, z)))return true;
    if (cuboid.inside(worldPos(half.x*s, 0, z)))return true;
    if (cuboid.inside(worldPos(0, -half.y*s, z)))return true;
    if (cuboid.inside(worldPos(0, half.y*s, z)))return true;
    if (cuboid.inside(worldPos(0, 0, z)))return true;
    return false;
  }

  //ワールド座標に変換
  private PVector worldPos(float x, float y, float z) {
    PVector wPos = PVector.add(position, PVector.add(right(x), up(y)));
    wPos.z += z;
    return wPos;
  }

  //指定した点が内側にあるか
  public boolean inside(PVector wPos) {
    PVector lPos = PVector.sub(wPos, position);
    if (-half.x <= lPos.x && lPos.x < half.x && -half.y <= lPos.y && lPos.y < half.y && -half.z <= lPos.z && lPos.z < half.z)return true;
    return false;
  }

  //プレイヤーからみた右方向と上方向の大きさ1のベクトル
  protected PVector right() {
    return new PVector(constrain(cos(radians(-rotation)), -1, 1), constrain(sin(radians(-rotation)), -1, 1), 0);
  }
  protected PVector up() {
    return new PVector(constrain(sin(radians(rotation)), -1, 1), constrain(cos(radians(rotation)), -1, 1), 0);
  }

  //大きさを指定可能にしたもの
  protected PVector right(float value) {
    return right().mult(value);
  }

  protected PVector up(float value) {
    return up().mult(value);
  }
}
