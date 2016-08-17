class MapPlane {

  PGraphics buffer;
  CornerPinSurface surface;
  Movie video;

  int ID;

  MapPlane(Movie _video, int _ID) {

    video = _video;
    video.loop();
    video.play();
    //println("At MapPlane Init : Video Width:Height = " + video.width + ":" + video.height);

    buffer = createGraphics(video.width, video.height, P2D);
    //println("Buffer Width:Height = " + buffer.width + ":" + buffer.height);

    surface = keyStone.createCornerPinSurface(video.width, video.height, 10);

    ID = _ID;
  }

  void update() {

    if (video.available()) {
      video.read();
    }


    buffer.beginDraw();
    
    buffer.background(0);
    buffer.image(video, 0, 0);

    if (keyStone.isCalibrating()) {
      buffer.fill(255);
      buffer.stroke(0);
      buffer.textSize(40);
      buffer.text(ID, 5, 50);
    }

    buffer.endDraw();
  }


  void render() {
    surface.render(buffer);
  }
}
