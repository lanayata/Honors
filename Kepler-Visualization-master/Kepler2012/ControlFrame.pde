public class ControlFrame extends PApplet {
  int w, h;
  int abc = 100;
    ControlP5 cp5;
int myColorBackground = color(0,0,0);
Range range;
  float minESL = 0;
  float maxESL = 1;
  float minKOI = 10000;
  float maxKOI = 0;
  Object parent;
  
  
  public void getMinMax(){
    for (int i = 0; i < allPlanets.size(); i++)
    {
   
      ExoPlanet p = allPlanets.get(i);
         if (p.corePlanet) continue;
      maxKOI = max(parseFloat(p.KOI), maxKOI);
      minKOI = min(parseFloat(p.KOI), minKOI);
    }
  
  }
  
  public void setup() {
    getMinMax();
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
           
              //Slider for KOI
              range = cp5.addRange("KOI Range")
             .setBroadcast(false) 
             .setPosition(300,0)
             .setSize(200,40)
             .setHandleSize(20)
             .setRange(minKOI,maxKOI)
             .setRangeValues(minKOI,maxKOI)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(255,40))
             .setColorBackground(color(255,40))  
             ;
             //
              //Slider for temperature
              range = cp5.addRange("Temperature Range")
             .setBroadcast(false) 
             .setPosition(300,50)
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
             .setPosition(300,100)
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
             .setPosition(300,150)
             .setSize(200,40)
             .setHandleSize(20)
             .setRange(0.0,1.0)
             .setRangeValues(0.0,1.0)
             // after the initialization we turn broadcast back on again
             .setBroadcast(true)
             .setColorForeground(color(255,40))
             .setColorBackground(color(255,40)) 
            ; 
              cp5.addButton("pause")
     .setValue(0)
     .setPosition(displayWidth-100, 0)
     .setSize(100,50)
     ;
                cp5.addButton("Grey out other planets")
     .setValue(0)
     .setPosition(displayWidth-100, 110)
     .setSize(100,50)
     ;
            filterData();
             //
               noStroke();        
  }

  
  void controlEvent(ControlEvent event) {
    try{
  if(event.isFrom("Temperature Range")) {
    minTemp = event.getController().getArrayValue(0);
    maxTemp = event.getController().getArrayValue(1);
  }
    else if(event.isFrom("Size Range")) {
    minSize = event.getController().getArrayValue(0);
    maxSize = event.getController().getArrayValue(1);
  }
     else if(event.isFrom("Earth Similarity Index Range")) {
    minESL = event.getController().getArrayValue(0);
    maxESL = event.getController().getArrayValue(1);
  }
     else if(event.isFrom("KOI Range")) {
    minKOI = event.getController().getArrayValue(0);
    maxKOI = event.getController().getArrayValue(1);
  }
    
      filterData();

  if (event.isFrom("pause")) {
  if (pausedVis) pausedVis = false;
  else pausedVis = true;
  }
  if (event.isFrom("Grey out other planets")) {
     if(greyOutPlanets) greyOutPlanets = false;
     else greyOutPlanets = true;
  } 
    }
    catch(Exception e){e.printStackTrace();}
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
    
   if (p.feature || p.corePlanet) {  
   planets.add(p);
   continue;
   }
   //  Sort by Temp
    if (p.temp >= minTemp && p.temp <= maxTemp){
      if (p.radius >= minSize && p.radius <= maxSize){
        if (p.ESLg >= minESL && p.ESLg <= maxESL){
                  if (parseFloat(p.KOI) >= minKOI && parseFloat(p.KOI) <= maxKOI){
      planets.add(p);
                  }
      }
       }}
  }
  if (mode.equals("ESL")) sortByESL();
  else if (mode.equals("temp")) sortByTemp();
  else if (mode.equals("size")) sortBySize();
  else if (mode.equals("none")) unSort();
}  
}



