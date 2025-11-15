//
//  RecordDetailViewModel.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/15/25.
//

import Foundation
import Combine
import SwiftUI

/// RecordDetailView의 상태와 로직을 관리하는 ViewModel
class RecordDetailViewModel: ObservableObject {
    
    // MARK: - Properties
    
    let selectedMenuItem: MenuItem
    let baseCaffeinePerShot: Int
    
    // MARK: - Published State
    
    // 1. View에서 바인딩할 상태
    @Published var shotCount: Int = 1
    @Published var size: CoffeeSize = .tall
    @Published var selectedDate: Date = Date()
    
    // 2. 계산된 총 카페인
    @Published var totalCaffeine: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(menuItem: MenuItem) {
        self.selectedMenuItem = menuItem
        self.baseCaffeinePerShot = menuItem.baseCaffeinePerShot
        
        // 초기값 설정
        self.size = .tall
        self.shotCount = self.size.defaultShotCount
        
        // 3. (핵심) shotCount 또는 size가 변경될 때마다 totalCaffeine을 다시 계산
        setupBindings()
        
        // 4. 초기 카페인 값 계산
        updateTotalCaffeine()
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        // 샷 카운트가 변경되면 카페인 업데이트
        $shotCount
            .sink { [weak self] _ in
                self?.updateTotalCaffeine()
            }
            .store(in: &cancellables)
        
        // 사이즈가 변경되면 샷 카운트를 기본값으로 업데이트
        $size
            .sink { [weak self] newSize in
                self?.shotCount = newSize.defaultShotCount
                // shotCount가 변경되었으므로 updateTotalCaffeine()이 자동으로 호출됨
            }
            .store(in: &cancellables)
    }
    
    /// 총 카페인을 계산하는 로직
    private func updateTotalCaffeine() {
        // (샷 당 카페인) * (샷 수)
        totalCaffeine = baseCaffeinePerShot * shotCount
        print("총 카페인 계산됨: \(totalCaffeine)mg")
    }
    
    // MARK: - Public Methods
    
    /// 저장 버튼 로직 (DIContainer를 통해 주입받아 사용)
    func saveRecord(container: DIContainer) {
        print("--- 카페인 기록 저장 ---")
        print("메뉴: \(selectedMenuItem.name)")
        print("샷: \(shotCount), 사이즈: \(size.rawValue)")
        print("시간: \(selectedDate)")
        print("총 카페인: \(totalCaffeine)mg")
        
        // TODO: container.caffeineService.addRecord(...) 같은 저장 로직 호출
        
        // 저장 후 이전 화면으로 돌아가기
        container.router.pop()
    }
}
