package com.bookstore.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Book {
    private int bookId;
    private String title;
    private String author;
    private String isbn;
    private String description;
    private BigDecimal price;
    private BigDecimal discountPrice;
    private int stock;
    private String category;
    private String imageUrl;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Default constructor
    public Book() {}
    
    // Constructor with parameters
    public Book(String title, String author, String isbn, String description, 
                BigDecimal price, int stock, String category, String imageUrl) {
        this.title = title;
        this.author = author;
        this.isbn = isbn;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.category = category;
        this.imageUrl = imageUrl;
    }
    
    // Getters and Setters
    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    
    public BigDecimal getDiscountPrice() { return discountPrice; }
    public void setDiscountPrice(BigDecimal discountPrice) { this.discountPrice = discountPrice; }
    
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public BigDecimal getFinalPrice() {
        return discountPrice != null ? discountPrice : price;
    }
    
    public boolean hasDiscount() {
        return discountPrice != null && discountPrice.compareTo(price) < 0;
    }
}
