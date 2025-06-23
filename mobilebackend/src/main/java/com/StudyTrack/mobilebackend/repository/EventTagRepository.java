package com.StudyTrack.mobilebackend.repository;

import com.StudyTrack.mobilebackend.entity.EventTag;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface EventTagRepository extends JpaRepository<EventTag, Long> {
    Optional<EventTag> findByName(String name);
} 