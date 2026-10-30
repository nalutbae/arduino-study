#include <Arduino.h>
#include <AccelStepper.h>

const int PUL_PIN = 2;
const int DIR_PIN = 3;

const int BTN_CW   = 4;
const int BTN_CCW  = 5;
const int BTN_HOME = 6;

const int LED_GREEN = 8;
const int LED_RED   = 9;

// 앞에서 LED가 정상이 되었던 값 그대로 유지하세요
const int LED_ON  = HIGH;
const int LED_OFF = LOW;

AccelStepper stepper(1, PUL_PIN, DIR_PIN);

const long JOG_FAR = 1000000L;

enum Mode { IDLE, JOG_CW, JOG_CCW, HOMING };
Mode mode = IDLE;

int homeIdleLevel;  // 원점 버튼이 안 눌렸을 때의 평소 레벨

void setLeds(bool green, bool red) {
  digitalWrite(LED_GREEN, green ? LED_ON : LED_OFF);
  digitalWrite(LED_RED,   red   ? LED_ON : LED_OFF);
}

void setup() {
  pinMode(BTN_CW,   INPUT_PULLUP);
  pinMode(BTN_CCW,  INPUT_PULLUP);
  pinMode(BTN_HOME, INPUT_PULLUP);

  pinMode(LED_GREEN, OUTPUT);
  pinMode(LED_RED,   OUTPUT);
  setLeds(false, false);

  stepper.setMaxSpeed(2000.0);
  stepper.setAcceleration(1000.0);
  stepper.setCurrentPosition(0);

  delay(100);                              // 핀 안정화
  homeIdleLevel = digitalRead(BTN_HOME);   // 부팅 중에는 버튼을 누르지 마세요
}

void loop() {
  bool cw   = (digitalRead(BTN_CW)   == LOW);
  bool ccw  = (digitalRead(BTN_CCW)  == LOW);
  bool home = (digitalRead(BTN_HOME) != homeIdleLevel);

  if (cw && !ccw) {
    if (mode != JOG_CW) {
      mode = JOG_CW;
      stepper.moveTo(JOG_FAR);
    }
  }
  else if (ccw && !cw) {
    if (mode != JOG_CCW) {
      mode = JOG_CCW;
      stepper.moveTo(-JOG_FAR);
    }
  }
  else if (home) {
    if (mode != HOMING) {
      mode = HOMING;
      stepper.moveTo(0);
    }
  }
  else {
    if (mode == JOG_CW || mode == JOG_CCW) {
      stepper.stop();      // 감속 후 현재 위치에서 정지
      mode = IDLE;
    }
  }

  if (mode == HOMING && stepper.distanceToGo() == 0) {
    mode = IDLE;
  }

  switch (mode) {
    case JOG_CW:  setLeds(true,  false); break;
    case JOG_CCW: setLeds(false, true);  break;
    case HOMING:  setLeds(true,  true);  break;
    default:      setLeds(false, false); break;
  }

  stepper.run();
}