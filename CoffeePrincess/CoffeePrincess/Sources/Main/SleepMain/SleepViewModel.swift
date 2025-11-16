//
//  SleepViewModel.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/16/25.
//

import Foundation

final class SleepViewModel: ObservableObject {
    
    // MARK: - 수면 영향
    @Published var usualBedtimeText: String = ""
    @Published var lastIntakeTimeText: String = ""
    @Published var sleepDisruptionPercent: Int = 0
    
    // MARK: - 대사 그래프
    @Published var metabolismCurrentMg: Int = 0
    @Published var metabolismUntilText: String = ""
    @Published var metabolismSleepTimeText: String = ""
    @Published var metabolismBars: [MetabolismBar] = []
    
    // MARK: - 수면 예측 (추가 섹션용)
    @Published var tonightDisruptionPercent: Int = 0
    @Published var tonightLastIntakeTimeText: String = "-"
    @Published var tonightUsualBedtimeText: String = ""
    
    @Published var isLoadingGraph: Bool = false
    
    private var dateFomatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    // MARK: - Init
    init() {
        loadMockData()
    }
    
    /// (GET) API를 호출하여 카페인 그래프 데이터를 가져옵니다.
    func fetchCaffeineGraph(container: DIContainer) {
        isLoadingGraph = true
        
        container.dashboardService.getCaffeineInfo { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.isLoadingGraph = false
                switch result {
                case .success(let response):
                    print("✅ [GET] (SleepView) 카페인 그래프 로드 성공")
                    
                    // 1. API 데이터로 @Published 프로퍼티 덮어쓰기
                    self.metabolismCurrentMg = Int(response.currentCaffeine)
                    
                    // 2. API 응답(CaffeineGraphPoint) ➔ UI 모델(MetabolismBar)로 변환
                    let currentHour = Calendar.current.component(.hour, from: Date())
                    let currentHourString = String(format: "%02d", currentHour)
                    
                    self.metabolismBars = response.graph.map { point in
                        let barHour = String(point.time.prefix(2)) // "06:24" ➔ "06"
                        let isPast = barHour < currentHourString
                        let isNow = barHour == currentHourString
                        
                        return MetabolismBar(
                            timeLabel: barHour,
                            amount: point.caffeine,
                            isPast: isPast,
                            isNow: isNow
                        )
                    }
                    
                case .failure(let error):
                    print("❌ [GET] (SleepView) 카페인 그래프 로드 실패: \(error.localizedDescription)")
                    self.metabolismBars = []
                }
            }
        }
        let todayString = dateFomatter.string(from: Date())
        
        container.coffeeService.getTodayCoffee(date: todayString) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("✅ [GET] (SleepView) 오늘 마신 커피 목록 로드 성공")
                    
                    // 마지막 섭취 기록 찾기
                    if let lastDrink = response.coffeeItemResponseList.last {
                        // "HH:mm:ss" ➔ "오후 9:50" 형식으로 변환
                        self?.lastIntakeTimeText = self?.formatLastIntakeTime(lastDrink.drinkTime) ?? "시간 변환 실패"
                    } else {
                        self?.lastIntakeTimeText = "오늘 기록 없음"
                    }
                    
                case .failure(let error):
                    print("❌ [GET] (SleepView) 커피 목록 로드 실패: \(error.localizedDescription)")
                    self?.lastIntakeTimeText = "로드 실패"
                }
            }
        }
    }
    
    private func formatLastIntakeTime(_ timeString: String) -> String {
        let formatter = DateFormatter()
        // (가정) A님의 CurrentViewModel을 보니 timeText가 "HH:mm" 형식입니다.
        // "HH:mm:ss" 또는 "HH:mm" 형식을 "HH:mm"으로 통일
        let timeOnly = String(timeString.prefix(5))
        
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = formatter.date(from: timeOnly) else {
            return timeOnly // 변환 실패 시 원본("HH:mm") 반환
        }
        
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm" // "오후 9:50"
        return formatter.string(from: date)
    }
    
    // MARK: - Mock Data
    private func loadMockData() {
        // 수면 영향
        usualBedtimeText       = "오후 11:30"
        lastIntakeTimeText     = "오후 9:50"
        sleepDisruptionPercent = 37
        
        // 대사 그래프
        metabolismCurrentMg     = 300
        metabolismUntilText     = "23:51"
        metabolismSleepTimeText = "23:00"
//        metabolismBars = [
//            .init(timeLabel: "06", amount: 0,   isPast: true,  isNow: false),
//            .init(timeLabel: "08", amount: 250, isPast: true,  isNow: false),
//            .init(timeLabel: "09", amount: 220, isPast: true,  isNow: true),
//            .init(timeLabel: "10", amount: 190, isPast: true,  isNow: false),
//            .init(timeLabel: "11", amount: 160, isPast: true,  isNow: false),
//            .init(timeLabel: "12", amount: 130, isPast: true,  isNow: false),
//            .init(timeLabel: "13", amount: 100, isPast: true,  isNow: false),
//            .init(timeLabel: "14", amount: 80,  isPast: false, isNow: false),
//            .init(timeLabel: "15", amount: 60,  isPast: false, isNow: false),
//            .init(timeLabel: "16", amount: 40,  isPast: false, isNow: false),
//            .init(timeLabel: "17", amount: 25,  isPast: false, isNow: false),
//            .init(timeLabel: "18", amount: 10,  isPast: false, isNow: false)
//        ]
        
        // 수면 예측 더미
        tonightDisruptionPercent   = 0
        tonightLastIntakeTimeText  = "-"
        tonightUsualBedtimeText    = "23:30"
    }
}
