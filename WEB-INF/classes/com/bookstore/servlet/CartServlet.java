package com.bookstore.servlet;

import com.bookstore.dao.CartDAO;
import com.bookstore.dao.BookDAO;
import com.bookstore.model.CartItem;
import com.bookstore.model.Book;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class CartServlet extends HttpServlet {
    private CartDAO cartDAO;
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        bookDAO = new BookDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "view";
        }
        
        switch (action) {
            case "view":
                viewCart(request, response, userId);
                break;
            case "remove":
                removeFromCart(request, response, userId);
                break;
            default:
                viewCart(request, response, userId);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "add":
                addToCart(request, response, userId);
                break;
            case "update":
                updateCart(request, response, userId);
                break;
            case "clear":
                clearCart(request, response, userId);
                break;
            default:
                viewCart(request, response, userId);
                break;
        }
    }
    
    private void viewCart(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        
        List<CartItem> cartItems = cartDAO.getCartItems(userId);
        request.setAttribute("cartItems", cartItems);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }
    
    private void addToCart(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        
        String bookIdStr = request.getParameter("bookId");
        String quantityStr = request.getParameter("quantity");
        
        if (bookIdStr != null && quantityStr != null) {
            try {
                int bookId = Integer.parseInt(bookIdStr);
                int quantity = Integer.parseInt(quantityStr);
                
                // Check if book exists and has sufficient stock
                Book book = bookDAO.getBookById(bookId);
                if (book == null) {
                    request.setAttribute("error", "Book not found");
                    response.sendRedirect(request.getContextPath() + "/books");
                    return;
                }
                
                if (book.getStock() < quantity) {
                    request.setAttribute("error", "Insufficient stock available");
                    response.sendRedirect(request.getContextPath() + "/books?action=view&id=" + bookId);
                    return;
                }
                
                CartItem cartItem = new CartItem(userId, bookId, quantity);
                
                if (cartDAO.addToCart(cartItem)) {
                    response.sendRedirect(request.getContextPath() + "/cart");
                } else {
                    request.setAttribute("error", "Failed to add item to cart");
                    response.sendRedirect(request.getContextPath() + "/books?action=view&id=" + bookId);
                }
                
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid input");
                response.sendRedirect(request.getContextPath() + "/books");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/books");
        }
    }
    
    private void updateCart(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        
        String bookIdStr = request.getParameter("bookId");
        String quantityStr = request.getParameter("quantity");
        
        if (bookIdStr != null && quantityStr != null) {
            try {
                int bookId = Integer.parseInt(bookIdStr);
                int quantity = Integer.parseInt(quantityStr);
                
                if (quantity <= 0) {
                    cartDAO.removeFromCart(userId, bookId);
                } else {
                    // Check stock availability
                    Book book = bookDAO.getBookById(bookId);
                    if (book != null && book.getStock() >= quantity) {
                        cartDAO.updateCartItem(userId, bookId, quantity);
                    } else {
                        request.setAttribute("error", "Insufficient stock available");
                    }
                }
                
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid input");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/cart");
    }
    
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        
        String bookIdStr = request.getParameter("bookId");
        
        if (bookIdStr != null) {
            try {
                int bookId = Integer.parseInt(bookIdStr);
                cartDAO.removeFromCart(userId, bookId);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid book ID");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/cart");
    }
    
    private void clearCart(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        
        cartDAO.clearCart(userId);
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
