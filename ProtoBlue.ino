#include <SoftwareSerial.h>
SoftwareSerial SerialBlue(10, 11); // RX, TX

const int ledPin =  8;// Led Indicador de Push
String dato = "";

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(9600);
  SerialBlue.begin(38400);
  Serial.println("Preparado...");
  digitalWrite(LED_BUILTIN, LOW);
}

void loop() {
  if (SerialBlue.available()) {
    Serial.write(SerialBlue.read());
  }else{
    if (Serial.available()) {
      digitalWrite(ledPin, HIGH);
      dato = Serial.readString();
      if(dato == "OK"){
        digitalWrite(ledPin, LOW);
      }
    }
  }
}
