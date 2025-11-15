package practice.deploy.schedule.service;

import practice.deploy.schedule.dto.ScheduleCreateRequest;
import practice.deploy.schedule.dto.ScheduleUpdateRequest;
import practice.deploy.schedule.entity.Schedule;
import practice.deploy.schedule.repository.ScheduleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import practice.deploy.schedule.repository.ScheduleRepository;


@Service
@RequiredArgsConstructor
public class ScheduleService {

    private final ScheduleRepository scheduleRepository;

    // 일정 생성
    public Schedule create(ScheduleCreateRequest request) {
        Schedule schedule = Schedule.builder()
                .date(request.getDate())
                .time(request.getTime())
                .name(request.getName())
                .userId(request.getUserId())
                .build();

        return scheduleRepository.save(schedule);
    }

    // 일정 조회
    public List<Schedule> getSchedules(Long userId) {
        return scheduleRepository.findAllByUserId(userId);
    }

    // 일정 수정
    public Schedule update(Long id, ScheduleUpdateRequest request) {
        Schedule schedule = scheduleRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("일정을 찾을 수 없습니다."));

        schedule.setDate(request.getDate());
        schedule.setTime(request.getTime());
        schedule.setName(request.getName());

        return scheduleRepository.save(schedule);
    }

    // 일정 삭제
    public void delete(Long id) {
        scheduleRepository.deleteById(id);
    }
}
