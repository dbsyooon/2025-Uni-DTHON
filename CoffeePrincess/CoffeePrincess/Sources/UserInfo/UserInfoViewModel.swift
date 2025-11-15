//
//  UserInfoViewModel.swift
//  CoffeePrincess
//
//  Created on 11/15/25.
//

import Foundation
import SwiftUI

class UserInfoViewModel: ObservableObject {
    @Published var userInfo: UserInfo = UserInfo() {
        didSet {
            saveUserInfo()
        }
    }
    
    @Published var gender: String = ""
    @Published var age: String = ""
    @Published var tolerance: Double = 50
    @Published var heartRate: String = ""
    @Published var bedtime: String = "23:30"
    @Published var wakeTime: String = "07:30"
    @Published var selectedImportantTimes: Set<String> = []
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private let userInfoKey = "userInfo"
    
    private let timeOptions: [String] = {
        var options: [String] = []
        for hour in 0..<24 {
            for minute in [0, 30] {
                options.append(String(format: "%02d:%02d", hour, minute))
            }
        }
        return options
    }()
    
    let importantTimeOptions = [
        ("morning", "오전 9~12시"),
        ("afternoon1", "오후 1~3시"),
        ("afternoon2", "오후 3~6시")
    ]
    
    init() {
        loadUserInfo()
    }
    
    func loadUserInfo() {
        if let data = UserDefaults.standard.data(forKey: userInfoKey),
           let decoded = try? JSONDecoder().decode(UserInfo.self, from: data) {
            self.userInfo = decoded
            self.gender = decoded.gender
            self.age = decoded.age > 0 ? String(decoded.age) : ""
            self.tolerance = Double(decoded.tolerance)
            self.heartRate = decoded.heartRate
            self.bedtime = decoded.bedtime.isEmpty ? "23:30" : decoded.bedtime
            self.wakeTime = decoded.wakeTime.isEmpty ? "07:30" : decoded.wakeTime
            self.selectedImportantTimes = Set(decoded.importantTimes)
        }
    }
    
    func saveUserInfo() {
        if let encoded = try? JSONEncoder().encode(userInfo) {
            UserDefaults.standard.set(encoded, forKey: userInfoKey)
        }
    }
    
    func getTimeOptions() -> [String] {
        return timeOptions
    }
    
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
    
    func validateAndSave() -> Bool {
        // 성별 검증
        if gender.isEmpty {
            alertMessage = "성별을 선택해주세요."
            showAlert = true
            return false
        }
        
        // 나이 검증
        guard let ageInt = Int(age), ageInt > 0, ageInt <= 150 else {
            alertMessage = "올바른 나이를 입력해주세요."
            showAlert = true
            return false
        }
        
        // 심장 박동 경험 검증
        if heartRate.isEmpty {
            alertMessage = "카페인 섭취 후 심장 박동 경험을 선택해주세요."
            showAlert = true
            return false
        }
        
        // 수면 시간 검증
        if bedtime.isEmpty || wakeTime.isEmpty {
            alertMessage = "수면 시간을 모두 선택해주세요."
            showAlert = true
            return false
        }
        
        // 중요 일정 시간대 검증
        if selectedImportantTimes.isEmpty {
            alertMessage = "중요한 일정이 많은 시간대를 최소 1개 이상 선택해주세요."
            showAlert = true
            return false
        }
        
        // 모든 검증 통과 시 저장
        userInfo.gender = gender
        userInfo.age = ageInt
        userInfo.tolerance = Int(tolerance)
        userInfo.heartRate = heartRate
        userInfo.bedtime = bedtime
        userInfo.wakeTime = wakeTime
        userInfo.importantTimes = Array(selectedImportantTimes)
        userInfo.completed = true
        userInfo.step = 2
        userInfo.timestamp = Date().timeIntervalSince1970
        
        saveUserInfo()
        return true
    }
}

