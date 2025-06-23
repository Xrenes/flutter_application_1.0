package com.StudyTrack.mobilebackend.entity;

/**
 * Enum representing status of calendar events.
 * Demonstrates enum usage in OOP for type safety and status management.
 */
public enum EventStatus {
    SCHEDULED("Scheduled"),
    IN_PROGRESS("In Progress"),
    COMPLETED("Completed"),
    CANCELLED("Cancelled"),
    POSTPONED("Postponed");
    
    private final String displayName;
    
    EventStatus(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    public boolean isActive() {
        return this == SCHEDULED || this == IN_PROGRESS;
    }
    
    public boolean isCompleted() {
        return this == COMPLETED;
    }
    
    public boolean isCancelled() {
        return this == CANCELLED || this == POSTPONED;
    }
} 