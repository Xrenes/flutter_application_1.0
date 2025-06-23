package com.StudyTrack.mobilebackend.repository;

import com.StudyTrack.mobilebackend.entity.CalendarEvent;
import com.StudyTrack.mobilebackend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CalendarEventRepository extends JpaRepository<CalendarEvent, Long> {
    List<CalendarEvent> findByUser(User user);
} 