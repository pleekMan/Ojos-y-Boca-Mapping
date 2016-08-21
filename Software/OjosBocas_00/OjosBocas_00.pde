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
  //size(1280, 720, P2D);
  size(displayWidth, displayHeight, P2D);

  keyStone = new Keystone(this);

  controlGui = new ControlP5(this);
  controlGroup = controlGui.addGroup("CONTROLES")
    .setPosition(10, 20)
      .setBackgroundHeight(100)
        .setBackgroundColor(color(127, 200))
          .setSize(200, height - 100);
  ;
  controlGui.addButton("gui_randomize").setPosition(10, 20).setLabel("SALTAR VIDEOS").setGroup(controlGroup);
  controlGui.addButton("gui_loadMappingSettings").setPosition(10, 50).setLabel("CARGAR MAPEO").setGroup(controlGroup);
  controlGui.addButton("gui_saveMappingSettings").setPosition(110, 50).setLabel("GUARDAR MAPEO").setGroup(controlGroup);


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

  //text(sketchPath + "/videos/",500,500);

  //text(mouseX + " | " + mouseY, mouseX + 3, mouseY -5);
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
    names = sort(names);

    for (int i=0; i<names.length; i++) {
      //for (int i=0; i<12; i++) {

      String videoPath = videoFolder.getAbsolutePath() + "/" + names[i];

      if (videoPath.toLowerCase().endsWith(".mov")) {
        println(videoPath);

        Movie video = new Movie(this, videoPath);
        MapPlane mapPlane = new MapPlane(video, i, names[i]);

        println("|| Created MapPlane " + i);

        mapPlanes.add(mapPlane);

        // GUI TOGGLER -> VIDEO VISIBILITY
        Toggle videoToggle = controlGui.addToggle("gui_videoToggle_" + i).setPosition(10, 80 + (25 * i)).setSize(20, 20).setLabel(i + " -- " + names[i]).setValue(1.0).setGroup(controlGroup);
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
  if (key == ' ') {
    toggleCalibration();
  }

  if (key == 'c') {
    keyStone.load();
  }
  if (key == 'g') {
    keyStone.save();
  }

  if (key == 'r') {
    randomizeVideos();
  }

  if (key == 'g') {
    //createMapPlanes();
  }
}

public void toggleCalibration() {
  keyStone.toggleCalibration();
  calibrating = keyStone.isCalibrating();

  controlGui.setVisible(calibrating);

  if (calibrating) {
    cursor();
  } else {
    noCursor();
  }
}

public void gui_randomize() {
  randomizeVideos();
}

public void gui_loadMappingSettings() {
  keyStone.load();
}
public void gui_saveMappingSettings() {
  keyStone.save();
}

void controlEvent(ControlEvent theEvent) {

  if (theEvent.isController()) {

    String controllerName = theEvent.getController().getName();

    if (controllerName.substring(0, 15).equals("gui_videoToggle")) {
      String nameSplit[] = split(controllerName, '_');
      int buttonVideoId = Integer.parseInt(nameSplit[2]);

      println("Pressed on: " + controllerName.substring(0, 16) + buttonVideoId);

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
