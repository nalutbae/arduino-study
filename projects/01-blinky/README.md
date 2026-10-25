# 01-blinky

## 목적

LED 깜빡이기 — 보드 연결·빌드·업로드 파이프라인 테스트.

첫 프로젝트로 PlatformIO 개발 환경이 정상 작동하는지 확인합니다.

## 회로

온보드 LED 사용 — 외부 부품 불필요.

| 부품 | 핀 |
|------|-----|
| 온보드 LED | LED_BUILTIN (Uno/Nano=13, ESP32=2) |

## 빌드·업로드

```
pio run -e uno               # Uno 빌드
pio run -e nano              # Nano 빌드
pio run -e esp32dev          # ESP32 빌드
pio run -e uno -t upload     # 보드 업로드
```

## 학습 내용

- PlatformIO 프로젝트 구조 (src/ · lib/ · platformio.ini)
- 멀티 보드 env 정의와 선택 빌드
- `pinMode`·`digitalWrite`·`delay` 기본 함수
- `LED_BUILTIN` 매크로와 보드별 차이