abstract class Scene implements ReceiveClick {
  protected int frame;

  public void enter() {
    frame = 0;
    onEnter();
  }
  public void update() {
    onUpdate();
    frame++;
  }

  protected abstract void onEnter();
  protected abstract void onUpdate();
}

class SceneManager {
  private Scene[] scene;
  private int sceneID;
  public int getID() {
    return sceneID;
  }

  SceneManager(Scene... s) {
    scene = s;
    loadScene(0);
  }

  public void loadScene(int id) {
    sceneID = id;
    scene[id].enter();
    Input.receiveClick = scene[id];//現在のシーンがクリック入力を受け取る
  }

  public void update() {
    scene[sceneID].update();
  }
}
