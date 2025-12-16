package com.bookstore.model;

import java.math.BigDecimal;

public class CartItem {
    private int cartItemId;
    private int userId;
    private int bookId;
    private int quantity;
    private Book book;
    
    // Default constructor
    public CartItem() {}
    
    // Constructor with parameters
    public CartItem(int userId, int bookId, int quantity) {
        this.userId = userId;
        this.bookId = bookId;
        this.quantity = quantity;
    }
    
    // Getters and Setters
    public int getCartItemId() { return cartItemId; }
    public void setCartItemId(int cartItemId) { this.cartItemId = cartItemId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public Book getBook() { return book; }
    public void setBook(Book book) { this.book = book; }
    
    public BigDecimal getTotalPrice() {
        if (book != null) {
            return book.getFinalPrice().multiply(BigDecimal.valueOf(quantity));
        }
        return BigDecimal.ZERO;
    }
}
