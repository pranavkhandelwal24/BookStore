package com.bookstore.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class Order {
    private int orderId;
    private int userId;
    private BigDecimal totalAmount;
    private String status; // "pending", "confirmed", "shipped", "delivered", "cancelled"
    private String paymentMethod;
    private String paymentStatus; // "pending", "completed", "failed"
    private String transactionId;
    private String shippingAddress;
    private Timestamp orderDate;
    private Timestamp updatedAt;
    private List<OrderItem> orderItems;
    private User user;
    
    // Default constructor
    public Order() {}
    
    // Constructor with parameters
    public Order(int userId, BigDecimal totalAmount, String paymentMethod, String shippingAddress) {
        this.userId = userId;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.shippingAddress = shippingAddress;
        this.status = "pending";
        this.paymentStatus = "pending";
    }
    
    // Constructor with transaction ID
    public Order(int userId, BigDecimal totalAmount, String paymentMethod, String transactionId, String shippingAddress) {
        this.userId = userId;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.transactionId = transactionId;
        this.shippingAddress = shippingAddress;
        this.status = "pending";
        this.paymentStatus = "pending";
    }
    
    // Getters and Setters
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    
    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }
    
    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }
    
    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public List<OrderItem> getOrderItems() { return orderItems; }
    public void setOrderItems(List<OrderItem> orderItems) { this.orderItems = orderItems; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}
