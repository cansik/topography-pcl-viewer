import peasy.PeasyCam;

import java.util.List;
import java.util.Map;

PeasyCam cam;
DepthMapCloud cloud;

boolean showAxis = true;
boolean autoRotateCamera = false;
boolean proposeTakeScreenshot = false;

String currentCloudName = "no-cloud";

void setup()
{ 
  size(1280, 900, P3D);
  //fullScreen(P3D);
  pixelDensity(2);

  cam = new PeasyCam(this, 620);
  cam.setSuppressRollRotationMode();

  // change clipping
  perspective(PI/3.0, (float)width/height, 0.1, 100000);

  // depth images
  //cloud = createCloud("sun_depth.png", "sun_color.png", 3, 3.0, -60, true, false);
  //cloud = createCloud("swiss_depth.png", "swiss_color.png", 3, 3.0, -60, true, false);
  cloud = createCloud("aargau_depth_topo.png", "aargau_color_topo.png", 3, 3.0, -60, true, false);
  //cloud = createCloud("aargau_depth_bwd.png", "aargau_color.png", 3, 3.0, -60, true, false);
  currentCloudName = "Aargau";

  cloud.setup();

  setupUI();
}

void draw()
{
  background(255);

  // draw cloud
  pushMatrix();
  translate(cloud.width / -2, cloud.height / -2);
  cloud.prepare();
  cloud.draw(this.g);
  popMatrix();

  // take screenshot if needed
  if (proposeTakeScreenshot)
  {
    String fileName = sketchPath("screenshots/" + currentCloudName + "-" + frameCount + ".png");
    saveFrame(fileName);
    proposeTakeScreenshot = false;

    println("created screenshot " + fileName);
  }

  // draw debug tools
  if (showAxis)
    showAxisMarker();

  // rotate camera
  if (autoRotateCamera)
  {
    cam.rotateY(radians(-0.25));
  }

  showInformation();
}

void showAxisMarker()
{
  int axisLength = 100;
  strokeWeight(3);

  // x
  stroke(236, 32, 73);
  line(0, 0, 0, axisLength, 0, 0);

  // y
  stroke(47, 149, 153);
  line(0, 0, 0, 0, axisLength, 0);

  // z
  stroke(247, 219, 79);
  line(0, 0, 0, 0, 0, axisLength);
}

void showInformation()
{
  cam.beginHUD();
  cp5.draw();

  fill(255);
  textSize(14);
  String infoText = "FPS: " + frameRate 
    + "\nVertex Count: " + cloud.cloud.getVertexCount();

  text(infoText, 20, height - 40);
  cam.endHUD();
}

DepthMapCloud createCloud(String colorImageName, String depthImageName, int samplingStep, float pointSize, int rangeMax, boolean adjustSize, boolean flipDepth)
{  
  PImage depthImage = loadImage(depthImageName);
  PImage colorImage = loadImage(colorImageName);

  // adjust images to each other
  if (adjustSize && depthImage.width < colorImage.width)
  {
    colorImage.resize(depthImage.width, depthImage.height);
  } else if (adjustSize && depthImage.width < colorImage.width)
  {
    depthImage.resize(colorImage.width, colorImage.height);
  }

  return new DepthMapCloud(colorImage, depthImage, samplingStep, pointSize, rangeMax, flipDepth, this);
}
