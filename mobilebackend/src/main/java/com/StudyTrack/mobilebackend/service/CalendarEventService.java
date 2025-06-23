package com.StudyTrack.mobilebackend.service;

import com.StudyTrack.mobilebackend.dto.CalendarEventDto;
import com.StudyTrack.mobilebackend.entity.*;
import com.StudyTrack.mobilebackend.repository.CalendarEventRepository;
import com.StudyTrack.mobilebackend.repository.EventCategoryRepository;
import com.StudyTrack.mobilebackend.repository.EventTagRepository;
import com.StudyTrack.mobilebackend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CalendarEventService {
    
    @Autowired
    private CalendarEventRepository eventRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private EventCategoryRepository categoryRepository;
    
    @Autowired
    private EventTagRepository tagRepository;
    
    public CalendarEvent createEvent(CalendarEventDto eventDto, String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        CalendarEvent event;
        
        if ("ASSIGNMENT".equals(eventDto.getEventType())) {
            AssignmentEvent assignmentEvent = new AssignmentEvent();
            assignmentEvent.setSubject(eventDto.getSubject());
            assignmentEvent.setCourseCode(eventDto.getCourseCode());
            if (eventDto.getAssignmentType() != null) {
                assignmentEvent.setAssignmentType(AssignmentType.valueOf(eventDto.getAssignmentType()));
            }
            assignmentEvent.setTotalPoints(eventDto.getTotalPoints());
            assignmentEvent.setSubmissionMethod(eventDto.getSubmissionMethod());
            assignmentEvent.setGroupAssignment(eventDto.isGroupAssignment());
            event = assignmentEvent;
        } else {
            event = new CalendarEvent() {
                @Override
                public String getEventType() {
                    return "GENERAL";
                }
            };
        }
        
        event.setTitle(eventDto.getTitle());
        event.setDescription(eventDto.getDescription());
        event.setStartTime(eventDto.getStartTime());
        event.setEndTime(eventDto.getEndTime());
        event.setPriority(eventDto.getPriority());
        event.setStatus(eventDto.getStatus());
        event.setUser(user);
        
        // Set category if provided
        if (eventDto.getCategoryId() != null) {
            EventCategory category = categoryRepository.findById(eventDto.getCategoryId())
                    .orElse(null);
            event.setCategory(category);
        }
        
        // Set tags if provided
        if (eventDto.getTagIds() != null && !eventDto.getTagIds().isEmpty()) {
            List<EventTag> tags = tagRepository.findAllById(eventDto.getTagIds());
            event.setTags(tags);
        }
        
        return eventRepository.save(event);
    }
    
    public CalendarEvent updateEvent(Long eventId, CalendarEventDto eventDto, String username) {
        CalendarEvent event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Event not found"));
        
        // Check if user owns the event
        if (!event.getUser().getUsername().equals(username)) {
            throw new RuntimeException("You can only update your own events");
        }
        
        event.setTitle(eventDto.getTitle());
        event.setDescription(eventDto.getDescription());
        event.setStartTime(eventDto.getStartTime());
        event.setEndTime(eventDto.getEndTime());
        event.setPriority(eventDto.getPriority());
        event.setStatus(eventDto.getStatus());
        
        // Update category if provided
        if (eventDto.getCategoryId() != null) {
            EventCategory category = categoryRepository.findById(eventDto.getCategoryId())
                    .orElse(null);
            event.setCategory(category);
        }
        
        // Update tags if provided
        if (eventDto.getTagIds() != null) {
            List<EventTag> tags = tagRepository.findAllById(eventDto.getTagIds());
            event.setTags(tags);
        }
        
        return eventRepository.save(event);
    }
    
    public void deleteEvent(Long eventId, String username) {
        CalendarEvent event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Event not found"));
        
        // Check if user owns the event
        if (!event.getUser().getUsername().equals(username)) {
            throw new RuntimeException("You can only delete your own events");
        }
        
        eventRepository.delete(event);
    }
    
    public List<CalendarEvent> getUserEvents(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return eventRepository.findByUser(user);
    }
    
    public Optional<CalendarEvent> getEventById(Long eventId) {
        return eventRepository.findById(eventId);
    }
    
    public List<CalendarEvent> getUpcomingEvents(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        return eventRepository.findByUser(user).stream()
                .filter(CalendarEvent::isUpcoming)
                .collect(Collectors.toList());
    }
    
    public List<CalendarEvent> getTodayEvents(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        return eventRepository.findByUser(user).stream()
                .filter(CalendarEvent::isToday)
                .collect(Collectors.toList());
    }
} 