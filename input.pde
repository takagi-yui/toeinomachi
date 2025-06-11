//入力情報を保存するクラス
static class Input {
  public static boolean a = false, d = false, w = false, s = false, left = false, right = false, up = false, down = false;

  public static ReceiveClick receiveClick;
}

//クリックを受け取るもの
interface ReceiveClick {
  void clicked();
}

//クリックをreceiveClickに伝える
void mouseClicked() {
  Input.receiveClick.clicked();
}

//入力状況に応じてInputの値を変える
void keyPressed() {
  if (key == 'a')Input.a = true;
  if (key == 'd')Input.d = true;
  if (key == 'w')Input.w = true;
  if (key == 's')Input.s = true;
  if (key != CODED)return;
  if (keyCode == LEFT)Input.left = true;
  if (keyCode == RIGHT)Input.right = true;
  if (keyCode == UP)Input.up = true;
  if (keyCode == DOWN)Input.down = true;
}
void keyReleased() {
  mouseClicked();//キー入力もクリックされたと判定

  if (key == 'a')Input.a = false;
  if (key == 'd')Input.d = false;
  if (key == 'w')Input.w = false;
  if (key == 's')Input.s = false;
  if (key != CODED)return;
  if (keyCode == LEFT)Input.left = false;
  if (keyCode == RIGHT)Input.right = false;
  if (keyCode == UP)Input.up = false;
  if (keyCode == DOWN)Input.down = false;
}
void mousePressed() {
  if (mouseButton == LEFT)Input.left = true;
  if (mouseButton == RIGHT)Input.right = true;
}
void mouseReleased() {
  if (mouseButton == LEFT)Input.left = false;
  if (mouseButton == RIGHT)Input.right = false;
}
