package com.StudyTrack.mobilebackend.dto;

import com.StudyTrack.mobilebackend.entity.EventPriority;
import com.StudyTrack.mobilebackend.entity.EventStatus;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.List;

public class CalendarEventDto {
    private Long id;
    
    @NotBlank(message = "Title is required")
    private String title;
    
    private String description;
    
    @NotNull(message = "Start time is required")
    private LocalDateTime startTime;
    
    @NotNull(message = "End time is required")
    private LocalDateTime endTime;
    
    private EventPriority priority = EventPriority.MEDIUM;
    private EventStatus status = EventStatus.SCHEDULED;
    private String eventType;
    private Long userId;
    private Long categoryId;
    private List<Long> tagIds;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Assignment-specific fields
    private String subject;
    private String courseCode;
    private String assignmentType;
    private Integer totalPoints;
    private String submissionMethod;
    private boolean isGroupAssignment;
    
    public CalendarEventDto() {}
    
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
    
    public String getEventType() {
        return eventType;
    }
    
    public void setEventType(String eventType) {
        this.eventType = eventType;
    }
    
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    
    public Long getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }
    
    public List<Long> getTagIds() {
        return tagIds;
    }
    
    public void setTagIds(List<Long> tagIds) {
        this.tagIds = tagIds;
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
    
    public String getSubject() {
        return subject;
    }
    
    public void setSubject(String subject) {
        this.subject = subject;
    }
    
    public String getCourseCode() {
        return courseCode;
    }
    
    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }
    
    public String getAssignmentType() {
        return assignmentType;
    }
    
    public void setAssignmentType(String assignmentType) {
        this.assignmentType = assignmentType;
    }
    
    public Integer getTotalPoints() {
        return totalPoints;
    }
    
    public void setTotalPoints(Integer totalPoints) {
        this.totalPoints = totalPoints;
    }
    
    public String getSubmissionMethod() {
        return submissionMethod;
    }
    
    public void setSubmissionMethod(String submissionMethod) {
        this.submissionMethod = submissionMethod;
    }
    
    public boolean isGroupAssignment() {
        return isGroupAssignment;
    }
    
    public void setGroupAssignment(boolean groupAssignment) {
        isGroupAssignment = groupAssignment;
    }
} 