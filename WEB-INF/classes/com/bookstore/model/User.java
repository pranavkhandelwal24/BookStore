package com.bookstore.model;

import java.sql.Timestamp;

/**
 * User Model Class
 * 
 * This class represents a user entity in the Online Bookstore system.
 * It encapsulates all user-related data including personal information,
 * authentication credentials, and role-based access control.
 * 
 * The User class supports two types of users:
 * 1. Regular users (customers) - can browse, purchase books, manage cart
 * 2. Admin users - can manage books, view orders, manage users
 * 
 * Security Features:
 * - Passwords are stored as SHA-256 hashes, never in plain text
 * - Role-based access control for different user privileges
 * - Timestamps for audit trail and account management
 * 
 * @author Bookstore Development Team
 * @version 1.0
 * @since 2025-01-09
 */
public class User {
    
    // ============================================================================
    // PRIVATE FIELDS - User Data Properties
    // ============================================================================
    
    /**
     * Unique identifier for each user in the database
     * This is the primary key and auto-incremented by MySQL
     */
    private int userId;
    
    /**
     * Username for login authentication
     * Must be unique across all users in the system
     * Used for login along with password
     */
    private String username;
    
    /**
     * Email address of the user
     * Must be unique and used for communication and account recovery
     * Validated for proper email format
     */
    private String email;
    
    /**
     * SHA-256 hashed password for secure authentication
     * Never stores plain text passwords for security
     * Generated using SHA-256 algorithm with salt
     */
    private String password;
    
    /**
     * Full display name of the user
     * Used for personalization and order management
     * Can contain spaces and special characters
     */
    private String fullName;
    
    /**
     * Phone number for contact and delivery purposes
     * Optional field, can be null
     * Used for order delivery coordination
     */
    private String phone;
    
    /**
     * Shipping/billing address for order delivery
     * Optional field, can be null
     * Used as default shipping address for orders
     */
    private String address;
    
    /**
     * User role for access control
     * Possible values: "user" (customer), "admin" (administrator)
     * Determines what features and pages user can access
     */
    private String role;
    
    /**
     * Timestamp when the user account was created
     * Automatically set by database on account creation
     * Used for audit trail and account age tracking
     */
    private Timestamp createdAt;
    
    // ============================================================================
    // CONSTRUCTORS
    // ============================================================================
    
    /**
     * Default constructor
     * Initializes an empty User object
     */
    public User() {}
    
    /**
     * Constructor with parameters
     * Initializes a User object with provided data
     * 
     * @param username Username for login authentication
     * @param email Email address of the user
     * @param password SHA-256 hashed password for secure authentication
     * @param fullName Full display name of the user
     * @param address Shipping/billing address for order delivery
     * @param phone Phone number for contact and delivery purposes
     * @param role User role for access control
     */
    public User(String username, String email, String password, String fullName, 
                String address, String phone, String role) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.address = address;
        this.phone = phone;
        this.role = role;
    }
    
    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public boolean isAdmin() {
        return "admin".equals(role);
    }
}
