package practice.deploy.schedule.dto;

import lombok.*;

import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ScheduleCreateRequest {
    private LocalDate date;
    private LocalTime time;
    private String name;
    private Long userId;
}
