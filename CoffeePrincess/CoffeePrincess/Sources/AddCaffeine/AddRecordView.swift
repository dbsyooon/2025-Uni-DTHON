//
//  AddRecordView.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/15/25.
//

import SwiftUI

struct AddRecordView: View {
    @Environment(\.diContainer) private var di
    
    @State private var starbucksMenu: [MenuItem] = MenuItem.mockStarbucksItems
    @State private var otherMenu: [MenuItem] = MenuItem.mockOtherItems
    
    // 검색창을 위한 상태
    @State private var searchText: String = ""

    var body: some View {
        HeaderBar(viewText: "카페인 추가", onTapBack: { di.router.pop() })
        List {
            // MARK: - 스타벅스 섹션
            Section(header: Text("Coffee")) {
                // ForEach를 사용해 메뉴 아이템을 동적으로 표시합니다.
                ForEach(starbucksMenu) { item in
                    // 2. 재사용 가능한 'MenuItemView' 컴포넌트를 사용합니다.
                    MenuItemView(item: item)
                        .onTapGesture {
                            di.router.push(.recordDetail(menuItem: item))
                        }
                }
            }
            
            // MARK: - 기타 음료 섹션
            Section(header: Text("Others")) {
                ForEach(otherMenu) { item in
                    MenuItemView(item: item)
                        .onTapGesture {
                            print("\(item.name) 선택됨")
                        }
                }
            }
        }
        .listStyle(.insetGrouped)
//        .navigationTitle("카페인 추가")
//        .searchable(text: $searchText, prompt: "메뉴 검색") // 검색 기능
    }
}

// MARK: - Menu Item Row Component
/// 개별 메뉴 아이템을 보여주는 재사용 가능한 뷰 컴포넌트입니다.
struct MenuItemView: View {
    let item: MenuItem
    
    var body: some View {
        HStack(spacing: 16) {
            // 아이콘
//            Image(item.iconName)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 40)
            Image(systemName: item.iconName)
                .font(.title3)
                .foregroundStyle(Color.brown1) // 아이콘 색상
                .frame(width: 40) // 아이콘 정렬을 위한 프레임
            
            // 이름
            Text(item.name)
                .font(.pretendard(.regular, size: 17))
//                .foregroundStyle(Color.brown1)
            
            Spacer()
            
            // 네비게이션을 암시하는 > 아이콘
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding(.vertical, 8) // 컴포넌트 상하 여백
    }
}

#Preview {
    AddRecordView()
}
