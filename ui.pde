import controlP5.*;
import java.util.Arrays;

ControlP5 cp5;

ScrollableList exampleList;

int uiHeight;

boolean isUIInitialized = false;

Object[] keys;

void setupUI()
{
  isUIInitialized = false;
  PFont font = createFont("Helvetica", 100f);

  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);

  // change the original colors
  cp5.setColorForeground(color(255, 132, 124));
  cp5.setColorBackground(color(42, 54, 59));
  cp5.setFont(font, 14);
  cp5.setColorCaptionLabel(color(0));
  //cp5.setColorValueLabel(color(0));
  cp5.setColorActive(color(255, 132, 124));

  int h = 10;
  cp5.addSlider("samplingStep", 10, 150, 10, h, 100, 20)
    .setRange(1, 15)
    .setLabel("Sampling Step")
    .setValue(cloud.samplingStep)
    .plugTo(cloud);

  h += 25;
  cp5.addSlider("pointSize", 10, 150, 10, h, 100, 20)
    .setRange(0.5, 5)
    .setLabel("Point Size")
    .setValue(cloud.pointSize)
    .plugTo(cloud);

  h += 30;
  cp5.addButton("recreateCloud")
    .setValue(100)
    .setPosition(10, h)
    .setSize(200, 22)
    .setCaptionLabel("Create Cloud")
    ;

  h += 50;
  cp5.addSlider("rangeMax", 10, 150, 10, h, 100, 20)
    .setRange(0, -150)
    .setLabel("Depth Range")
    .setValue(cloud.rangeMax)
    .setSliderMode(Slider.FLEXIBLE)
    .plugTo(cloud);

  h += 25;
  cp5.addSlider("colorDepthMix", 10, 150, 10, h, 100, 20)
    .setRange(0.0, 1.0)
    .setLabel("Color / Depth Mix")
    .setSliderMode(Slider.FLEXIBLE)
    .setValue(cloud.colorDepthMix)
    .plugTo(cloud);

  h += 50;
  cp5.addToggle("flipDepth")
    .setPosition(10, h)
    .setSize(100, 20)
    .setCaptionLabel("Flip Depth")
    .setValue(cloud.flipDepth)
    .plugTo(cloud);

  cp5.addToggle("filterZeroDepth")
    .setPosition(10 + 105, h)
    .setSize(100, 20)
    .setCaptionLabel("Filter 0-Depth")
    .setValue(cloud.filterZeroDepth)
    .plugTo(cloud);

  h += 50;
  cp5.addToggle("useColorAsInput")
    .setPosition(10, h)
    .setSize(100, 20)
    .setCaptionLabel("Color Input")
    .setValue(cloud.useColorAsInput)
    .plugTo(cloud);

  h += 50;
  cp5.addToggle("showAxis")
    .setPosition(10, h)
    .setSize(100, 20)
    .setCaptionLabel("Show Axis");

  cp5.addToggle("autoRotateCamera")
    .setPosition(10 + 105, h)
    .setSize(100, 20)
    .setCaptionLabel("Auto Rotate")
    .setValue(autoRotateCamera);

  h += 50;
  cp5.addButton("takeScreenShot")
    .setValue(100)
    .setPosition(10, h)
    .setSize(200, 22)
    .setCaptionLabel("Screenshot")
    ;

  uiHeight = h + 500;

  isUIInitialized = true;
}

void samplingStep(int value)
{
  if (!isUIInitialized) return;
  cloud.samplingStep = value;
}

void pointSize(float value)
{
  if (!isUIInitialized) return;
  cloud.pointSize = value;
}

void rangeMax(float value)
{
  if (!isUIInitialized) return;
  cloud.rangeMax = value;
}

void colorDepthMix(float value)
{
  if (!isUIInitialized) return;
  cloud.colorDepthMix = value;
}

void flipDepth(boolean value)
{
  if (!isUIInitialized) return;
  cloud.flipDepth = value;
}

void filterZeroDepth(boolean value)
{
  if (!isUIInitialized) return;
  cloud.filterZeroDepth = value;
}

void useColorAsInput(boolean value)
{
  if (!isUIInitialized) return;
  cloud.useColorAsInput = value;
}

void recreateCloud(int value)
{
  if (!isUIInitialized)
    return;
  cloud.dispose();
  cloud.setup();
}

void takeScreenShot(int value)
{
  if (!isUIInitialized)
    return;

  proposeTakeScreenshot = true;
}

public String formatTime(long millis)
{
  long second = (millis / 1000) % 60;
  long minute = (millis / (1000 * 60)) % 60;
  long hour = (millis / (1000 * 60 * 60)) % 24;

  if (minute == 0 && hour == 0 && second == 0)
    return String.format("%02dms", millis);

  if (minute == 0 && hour == 0)
    return String.format("%02ds", second);

  if (hour == 0)
    return String.format("%02dm %02ds", minute, second);

  return String.format("%02dh %02dm %02ds", hour, minute, second);
}

void mousePressed() {

  // suppress cam on UI
  if (mouseX > 0 && mouseX < 250 && mouseY > 0 && mouseY < uiHeight) {
    cam.setActive(false);
  } else {
    cam.setActive(true);
  }
}
