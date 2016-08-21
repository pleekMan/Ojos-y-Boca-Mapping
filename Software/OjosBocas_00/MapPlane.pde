class MapPlane {

  PGraphics buffer;
  CornerPinSurface surface;
  Movie video;
  String videoName;

  int ID;
  
  boolean isVisible;

  MapPlane(Movie _video, int _ID, String _videoName) {
     
    videoName = _videoName;
    video = _video;
    video.loop();
    video.play();
    //println("At MapPlane Init : Video Width:Height = " + video.width + ":" + video.height);

    buffer = createGraphics(video.width, video.height, P2D);
    //println("Buffer Width:Height = " + buffer.width + ":" + buffer.height);

    surface = keyStone.createCornerPinSurface(video.width, video.height, 3);
    surface.moveTo(video.width, 20);
     
    ID = _ID;
    
    isVisible = true;
    
  }

  void update() {

    if (video.available()) {
      video.read();
    }

    /*
    fill(0,200);
    rect(surface.x, surface.y, 300, 20);
    fill(255,255,0);
    text(videoName,surface.x, surface.y + 10);
    */
    
    buffer.beginDraw();
    
    buffer.background(0);
    buffer.image(video, 0, 0);

    if (keyStone.isCalibrating()) {
      
      buffer.fill(0,150);
      buffer.rect(0,0,buffer.width, 70);
      
      buffer.fill(255);
      buffer.stroke(0);
      buffer.textSize(30);
      buffer.text(ID, 5, 40);
      
      buffer.textSize(15);
      buffer.text(videoName,5, 60);
    }

    buffer.endDraw();
  }


  void render() {
    surface.render(buffer);
  }
  
  void jumpToRandom(){
    println("Jumping video: " + ID);
    video.jump(random(video.duration()));
  }
  
  void setVisible(boolean state){
    isVisible = state;
  }
  
  boolean isVisible(){
   return isVisible; 
  }
}
