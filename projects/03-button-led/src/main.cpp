#include <Arduino.h>

const int BUTTON = 2;
const int LED = 13;

void setup() {
  pinMode(BUTTON, INPUT);
  pinMode(LED, OUTPUT);
}

void loop() {
  int pressed = digitalRead(BUTTON);
  digitalWrite(LED, pressed);
}