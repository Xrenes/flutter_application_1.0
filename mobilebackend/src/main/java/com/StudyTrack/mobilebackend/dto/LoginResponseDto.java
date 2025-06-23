package com.StudyTrack.mobilebackend.dto;

import com.StudyTrack.mobilebackend.entity.UserRole;

public class LoginResponseDto {
    private String token;
    private String username;
    private String email;
    private String fullName;
    private UserRole role;
    private Long userId;
    
    public LoginResponseDto() {}
    
    public LoginResponseDto(String token, String username, String email, String fullName, UserRole role, Long userId) {
        this.token = token;
        this.username = username;
        this.email = email;
        this.fullName = fullName;
        this.role = role;
        this.userId = userId;
    }
    
    public String getToken() {
        return token;
    }
    
    public void setToken(String token) {
        this.token = token;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public UserRole getRole() {
        return role;
    }
    
    public void setRole(UserRole role) {
        this.role = role;
    }
    
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
} 