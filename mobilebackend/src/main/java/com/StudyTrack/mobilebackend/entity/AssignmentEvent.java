package com.StudyTrack.mobilebackend.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.time.LocalDateTime;

/**
 * AssignmentEvent entity representing assignment events in the academic calendar.
 * Demonstrates inheritance and polymorphism by extending CalendarEvent.
 */
@Entity
@DiscriminatorValue("ASSIGNMENT")
public class AssignmentEvent extends CalendarEvent {
    
    @NotBlank(message = "Subject is required for assignments")
    @Column(nullable = false)
    private String subject;
    
    @Column(name = "course_code")
    private String courseCode;
    
    @Column(name = "assignment_type")
    @Enumerated(EnumType.STRING)
    private AssignmentType assignmentType = AssignmentType.HOMEWORK;
    
    @Column(name = "total_points")
    private Integer totalPoints;
    
    @Column(name = "submission_method")
    private String submissionMethod;
    
    @Column(name = "is_group_assignment")
    private boolean isGroupAssignment = false;
    
    // Default constructor
    public AssignmentEvent() {
        super();
    }
    
    // Parameterized constructor
    public AssignmentEvent(String title, String description, LocalDateTime startTime, 
                          LocalDateTime endTime, String subject, String courseCode) {
        super(title, description, startTime, endTime);
        this.subject = subject;
        this.courseCode = courseCode;
    }
    
    // Implementation of abstract method - demonstrates polymorphism
    @Override
    public String getEventType() {
        return "ASSIGNMENT";
    }
    
    // Business methods specific to assignments
    public boolean isOverdue() {
        return LocalDateTime.now().isAfter(getEndTime()) && getStatus() == EventStatus.SCHEDULED;
    }
    
    public long getDaysUntilDue() {
        LocalDateTime now = LocalDateTime.now();
        if (now.isAfter(getEndTime())) {
            return 0;
        }
        return java.time.Duration.between(now, getEndTime()).toDays();
    }
    
    public String getAssignmentSummary() {
        return String.format("%s - %s (%s)", getSubject(), getTitle(), getCourseCode());
    }
    
    // Getters and Setters
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
    
    public AssignmentType getAssignmentType() {
        return assignmentType;
    }
    
    public void setAssignmentType(AssignmentType assignmentType) {
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
    
    @Override
    public String toString() {
        return "AssignmentEvent{" +
                "id=" + getId() +
                ", title='" + getTitle() + '\'' +
                ", subject='" + subject + '\'' +
                ", courseCode='" + courseCode + '\'' +
                ", assignmentType=" + assignmentType +
                ", startTime=" + getStartTime() +
                ", endTime=" + getEndTime() +
                '}';
    }
} 
 