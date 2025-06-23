package com.StudyTrack.mobilebackend.controller;

import com.StudyTrack.mobilebackend.dto.CalendarEventDto;
import com.StudyTrack.mobilebackend.entity.CalendarEvent;
import com.StudyTrack.mobilebackend.service.CalendarEventService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/events")
@CrossOrigin(origins = "*")
public class CalendarEventController {
    
    @Autowired
    private CalendarEventService eventService;
    
    @PostMapping
    public ResponseEntity<?> createEvent(@Valid @RequestBody CalendarEventDto eventDto) {
        try {
            String username = getCurrentUsername();
            CalendarEvent event = eventService.createEvent(eventDto, username);
            
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Event created successfully");
            response.put("eventId", event.getId());
            response.put("event", event);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    @PutMapping("/{eventId}")
    public ResponseEntity<?> updateEvent(@PathVariable Long eventId, @Valid @RequestBody CalendarEventDto eventDto) {
        try {
            String username = getCurrentUsername();
            CalendarEvent event = eventService.updateEvent(eventId, eventDto, username);
            
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Event updated successfully");
            response.put("event", event);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    @DeleteMapping("/{eventId}")
    public ResponseEntity<?> deleteEvent(@PathVariable Long eventId) {
        try {
            String username = getCurrentUsername();
            eventService.deleteEvent(eventId, username);
            
            Map<String, String> response = new HashMap<>();
            response.put("message", "Event deleted successfully");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    @GetMapping
    public ResponseEntity<?> getUserEvents() {
        try {
            String username = getCurrentUsername();
            List<CalendarEvent> events = eventService.getUserEvents(username);
            return ResponseEntity.ok(events);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    @GetMapping("/{eventId}")
    public ResponseEntity<?> getEventById(@PathVariable Long eventId) {
        try {
            return eventService.getEventById(eventId)
                    .map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    @GetMapping("/upcoming")
    public ResponseEntity<?> getUpcomingEvents() {
        try {
            String username = getCurrentUsername();
            List<CalendarEvent> events = eventService.getUpcomingEvents(username);
            return ResponseEntity.ok(events);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    @GetMapping("/today")
    public ResponseEntity<?> getTodayEvents() {
        try {
            String username = getCurrentUsername();
            List<CalendarEvent> events = eventService.getTodayEvents(username);
            return ResponseEntity.ok(events);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    private String getCurrentUsername() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication.getName();
    }
} 