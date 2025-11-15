package practice.deploy.schedule.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.List;

import practice.deploy.schedule.dto.ScheduleCreateRequest;
import practice.deploy.schedule.dto.ScheduleUpdateRequest;
import practice.deploy.schedule.entity.Schedule;
import practice.deploy.schedule.service.ScheduleService;
@RestController
@RequestMapping("/api/schedules")
@RequiredArgsConstructor
public class ScheduleController {

    private final ScheduleService scheduleService;

    // CREATE - 일정 생성
    @PostMapping
    public Schedule create(@RequestBody ScheduleCreateRequest request) {
        return scheduleService.create(request);
    }

    // READ - 유저 일정 전체 조회
    @GetMapping("/{userId}")
    public List<Schedule> getUserSchedules(@PathVariable Long userId) {
        return scheduleService.getSchedules(userId);
    }

    // UPDATE - 일정 수정
    @PutMapping("/{id}")
    public Schedule update(@PathVariable Long id,
                           @RequestBody ScheduleUpdateRequest request) {
        return scheduleService.update(id, request);
    }

    // DELETE - 일정 삭제
    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        scheduleService.delete(id);
    }
}
