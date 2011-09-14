/*

 Learning Pet Demo ADK
 --------------------
 RobotGrrl.com/LearningPet
 
 Licensed under BSD 3-Clause license
 
 */

import cc.arduino.*;

ArduinoAdkUsb arduino;

int val;
float rotation;

PFont statsFont;
PImage space, brrd;

int ultraLow = 0;
int ultraHigh = 620;

void setup() {
  arduino = new ArduinoAdkUsb( this );

  if ( arduino.list() != null )
    arduino.connect( arduino.list()[0] );

  orientation(LANDSCAPE);
  background( 255 );

  space = loadImage("space.jpg");
  brrd = loadImage("brrd.png");

  statsFont = loadFont("PTSans-NarrowBold-34.vlw");
}

void draw() {

  image(space, 0, 0, width, height);

  fill(255, 255, 255);
  rect(random(0, width), random(0, height), 2, 2);
  rect(random(0, width), random(0, height), 1, 1);

  fill(0, 0, 0, 60);
  rect(0, 0, width, height);

  if ( arduino.isConnected() ) {
    /* Try to read from arduino */
    if ( arduino.available() > 0 ) {
      val = arduino.readByte() & 0xFF; // 0-255

      /* Get a rotational value from the read byte */
      rotation = map( val, 0, ultraHigh/4, 0, HALF_PI );
    }

    /* Draw a simple rectangle, rotates based on read value */
    pushMatrix();
    translate( sketchWidth()/2, sketchHeight()/2 );
    rotate( rotation );
    fill( 0 );
    //rect( 0, 0, 300, 300 );
    image(brrd, 0, -100, 364, 200);

    popMatrix();
  }

  fill(255, 255, 255);
  textFont(statsFont, 34);
  text("Travelling Learning Pet!", 20, sketchHeight()-20);


  /*
  if(arduino.list() != null) {
   textFont(statsFont, 14);
   text("list was not null", 20, sketchHeight()-50);
   } else {
   textFont(statsFont, 14);
   text("list was null", 20, sketchHeight()-50);
   }
   */

  /* Draws a filled rect based on arduino connection state */
  connected( arduino.isConnected() );
}

/*
void onStop() {
 finish();
 }
 */

void connected( boolean state ) {
  pushMatrix();
  translate( 20, 20 );
  if ( state ) {
    fill( 0, 255, 0 );
  } 
  else {
    fill( 255, 0, 0 );
    if ( arduino.list() != null )
      arduino.connect( arduino.list()[0] );
  }
  ellipse(0, 0, 30, 30);
  popMatrix();
}

