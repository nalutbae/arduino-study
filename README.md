# arduino-study

VSCode + PlatformIO 기반 아두이노 다중 프로젝트 monorepo.

각 프로젝트는 `projects/` 아래 독립적으로 존재하며, 하나의 git 저장소로 관리합니다.

## 구조

```
arduino-study/
├── projects/              # 각 아두이노 프로젝트 (독립 실행)
│   ├── 01-blinky/         # 예시: LED 깜빡이기
│   │   ├── src/main.cpp
│   │   ├── lib/           # 프로젝트 전용 라이브러리
│   │   ├── platformio.ini
│   │   └── README.md
│   └── 02-.../
├── docs/                  # 회로도·핀맵·학습 노트
├── scripts/
│   └── new-project.sh     # 신규 프로젝트 스캐폴딩
├── arduino-study.code-workspace  # VSCode multi-root workspace
├── .gitignore
└── README.md
```

## 시작하기

### 1. VSCode workspace 열기

```
code arduino-study.code-workspace
```

VSCode에서 **File → Open Workspace from File**로 열면 모든 프로젝트가
독립 폴더로 나란히 표시됩니다. PlatformIO 익스텐션이 각 프로젝트를
자동 인식합니다.

### 2. 신규 프로젝트 생성

```
./scripts/new-project.sh 03-my-project uno
```

보드 지정 없이 실행하면 대화형으로 선택합니다. 생성된 프로젝트는
workspace에 자동 등록됩니다.

### 3. 빌드·업로드

프로젝트 폴더에서:

```
cd projects/01-blinky
pio run                    # 기본 env 빌드
pio run -e uno             # 특정 env
pio run -t upload          # 보드 업로드
pio run -t monitor         # 시리얼 모니터
```

VSCode에서는 프로젝트를 우클릭 → **Set as Active Project** 후
PlatformIO 툴바의 ✓(Build) → →(Upload)를 사용합니다.

## 보드 환경

프로젝트별 `platformio.ini`에 여러 env를 정의해 혼합 보드를 지원합니다:

```ini
[env:uno]     ; Arduino Uno
[env:nano]    ; Arduino Nano
[env:esp32dev]; ESP32 DevKit
```

빌드 시 env를 골라 해당 보드용 바이너리를 만듭니다.

## 프로젝트 관례

- 이름: `NN-이름` (예: `01-blinky`, `02-uart-chat`) — 생성 순서 유지
- 각 프로젝트 `README.md`에 목적·회로·핀맵·학습 내용을 기록
- 프로젝트별 `lib/`에 전용 라이브러리 — 다른 프로젝트와 완전 독립
- 외부 라이브러리는 `platformio.ini`의 `lib_deps`로 선언 (로컬 설치 금지)
- 하드웨어 관련 노트는 `docs/`에 정리