#include <Arduino.h>

/* 01-blinky — LED 깜빡이기 (보드 연결 테스트)
 *
 * 온보드 LED를 500ms 간격으로 깜빡입니다.
 * 대부분의 보드에서 LED_BUILTIN 매크로가 내장 LED 핀을 가리킵니다.
 * (Uno/Nano = 13번, ESP32 DevKit = 2번, 보드에 따라 다름)
 */

#ifndef LED_BUILTIN
#define LED_BUILTIN 2  // LED_BUILTIN이 없는 보드용 폴백
#endif

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  digitalWrite(LED_BUILTIN, HIGH);
  delay(500);
  digitalWrite(LED_BUILTIN, LOW);
  delay(500);
}