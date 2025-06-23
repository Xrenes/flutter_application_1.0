package com.StudyTrack.mobilebackend.entity;

/**
 * Enum representing user roles in the academic calendar system.
 * Demonstrates enum usage in OOP for type safety and role-based access control.
 */
public enum UserRole {
    STUDENT("Student"),
    TEACHER("Teacher"),
    ADMIN("Administrator");
    
    private final String displayName;
    
    UserRole(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    public static UserRole fromDisplayName(String displayName) {
        for (UserRole role : values()) {
            if (role.displayName.equalsIgnoreCase(displayName)) {
                return role;
            }
        }
        throw new IllegalArgumentException("Unknown role: " + displayName);
    }
} 