import beads.*;
import org.jaudiolibs.beads.*;
import controlP5.*;

//Left Arm = sineChest

//UGens needed for muscle groups
WavePlayer sineLeftArm;
Glide sineLeftArmGlide;
Slider leftArmSlider;
Toggle leftArmToggler;
float leftArmValue;
boolean leftArmAudio;
float leftArmMult = 1000;

WavePlayer sineRightArm;
Glide sineRightArmGlide;
Slider rightArmSlider;
Toggle rightArmToggler;
float rightArmValue;
boolean rightArmAudio;
float rightArmMult = 2000;

WavePlayer sineShoulders;
Glide sineShouldersGlide;
Slider shouldersSlider;
Toggle shouldersToggler;
float shouldersValue;
boolean shouldersAudio;
float shouldersMult = 3000;

WavePlayer sineBack;
Glide sineBackGlide;
Slider backSlider;
Toggle backToggler;
float backValue;
boolean backAudio;
float backMult = 4000;


WavePlayer sineCalves;
Glide sineCalvesGlide;
Slider calvesSlider;
Toggle calvesToggler;
float calvesValue;
boolean calvesAudio;
float calvesMult = 5000;


//UGens needed for Wrist rotation
Knob wristRotation;
Knob targetRotation;
BiquadFilter lowPassFilter;
Glide lowPassGlide;

//Ugens needed for Weight Distribution
Envelope envelope;
Gain envelopeGain;
Panner audioPanner;
Glide audioPannerGlide;
Slider2D weightDist;

//UGens needed for volume
Glide masterGainGlide;
Gain masterGain;

//UGen Needed for TTS Volume
Gain ttsGain;




void setupAudio() {
  setupMasterGain();
  setupFilters();
  setupWavePlayers();
  setupEnvelopes();;
  setupKnobs();
  setupInputs();
}

void setupFilters() {
  lowPassGlide = new Glide(ac, 600, 50);
  lowPassFilter = new BiquadFilter(ac, BiquadFilter.AP, lowPassGlide, .5);
  
}

void setupMasterGain() {
  masterGainGlide = new Glide(ac, 100, 1.0);
  masterGain = new Gain(ac, 2, masterGainGlide);
  //Change this back to 2 inputs later if it doesnt bug out
  
  ttsGain = new Gain(ac, 1, 5);
}

void setupWavePlayers() {
  sineLeftArmGlide = new Glide(ac, 0.0, 50);
  sineLeftArm = new WavePlayer(ac, sineLeftArmGlide, Buffer.SINE);
  
  sineRightArmGlide = new Glide(ac, 0.0, 50);
  sineRightArm = new WavePlayer(ac, sineRightArmGlide, Buffer.SINE);
  
  sineShouldersGlide = new Glide(ac, 0.0, 50);
  sineShoulders = new WavePlayer(ac, sineShouldersGlide, Buffer.SINE);
    
  sineBackGlide = new Glide(ac, 0.0, 50);
  sineBack = new WavePlayer(ac, sineBackGlide, Buffer.SINE);
  
  sineCalvesGlide = new Glide(ac, 0.0, 50);
  sineCalves = new WavePlayer(ac, sineCalvesGlide, Buffer.SINE);
}

void setupKnobs() {
  audioPannerGlide = new Glide(ac, 0, 5);
  audioPanner = new Panner(ac, audioPannerGlide);
}

void setupInputs() {
 
  envelopeGain.addInput(sineLeftArm);
  envelopeGain.addInput(sineRightArm);
  envelopeGain.addInput(sineShoulders);
  envelopeGain.addInput(sineBack);
  envelopeGain.addInput(sineCalves);
  envelopeGain.addInput(ttsGain);
  
  lowPassFilter.addInput(envelopeGain);
  audioPanner.addInput(lowPassFilter);
  masterGain.addInput(audioPanner);
  //Experimental below I'd have a gain that controls the tts volume
  ac.out.addInput(masterGain);
}

void setupEnvelopes() {
  envelope = new Envelope(ac, 1);
  envelopeGain = new Gain(ac, 6, envelope);
}

//Below are Functions for the Ugens
void trainingSelection (int selection) {
  if (selection == 1) {
    resetDevice();
    ac.start();
    notificationServer.loadEventStream(perfectBenchJSON);
    println("**** New event stream loaded: " + perfectBenchJSON + " ****");
  } else if (selection == 2) {
    resetDevice();
    ac.start();
    notificationServer.loadEventStream(perfectPushupJSON);
    println("**** New event stream loaded: " + perfectPushupJSON + " ****");
  } else if (selection == 3) {
    resetDevice();
    ac.start();
  } else if (selection == 4) {
    resetDevice();
    ac.start();
    notificationServer.loadEventStream(incorrectBenchJSON);
    println("**** New event stream loaded: " + incorrectBenchJSON + " ****");
  } else if (selection == 5) {
    resetDevice();
    ac.start();
    notificationServer.loadEventStream(incorrectPushupJSON);
    println("**** New event stream loaded: " + incorrectPushupJSON + " ****");
  } else {
    resetDevice();
    ac.stop();
  }
}

void masterGainSlider(float value) {
  masterGainGlide.setValue(value/350.0);
}

void sineLeftArmSlider(float value) {
  if (leftArmAudio) {
    sineLeftArmGlide.setValue(value * leftArmMult);
  } else {
    sineLeftArmGlide.setValue(0);
  }
  leftArmValue = value;
}

void leftArm(boolean value) {
  if (value == true) {
    leftArmAudio = true;
    sineLeftArmGlide.setValue(leftArmValue * leftArmMult);
  } else {
    leftArmAudio = false;
    sineLeftArmGlide.setValue(0);
  }
}

void leftArmAlert() {
  if (trainingSelector.getValue() == 3) {
    ttsExamplePlayback("left arm");
  }
}

void rightArmSlider(float value) {
  if (rightArmAudio) {
    sineRightArmGlide.setValue(value * rightArmMult);
  } else {
    sineRightArmGlide.setValue(0);
  }
  rightArmValue = value;
}

void rightArm(boolean value) {
  if (value == true) {
    rightArmAudio = true;
    sineRightArmGlide.setValue(rightArmValue * rightArmMult);
  } else {
    rightArmAudio = false;
    sineRightArmGlide.setValue(0);
  }
}

void rightArmAlert() {
  if (trainingSelector.getValue() == 3) {
    ttsExamplePlayback("right arm");
  }
}

void shouldersSlider(float value) {
  if (shouldersAudio) {
    sineShouldersGlide.setValue(value * shouldersMult);
  } else {
    sineShouldersGlide.setValue(0);
  }
  shouldersValue = value;
}

void shoulders(boolean value) {
  if (value == true) {
    shouldersAudio = true;
    sineShouldersGlide.setValue(shouldersValue * shouldersMult);
  } else {
    shouldersAudio = false;
    sineShouldersGlide.setValue(0);
  }
}

void shouldersAlert() {
  if (trainingSelector.getValue() == 3) {
    ttsExamplePlayback("shoulders");
  }
}

void backSlider(float value) {
  if (backAudio) {
    sineBackGlide.setValue(value * backMult);
  } else {
    sineBackGlide.setValue(0);
  }
  backValue = value;
}

void back(boolean value) {
  if (value == true) {
    backAudio = true;
    sineBackGlide.setValue(backValue * backMult);
  } else {
    backAudio = false;
    sineBackGlide.setValue(0);
  }
}

void backAlert() {
  if (trainingSelector.getValue() == 3) {
    ttsExamplePlayback("back");
  }
}


void calvesSlider(float value) {
  if (calvesAudio) {
    sineCalvesGlide.setValue(value * calvesMult);
  } else {
    sineCalvesGlide.setValue(0);
  }
  calvesValue = value;
}

void calves(boolean value) {
  if (value == true) {
    calvesAudio = true;
    sineCalvesGlide.setValue(calvesValue * calvesMult);
  } else {
    calvesAudio = false;
    sineCalvesGlide.setValue(0);
  }
}


void calvesAlert() {
  if (trainingSelector.getValue() == 3) {
    ttsExamplePlayback("calves");
  }
}


//Knobs logic here
void wristRotation(float value) {
  if (wristRotation != null) {
    if (value != targetRotation.getValue()) {
      lowPassFilter.setType(BiquadFilter.LP);
      //lowPassGlide.setValue(35 * abs(value));
      lowPassGlide.setValue(30 * abs(abs(targetRotation.getValue()) - abs(value)));
    } else {
      lowPassFilter.setType(BiquadFilter.AP);
    }
  }
}


void targetRotation(float value) {
  if (targetRotation != null) {
    if (wristRotation.getValue() == value) {
      lowPassFilter.setType(BiquadFilter.AP);
    }
  }
}



void weightDist() {
  if (weightDist != null) {
    float weightX = weightDist.getArrayValue()[0];
    float weightY = weightDist.getArrayValue()[1];
    
    audioPannerGlide.setValue(weightX/5);

    if (weightY < 1f && weightY > -1f) {
      envelope.clear();
      envelope.setValue(1);
    } else {
      println("Executed");
      envelope.addSegment(weightY/10, 50);
      envelope.addSegment(weightY/10 * 3, 60);
      envelope.addSegment(weightY/10, 70);
    }
  }
}

void resetDevice() {
  notificationServer.stopEventStream();
  sineLeftArmGlide.setValue(0);
  leftArmSlider.setValue(0);
  
  sineRightArmGlide.setValue(0);
  rightArmSlider.setValue(0);
  
  sineBackGlide.setValue(0);
  backSlider.setValue(0);
  
  sineShouldersGlide.setValue(0);
  shouldersSlider.setValue(0);
  
  wristRotation.setValue(0);
  targetRotation.setValue(0);
  audioPannerGlide.setValue(0);
  
  weightDist.setValue(0,0);
  calvesSlider.setValue(0);
  leftArmToggler.setValue(true);
  rightArmToggler.setValue(true);
  shouldersToggler.setValue(true);
  backToggler.setValue(true);
  calvesToggler.setValue(true);
}
