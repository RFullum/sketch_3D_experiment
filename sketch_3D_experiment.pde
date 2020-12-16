/*
*  Audio visualizer using FFT analysis to display the audio spectrum
*  Low frequencies in the center, with higher frequencies to the sides
*  When the FFT band amplitude increases, the sphere size increases, while
*  moving towards you along the Z axis, and color-lerping
*  
*  Robert Fullum 2020
*/

import processing.sound.*;

// Sound instances
AudioIn audioIn;
FFT fft;

// FFT variables
int fftResolution = 7;    // the power you're raising 2 to
int bands = (int)pow(2, fftResolution);  
int halfBands = bands / 2;
float smoothingFactor = 0.1f;
float[] spectrum = new float[bands];

// Sphere variables
int ures = 50;
int vres = 50;
float sphereSize = 100.0f;

void setup()
{
  fullScreen(P3D);
  
  // Audio Setup
  audioIn = new AudioIn(this, 0);
  fft = new FFT(this, bands);
  
  audioIn.start();
  fft.input(audioIn);
  
  blendMode(BLEND);
}

void draw()
{
  background(0);
  
  // Audio values
  fft.analyze();
  
  for (int i=0; i<bands; i++)
  {
    spectrum[i] += (fft.spectrum[i] - spectrum[i]) * smoothingFactor;
  }
  
  // Color values
  color c1 = color(49.0f, 250.0f, 255.0f);
  color c2 = color(255.0f, 128.0f, 23.0f);
  noStroke();
  
  // Low to High :: Center to Right
  for (int i=0; i<halfBands; i++)
  {
    float sphrRadius = (width / (float)halfBands) / 2.0f;
    float xCoord = (width / 2) + (sphrRadius / 2.0f) + (sphrRadius * i);
    float yCoord = height / 2.0f;
    
    float colorMap = norm((float)i, 0.0f, (float)halfBands); 
    float euler = 2.718f;
    float lerpAmount = map(spectrum[i], 0.0f, 1.0f, 1.0f, euler);
    
    pushMatrix();
      translate( xCoord, yCoord, -500.0f + (spectrum[i] * 1000.0f) );
      fill( lerpColor( lerpColor(c1, c2, colorMap), color(252.0f, 76.0f, 215.0f), log(lerpAmount) ) );
      sphere( sphrRadius + (height * spectrum[i]) );
    popMatrix();
  }
  
  // Low to High :: Center to Left
  for (int i=0; i<halfBands; i++)
  {
    float sphrRadius = (width / (float)halfBands) / 2.0f;
    float xCoord = (width / 2) + (sphrRadius / 2.0f) + (sphrRadius * -i);
    float yCoord = height / 2.0f;
    
    float colorMap = norm((float)i, 0.0f, (float)halfBands); 
    float euler = 2.718f;
    float lerpAmount = map(spectrum[i], 0.0f, 1.0f, 1.0f, euler);
    
    pushMatrix();
      translate( xCoord, yCoord, -500.0f + (spectrum[i] * 1000.0f) );
      fill( lerpColor( lerpColor(c1, c2, colorMap), color(252.0f, 76.0f, 215.0f), log(lerpAmount) ) );
      sphere( sphrRadius + (height * spectrum[i]) );
    popMatrix();
  }
  
  /*
  for (int i=0; i<halfBands; i++)
  {
    float rectWidth = width / (float)halfBands;
    float rectHeight = -height * spectrum[i] * 10.0f;
    
    float xCoord = (rectWidth / 2.0f) + (rectWidth * i);
    float yCoord = height;
    
    float colorMap = norm((float)i, 0.0f, (float)halfBands); 
    
    pushMatrix();
      translate(xCoord, yCoord, -500.0f + (spectrum[i] * 1000.0f));
      fill( lerpColor( lerpColor(c1, c2, colorMap), color(252.0f, 76.0f, 215.0f), spectrum[i] ) );
      rect(0.0f, 0.0f, rectWidth + (rectWidth * spectrum[i] * 10.0f), rectHeight);
    popMatrix();
    
  }
  */
}
