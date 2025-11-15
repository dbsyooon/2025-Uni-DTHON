//
//  CoffeeModel.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/15/25.
//

import Foundation

struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let iconName: String // SFSymbol 이름
    
    let baseCaffeinePerShot: Int
}

// MARK: - Mock Data
extension MenuItem {
    /// 아이콘은 SF Symbols를 사용합니다. (https://developer.apple.com/sf-symbols/)
    static var mockStarbucksItems: [MenuItem] = [
        MenuItem(name: "아메리카노", iconName: "cup.and.saucer.fill", baseCaffeinePerShot: 150), // 조사 완료
        MenuItem(name: "카페라떼", iconName: "cup.and.saucer.fill", baseCaffeinePerShot: 75), // 조사 완료
        MenuItem(name: "바닐라 라떼", iconName: "cup.and.saucer.fill", baseCaffeinePerShot: 75), // 조사 완료
        MenuItem(name: "콜드 브루", iconName: "mug.fill", baseCaffeinePerShot: 155), // 조사 완료
        MenuItem(name: "플랫 화이트", iconName: "snowflake", baseCaffeinePerShot: 130), // 조사 완료
        MenuItem(name: "카페 모카", iconName: "leaf.fill", baseCaffeinePerShot: 95), // 조사 완료
        MenuItem(name: "돌체 라떼", iconName: "leaf.fill", baseCaffeinePerShot: 150), // 조사 완료
        MenuItem(name: "자바 칩 프라푸치노", iconName: "leaf.fill", baseCaffeinePerShot: 100) // 조사 완료
    ]
    
    static var mockOtherItems: [MenuItem] = [
        MenuItem(name: "믹스 커피", iconName: "mug.fill", baseCaffeinePerShot: 50), // 조사 완료
        MenuItem(name: "에너지 드링크", iconName: "bolt.fill", baseCaffeinePerShot: 100) // 조사 완료
    ]
}

enum CoffeeSize: String, CaseIterable, Identifiable {
    case short = "Short"
    case tall = "Tall"
    case grande = "Grande"
    case venti = "Venti"
    
    var id: String { self.rawValue }
    
    /// 사이즈별 기본 샷 수를 반환합니다. (스타벅스 기준 예시)
    /// 이 값은 ViewModel에서 샷 수의 '기본값'으로 사용됩니다.
    var defaultShotCount: Int {
        switch self {
        case .short: return 1
        case .tall: return 1
        case .grande: return 2
        case .venti: return 2 // Venti(Hot)은 2샷, Venti(Iced)는 3샷이지만 단순화
        }
    }
}
