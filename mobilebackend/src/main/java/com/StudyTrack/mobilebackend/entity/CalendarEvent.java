package com.StudyTrack.mobilebackend.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * CalendarEvent entity representing an event in the academic calendar.
 * Demonstrates inheritance, polymorphism, and association relationships.
 */
@Entity
@Table(name = "calendar_events")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "event_type", discriminatorType = DiscriminatorType.STRING)
public abstract class CalendarEvent {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "Title is required")
    @Column(nullable = false)
    private String title;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @NotNull(message = "Start time is required")
    @Column(name = "start_time", nullable = false)
    private LocalDateTime startTime;
    
    @NotNull(message = "End time is required")
    @Column(name = "end_time", nullable = false)
    private LocalDateTime endTime;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private EventPriority priority = EventPriority.MEDIUM;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private EventStatus status = EventStatus.SCHEDULED;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Association with User (Many-to-One)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    // Association with EventCategory (Many-to-One)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private EventCategory category;
    
    // Association with EventTag (Many-to-Many)
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "event_tags",
        joinColumns = @JoinColumn(name = "event_id"),
        inverseJoinColumns = @JoinColumn(name = "tag_id")
    )
    private List<EventTag> tags = new ArrayList<>();
    
    // Default constructor
    public CalendarEvent() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    // Parameterized constructor
    public CalendarEvent(String title, String description, LocalDateTime startTime, LocalDateTime endTime) {
        this();
        this.title = title;
        this.description = description;
        this.startTime = startTime;
        this.endTime = endTime;
    }
    
    // Abstract method - demonstrates polymorphism
    public abstract String getEventType();
    
    // Business methods
    public boolean isOverlapping(CalendarEvent other) {
        return !(this.endTime.isBefore(other.startTime) || this.startTime.isAfter(other.endTime));
    }
    
    public long getDurationInMinutes() {
        return java.time.Duration.between(startTime, endTime).toMinutes();
    }
    
    public boolean isToday() {
        LocalDateTime now = LocalDateTime.now();
        return startTime.toLocalDate().equals(now.toLocalDate());
    }
    
    public boolean isUpcoming() {
        return startTime.isAfter(LocalDateTime.now());
    }
    
    public void addTag(EventTag tag) {
        if (!tags.contains(tag)) {
            tags.add(tag);
            tag.getEvents().add(this);
        }
    }
    
    public void removeTag(EventTag tag) {
        if (tags.remove(tag)) {
            tag.getEvents().remove(this);
        }
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public LocalDateTime getStartTime() {
        return startTime;
    }
    
    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }
    
    public LocalDateTime getEndTime() {
        return endTime;
    }
    
    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }
    
    public EventPriority getPriority() {
        return priority;
    }
    
    public void setPriority(EventPriority priority) {
        this.priority = priority;
    }
    
    public EventStatus getStatus() {
        return status;
    }
    
    public void setStatus(EventStatus status) {
        this.status = status;
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
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    public EventCategory getCategory() {
        return category;
    }
    
    public void setCategory(EventCategory category) {
        this.category = category;
    }
    
    public List<EventTag> getTags() {
        return tags;
    }
    
    public void setTags(List<EventTag> tags) {
        this.tags = tags;
    }
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    @Override
    public String toString() {
        return "CalendarEvent{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", priority=" + priority +
                ", status=" + status +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CalendarEvent that = (CalendarEvent) o;
        return id != null && id.equals(that.id);
    }
    
    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }
} 
 