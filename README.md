# 2025-Uni-DTHON
Uni-DTHON 카페인 추적을 통한 일정 관리 서비스


주제:일일 맞춤형 서비스

아키텍처: Backend (Java Spring Boot) + Frontend (iOS Swift)

---

#### Backend 

- Java / Spring Boot
- **데이터베이스**: MySQL
- **보안**: Spring Security + JWT
- **API**: Swagger
- **빌드**: Gradle

##### Frontend

- iOS/ Swift/ SwiftUI
- **네트워킹**: Moya + Combine
- **아키텍처**: MVVM + DI Container

<br>

---

<br>

### 주요 모듈 및 기능

#### 1. 인증 모듈 (`auth/`)

#### AuthController.java
- 회원가입/로그인 엔드포인트 제공
- `POST /api/v1/auth/signup`: 회원가입
- `POST /api/v1/auth/login`: 로그인 (JWT 토큰 발급)

#### AuthService.java
- 인증 관련 비즈니스 로직 처리
- `signup(LoginRequest request)`: 사용자 등록, 비밀번호 암호화
- `login(LoginRequest request)`: 인증 후 JWT 토큰 생성

#### JwtTokenProvider.java
- JWT 토큰 생성 및 검증
- `createToken(String userId)`: 사용자 ID 기반 토큰 생성
- `validateToken(String jwtToken)`: 토큰 유효성 검증
- `getUserPk(String token)`: 토큰에서 사용자 ID 추출
- `resolveToken(HttpServletRequest request)`: 요청 헤더에서 토큰 추출

#### JwtAuthFilter.java
- 모든 요청에 대해 JWT 검증을 수행하는 필터  

<br>

#### 2. 커피/카페인 모듈 (`coffee/`)

**CoffeeController.java**
- 커피 기록 및 카페인 분석 API 제공
- `POST /api/v1/coffee`: 커피 기록 등록
- `GET /api/v1/coffee/today`: 특정 날짜 커피 목록 조회
- `GET /api/v1/coffee/caffeine`: 현재 카페인 농도 조회
- `GET /api/v1/coffee/alertness`: 현재 각성도 조회

**CoffeeService.java**
- 커피 기록 관리 및 카페인 계산 로직
- `addCoffee(Long userId, CoffeeRequest request)`: 커피 기록 저장
- `getCoffeeList(LocalDate drinkDate, Long userId)`: 날짜별 커피 목록 조회
- `getCaffeineConcentration(Long userId, LocalDateTime currentTime)`: 카페인 농도 계산
  - 반감기 기반 감소 공식: `remaining = amount × (0.5)^(경과시간/반감기)`
  - 시간대별 그래프 데이터 생성
- `getAlertness(Long userId, LocalDateTime currentTime)`: 각성도 계산
  - 혈중 농도 계산 (`CaffeineModel.concentrationWithAbsorption()`)
  - 내성 계산 (주간 섭취량 기반), 각성 종료 시간 예측
- `calculateRemainingCaffeine()`: 남은 카페인량 계산 (핵심 로직)
- `calculateAlertnessEndTime()`: 각성 종료 시간 계산

#### CaffeineModel.java
- 카페인 모델링을 위한 유틸리티 클래스
- `estimateTHalf(int age, String metabolizer)`: 나이/대사능력 기반 반감기 추정
- `concentrationWithAbsorption(double t, double dose, double weight, double tHalf)`: 혈중 농도 계산 (PK 모델)
- `caffeineEffect(double C, int age, int weekNumber, String effectType)`: 각성도 계산 (PD 모델, Hill 방정식)
- `toleranceFactor(int weekNumber, int daysSinceLast)`: 내성 계산
- `receptorSensitivity(int age)`: 연령별 민감도 계산  

<br>


#### 3. 사용자 모듈 (`user/`)

#### UserController.java
- 사용자 정보 관리 API
- `POST /api/v1/user`: 사용자 정보 입력 (성별, 나이, 수면 시간)
- `GET /api/v1/user`: 사용자 정보 조회

#### UserService.java
- 사용자 정보 관리 비즈니스 로직
- `createUserInfo(Long userId, CreateUserInfoRequest request)`: 사용자 정보 업데이트
- `getUserInfo(Long userId)`: 사용자 정보 조회

#### User.java (Domain)
- **엔티티 필드**:`id`, `username`, `password`, `gender`, `age`, `role`, `sleepTime`
- `insertUserInfo()`: 사용자 정보 삽입  

<br>


#### 4. 일정 모듈 (`schedule/`)

#### ScheduleController.java
- 일정 관리 API
- `POST /api/v1/schedule`: 일정 생성
- `GET /api/v1/schedule`: 특정 날짜 일정 조회

#### ScheduleService.java
- 일정 관리 비즈니스 로직
- `createSchedule(Long userId, ScheduleCreateRequest request)`: 일정 저장
- `getScheduleList(Long userId, LocalDate time)`: 날짜별 일정 목록 조회

<br>


#### 5. 리포트 모듈 (`report/`)

#### ReportController.java
- 맞춤형 리포트 생성 API
- `POST /api/v1/report`: 맞춤형 리포트 생성

#### ReportService.java
- 리포트 생성 비즈니스 로직
- `generateReport(Long userId, LocalDate endDate)`: 30일 데이터 분석 후 리포트 생성
- `createPrompt(List<DailyCaffeineLog> analysisLogs)`: Upstage AI API용 프롬프트 생성


<br>


#### 6. 피드백 모듈 (`feedback/`)

#### FeedbackController.java
- 피드백 API
- `POST /api/v1/feedback`: 피드백 등록 (수면 시간, 심장 두근거림 등)

#### FeedbackService.java
- 피드백 저장 및 조회
- `addFeedback(Long userId, FeedbackRequest request)`: 피드백 저장
- `getFeedbackList(LocalDate sleepDate, Long userId)`: 피드백 목록 조회


<br>


#### 7. 전역 설정 (`global/`)

#### SecurityConfig.java
- Spring Security 설정
- JWT 필터 적용
- CORS 설정 (localhost:3000, 8080, 5173 허용)
- 인증 필요 경로 설정 (`/api/v1/coffee/**`, `/api/v1/user/**` 등)

#### GlobalExceptionHandler.java
- 전역 예외 처리
- 커스텀 예외를 `ErrorResponse`로 변환

#### ApiResponse.java
- 공통 API 응답 래퍼
- **구조**: `isSuccess`, `code`, `message`, `results`

#### BaseEntity.java
- 공통 엔티티 필드 (생성일시, 수정일시 등)

---


#### 1. 앱 진입점

#### CoffeePrincessApp.swift
- 앱 메인 진입점
  - `NavigationStack` 기반 네비게이션
  - `DIContainer` 주입
  - 라우팅 설정 (`Route` enum 기반)
  - Alert 표시 로직


#### CurrentView.swift / CurrentViewModel.swift
- 현재 상태 화면
- **주요 기능**:
  - `fetchTodayCoffee(container:)`: 오늘 마신 커피 목록 조회
  - `fetchDashboardStatus(container:)`: 카페인 농도/각성도 조회
  - 상태 표시: 카페인량, 각성도, 마지막 섭취 시간, 각성 종료 시간
- **Published Properties**:
  - `currentCaffeine`: 현재 카페인량
  - `currentAlertnessPercent`: 각성도 (%)
  - `todayDrinks`: 오늘 마신 음료 목록
  - `lastIntakeText`: 마지막 섭취 시간 텍스트
  - `awakeEndText`: 각성 종료 시간 텍스트

<br>

#### 2. 카페인 추가 (`AddCaffeine/`)

#### AddRecordView.swift
- 카페인 기록 추가 화면
- **주요 구성**:
  - 스타벅스/기타 음료 메뉴 리스트
  - 메뉴 선택 시 상세 화면으로 이동
  - 검색 기능 (주석 처리됨)

<br>

#### 3. 일정 관리 (`Schedule/`)

#### ScheduleView.swift
- **기능**: 일정 등록 화면
- **주요 구성**:
  - 일정 제목 입력 (TextField)
  - 시간 선택 (DatePicker)
  - 일정 저장 버튼

#### ScheduleViewModel.swift
- **기능**: 일정 뷰모델
- **주요 메서드**:
  - `buildSchedule()`: Schedule 모델 생성
  - `saveSchedule()`: 서버에 일정 저장 (Combine 사용)
- **Published Properties**:
  - `name`: 일정 제목
  - `time`: 일정 시간

<br>

#### 4. 리포트 (`Report/`)

#### NewReportView.swift
- **기능**: 맞춤형 리포트 화면
- **주요 구성**:
  - 월간 리포트 카드
  - 수면 가이드 카드
  - 각성 가이드 카드
  - 캐릭터 이미지

#### NewReportViewModel.swift
- **기능**: 리포트 뷰모델
- **주요 메서드**:
  - `fetchReportData()`: 서버에서 리포트 데이터 조회
- **Computed Properties**:
  - `monthlyReportText`: 월간 리포트 텍스트
  - `sleepGuideText`: 수면 가이드 텍스트
  - `awakeGuideText`: 각성 가이드 텍스트

<br>

#### 5. 설문조사 (`Survey/`)

#### SurveyView.swift
- **기능**: 피드백 설문 화면
- **주요 구성**:
  - 심장 두근거림 경험 질문 (라디오 버튼)
  - 수면 시간 선택 (드롭다운 피커)
  - 완료 버튼

#### SurveyViewModel.swift
- **기능**: 설문 뷰모델
- **주요 메서드**:
  - `validateAndSend(completion:)`: 설문 데이터 검증 및 전송
  - `getTimeOptions()`: 시간 옵션 생성
  - `formatTimeDisplay(_:)`: 시간 표시 포맷팅
  - `timeStringToDate(_:)`: 시간 문자열 → Date 변환
  - `dateToTimeString(_:)`: Date → 시간 문자열 변환


---

### 주요 기능 흐름

#### 1. 사용자 인증 흐름

1. **회원가입**
   - 사용자 입력 → `AuthController.signUp()` → `AuthService.signup()`
   - 비밀번호 암호화 (`PasswordEncoder`) → DB 저장

2. **로그인**
   - 사용자 입력 → `AuthController.login()` → `AuthService.login()`
   - 비밀번호 검증 → JWT 토큰 생성 (`JwtTokenProvider.createToken()`)
   - 토큰 반환 → iOS 앱에 저장 (`AuthManager`)

#### 2. 카페인 기록 및 분석 흐름

1. **커피 기록 추가**
   - iOS: `AddRecordView` → 메뉴 선택 → 시간/카페인량 입력
   - API 호출: `POST /api/v1/coffee` → `CoffeeService.addCoffee()`
   - DB 저장: `CoffeeRepository.save()`

2. **카페인 농도 조회**
   - iOS: `CurrentViewModel.fetchDashboardStatus()`
   - API 호출: `GET /api/v1/coffee/caffeine?currentTime=...`
   - 서버 계산: `CoffeeService.getCaffeineConcentration()`
     - 반감기 계산 (`CaffeineModel.estimateTHalf()`)
     - 시간대별 남은 카페인량 계산 (`calculateRemainingCaffeine()`)
     - 그래프 데이터 생성 (1시간 간격)
   - 응답: 현재 카페인량 + 시간대별 그래프

3. **각성도 조회**
   - iOS: `CurrentViewModel.fetchDashboardStatus()`
   - API 호출: `GET /api/v1/coffee/alertness?currentTime=...`
   - 서버 계산: `CoffeeService.getAlertness()`
     - 혈중 농도 계산 (`CaffeineModel.concentrationWithAbsorption()`)
     - 내성 계산 (`calculateWeekNumber()`)
     - 각성도 계산 (`CaffeineModel.caffeineEffect()`)
     - 각성 종료 시간 예측 (`calculateAlertnessEndTime()`)
   - 응답: 현재 각성도 + 각성 종료 시간

#### 3. 맞춤형 리포트 생성 흐름

1. **데이터 수집**
   - `DataPreparationService.prepareMonthlyData()`: 30일간 데이터 집계
   - 카페인 섭취량, 수면 시간, 심장 두근거림 등

2. **AI 분석**
   - `ReportService.createPrompt()`: Upstage AI용 프롬프트 생성
   - `UpstageApiService.getMinSleepTimeJson()`: AI API 호출
   - 최소 수면 시간 계산

3. **리포트 생성**
   - `ReportService.generateReport()`: 리포트 텍스트 생성
   - iOS: `NewReportViewModel.fetchReportData()`: 리포트 조회 및 표시

#### 4. 일정 관리 흐름

1. **일정 등록**
   - iOS: `ScheduleView` → 제목/시간 입력
   - `ScheduleViewModel.saveSchedule()` → `ScheduleService.addSchedule()`
   - API 호출: `POST /api/v1/schedule` → DB 저장

2. **일정 조회**
   - API 호출: `GET /api/v1/schedule?date=...`
   - `ScheduleService.getScheduleList()`: 날짜별 일정 조회

#### 5. 피드백 수집 흐름

1. **설문 조사**
   - iOS: `SurveyView` → 심장 두근거림/수면 시간 입력
   - `SurveyViewModel.validateAndSend()`: 데이터 검증 및 전송

2. **피드백 저장**
   - API 호출: `POST /api/v1/feedback`
   - `FeedbackService.addFeedback()`: DB 저장

---

#### 핵심 알고리즘 및 계산 로직

#### 카페인 반감기 계산

```java
// CaffeineModel.estimateTHalf()
- 기본 반감기: 5.0시간
- 대사능력 보정: slow(1.6x), normal(1.0x), fast(0.7x)
- 연령 보정:
  - 18세 미만: 1.2x
  - 18-40세: 0.95x
  - 40-65세: 1.0 + (age-40) × 0.008
  - 65세 이상: 1.2 + (age-65) × 0.015
```

#### 남은 카페인량 계산

```java
// CoffeeService.calculateRemainingCaffeine()
remaining = caffeineAmount × (0.5)^(경과시간/반감기)
```

#### 혈중 농도 계산 (PK 모델)

```java
// CaffeineModel.concentrationWithAbsorption()
- 분포 용적(Vd) = 0.65 × 체중
- 제거율(ke) = ln(2) / 반감기
- 흡수율(ka) = 1.2 (기본값)
- 생체이용률(F) = 0.99

농도 = (F × dose × ka) / (Vd × (ka - ke)) × (e^(-ke×t) - e^(-ka×t))
```

#### 각성도 계산 (PD 모델)

```java
// CaffeineModel.caffeineEffect()
- Hill 방정식 사용
- EC50 (각성도): 8.0 mg/L
- 내성 보정: toleranceFactor()
- 민감도 보정: receptorSensitivity()

효과 = baseline(0.1) + (Emax × C^h) / (EC50^h + C^h) × 내성 × 민감도
```

#### 내성 계산

```java
// CaffeineModel.toleranceFactor()
- 주간 섭취 횟수 기반:
  - 14회 이상 (하루 2회 이상): weekNumber = 7 → 내성 0.5
  - 7회 이상 (하루 1회 이상): weekNumber = 4 → 내성 0.7
  - 2회 이상: weekNumber = 2 → 내성 0.85
  - 그 외: weekNumber = 0 → 내성 1.0
```

---

# 요약

이 프로젝트는 **카페인 추적 및 맞춤형 분석 서비스**로, 과학적 모델링과 AI를 결합하여 사용자에게 개인화된 카페인 관리 솔루션을 제공합니다. Backend는 Spring Boot 기반의 안정적인 REST API를 제공하고, Frontend는 SwiftUI를 활용한 현대적인 iOS 앱으로 구현되어 있습니다.

****
