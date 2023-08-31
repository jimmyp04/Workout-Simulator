enum NotificationType { MuscleExtension, WeightDistribution, WristRotation}

class Notification {
   

  NotificationType type; // MuscleExtension, WeightDistribution, WristRotation
  int timestamp; //parameter used by all types
  
  //MuscleExtension Parameters
  String muscle_group;
  String flag;
  float extension_level;
  
  //WeightDistribution Parameters
  float x_pos;
  float y_pos;
  
  //WristRotation Parameters
  float current_rotation;
  float target_rotation;

  
  public Notification(JSONObject json) {
    this.timestamp = json.getInt("timestamp");
    //time in milliseconds for playback from sketch start
    
    String typeString = json.getString("type");
    
    try {
      this.type = NotificationType.valueOf(typeString);
    }
    catch (IllegalArgumentException e) {
      throw new RuntimeException(typeString + " is not a valid value for enum NotificationType.");
    }
    
    
    if (json.isNull("muscle_group")) {
      this.muscle_group = "";
    }
    else {
      this.muscle_group = json.getString("muscle_group");
    }
    
    if (json.isNull("flag")) {
      this.flag = "";
    }
    else {
      this.flag = json.getString("flag");      
    }
    
    if (json.isNull("extension_level")) {
      this.extension_level = 0;
    }
    else {
      this.extension_level = json.getFloat("extension_level");      
    }
    
    if (json.isNull("x_pos")) {
      this.x_pos = 0;
    }
    else {
      this.x_pos = json.getFloat("x_pos");      
    }

    if (json.isNull("y_pos")) {
      this.y_pos = 0;
    }
    else {
      this.y_pos = json.getFloat("y_pos");      
    }


    if (json.isNull("current_rotation")) {
      this.current_rotation = 0;
    }
    else {
      this.current_rotation = json.getFloat("current_rotation");      
    }
    
    if (json.isNull("target_rotation")) {
      this.target_rotation = 0;
    }
    else {
      this.target_rotation = json.getFloat("target_rotation");      
    }
  }
  
  public int getTimestamp() { return timestamp; }
  public NotificationType getType() { return type; }
  public String getMuscleGroup() { return muscle_group; }
  public float getExtensionLevel() { return extension_level; }
  public String getFlag() { return flag; }
  public float getXPos() { return x_pos; }
  public float getYPos() { return y_pos; }
  public float getCurrentRotation() { return current_rotation; }
  public float getTargetRotation() { return target_rotation; }
  /*
  public String toString() {
      String output = getType().toString() + ": ";
      output += "(muscle group: " + getMuscleGroup() + ") ";
      output += "(flag: " + getFlag() + ") ";
      output += "(contraction level: " + getContractionLevel() + ") ";
      output += "(alignment: " + getAlignment() + ") ";
      return output;
    }
    */
}
