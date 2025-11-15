//
//  ProfileViewModel.swift
//  CoffeePrincess
//
//  Created by 김세은 on 11/15/25.
//
import Foundation

class ProfileViewModel: ObservableObject {
    @Published var userInfo: UserInfo = UserInfo() {
        didSet {
            saveUserInfo()
        }
    }
    
    private let userInfoKey = "userInfo"
    
    init() {
        loadUserInfo()
    }
    
    func loadUserInfo() {
        if let data = UserDefaults.standard.data(forKey: userInfoKey),
           let decoded = try? JSONDecoder().decode(UserInfo.self, from: data) {
            self.userInfo = decoded
        }
    }
    
    func saveUserInfo() {
        if let encoded = try? JSONEncoder().encode(userInfo) {
            UserDefaults.standard.set(encoded, forKey: userInfoKey)
        }
    }
    
    func getCaffeineType() -> String {
        if userInfo.tolerance < 30 {
            return "민감형"
        } else if userInfo.tolerance < 70 {
            return "일반형"
        } else {
            return "둔감형"
        }
    }
    
    func getHeartRateText() -> String {
        switch userInfo.heartRate {
            case "often": return "자주 있음"
            case "sometimes": return "가끔 있음"
            case "rarely": return "거의 없음"
            case "never": return "없음"
            default: return "-"
        }
    }
    
    func getDefaultMaxCaffeine() -> Int {
        if userInfo.tolerance < 30 {
            return 100
        } else if userInfo.tolerance < 70 {
            return 140
        } else {
            return 200
        }
    }
    
    // String 시간을 Date로 변환
    func timeStringToDate(_ timeString: String) -> Date {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            // 기본값: 오늘 23:30
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: Date())
            components.hour = 23
            components.minute = 30
            return calendar.date(from: components) ?? Date()
        }
        
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        dateComponents.hour = hour
        dateComponents.minute = minute
        return calendar.date(from: dateComponents) ?? Date()
    }
    
    // Date를 String 시간으로 변환
    func dateToTimeString(_ date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return String(format: "%02d:%02d", hour, minute)
    }
    
    // 시간 표시 포맷팅
    func formatTimeDisplay(_ time: String) -> String {
        let components = time.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            return time
        }
        
        let hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        let ampm = hour < 12 ? "오전" : "오후"
        return "\(ampm) \(hour12):\(String(format: "%02d", minute))"
    }
}
