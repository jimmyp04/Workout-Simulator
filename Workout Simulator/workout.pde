import beads.*;
import org.jaudiolibs.beads.*;
import controlP5.*;

ControlP5 p5;
RadioButton trainingSelector;



//to use text to speech functionality, copy text_to_speech.pde from this sketch to yours
//example usage below

//IMPORTANT (notice from text_to_speech.pde):
//to use this you must import 'ttslib' into Processing, as this code uses the included FreeTTS library
//e.g. from the Menu Bar select Sketch -> Import Library... -> ttslib
TextToSpeechMaker ttsMaker; 


//to use this, copy notification.pde, notification_listener.pde and notification_server.pde from this sketch to yours.
//Example usage below.

//name of a file to load from the data directory
//String eventDataJSON2 = "smarthome_party.json";
String perfectBenchJSON = "bench_press_correct.json";
String incorrectBenchJSON = "bench_press_incorrect.json";
String perfectPushupJSON = "pushup_correct.json";
String incorrectPushupJSON = "pushup_incorrect.json";

NotificationServer notificationServer;
ArrayList<Notification> notifications;

MyNotificationListener myNotificationListener;

void setup() {
  size(600,600);
  p5 = new ControlP5(this);
  ac = new AudioContext(); //ac is defined in helper_functions.pde
  setupAudio();
  //this will create WAV files in your data directory from input speech 
  //which you will then need to hook up to SamplePlayer Beads
  ttsMaker = new TextToSpeechMaker();
  
  
  //START NotificationServer setup
  notificationServer = new NotificationServer();
  
  //instantiating a custom class (seen below) and registering it as a listener to the server
  myNotificationListener = new MyNotificationListener();
  notificationServer.addListener(myNotificationListener);
    
//Control P5 Elements go here
  trainingSelector = p5.addRadioButton("trainingSelection")
    .setPosition(40,20)
    .setSize(105,25)
    .setSpacingRow(15)
    .setSpacingColumn(30)
    .setItemsPerRow(3)
    .setLabelPadding(-100,0)
    .addItem("Perfect Bench-Press", 1)
    .addItem("Perfect Push-Up", 2)
    .addItem("Training Mode", 3)
    .addItem("Incorrect Bench-Press", 4)
    .addItem("Incorrect Push-Up", 5);
    
  p5.addSlider("masterGainSlider")
    .setPosition(40, 150)
    .setSize(500, 20)
    .setRange(0, 100)
    .setValue(masterGainGlide.getValue())
    .setLabel("Volume");
    
  leftArmSlider = p5.addSlider("sineLeftArmSlider")
    .setPosition(20, 410)
    .setSize(20, 100)
    .setRange(0, 1)
    .setValue(sineLeftArmGlide.getValue())
    .setLabel("Left Arm Extension");
    
  leftArmToggler = p5.addToggle("leftArm")
    .setPosition(20, 530)
    .setSize(70,15)
    .setLabel("")
    .setValue(true);
    
  rightArmSlider = p5.addSlider("rightArmSlider")
    .setPosition(110, 410)
    .setSize(20, 100)
    .setRange(0, 1)
    .setValue(sineRightArmGlide.getValue())
    .setLabel("Right Arm Extension");

  rightArmToggler = p5.addToggle("rightArm")
    .setPosition(110, 530)
    .setSize(70,15)
    .setLabel("")
    .setValue(true);

  shouldersSlider = p5.addSlider("shouldersSlider")
    .setPosition(210, 410)
    .setSize(20, 100)
    .setRange(0, 1)
    .setValue(sineShouldersGlide.getValue())
    .setLabel("Shoulders Extension");

  shouldersToggler = p5.addToggle("shoulders")
    .setPosition(210, 530)
    .setLabel("")
    .setSize(70,15)
    .setValue(true);

  backSlider = p5.addSlider("backSlider")
    .setPosition(310, 410)
    .setSize(20, 100)
    .setRange(0, 1)
    .setValue(sineBackGlide.getValue())
    .setLabel("Back Extension");

  backToggler = p5.addToggle("back")
    .setPosition(310, 530)
    .setLabel("")
    .setSize(50,15)
    .setValue(true);


  calvesSlider = p5.addSlider("calvesSlider")
    .setPosition(390, 410)
    .setSize(20, 100)
    .setRange(0, 1)
    .setValue(sineCalvesGlide.getValue())
    .setLabel("Calves Extension");

  calvesToggler = p5.addToggle("calves")
    .setPosition(390, 530)
    .setLabel("")
    .setSize(50,15)
    .setValue(true);

  wristRotation = p5.addKnob("wristRotation")
    .setPosition(30, 200)
    .setRadius(75)
    .setNumberOfTickMarks(14)
    .setTickMarkLength(6)
    .snapToTickMarks(true)
    .setRange(-5, 30)
    .setValue(0)
    .setLabel("Wrist Rotation Angle (-Flexion, Extension)");

  targetRotation = p5.addKnob("targetRotation")
    .setPosition(230, 200)
    .setRadius(75)
    .setNumberOfTickMarks(14)
    .setTickMarkLength(6)
    .snapToTickMarks(true)
    .setRange(-5, 30)
    .setValue(0)
    .setLabel("Target Rotation Angle (-Flexion, Extension)");
    
  weightDist = p5.addSlider2D("weightDist")
    .setPosition(425, 200)
    .setSize(150, 150)
    .setMinMax(-5, -5, 5, 5)
    .setLabel("Weight Distribution")            
    .setValue(0,0);


  p5.addButton("leftArmAlert")
    .setPosition(480, 410)
    .setLabel("Left Arm Alert")
    .setSize(105,25);


  p5.addButton("rightArmAlert")
    .setPosition(480, 435)
    .setLabel("Right Arm Alert")
    .setSize(105,25);

  p5.addButton("shouldersAlert")
    .setPosition(480, 460)
    .setLabel("Shoulders Alert")
    .setSize(105,25);

  p5.addButton("backAlert")
    .setPosition(480, 485)
    .setLabel("Back Alert")
    .setSize(105,25);
    
  p5.addButton("calvesAlert")
    .setPosition(480, 510)
    .setLabel("Calves Alert")
    .setSize(105,25);
    
  //ac.start();
}

void draw() {
  //this method must be present (even if empty) to process events such as keyPressed()
  background(0);
}
//in your own custom class, you will implement the NotificationListener interface 
//(with the notificationReceived() method) to receive Notification events as they come in
class MyNotificationListener implements NotificationListener {
  
  public MyNotificationListener() {
    //setup here
  }
  
  //this method must be implemented to receive notifications
  public void notificationReceived(Notification notification) { 
    println("<Example> " + notification.getType().toString() + " notification received at " 
    + Integer.toString(notification.getTimestamp()) + " ms");
    
    String debugOutput = ">>> ";
    switch (notification.getType()) {
      case MuscleExtension:
        if (notification.getMuscleGroup().equals("left_arm")) {
          leftArmSlider.setValue(notification.getExtensionLevel());
          if (notification.getFlag().equals("bad")) {
            ttsExamplePlayback("left arm");
          }
          
        } else if (notification.getMuscleGroup().equals("right_arm")) {
          rightArmSlider.setValue(notification.getExtensionLevel());
          if (notification.getFlag().equals("bad")) {
            ttsExamplePlayback("right arm");
          }
          
        } else if (notification.getMuscleGroup().equals("back")) {
          backSlider.setValue(notification.getExtensionLevel());
          if (notification.getFlag().equals("bad")) {
            ttsExamplePlayback("back");
          }
          
        } else if (notification.getMuscleGroup().equals("shoulders")) {
          shouldersSlider.setValue(notification.getExtensionLevel());
          if (notification.getFlag().equals("bad")) {
            ttsExamplePlayback("shoulders");
          }
          
        } else if (notification.getMuscleGroup().equals("calves")) {
          calvesSlider.setValue(notification.getExtensionLevel());
          if (notification.getFlag().equals("bad")) {
            ttsExamplePlayback("calves");
          }
          
        }
        break;
      case WristRotation:
        targetRotation.setValue(notification.getTargetRotation());
        wristRotation.setValue(notification.getCurrentRotation());
        break;
      case WeightDistribution:
        weightDist.setValue(notification.getXPos(), notification.getYPos());
        break;
       
    }
    debugOutput += notification.toString();
    //debugOutput += notification.getLocation() + ", " + notification.getTag();
    
    println(debugOutput);
    
   //You can experiment with the timing by altering the timestamp values (in ms) in the exampleData.json file
    //(located in the data directory)
  }
}

void ttsExamplePlayback(String inputSpeech) {
  //create TTS file and play it back immediately
  //the SamplePlayer will remove itself when it is finished in this case
  
  String ttsFilePath = ttsMaker.createTTSWavFile(inputSpeech);
  println("File created at " + ttsFilePath);
  
  //createTTSWavFile makes a new WAV file of name ttsX.wav, where X is a unique integer
  //it returns the path relative to the sketch's data directory to the wav file
  
  //see helper_functions.pde for actual loading of the WAV file into a SamplePlayer
  
  SamplePlayer sp = getSamplePlayer(ttsFilePath, true); 
  //true means it will delete itself when it is finished playing
  //you may or may not want this behavior!
  //envelopeGain.addInput(sp);;
  ttsGain.addInput(sp);
  //masterGain.addInput(sp);
  sp.setToLoopStart();
  sp.start();
  println("TTS: " + inputSpeech);
}
