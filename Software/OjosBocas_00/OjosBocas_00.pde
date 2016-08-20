import controlP5.*; //<>//
import processing.video.*;
import deadpixel.keystone.*;

Keystone keyStone;
ControlP5 controlGui;
Group controlGroup;

int videoCount;
ArrayList<MapPlane> mapPlanes;

boolean calibrating;

void setup() {
  size(1280, 720, P2D);

  keyStone = new Keystone(this);

  controlGui = new ControlP5(this);
  controlGroup = controlGui.addGroup("CONTROLES")
    .setPosition(10, 20)
      .setBackgroundHeight(100)
        .setBackgroundColor(color(127, 200))
          .setSize(200, height - 100);
  ;
  controlGui.addButton("gui_randomize").setPosition(10, 10).setLabel("SALTAR VIDEOS").setGroup(controlGroup);


  //videoCount = 2;
  mapPlanes = new ArrayList<MapPlane>();
  createMapPlanes();

  calibrating = true;
  controlGui.setVisible(false);
  //delay(5000);
}

void draw() {
  background(0);

  for (int i=0; i<mapPlanes.size (); i++) {
    MapPlane currentMapPlane = mapPlanes.get(i);

    if (currentMapPlane.isVisible()) {    
      currentMapPlane.update();
      currentMapPlane.render();
    }
    
  }

  //println("At keyPressed : Video Width:Height = " + map1.video.width + ":" + map1.video.height);
}

void createMapPlanes() {

  File videoFolder = new File(sketchPath + "/videos/");
  println("|| Video Folder: " + videoFolder.getAbsolutePath());


  /*
  public java.io.FilenameFilter movFilter = new java.io.FilenameFilter() {
   boolean accept(File dir, String name) {
   return name.toLowerCase().endsWith(".mov");
   }
   };
   
   // list the files in the data folder
   String[] names = videoFolder.list(movFilter);
   */

  if (videoFolder.isDirectory()) {
    String names[] = videoFolder.list();

    //for (int i=0; i<names.length; i++) {
    for (int i=0; i<3; i++) {

      String videoPath = videoFolder.getAbsolutePath() + "/" + names[i];

      if (videoPath.toLowerCase().endsWith(".mov")) {
        println(videoPath);

        Movie video = new Movie(this, videoPath);
        MapPlane mapPlane = new MapPlane(video, i, names[i]);

        println("|| Created MapPlane " + i);

        mapPlanes.add(mapPlane);

        // GUI TOGGLER -> VIDEO VISIBILITY
        Toggle videoToggle = controlGui.addToggle("gui_videoToggle_" + i).setPosition(10, 40 + (25 * i)).setSize(20, 20).setLabel(i + " -- " + names[i]).setValue(1.0).setGroup(controlGroup);
        Label toggleLabel = videoToggle.getCaptionLabel();
        toggleLabel.getStyle().marginTop = -18;
        toggleLabel.getStyle().marginLeft = 30;
      }
    }
  } else {
  }
}

void randomizeVideos() {
  for (int i=0; i<mapPlanes.size (); i++) {
    mapPlanes.get(i).jumpToRandom();
  }
}

void keyPressed() {
  if (key == 'c') {
    toggleCalibration();
  }

  if (key == 'l') {
    keyStone.load();
  }
  if (key == 's') {
    keyStone.save();
  }

  if (key == 'r') {
    randomizeVideos();
  }
}

public void toggleCalibration() {
  keyStone.toggleCalibration();
  calibrating = keyStone.isCalibrating();

  controlGui.setVisible(calibrating);
}

public void gui_randomize() {
  randomizeVideos();
}

void controlEvent(ControlEvent theEvent) {

  if (theEvent.isController()) {

    String controllerName = theEvent.getController().getName();

    if (controllerName.substring(0, 15).equals("gui_videoToggle")) {
      char nameNumberTrim = controllerName.charAt(controllerName.length() - 1);
      println("Pressed on: " + controllerName.substring(0, 16) + nameNumberTrim);

      int buttonVideoId = Character.getNumericValue(nameNumberTrim);

      setPlaneVisibility(buttonVideoId, theEvent.getValue() != 0);
    }
  }

  /*
  if(theEvent.isGroup()) {
   println("got an event from group "
   +theEvent.getGroup().getName()
   +", isOpen? "+theEvent.getGroup().isOpen()
   );
   
   } else if (theEvent.isController()){
   println("got something from a controller "
   +theEvent.getController().getName()
   );
   }
   */
}

void setPlaneVisibility(int videoID, boolean state) {
  for (int i=0; i<mapPlanes.size (); i++) {
    MapPlane currentMapPlane = mapPlanes.get(i);

    if (currentMapPlane.ID == videoID) {
      currentMapPlane.setVisible(state);
      break;
    }
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
