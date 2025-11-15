import SwiftUI

// MARK: - 메인 프로필 화면

struct ProfileView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss

    @State private var showSleepTimeModal = false
    @State private var showTargetSleepModal = false
    @State private var showMaxCaffeineModal = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()   // 흰색 배경 유지

                ScrollView {
                    VStack(spacing: 28) {
                        ProfileHeaderView(viewModel: profileViewModel)
                        personalSettingsSection
                        healthInfoSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("프로필")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    })
                    {
                        Image(systemName: "chevron.left")
                            .font(.pretendard(.semiBold, size: 18))
                            .foregroundColor(.mainBrown)
                    }
                }
            }
        }
        .sheet(isPresented: $showSleepTimeModal) {
            SleepTimeModalView(profileViewModel: profileViewModel)
        }
        .sheet(isPresented: $showTargetSleepModal) {
            TargetSleepModalView(profileViewModel: profileViewModel)
        }
        .sheet(isPresented: $showMaxCaffeineModal) {
            MaxCaffeineModalView(profileViewModel: profileViewModel)
        }
    }

    // MARK: - 서브 뷰들 분리

    private var personalSettingsSection: some View {
        ProfileSection(title: "개인 설정") {
            SettingRow(
                label: "평소 수면 시간대",
                value: formatSleepTimeRange(),
                action: { showSleepTimeModal = true }
            )

            SettingRow(
                label: "목표 수면 시간",
                value: formatTargetSleep(),
                action: { showTargetSleepModal = true }
            )

            Button(action: {
                profileViewModel.userInfo.step = 0
                profileViewModel.userInfo.completed = false
                profileViewModel.saveUserInfo()
                dismiss()
            }) {
                Text("카페인 민감도 재측정")
                    .font(.pretendard(.semiBold, size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.mainBrown)
                    .cornerRadius(12)
            }
            .padding(.top, 8)
        }
    }

    private var healthInfoSection: some View {
        ProfileSection(title: "건강 정보") {
            InfoRow(
                label: "심장이 과하게 뛴 경험",
                value: profileViewModel.getHeartRateText()
            )

            InfoRow(
                label: "1일 최대 카페인 제한치",
                value: "\(profileViewModel.userInfo.maxCaffeine) mg",
                showEdit: true,
                action: { showMaxCaffeineModal = true }
            )
        }
    }

    // MARK: - 포맷팅 함수

    private func formatSleepTimeRange() -> String {
        let bedtime = formatTime(profileViewModel.userInfo.bedtime)
        let wakeTime = formatTime(profileViewModel.userInfo.wakeTime)
        return "\(bedtime) ~ \(wakeTime)"
    }

    private func formatTime(_ time: String) -> String {
        let components = time.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            return time
        }

        let ampm = hour >= 12 ? "오후" : "오전"
        let displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        return "\(ampm) \(displayHour):\(String(format: "%02d", minute))"
    }

    private func formatTargetSleep() -> String {
        let hours = Int(profileViewModel.userInfo.targetSleep)
        let minutes = Int((profileViewModel.userInfo.targetSleep - Double(hours)) * 60)
        return minutes == 0 ? "\(hours)시간" : "\(hours)시간 \(minutes)분"
    }
}

// MARK: - 헤더 뷰

struct ProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("👤")
                .font(.pretendard(.medium, size: 54))
                .frame(width: 110, height: 110)
                .background(Color.cardBackground)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.dividerCol, lineWidth: 2)
                )

            HStack(spacing: 4) {
                Text("사용자")
                    .font(.pretendard(.bold, size: 24))
                    .foregroundColor(.mainBrown)
                Text("님")
                    .font(.pretendard(.semiBold, size: 24))
                    .foregroundColor(.secondaryBrown)
            }

            Text("카페인 타입: \(viewModel.getCaffeineType())")
                .font(.pretendard(.medium, size: 17))
                .foregroundColor(.secondaryBrown)
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(Color.sectionBackground)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.dividerCol, lineWidth: 1)
        )
    }
}

// MARK: - 섹션/행 공통 뷰

struct ProfileSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(title)
                .font(.pretendard(.bold, size: 20))
                .foregroundColor(.mainBrown)
                .padding(.bottom, 4)

            VStack(spacing: 0) {
                content
            }
        }
        .padding(22)
        .background(Color.sectionBackground)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.dividerCol, lineWidth: 1)
        )
    }
}

struct SettingRow: View {
    let label: String
    let value: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundColor(.mainBrown)

                Spacer()

                HStack(spacing: 8) {
                    Text(value)
                        .font(.pretendard(.medium, size: 15))
                        .foregroundColor(.secondaryBrown)
                    Image(systemName: "chevron.right")
                        .font(.pretendard(.semiBold, size: 12))
                        .foregroundColor(.mainBrown)
                }
            }
            .padding(.vertical, 14)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color.dividerCol)
                    .frame(height: 1)
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    var showEdit: Bool = false
    var action: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(label)
                .font(.pretendard(.medium, size: 16))
                .foregroundColor(.mainBrown)
            Spacer()
            HStack(spacing: 8) {
                Text(value)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundColor(.secondaryBrown)
                if showEdit {
                    Button(action: { action?() }) {
                        Text("수정")
                            .font(.pretendard(.medium, size: 14))
                            .foregroundColor(.mainBrown)
                            .underline()
                    }
                }
            }
        }
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.dividerCol)
                .frame(height: 1)
        }
    }
}

// MARK: - 수면 시간 수정 모달

struct SleepTimeModalView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss

    @State private var bedtime: String = "23:30"
    @State private var wakeTime: String = "07:30"

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ProfileTimePicker(
                    title: "잠드는 시간",
                    selection: $bedtime,
                    profileViewModel: profileViewModel
                )

                ProfileTimePicker(
                    title: "일어나는 시간",
                    selection: $wakeTime,
                    profileViewModel: profileViewModel
                )

                Spacer()

                Button(action: {
                    profileViewModel.userInfo.bedtime = bedtime
                    profileViewModel.userInfo.wakeTime = wakeTime
                    profileViewModel.saveUserInfo()
                    dismiss()
                }) {
                    Text("저장")
                        .font(.pretendard(.semiBold, size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.mainBrown)
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .navigationTitle("수면 시간 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") { dismiss() }
                        .font(.pretendard(.medium, size: 16))
                        .foregroundColor(.mainBrown)
                }
            }
        }
        .onAppear {
            bedtime = profileViewModel.userInfo.bedtime.isEmpty ? "23:30" : profileViewModel.userInfo.bedtime
            wakeTime = profileViewModel.userInfo.wakeTime.isEmpty ? "07:30" : profileViewModel.userInfo.wakeTime
        }
    }
}

// MARK: - 프로필 시간 선택 휠 피커
struct ProfileTimePicker: View {
    let title: String
    @Binding var selection: String
    @ObservedObject var profileViewModel: ProfileViewModel
    
    @State private var showPicker = false
    @State private var selectedDate: Date
    
    init(title: String, selection: Binding<String>, profileViewModel: ProfileViewModel) {
        self.title = title
        self._selection = selection
        self.profileViewModel = profileViewModel
        self._selectedDate = State(initialValue: profileViewModel.timeStringToDate(selection.wrappedValue))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.pretendard(.medium, size: 15))
                .foregroundColor(.mainBrown)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showPicker.toggle()
                }
            }) {
                HStack {
                    Text(profileViewModel.formatTimeDisplay(selection))
                        .font(.pretendard(.medium, size: 16))
                        .foregroundColor(.mainBrown)
                    
                    Spacer()
                    
                    Image(systemName: showPicker ? "chevron.up" : "chevron.down")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundColor(.mainBrown)
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color.sectionBackground)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.dividerCol, lineWidth: 1)
                )
            }
            
            if showPicker {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .tint(.mainBrown)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.cardBackground.opacity(0.5))
                )
                .onChange(of: selectedDate) { oldValue, newValue in
                    selection = profileViewModel.dateToTimeString(newValue)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .onChange(of: selection) { oldValue, newValue in
            selectedDate = profileViewModel.timeStringToDate(newValue)
        }
    }
}

// MARK: - 목표 수면 시간 수정 모달

struct TargetSleepModalView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedHours: Int = 7
    @State private var selectedMinutes: Int = 30
    
    private let hourOptions = Array(1...15)
    private let minuteOptions = [0, 15, 30, 45]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("목표 수면 시간")
                        .font(.pretendard(.medium, size: 15))
                        .foregroundColor(.mainBrown)

                    HStack(spacing: 0) {
                        // 시간 선택
                        VStack(spacing: 8) {
                            Text("시간")
                                .font(.pretendard(.medium, size: 14))
                                .foregroundColor(.mainBrown)
                            
                            Picker("시간", selection: $selectedHours) {
                                ForEach(hourOptions, id: \.self) { hour in
                                    Text("\(hour)").tag(hour)
                                }
                            }
                            .pickerStyle(.wheel)
                            .tint(.mainBrown)
                            .frame(maxWidth: .infinity)
                        }
                        
                        // 분 선택
                        VStack(spacing: 8) {
                            Text("분")
                                .font(.pretendard(.medium, size: 14))
                                .foregroundColor(.mainBrown)
                            
                            Picker("분", selection: $selectedMinutes) {
                                ForEach(minuteOptions, id: \.self) { minute in
                                    Text("\(minute)").tag(minute)
                                }
                            }
                            .pickerStyle(.wheel)
                            .tint(.mainBrown)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(12)
                    .background(Color.sectionBackground)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.dividerCol, lineWidth: 1)
                    )
                }

                Spacer()

                Button(action: {
                    let totalSleep = Double(selectedHours) + Double(selectedMinutes) / 60.0
                    profileViewModel.userInfo.targetSleep = totalSleep
                    profileViewModel.saveUserInfo()
                    dismiss()
                }) {
                    Text("저장")
                        .font(.pretendard(.semiBold, size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.mainBrown)
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .navigationTitle("목표 수면 시간 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") { dismiss() }
                        .font(.pretendard(.medium, size: 16))
                        .foregroundColor(.mainBrown)
                }
            }
        }
        .onAppear {
            let currentSleep = profileViewModel.userInfo.targetSleep
            selectedHours = Int(currentSleep)
            selectedMinutes = Int((currentSleep - Double(Int(currentSleep))) * 60)
            // 분을 15분 단위로 반올림
            selectedMinutes = minuteOptions.min(by: { abs($0 - selectedMinutes) < abs($1 - selectedMinutes) }) ?? 0
        }
    }
}

// MARK: - 최대 카페인 제한치 수정 모달

struct MaxCaffeineModalView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss

    @State private var maxCaffeine: String = "140"

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("1일 최대 카페인 제한치 (mg)")
                        .font(.pretendard(.medium, size: 15))
                        .foregroundColor(.mainBrown)

                    TextField("", text: $maxCaffeine)
                        .font(.pretendard(.medium, size: 16))
                        .keyboardType(.numberPad)
                        .padding(12)
                        .background(Color.sectionBackground)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.dividerCol, lineWidth: 1)
                        )
                }

                Spacer()

                Button(action: {
                    if let value = Int(maxCaffeine), value >= 0 && value <= 500 {
                        profileViewModel.userInfo.maxCaffeine = value
                        profileViewModel.saveUserInfo()
                        dismiss()
                    }
                }) {
                    Text("저장")
                        .font(.pretendard(.semiBold, size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.mainBrown)
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .navigationTitle("최대 카페인 제한치 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") { dismiss() }
                        .font(.pretendard(.medium, size: 16))
                        .foregroundColor(.mainBrown)
                }
            }
        }
        .onAppear {
            maxCaffeine = String(profileViewModel.userInfo.maxCaffeine)
        }
    }
}

// MARK: - Preview

#Preview {
    ProfileView(profileViewModel: ProfileViewModel())
}
