
/**
 * ControlP5 Textfield
 *
 *
 * find a list of public methods available for the Textfield Controller
 * at the bottom of this sketch.
 *
 * by Andreas Schlegel, 2012
 * www.sojamo.de/libraries/controlp5
 *
 */

byte UPDATE_CTIME = 0X01;
byte UPDATE_FTIME1 = 0X02;
byte UPDATE_FTIME2 = 0X03;
byte GET_FTIME1 = 0X04;
byte GET_FTIME2 = 0X05;
byte UPDATE_MANUAL = 0X06;

import controlP5.*;
ControlP5 cp5;  // Create GUI object 

import processing.serial.*; 
Serial port;                       // Create object from Serial class
int lf = 10;      // ASCII linefeed


class time 
{
    byte day;
    byte month;
    byte year;
    byte hour;
    byte minute;
    byte second;
    
    void set_time(int y, int m, int d, int h, int min, int s){
      day = (byte)d;
      year = (byte)(y%100);
      month =(byte)m;
      hour = (byte)h;
      minute = (byte)min;
      second = (byte)s;
    }
    
    
    void set_time_from_sys()
    {
      set_time(year(), month(), day(), hour(), minute(), second());
    }
}

class setTime extends time
{
  byte duration;
  void set_trigger_time(int h, int min, int s, int dura){
      hour = (byte)h;
      minute = (byte)min;
      second = (byte)s;
      duration = (byte)dura;
  }
}


time ctime = new time();
time setTime1 = new time();
time setTime2 = new time();
String timeCurrent = " ";

PFont font_title; 
PFont font; 
PFont font_label;

Knob speedKnob1;
Knob speedKnob2;
Knob speedKnob;

void setup_serial(int baud)
{
    try {
     // List all the available serial ports:
      printArray(Serial.list());
      // Open the port that the board is connected to and use the same speed (9600 bps)
      port = new Serial(this, Serial.list()[0], baud);
      port.bufferUntil(lf);
  } catch (Exception  e) {
    e.printStackTrace();
    println("No Serial port is detected.");
  }
 
}

void setup_gui()
{  
  font_title = createFont("forte", 32);
  font = createFont("arial", 20);
  font_label = createFont("arial", 15);
  cp5 = new ControlP5(this);
  int size = 60;

  cp5.addTextfield("Year")
    .setPosition(20, 120)
    .setSize(size, 30)
    .setFont(font_label)
 //   .setFocus(true)
    .setAutoClear(false)
    .setInputFilter(1)
    ;

  cp5.addTextfield("Month")
    .setPosition(20 + size + 20, 120)
    .setSize(size, 30)
    .setFont(font_label)
//    .setFocus(true)
    .setAutoClear(false)  
    .setInputFilter(1)
    ;

  cp5.addTextfield("Day")
    .setPosition(20 + (size + 20) * 2, 120)
    .setSize(size, 30)
    .setFont(font_label)
  //  .setFocus(true)
    .setAutoClear(false)
    .setInputFilter(1)
    ;
    
  cp5.addTextfield("Hour")
    .setPosition(20 + (size + 20) * 3, 120)
    .setSize(size, 30)
    .setFont(font_label)
//    .setFocus(true)
    .setAutoClear(false)
    .setInputFilter(1)
    ;

    
  cp5.addTextfield("Minute")
    .setPosition(20 + (size + 20) * 4, 120)
    .setSize(size, 30)
    .setFont(font_label)
//    .setFocus(true)
    .setAutoClear(false)
    .setInputFilter(1)
    ;
    
        
  cp5.addTextfield("Second")
    .setPosition(20 + (size + 20) * 5, 120)
    .setSize(size, 30)
    .setFont(font_label)
//    .setFocus(true)
    .setAutoClear(false)
    .setInputFilter(1)
    ;

     cp5.addBang("Update")
    .setPosition(20 + (size + 20) * 6, 120)
    .setSize(80, 30)
    .setFont(font_label)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    ;   
 
     cp5.addBang("get_sys_time")
    .setPosition(20 + (size + 20) * 7 + 20, 120)
    .setSize(160, 30)
    .setLabel("Get the Sys Time")
    .setFont(font_label)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    ;   
  
    Group g1 = cp5.addGroup("g1")
                .setPosition(20,200)
                .setWidth(400)
                .activateEvent(true)
                .setBackgroundColor(color(255,80))
                .setBackgroundHeight(260)
                .setLabel("Feed Time 1.")
                ; 
                
  cp5.addTextfield("feed1_hour")
    .setPosition(10, 20)
    .setSize(size, 30)
    .setFont(font_label)
    .setLabel("Hour")
    .setAutoClear(false)
    .setGroup(g1)
    .setInputFilter(1)
    ;

  cp5.addTextfield("feed1_min")
    .setPosition(10 + (size + 20) , 20)
    .setSize(size, 30)
    .setFont(font_label)
    .setLabel("Min")
    .setAutoClear(false)
    .setGroup(g1)
    .setInputFilter(1)
    ;

  cp5.addTextfield("feed1_sec")
    .setPosition(10 + (size + 20) * 2, 20)
    .setSize(size, 30)
    .setFont(font_label)
    .setLabel("Sec")
    .setAutoClear(false)
    .setGroup(g1)
    .setInputFilter(1)
    ;

  cp5.addTextfield("feed1_dur")
    .setPosition(10 + (size + 20) * 3, 20)
    .setSize(size + 50, 30)
    .setFont(font_label)
    .setLabel("Duration/Sec")
    .setAutoClear(false)
    .setGroup(g1)
    .setInputFilter(1)
    ;
    
  speedKnob1 = cp5.addKnob("Speed1")
               .setRange(0,255)
               .setValue(50)
               .setPosition(10,100)
               .setRadius(50)
               .setColorForeground(color(255))
               .setColorBackground(color(0, 160, 100))
               .setColorActive(color(255,255,0))
               .setDragDirection(Knob.VERTICAL)
               .setGroup(g1)
               ;
                     
  // create a toggle and change the default look to a (on/off) switch look
  cp5.addToggle("feed1_switcher")
     .setPosition(20,222)
     .setSize(80,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     .setGroup(g1)
     ;
     
     cp5.addBang("Update1")
    .setPosition(150, 120)
    .setSize(80, 30)
    .setLabel("Update")
    .setFont(font_label)
    .setGroup(g1)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    ;   
 
     cp5.addBang("getTime1")
    .setPosition(150, 170)
    .setSize(160, 30)
    .setLabel("Get Setting Time")
    .setFont(font_label)
    .setGroup(g1)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)     
    ;
    
    Group g2 = cp5.addGroup("g2")
                .setPosition(20 + (size + 20) * 6 ,200)
                .setWidth(400)
                .activateEvent(true)
                .setBackgroundColor(color(255,80))
                .setBackgroundHeight(260)
                .setLabel("Feed Time 2.")
                ; 

  cp5.addTextfield("feed2_hour")
    .setPosition(10, 20)
    .setSize(size, 30)
    .setFont(font_label)
    .setLabel("Hour")
    .setAutoClear(false)
    .setGroup(g2)
    .setInputFilter(1)
    ;

  cp5.addTextfield("feed2_min")
    .setPosition(10 + (size + 20) , 20)
    .setSize(size, 30)
    .setFont(font_label)
    .setLabel("Min")
    .setAutoClear(false)
    .setGroup(g2)
    .setInputFilter(1)
    ;

  cp5.addTextfield("feed2_sec")
    .setPosition(10 + (size + 20) * 2, 20)
    .setSize(size, 30)
    .setFont(font_label)
    .setAutoClear(false)
    .setLabel("Sec")
    .setGroup(g2)
    .setInputFilter(1)
    ;

  cp5.addTextfield("feed2_dur")
    .setPosition(10 + (size + 20) * 3, 20)
    .setSize(size + 50, 30)
    .setFont(font_label)
    .setAutoClear(false)
    .setLabel("Duration/Sec")
    .setGroup(g2)
    .setInputFilter(1)
    ;
    
  speedKnob1 = cp5.addKnob("Speed2")
               .setRange(0,255)
               .setValue(50)
               .setPosition(10,100)
               .setRadius(50)
               .setColorForeground(color(255))
               .setColorBackground(color(0, 160, 100))
               .setColorActive(color(255,255,0))
               .setDragDirection(Knob.VERTICAL)
               .setGroup(g2)
               ;
                     
  // create a toggle and change the default look to a (on/off) switch look
  cp5.addToggle("feed2_switcher")
     .setPosition(20,222)
     .setSize(80,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     .setGroup(g2)
     ;
     
     cp5.addBang("Update2")
    .setPosition(150, 120)
    .setSize(80, 30)
    .setLabel("Update")
    .setFont(font_label)
    .setGroup(g2)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    ;   
 
     cp5.addBang("getTime2")
    .setPosition(150, 170)
    .setSize(160, 30)
    .setLabel("Get Setting Time")
    .setFont(font_label)
    .setGroup(g2)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)     
    ;
    
                
   cp5.addToggle("manual_switcher")
     .setPosition(150,500)
     .setSize(100,40)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
     
   speedKnob = cp5.addKnob("Manual")
               .setRange(0,255)
               .setValue(50)
               .setPosition(20,480)
               .setRadius(50)
               .setDragDirection(Knob.VERTICAL)
               ;        
}

void setup() {
  size(1000, 600);
  setup_gui(); // setup the gui
  setup_serial(9600); // setup the serial
}

void draw() {
  background(0);

  // draw the title  
  fill(0, 255, 110);
  textFont(font_title);
  text("Rabbit Feeder for Tangyuan", 300, 50);  // Specify a z-axis value
  
  // draw the current time
  fill(255);
  textFont(font);
  text("Current Time: " + timeCurrent, 320, 80);
 // text(cp5.get(Textfield.class, "input").getText(), 360, 130);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class)) {
    println("controlEvent: accessing a string from controller '"
      +theEvent.getName()+"': "
      +theEvent.getStringValue()
      );
  }
  else  if(theEvent.isGroup()) {
    println("got an event from group "
            +theEvent.getGroup().getName()
            +", isOpen? "+theEvent.getGroup().isOpen()
            );
  }
}

public void get_sys_time() {
  ctime.set_time_from_sys();
  cp5.get(Textfield.class, "Year").setText("20"+String.valueOf(ctime.year));
  cp5.get(Textfield.class, "Month").setText(String.valueOf(ctime.month));
  cp5.get(Textfield.class, "Day").setText(String.valueOf(ctime.day));
  cp5.get(Textfield.class, "Hour").setText(String.valueOf(ctime.hour));
  cp5.get(Textfield.class, "Minute").setText(String.valueOf(ctime.minute));
  cp5.get(Textfield.class, "Second").setText(String.valueOf(ctime.second));
}

public void Update() {
  try
  {
    port.write(UPDATE_CTIME);
    port.write(ctime.year);port.write(ctime.month);port.write(ctime.day);port.write(ctime.hour);port.write(ctime.minute);port.write(ctime.second);
  }
  catch (Exception  e) {
    e.printStackTrace();
    println("No Serial port is detected.");
  }
}

public void Manual(int theValue) {
  // write the knod value to nano if the switcher is opened 
  if(cp5.get(Toggle.class, "manual_switcher").getBooleanValue() == true){
   try { 
    port.write(UPDATE_MANUAL);
    port.write((byte)theValue);
    println((byte)theValue);
   }
   catch (Exception  e) {
    e.printStackTrace();
    println("No Serial port is detected.");
  }
    // print(theValue);
  } 
  // write the 0x00 to nano if the switcher is closed
  else {
    try{
    port.write(UPDATE_MANUAL);
    port.write(0x00);
    }
    catch (Exception  e) {
    e.printStackTrace();
    println("No Serial port is detected.");
  }
    // print(0x00);
  }
}

public void manual_switcher(boolean theFlag) {
  if(theFlag==true) {
    try{
      port.write(UPDATE_MANUAL);
      port.write((byte)speedKnob.getValue());
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
      // print(speedKnob.getValue());
  }else {
    try{
      port.write(UPDATE_MANUAL);
      port.write(0x00);
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
   // print(0x00);
  }
  println(" toggle motor.");
}

public void Update1()
{
  try{
   // print((byte)Integer.parseInt(cp5.get(Textfield.class, "feed1_sec").getText()));
    port.write(UPDATE_FTIME1);
    port.write((byte)cp5.get(Toggle.class, "feed1_switcher").getValue());
    port.write((byte)speedKnob1.getValue());
    port.write((byte)Integer.parseInt(cp5.get(Textfield.class, "feed1_hour").getText()));
    port.write((byte)Integer.parseInt(cp5.get(Textfield.class, "feed1_min").getText()));   
    port.write((byte)Integer.parseInt(cp5.get(Textfield.class, "feed1_sec").getText()));

  }
  catch (Exception e)
  {
  }
  
}

int state = 0;
// 0 - NOP
// 1 - C time
// 2 - Feed time 1
// 3 - Fedd time 2

void serialEvent(Serial p) {
  String data = p.readString();
  if(data.equals("__NOMAL_TIME__\n")){
    state = 1;  
  }
  else if(data.equals("__FEED_TIME_1__\n"))
    state = 2;
  else if(data.equals("__FEED_TIME_2__\n"))
    state = 3; 
  else
  {
    switch (state)
    {
      case 1:
        timeCurrent = data;
      //  p.write(65);   p.write(20);   p.write(10);
        break;
      case 2:
        // do some thing
        break;
      case 3:
        // do some thing
        break;
      default:
        print(data);
    }
    state = 0;
  }   
}