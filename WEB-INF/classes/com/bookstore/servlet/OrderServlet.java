package com.bookstore.servlet;

import com.bookstore.dao.OrderDAO;
import com.bookstore.dao.CartDAO;
import com.bookstore.dao.BookDAO;
import com.bookstore.dao.UserDAO;
import com.bookstore.model.Order;
import com.bookstore.model.OrderItem;
import com.bookstore.model.CartItem;
import com.bookstore.model.Book;
import com.bookstore.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private CartDAO cartDAO;
    private BookDAO bookDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        cartDAO = new CartDAO();
        bookDAO = new BookDAO();
        userDAO = new UserDAO();
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
            action = "list";
        }
        
        switch (action) {
            case "list":
                listOrders(request, response, userId);
                break;
            case "view":
                viewOrder(request, response, userId);
                break;
            case "checkout":
                showCheckout(request, response, userId);
                break;
            default:
                listOrders(request, response, userId);
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
            case "place":
                placeOrder(request, response, userId);
                break;
            default:
                listOrders(request, response, userId);
                break;
        }
    }
    
    private void listOrders(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        
        List<Order> orders = orderDAO.getOrdersByUserId(userId);
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/orders.jsp").forward(request, response);
    }
    
    private void viewOrder(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        
        String orderIdStr = request.getParameter("id");
        
        if (orderIdStr != null && !orderIdStr.isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                Order order = orderDAO.getOrderById(orderId);
                
                if (order != null && order.getUserId() == userId) {
                    request.setAttribute("order", order);
                    request.getRequestDispatcher("/order-details.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order ID");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID is required");
        }
    }
    
    private void showCheckout(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        
        List<CartItem> cartItems = cartDAO.getCartItems(userId);
        
        if (cartItems.isEmpty()) {
            request.setAttribute("error", "Your cart is empty");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Calculate total
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cartItems) {
            total = total.add(item.getTotalPrice());
        }
        
        User user = userDAO.getUserById(userId);
        
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("total", total);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }
    
    private void placeOrder(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        
        String paymentMethod = request.getParameter("paymentMethod");
        String shippingAddress = request.getParameter("shippingAddress");
        String transactionId = request.getParameter("transactionId");
        String codCharges = request.getParameter("codCharges");
        
        // Debug logging
        System.out.println("DEBUG - Payment Method: " + paymentMethod);
        System.out.println("DEBUG - Transaction ID: " + transactionId);
        System.out.println("DEBUG - COD Charges: " + codCharges);
        
        if (paymentMethod == null || shippingAddress == null || 
            paymentMethod.trim().isEmpty() || shippingAddress.trim().isEmpty()) {
            request.setAttribute("error", "Payment method and shipping address are required");
            showCheckout(request, response, userId);
            return;
        }
        
        // Validate transaction ID for UPI payments
        if ("UPI".equals(paymentMethod) && (transactionId == null || transactionId.trim().isEmpty())) {
            request.setAttribute("error", "Transaction ID is required for UPI payments");
            showCheckout(request, response, userId);
            return;
        }
        
        try {
            List<CartItem> cartItems = cartDAO.getCartItems(userId);
            
            if (cartItems.isEmpty()) {
                request.setAttribute("error", "Your cart is empty");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
            
            // Calculate total and validate stock
            BigDecimal total = BigDecimal.ZERO;
            for (CartItem item : cartItems) {
                Book book = bookDAO.getBookById(item.getBookId());
                if (book == null || book.getStock() < item.getQuantity()) {
                    request.setAttribute("error", "Some items in your cart are no longer available");
                    showCheckout(request, response, userId);
                    return;
                }
                total = total.add(item.getTotalPrice());
            }
            
            // Add COD charges if applicable
            if ("COD".equals(paymentMethod) && codCharges != null) {
                try {
                    BigDecimal codAmount = new BigDecimal(codCharges);
                    total = total.add(codAmount);
                } catch (NumberFormatException e) {
                    // Default COD charges if parameter is invalid
                    total = total.add(new BigDecimal("20"));
                }
            }
            
            // Create order with transaction ID
            Order order;
            if ("UPI".equals(paymentMethod) && transactionId != null && !transactionId.trim().isEmpty()) {
                order = new Order(userId, total, paymentMethod, transactionId.trim(), shippingAddress);
            } else {
                order = new Order(userId, total, paymentMethod, shippingAddress);
            }
            
            int orderId = orderDAO.createOrder(order);
            
            if (orderId > 0) {
                // Add order items and update stock
                boolean success = true;
                for (CartItem item : cartItems) {
                    OrderItem orderItem = new OrderItem(orderId, item.getBookId(), 
                                                      item.getQuantity(), item.getBook().getFinalPrice());
                    
                    if (!orderDAO.addOrderItem(orderItem)) {
                        success = false;
                        break;
                    }
                    
                    // Update book stock
                    Book book = bookDAO.getBookById(item.getBookId());
                    int newStock = book.getStock() - item.getQuantity();
                    bookDAO.updateStock(item.getBookId(), newStock);
                }
                
                if (success) {
                    // Clear cart
                    cartDAO.clearCart(userId);
                    
                    // Get the complete order with items for display
                    Order completeOrder = orderDAO.getOrderById(orderId);
                    User user = userDAO.getUserById(userId);
                    
                    // Set attributes for order success page
                    request.setAttribute("order", completeOrder);
                    request.setAttribute("user", user);
                    
                    // Redirect to order success page
                    request.getRequestDispatcher("/order-success.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Failed to create order items");
                    showCheckout(request, response, userId);
                }
            } else {
                request.setAttribute("error", "Failed to create order");
                showCheckout(request, response, userId);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Order placement failed. Please try again.");
            showCheckout(request, response, userId);
        }
    }
}
