class PlayerShadow {
  private final float radius = 0.15;

  //ヒット情報を受け取る変数
  private float hitX, hitY, hitZ;
  private float l;
  private int faceType;

  private PVector pos, dir;

  void move(Building[] buildings, PVector pos, PVector dir) {
    this.pos = pos;
    this.dir = dir;

    l = 99;
    faceType = 0;
    for (Building b : buildings) {
      if (b==null)continue;
      if (abs(b.position.z-pos.z) > b.half.z+1)continue;
      rayX(b, b.p0.x);
      rayX(b, b.p1.x);
      rayY(b, b.p0.y);
      rayY(b, b.p1.y);
    }
  }

  void draw() {
    if (faceType == 0)return;

    int w, h;
    if (faceType == 1) {
      w = 18;
      h = 36;
    } else {
      w = 36;
      h = 18;
    }

    fill(183, 245, 255, 128);
    noStroke();
    ellipse((hitX-Camera.x)*400/(hitZ-Camera.z), -(hitY-Camera.y)*400/(hitZ-Camera.z), w, h);
  }

  private boolean rayY(Cuboid c, float y) {
    if ((y-pos.y)*dir.y <= 0)return false;

    float pY = y;
    float r = (pY - pos.y)/dir.y;
    float pX = pos.x + dir.x*r;
    float pZ = pos.z + dir.z*r;

    //交点が範囲内にあるか調べる
    if (abs(pY-pos.y) < l && abs(pX-c.position.x) < radius+c.half.x && abs(pZ-c.position.z) < radius+c.half.z) {
      hitX = pX;
      hitY = pY;
      hitZ = pZ;
      l = abs(pY-pos.y);
      faceType = -1;
      return true;
    }
    return false;
  }
  private boolean rayX(Cuboid c, float x) {
    if ((x-c.position.x)*dir.x >= 0)return false;

    float pX = x;
    float r = (pX - pos.x)/dir.x;
    float pY = pos.y + dir.y*r;
    float pZ = pos.z + dir.z*r;

    //交点が範囲内にあるか調べる
    if (abs(pX-pos.x) < l && abs(pY-c.position.y) < radius+c.half.y && abs(pZ-c.position.z) < radius+c.half.z) {
      hitX = pX;
      hitY = pY;
      hitZ = pZ;
      l = abs(pX-pos.x);
      faceType = 1;
      return true;
    }
    return false;
  }
}
