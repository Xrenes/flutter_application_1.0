package com.StudyTrack.mobilebackend.entity;

/**
 * Enum representing priority levels for calendar events.
 * Demonstrates enum usage in OOP for type safety and priority management.
 */
public enum EventPriority {
    LOW(1, "Low"),
    MEDIUM(2, "Medium"),
    HIGH(3, "High"),
    URGENT(4, "Urgent");
    
    private final int level;
    private final String displayName;
    
    EventPriority(int level, String displayName) {
        this.level = level;
        this.displayName = displayName;
    }
    
    public int getLevel() {
        return level;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    public boolean isHigherThan(EventPriority other) {
        return this.level > other.level;
    }
    
    public static EventPriority fromLevel(int level) {
        for (EventPriority priority : values()) {
            if (priority.level == level) {
                return priority;
            }
        }
        throw new IllegalArgumentException("Unknown priority level: " + level);
    }
} 