package com.bookstore.dao;

import com.bookstore.model.CartItem;
import com.bookstore.model.Book;
import com.bookstore.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    
    public boolean addToCart(CartItem cartItem) {
        // First check if item already exists in cart
        String checkSql = "SELECT quantity FROM cart WHERE user_id = ? AND book_id = ?";
        String insertSql = "INSERT INTO cart (user_id, book_id, quantity) VALUES (?, ?, ?)";
        String updateSql = "UPDATE cart SET quantity = quantity + ? WHERE user_id = ? AND book_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, cartItem.getUserId());
            checkStmt.setInt(2, cartItem.getBookId());
            
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                // Item exists, update quantity
                PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setInt(1, cartItem.getQuantity());
                updateStmt.setInt(2, cartItem.getUserId());
                updateStmt.setInt(3, cartItem.getBookId());
                return updateStmt.executeUpdate() > 0;
            } else {
                // Item doesn't exist, insert new
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setInt(1, cartItem.getUserId());
                insertStmt.setInt(2, cartItem.getBookId());
                insertStmt.setInt(3, cartItem.getQuantity());
                return insertStmt.executeUpdate() > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateCartItem(int userId, int bookId, int quantity) {
        String sql = "UPDATE cart SET quantity = ? WHERE user_id = ? AND book_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, quantity);
            stmt.setInt(2, userId);
            stmt.setInt(3, bookId);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean removeFromCart(int userId, int bookId) {
        String sql = "DELETE FROM cart WHERE user_id = ? AND book_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<CartItem> getCartItems(int userId) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT c.*, b.* FROM cart c JOIN books b ON c.book_id = b.book_id WHERE c.user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                CartItem cartItem = new CartItem();
                cartItem.setCartItemId(rs.getInt("cart_id"));
                cartItem.setUserId(rs.getInt("user_id"));
                cartItem.setBookId(rs.getInt("book_id"));
                cartItem.setQuantity(rs.getInt("quantity"));
                
                // Map book details
                Book book = new Book();
                book.setBookId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setPrice(rs.getBigDecimal("price"));
                book.setDiscountPrice(rs.getBigDecimal("discount_price"));
                book.setImageUrl(rs.getString("image_url"));
                book.setStock(rs.getInt("stock"));
                
                cartItem.setBook(book);
                cartItems.add(cartItem);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItems;
    }
    
    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            return stmt.executeUpdate() >= 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int getCartItemCount(int userId) {
        String sql = "SELECT SUM(quantity) FROM cart WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
