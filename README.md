# 카페인 추적을 통한 일정 관리 서비스
2025-Uni-DTHON 


주제:일일 맞춤형 서비스

카페인 섭취 데이터를 기반으로
각성도, 수면 영향, 일정 효율을 분석하는
개인 맞춤형 카페인 관리 서비스입니다.

<br>

### 아키텍처
Backend: Spring Boot / MySQL / JWT  
Frontend: iOS (SwiftUI, MVVM, Combine)

---
## 핵심 기능
- JWT 기반 사용자 인증
- 카페인 섭취 기록 및 잔존 농도 계산 (반감기 모델)
- 각성도 예측 (PK/PD 모델 적용)
- 일정 관리 및 각성 종료 시간 연동
- AI 기반 30일 맞춤 리포트 생성

##  기술적 차별점
- 카페인 **반감기 + 혈중 농도(PK) + 각성도(PD)** 모델링
- 사용자 나이/내성 기반 개인화 계산
- 카페인 → 일정 → 수면 → 리포트로 이어지는 데이터 흐름 설계
- 내성(tolerance) 및 연령별 민감도 고려
- 단순 통계가 아닌 **예측 기반 분석**
- AI(Upstage API)를 활용한 맞춤형 피드백


#### Backend 
- Java, Spring Boot, Spring Security, JWT
- MySQL, Swagger, Gradle

##### Frontend
- Swift, SwiftUI
- MVVM, DI Container
- Moya + Combine


---

# 요약

이 프로젝트는 **카페인 추적 및 맞춤형 분석 서비스**로, 과학적 모델링과 AI를 결합하여 사용자에게 개인화된 카페인 관리 솔루션을 제공합니다. Backend는 Spring Boot 기반의 REST API를 제공하고, Frontend는 SwiftUI를 활용한 iOS 앱으로 구현되어 있습니다.

****
