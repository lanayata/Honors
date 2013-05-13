public class ControlFrame extends PApplet {
  int w, h;
  int abc = 100;
    ControlP5 cp5;
int myColorBackground = color(0,0,0);
Range range;
  float minESL = 0;
  float maxESL = 1;

  Object parent;
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);
      textArea = cp5.addTextarea("txt")
                  .setPosition(0,0)
                  .setSize(250,500)                 
                  .setFont(createFont("arial",12))
                  .setLineHeight(14)
                  //.setColor(color(128))
                  .setColorBackground(color(255,100))
                  .setColorForeground(color(255,100));
                  ;
                  textArea.setText("No Planet Selected");
           
              //Slider for temperature
              range = cp5.addRange("Temperature Range")
             .setBroadcast(false) 
             .setPosition(300,0)
             .setSize(200,40)
             .setHandleSize(20)
             .setRange(minTemp,maxTemp)
             .setRangeValues(minTemp,maxTemp)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(255,40))
             .setColorBackground(color(255,40))  
             ;
             //
              //Slider for size
              range = cp5.addRange("Size Range")
             .setBroadcast(false) 
             .setPosition(300,50)
             .setSize(200,40)
             .setHandleSize(20)
             .setRange(minSize,maxSize)
             .setRangeValues(minSize,maxSize)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(255,40))
             .setColorBackground(color(255,40))  
             ;
             //Slider for ESL
              range = cp5.addRange("Earth Similarity Index Range")
             .setBroadcast(false) 
             .setPosition(300,100)
             .setSize(200,40)
             .setHandleSize(20)
             .setRange(0,1)
             .setRangeValues(0,1)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(255,40))
             .setColorBackground(color(255,40)) 
            ; 
             //
               noStroke();        
  }
  
  void controlEvent(ControlEvent event) {
  if(event.isFrom("Temperature Range")) {
    minTemp = event.getController().getArrayValue(0);
    maxTemp = event.getController().getArrayValue(1);
  }
    if(event.isFrom("Size Range")) {
    minSize = event.getController().getArrayValue(0);
    maxSize = event.getController().getArrayValue(1);
  }
     if(event.isFrom("Earth Similarity Index Range")) {
    minESL = event.getController().getArrayValue(0);
    maxESL = event.getController().getArrayValue(1);
  }
      filterData();
  
}


void keyPressed() {
//  switch(key) {
//    case('1'):rankepler.ge.setLowValue(0);break;
//    case('2'):range.setLowValue(100);break;
//    case('3'):range.setHighValue(120);break;
//    case('4'):range.setHighValue(200)//;break;
//    case('5'):range.setRangeValues(40,6;break;
//  }
}
  
  public void draw() {
      background(abc);
  
  }
  private ControlFrame() {
  }
  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }
  public ControlP5 control() {
    return cp5;
  }

public void filterData(){
  planets.clear();
  for (int i = 0; i < allPlanets.size(); i++){
   ExoPlanet p = allPlanets.get(i);
   //  Sort by Temp
    if (p.temp >= minTemp && p.temp <= maxTemp){
      if (p.radius >= minSize && p.radius <= maxSize){
      //   if (p.ESLg >= minESL && p.ESLg <= maxESL){
      planets.add(p);
     
      // }
       }}
  }
  if (mode.equals("ESL")) sortByESL();
  else if (mode.equals("temp")) sortByTemp();
  else if (mode.equals("size")) sortBySize();
}  
}



