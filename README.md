# 카페인 추적을 통한 일정 관리 서비스
Caffeine-Aware Schedule Optimization Platform


2025-Uni-DTHON) 이 프로젝트는 **일일 맞춤형 카페인 관리 서비스**로, 카페인 섭취 기록을 기반으로 **각성도, 수면 영향, 일정 효율**을 분석하여 사용자에게 개인화된 카페인 관리 솔루션을 제공합니다.


---

## Demo
![Image](https://github.com/user-attachments/assets/fd0b1776-264a-4203-b884-7fdc23e9403d)

---

## Key Features
- **JWT 기반 인증**: 회원가입/로그인 및 보호된 API 접근
- **카페인 기록 관리**: 음료, 섭취 시간, 카페인량 기록 및 일일 조회
- **현재 카페인 농도 추정**: 반감기 기반 모델로 잔존 카페인 계산 및 시간대별 그래프 제공
- **각성도(Alertness) 예측**: PK/PD 모델 기반 각성도(%) 산출 및 각성 종료 시간 예측
- **일정 관리**: 일정 등록 및 날짜별 일정 조회
- **월간 리포트(30일)**: 30일 데이터 분석 및 AI(Upstage) 기반 맞춤형 텍스트 가이드 생성
- **피드백(설문)**: 수면 시간, 심장 두근거림 등 컨디션 데이터 수집

---

## What Makes This Different
- **카페인 반감기 + 혈중 농도(PK) + 각성도(PD)**를 결합한 과학적 모델링
- **사용자 나이 및 내성(tolerance)**을 반영한 개인화 계산
- 카페인 → 일정 → 수면 → 리포트로 이어지는 **데이터 흐름 중심 설계**
- 단순 통계가 아닌 **미래 상태(각성 종료 시간) 예측 기반 분석**
- AI(Upstage API)를 활용한 개인 맞춤형 피드백 생성

<br>

## Tech Stack
### Backend 
- Java, Spring Boot, Spring Security, JWT
- MySQL, Swagger, Gradle

### Frontend
- Swift, SwiftUI
- MVVM, DI Container
- Moya + Combine


---
## Core Algorithm
- **반감기 기반 잔존 카페인량**:
  - $remaining = amount \times (0.5)^{\Delta t / t_{half}}$
  - $t_{half}$는 나이/대사능력(slow/normal/fast)으로 보정
- **혈중 농도(PK, 흡수 포함)**:
  - $Vd = 0.65 \times weight$, $ke = \ln(2) / t_{half}$
  - $C(t)=\frac{F \cdot dose \cdot ka}{Vd \cdot (ka-ke)} \cdot (e^{-ke t}-e^{-ka t})$
- **각성도(PD, Hill)**:
  - 농도 기반 Hill 방정식에 **내성(주간 섭취 패턴)** 및 **연령 민감도** 보정 적용
- 상세 내용: `docs/algorithms.md`

---




