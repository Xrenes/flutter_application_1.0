package com.StudyTrack.mobilebackend.entity;

/**
 * Enum representing different types of assignments.
 * Demonstrates enum usage in OOP for type safety and assignment categorization.
 */
public enum AssignmentType {
    HOMEWORK("Homework"),
    QUIZ("Quiz"),
    EXAM("Exam"),
    PROJECT("Project"),
    PRESENTATION("Presentation"),
    LAB_REPORT("Lab Report"),
    RESEARCH_PAPER("Research Paper"),
    ESSAY("Essay"),
    DISCUSSION("Discussion"),
    PARTICIPATION("Participation");
    
    private final String displayName;
    
    AssignmentType(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    public boolean isMajorAssessment() {
        return this == EXAM || this == PROJECT || this == RESEARCH_PAPER;
    }
    
    public boolean isMinorAssessment() {
        return this == HOMEWORK || this == QUIZ || this == PARTICIPATION;
    }
} 