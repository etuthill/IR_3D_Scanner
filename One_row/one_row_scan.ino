#include <Servo.h>

const int irPin = A0; 
const int panPin = 13;

// servo object
Servo panServo;

// timing
uint32_t loop_time = 0; // last time ir was sampled

// starting angle + scan state
int panAngle = 20; 
bool scanning = true;
int panStep = 1; // step size for pan sweep

// spike filter
int lastValue = -1;
const int spikeThreshold = 300;

int rowID = 0; // row id for csv output

void setup() {
  Serial.begin(9600); // start serial
  panServo.attach(panPin); // attach pan servo

  panServo.write(0); // set servo to 0 deg

  loop_time = millis(); // init last reading time
  delay(5000); // wait before scanning starts
}

// check if dt ms have passed
bool it_is_time(uint32_t t, uint32_t t0, uint16_t dt) {
  return (t - t0 >= dt);
}

void loop() {
  if (!scanning) return; 

  uint32_t t = millis(); 

  if (it_is_time(t, loop_time, 100)) {

    // move servo to current pos
    panServo.write(panAngle);
    delay(30); // let servo settle

    // read ir 3 times and take min to reduce noise
    int x = analogRead(irPin);
    int y = analogRead(irPin);
    int z = analogRead(irPin);
    int irValue = min(min(x, y), z);

    // spike rejection
    if (lastValue != -1 && abs(irValue - lastValue) > spikeThreshold) {
      int retry = analogRead(irPin);
      if (abs(retry - lastValue) > spikeThreshold) {
        irValue = retry; // big change again then real change
      } else {
        irValue = lastValue; // one-off spike then reject
      }
    }
    lastValue = irValue;

    // print csv (row, pan, ir)
    Serial.print(rowID);
    Serial.print(",");
    Serial.print(panAngle);
    Serial.print(",");
    Serial.println(irValue);

    loop_time = t; // update last read time

    // update pan pos
    panAngle += panStep;

    // reverse sweep at limits
    if (panAngle >= 90) {
      panAngle = 90; 
      panStep = -panStep; // sweep left
      rowID++;
    } 
    else if (panAngle <= 20) {
      panAngle = 20;
      panStep = -panStep; // sweep right
      rowID++;
    }
  }
}
