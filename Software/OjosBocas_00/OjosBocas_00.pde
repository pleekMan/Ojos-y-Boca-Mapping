import processing.video.*; //<>//
import deadpixel.keystone.*;

Keystone keyStone;

int videoCount;
ArrayList<MapPlane> mapPlanes;

boolean calibrating;

void setup() {
  size(1280, 720, P2D);

  keyStone = new Keystone(this);

  videoCount = 2;
  mapPlanes = new ArrayList<MapPlane>();
  createMapPlanes();

  calibrating = false;
  //delay(5000);
}

void draw() {
  background(0);

  for (int i=0; i<mapPlanes.size (); i++) {
    mapPlanes.get(i).update();
    mapPlanes.get(i).render();
  }

  //println("At keyPressed : Video Width:Height = " + map1.video.width + ":" + map1.video.height);
}

void createMapPlanes() {

  File videoFolder = new File(sketchPath + "/videos/");
  println(videoFolder.getAbsolutePath());

  if (videoFolder.isDirectory()) {
    String names[] = videoFolder.list();
    println(names);


    for (int i=0; i<names.length; i++) {
      Movie video = new Movie(this, videoFolder.getAbsolutePath() + "/" + names[i]);
      MapPlane mapPlane = new MapPlane(video, i);

      mapPlanes.add(mapPlane);
    }
  }
}

void keyPressed() {
  if (key == 'c') {
    keyStone.toggleCalibration();
    calibrating = keyStone.isCalibrating();
  }

  if (key == 'l') {
    keyStone.load();
  }
  if (key == 's') {
    keyStone.save();
  }
}

void mousePressed() {
}

void mouseReleased() {
}

void mouseClicked() {
}

void mouseDragged() {
}

void mouseWheel(MouseEvent event) {
  //float e = event.getAmount();
  //println(e);
}

void movieEvent(Movie m) {
  m.read();
}
