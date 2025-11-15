//
//  RecordDetailView.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/15/25.
//

import SwiftUI

/// 선택한 메뉴의 상세 정보(샷, 사이즈, 시간)를 입력하고 저장하는 뷰입니다.
struct RecordDetailView: View {
    @Environment(\.diContainer) private var di
    
    // 1. @StateObject는 뷰가 직접 소유하고 생성해야 합니다.
    //    (private var로 변경)
    @StateObject private var viewModel: RecordDetailViewModel
    
    // 2. ViewModel을 생성하는데 필요한 '데이터'인 MenuItem을 init에서 받습니다.
    private let menuItem: MenuItem
    
    // 3. init(menuItem:) 추가
    init(menuItem: MenuItem) {
        self.menuItem = menuItem
        // 4. 전달받은 menuItem으로 ViewModel을 '내부에서' 생성합니다.
        self._viewModel = StateObject(wrappedValue: RecordDetailViewModel(menuItem: menuItem))
    }
    
    var body: some View {
        HeaderBar(viewText: viewModel.selectedMenuItem.name, onTapBack: { di.router.pop() })
        VStack(spacing: 0) {
            List {
                // MARK: - 메뉴 설정
                Section(header: Text("섭취량 설정")) {
                    Stepper(value: $viewModel.shotCount, in: 0...10) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundStyle(Color.brown1)
                            Text("샷 추가")
                            Spacer()
                            Text("\(viewModel.shotCount) 샷")
                        }
                    }
                    .font(.pretendard(.medium, size: 17))
                    
                    Picker("사이즈", selection: $viewModel.size) {
                        ForEach(CoffeeSize.allCases, id: \.self) { size in
                            Text(size.rawValue).tag(size)
                        }
                    }
                    .font(.pretendard(.medium, size: 17))
                    .pickerStyle(.menu)
                    .tint(Color.brown1)
                }
                
                // MARK: - 시간 설정
                Section(header: Text("섭취 시간")) {
                    DatePicker(
                        "마신 시간",
                        selection: $viewModel.selectedDate,
                        in: ...Date(), // 미래 시간은 선택 불가
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.graphical) // 달력 스타일
                    .labelsHidden()
                    .tint(Color.brown1)
                }
                
                // MARK: - 총 카페인 (계산 결과)
                Section(header: Text("예상 카페인")) {
                    HStack {
                        Image("activity-heart")
                            .foregroundStyle(Color.brown1)
                        Text("총 카페인 함량")
                            .font(.pretendard(.regular, size: 17))
                        Spacer()
                        Text("\(viewModel.totalCaffeine) mg")
                            .font(.pretendard(.bold, size: 19))
                            .foregroundColor(.brown1)
                    }
                }
            }
            .listStyle(.insetGrouped)
            
            // MARK: - 저장 버튼
            Button(action: {
                viewModel.saveRecord(container: di)
            }) {
                Text("저장하기")
                    .font(.pretendard(.bold, size: 18))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brown1)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
//        .navigationTitle(viewModel.selectedMenuItem.name) // 네비게이션 타이틀에 메뉴 이름
//        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
#Preview {
    let mockItem = MenuItem.mockStarbucksItems[0] // "아메리카노"
    RecordDetailView(menuItem: mockItem)
}
