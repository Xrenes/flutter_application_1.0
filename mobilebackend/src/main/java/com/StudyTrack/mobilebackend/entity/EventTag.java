package com.StudyTrack.mobilebackend.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * EventTag entity representing tags for calendar events.
 * Demonstrates many-to-many relationships and encapsulation.
 */
@Entity
@Table(name = "event_tags")
public class EventTag {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "Tag name is required")
    @Column(unique = true, nullable = false)
    private String name;
    
    @Column(name = "color_hex")
    private String colorHex = "#FF9800"; // Default orange color
    
    @Column(name = "is_active")
    private boolean isActive = true;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Association with CalendarEvent (Many-to-Many)
    @ManyToMany(mappedBy = "tags", fetch = FetchType.LAZY)
    private List<CalendarEvent> events = new ArrayList<>();
    
    // Default constructor
    public EventTag() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    // Parameterized constructor
    public EventTag(String name) {
        this();
        this.name = name;
    }
    
    // Business methods
    public int getEventCount() {
        return events.size();
    }
    
    public boolean hasEvents() {
        return !events.isEmpty();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getColorHex() {
        return colorHex;
    }
    
    public void setColorHex(String colorHex) {
        this.colorHex = colorHex;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public List<CalendarEvent> getEvents() {
        return events;
    }
    
    public void setEvents(List<CalendarEvent> events) {
        this.events = events;
    }
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    @Override
    public String toString() {
        return "EventTag{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", colorHex='" + colorHex + '\'' +
                ", isActive=" + isActive +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        EventTag eventTag = (EventTag) o;
        return id != null && id.equals(eventTag.id);
    }
    
    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }
} 