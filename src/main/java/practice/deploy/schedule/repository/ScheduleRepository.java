package practice.deploy.schedule.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import practice.deploy.schedule.entity.Schedule;

import java.util.List;

public interface ScheduleRepository extends JpaRepository<Schedule, Long> {

    List<Schedule> findAllByUserId(Long userId);
}
