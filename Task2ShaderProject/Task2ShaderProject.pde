ArduinoInput input; // Import the ArduinoInput Class
SoundInput sound; //Import the SoundInput Class

// Create shader objects
PShader shaderToy;
PShader rippleShader;
PShader rgbShiftShader;

// Create off sceen textures to render our shaders into
PGraphics shaderToyFBO;
PGraphics rippleFBO;
PGraphics rgbShiftFBO;

//-------------------------------------
void setup() {
  size(640, 480, P3D);
  //fullScreen(P3D);
  noStroke();
  background(0);

  input = new ArduinoInput(this);
  sound = new SoundInput(this);

  shaderToy = loadShader("myShader2.glsl"); // Load our .glsl shader from the /data folder  
  shaderToy.set("iResolution", float(width), float(height), 0); // Pass in our xy resolution to iResolution uniform variable in our shader
  shaderToyFBO = createGraphics(width, height, P3D);
  shaderToyFBO.shader(shaderToy);
  
  shaderToy.set("circleRadius", 0.5);
  shaderToy.set("sampleRate", 20.0);
  shaderToy.set("speed", 0.5);
  shaderToy.set("noiseScale", 10.0);

  rippleShader = loadShader("ripple.glsl");
  rippleShader.set("iResolution", float(width), float(height), 0); 
  rippleFBO = createGraphics(width, height, P3D);
  rippleFBO.shader(rippleShader);

  rgbShiftShader = loadShader("chromaticAbberation.glsl");
  rgbShiftShader.set("iResolution", float(width), float(height), 0);
  rgbShiftFBO = createGraphics(width, height, P3D);
  rgbShiftFBO.shader(rgbShiftShader);
}

//-------------------------------------
void updateShaderParams() {
  float[] sensorValues = input.getSensor();

  rippleShader.set("frequency", 0.00);
  rippleShader.set("waveNum", 0.00);
  rgbShiftShader.set("offset", 0.00);

  shaderToy.set("circleRadius", map(sensorValues[0], 0.0, 1024.0, 0.0, 1.0));
  shaderToy.set("sampleRate", map(sensorValues[1], 0.0, 1024.0, 20.0, 100.0));
  shaderToy.set("noiseScale", map(sensorValues[2], 0.0, 1024.0, 0.1, 20.0));
  shaderToy.set("speed", map(sound.getVolume(), 0.0, 1.0, 0.05, 0.1));
}

//-------------------------------------
void draw() {
  updateShaderParams();

  shaderToyFBO.beginDraw();
  shaderToy.set("iGlobalTime", millis() / 1000.0); // pass in a millisecond clock to enable animation 
  shader(shaderToy); 
  shaderToyFBO.rect(0, 0, width, height); // We draw a rect here for our shader to draw onto
  shaderToyFBO.endDraw();

  rippleFBO.beginDraw();
  rippleShader.set("iGlobalTime", millis() / 1000.0); 
  rippleShader.set("tex", shaderToyFBO);
  shader(rippleShader); 
  rippleFBO.rect(0, 0, width, height); 
  rippleFBO.endDraw();

  rgbShiftFBO.beginDraw();
  rgbShiftShader.set("iGlobalTime", millis() / 1000.0); 
  rgbShiftShader.set("tex", rippleFBO);
  shader(rgbShiftShader); 
  rgbShiftFBO.rect(0, 0, width, height); 
  rgbShiftFBO.endDraw();

  image(rgbShiftFBO, 0, 0, width, height);
}