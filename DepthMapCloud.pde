import java.nio.file.Path;
import java.nio.file.Paths;

class DepthMapCloud
{
  PImage depthMap;
  PImage colorMap;
  PShape cloud = createShape();

  protected PShader depthMapShader;

  int samplingStep = 1;
  float pointSize = 3.0;

  float rangeMin = 0.0;
  float rangeMax = -400.0;

  float colorDepthMix = 0.0;

  boolean filterZeroDepth = true;

  boolean flipDepth = false;
  boolean useColorAsInput = false;

  protected int width;
  protected int height;

  protected PApplet sketch;

  protected volatile boolean isSetup = false;

  public DepthMapCloud(int width, int height, PApplet sketch)
  {
    this.sketch = sketch;
    this.width = width;
    this.height = height;
  }

  public DepthMapCloud(PImage colorMap, PImage depthMap, PApplet sketch)
  {
    this(colorMap.width, colorMap.height, sketch);

    this.colorMap = colorMap;
    this.depthMap = depthMap;
  }

  public DepthMapCloud(PImage colorMap, PImage depthMap, int rangeMax, PApplet sketch)
  {
    this(colorMap, depthMap, sketch);

    this.rangeMax = rangeMax;
  }

  public DepthMapCloud(PImage colorMap, PImage depthMap, int samplingStep, float pointSize, int rangeMax, boolean flipDepth, PApplet sketch)
  {
    this(colorMap, depthMap, sketch);

    this.samplingStep = samplingStep;
    this.pointSize = pointSize;
    this.rangeMax = rangeMax;
    this.flipDepth = flipDepth;
  }

  public DepthMapCloud(PImage img, PApplet sketch)
  {
    this(img, img, sketch);
  }

  public void setup()
  {
    // load shaders
    depthMapShader = sketch.loadShader("depthMapColor.glsl", "depthMapVertex.glsl");

    // create pointcloud
    cloud = createShape();
    cloud.beginShape(POINTS);

    cloud.stroke(255);
    cloud.fill(255);
    cloud.strokeWeight(1.0f);

    // add points
    for (int x = 0; x < width; x += samplingStep)
    {
      for (int y = 0; y < height; y += samplingStep)
      {
        cloud.vertex(x, y, 0);
      }
    }
    cloud.endShape();

    isSetup = true;
  }

  public void prepare()
  {
    if (!isSetup)
      return;

    // set shader information
    depthMapShader.set("depthMap", useColorAsInput ? colorMap : depthMap);
    depthMapShader.set("colorMap", useColorAsInput ? depthMap : colorMap);
    depthMapShader.set("res", (float)width, (float)height);
    depthMapShader.set("flipDepth", flipDepth ? 1.0 : 0.0);
    depthMapShader.set("pointScale", pointSize);

    depthMapShader.set("rangeMin", rangeMin);
    depthMapShader.set("rangeMax", rangeMax);
    depthMapShader.set("colorDepthMix", colorDepthMix);
    depthMapShader.set("filterZeroDepth", filterZeroDepth ? 1.0 : 0.0);
  }

  public void draw(PGraphics g)
  {
    if (!isSetup)
      return;

    // render
    g.shader(depthMapShader, POINTS);
    g.shape(cloud);
    g.resetShader();
  }

  public void dispose() {
  }
}
