package practice.deploy.schedule.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import practice.deploy.schedule.entity.Schedule;

import java.time.LocalDate;
import java.time.LocalTime;

public record ScheduleItemResponse(
        Long scheduleId,
        String name,
        @JsonFormat(pattern = "yyyy-MM-dd")
        LocalDate date,
        @JsonFormat(pattern = "HH:mm")
        LocalTime time){
    public static ScheduleItemResponse from(Schedule schedule) {
        return new ScheduleItemResponse(schedule.getId(), schedule.getName(), schedule.getDate(), schedule.getTime());
    }
}