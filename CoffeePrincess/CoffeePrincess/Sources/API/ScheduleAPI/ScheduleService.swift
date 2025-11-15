import Foundation
import Moya
import Combine

/// 일정 관련 API 요청을 담당하는 서비스
final class ScheduleService {
    
    // ScheduleAPI를 사용하는 Moya Provider 인스턴스
    private let provider: MoyaProvider<ScheduleAPI>
    
    // MARK: - Initializer
    
    init(provider: MoyaProvider<ScheduleAPI> = MoyaProvider<ScheduleAPI>()) {
        self.provider = provider
    }
}

// MARK: - Public API
extension ScheduleService {
    
    /// (GET) 하루 일정 조회 API
    /// - Parameter date: "YYYY-MM-DD" 형식의 날짜 문자열 (예: "2025-11-15")
    /// - Returns: 해당 날짜의 Schedule 리스트를 방출하는 Publisher
    func fetchSchedules(date: String) -> AnyPublisher<[Schedule], Error> {
        provider.requestPublisher(.getSchedule(date: date))
            .map(\.data)
            .decode(
                type: BaseResponse<ScheduleListResponse>.self,
                decoder: JSONDecoder()
            )
            .tryMap { baseResponse in
                // 서버에서 실패로 내려오면 에러 처리
                guard baseResponse.isSuccess else {
                    throw ScheduleServiceError.server(message: baseResponse.message)
                }
                
                // results가 없으면 빈 배열 리턴
                let listResponse = baseResponse.results
                let items = listResponse?.scheduleItemResponseList ?? []
                
                // ScheduleItemResponse -> Schedule로 매핑
                return items.map { item in
                    // 서버 time: "HH:mm:ss" 인 경우 앞 5자리(HH:mm)만 사용
                    let timeString: String
                    if item.time.count >= 5 {
                        let index = item.time.index(item.time.startIndex, offsetBy: 5)
                        timeString = String(item.time[..<index])
                    } else {
                        timeString = item.time
                    }
                    
                    return Schedule(
                        name: item.name,
                        date: item.date,
                        time: timeString
                    )
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// (POST) 일정 생성 API
    /// - Parameter schedule: 생성할 일정 도메인 모델
    /// - Returns: Bool (성공 여부)를 방출하는 Publisher
    func addSchedule(_ schedule: Schedule) -> AnyPublisher<Bool, Error> {
        // 도메인 모델 -> 서버에 보낼 Record로 변환
        let record = ScheduleRecord(
            time: schedule.time,  // "HH:mm"
            date: schedule.date,  // "YYYY-MM-DD"
            name: schedule.name
        )
        
        return provider.requestPublisher(.addSchedule(record: record))
            .map(\.data)
            .decode(
                type: BaseResponse<EmptyResults>.self,
                decoder: JSONDecoder()
            )
            .tryMap { baseResponse in
                // 서버에서 실패로 내려오면 에러 처리
                guard baseResponse.isSuccess else {
                    throw ScheduleServiceError.server(message: baseResponse.message)
                }
                return baseResponse.isSuccess
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Error 정의
enum ScheduleServiceError: LocalizedError {
    case server(message: String)
    
    var errorDescription: String? {
        switch self {
        case .server(let message):
            return message
        }
    }
}
