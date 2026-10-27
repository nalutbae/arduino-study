#!/usr/bin/env bash
# 신규 PlatformIO 프로젝트 스캐폴딩 — arduino-study monorepo 전용
# 사용법:
#   ./scripts/new-project.sh <이름> [보드]
#   ./scripts/new-project.sh 03-my-project uno
#   ./scripts/new-project.sh 03-my-project          # 보드 대화형 선택
set -euo pipefail

# arduino-study 루트 디렉토리 (스크립트가 위치한 디렉토리의 상위)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECTS_DIR="$ROOT/projects"
WORKSPACE="$ROOT/arduino-study.code-workspace"

# ── 인자 확인 ──
NAME="${1:-}"
if [[ -z "$NAME" ]]; then
  echo "사용법: $0 <프로젝트이름> [보드]"
  echo "예:   $0 03-my-project uno"
  echo
  echo "보드 목록:"
  echo "  uno      Arduino Uno"
  echo "  nano     Arduino Nano"
  echo "  mega     Arduino Mega"
  echo "  esp32    ESP32 DevKit"
  echo "  esp8266  ESP8266 (NodeMCU)"
  exit 1
fi

BOARD="${2:-}"

if [[ -z "$BOARD" ]]; then
  echo "보드를 선택하세요:"
  echo "  1) uno      Arduino Uno"
  echo "  2) nano     Arduino Nano"
  echo "  3) mega     Arduino Mega"
  echo "  4) esp32    ESP32 DevKit"
  echo "  5) esp8266  ESP8266 NodeMCU"
  read -rp "번호 [1]: " choice
  case "${choice:-1}" in
    1) BOARD="uno" ;;
    2) BOARD="nano" ;;
    3) BOARD="mega" ;;
    4) BOARD="esp32" ;;
    5) BOARD="esp8266" ;;
    *) echo "알 수 없는 선택"; exit 1 ;;
  esac
fi

# ── 보드별 platformio.ini 스니펫 ──
board_env() {
  case "$1" in
    uno)
      cat <<'EOF'
[env:uno]
platform = atmelavr
board = uno
framework = arduino
monitor_speed = 115200
EOF
      ;;
    nano)
      cat <<'EOF'
[env:nano]
platform = atmelavr
board = nanoatmega328
framework = arduino
monitor_speed = 115200
EOF
      ;;
    mega)
      cat <<'EOF'
[env:mega]
platform = atmelavr
board = megaatmega2560
framework = arduino
monitor_speed = 115200
EOF
      ;;
    esp32)
      cat <<'EOF'
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
monitor_speed = 115200
EOF
      ;;
    esp8266)
      cat <<'EOF'
[env:esp01_1m]
platform = espressif8266
board = esp01_1m
framework = arduino
monitor_speed = 115200
EOF
      ;;
    *)
      echo "지원하지 않는 보드: $1" >&2
      exit 1
      ;;
  esac
}

# ── 프로젝트 생성 ──
TARGET="$PROJECTS_DIR/$NAME"
if [[ -e "$TARGET" ]]; then
  echo "이미 존재: $TARGET" >&2
  exit 1
fi

mkdir -p "$TARGET/src" "$TARGET/lib" "$TARGET/docs"

cat > "$TARGET/platformio.ini" <<EOF
; PlatformIO 프로젝트 — $(basename "$TARGET")
; https://docs.platformio.org/page/projectconf.html

$(board_env "$BOARD")
EOF

cat > "$TARGET/src/main.cpp" <<'EOF'
#include <Arduino.h>

void setup() {
  // 초기화
}

void loop() {
  // 메인 루프
}
EOF

cat > "$TARGET/README.md" <<EOF
# $(basename "$TARGET")

## 목적

(이 프로젝트로 무엇을 하는지)

## 회로

| 부품 | 핀 |
|------|-----|
|      |     |

## 핀 맵

## 학습 내용

EOF

cat > "$TARGET/.gitignore" <<'EOF'
.pio/
EOF

echo "✓ 생성: $TARGET"

# ── workspace에 등록 ──
# python3가 실제 실행되면 사용, 아니면 python
if python3 --version &>/dev/null; then
  PY="python3"
else
  PY="python"
fi
# Git Bash 경로(/c/)를 Windows 경로(C:/)로 변환
WS_PATH=${WORKSPACE/\/c\//C:\/}
WS_PATH=${WS_PATH//\//\\}
"$PY" - "$WS_PATH" "$NAME" <<'PYEOF'
import json, sys, os

ws_path, name = sys.argv[1], sys.argv[2]
entry = f"projects/{name}"

with open(ws_path) as f:
    ws = json.load(f)

folders = [f["path"] for f in ws["folders"]]
if entry not in folders:
    ws["folders"].append({"path": entry})
    with open(ws_path, "w") as f:
        json.dump(ws, f, indent=2)
        f.write("\n")
    print(f"✓ workspace 등록: {entry}")
else:
    print(f"· workspace 이미 등록됨: {entry}")
PYEOF

echo
echo "다음 단계:"
echo "  code $ROOT/arduino-study.code-workspace"
echo "  → VSCode에서 $(basename "$TARGET") 프로젝트가 나타납니다"