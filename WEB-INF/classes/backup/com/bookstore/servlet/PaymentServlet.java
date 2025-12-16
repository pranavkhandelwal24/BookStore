package com.bookstore.servlet;

import com.bookstore.dao.OrderDAO;
import com.bookstore.model.Order;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

public class PaymentServlet extends HttpServlet {
    private OrderDAO orderDAO;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
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
        
        String orderIdStr = request.getParameter("orderId");
        
        if (orderIdStr != null && !orderIdStr.isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                Order order = orderDAO.getOrderById(orderId);
                
                if (order != null && order.getUserId() == userId) {
                    request.setAttribute("order", order);
                    request.getRequestDispatcher("/payment.jsp").forward(request, response);
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
        String orderIdStr = request.getParameter("orderId");
        
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID is required");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null || order.getUserId() != userId) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                return;
            }
            
            if ("process".equals(action)) {
                processPayment(request, response, order);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order ID");
        }
    }
    
    private void processPayment(HttpServletRequest request, HttpServletResponse response, Order order) 
            throws ServletException, IOException {
        
        String paymentMethod = request.getParameter("paymentMethod");
        String upiId = request.getParameter("upiId");
        String upiPin = request.getParameter("upiPin");
        
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            request.setAttribute("error", "Payment method is required");
            request.setAttribute("order", order);
            request.getRequestDispatcher("/payment.jsp").forward(request, response);
            return;
        }
        
        // Simulate UPI payment processing
        if ("UPI".equals(paymentMethod)) {
            if (upiId == null || upiId.trim().isEmpty() || upiPin == null || upiPin.trim().isEmpty()) {
                request.setAttribute("error", "UPI ID and PIN are required for UPI payment");
                request.setAttribute("order", order);
                request.getRequestDispatcher("/payment.jsp").forward(request, response);
                return;
            }
            
            // Simulate payment processing (in real implementation, integrate with actual UPI gateway)
            boolean paymentSuccess = simulateUPIPayment(upiId, upiPin, order.getTotalAmount());
            
            if (paymentSuccess) {
                // Update order status
                orderDAO.updatePaymentStatus(order.getOrderId(), "completed");
                orderDAO.updateOrderStatus(order.getOrderId(), "confirmed");
                
                // Generate transaction ID
                String transactionId = generateTransactionId();
                
                request.setAttribute("success", true);
                request.setAttribute("transactionId", transactionId);
                request.setAttribute("order", order);
                request.getRequestDispatcher("/payment-success.jsp").forward(request, response);
            } else {
                orderDAO.updatePaymentStatus(order.getOrderId(), "failed");
                
                request.setAttribute("error", "Payment failed. Please check your UPI credentials and try again.");
                request.setAttribute("order", order);
                request.getRequestDispatcher("/payment.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Currently only UPI payment is supported");
            request.setAttribute("order", order);
            request.getRequestDispatcher("/payment.jsp").forward(request, response);
        }
    }
    
    private boolean simulateUPIPayment(String upiId, String upiPin, java.math.BigDecimal amount) {
        // Simulate UPI payment processing
        // In a real implementation, this would integrate with actual UPI payment gateway
        
        // Basic validation simulation
        if (upiId.contains("@") && upiPin.length() >= 4) {
            // Simulate 90% success rate
            Random random = new Random();
            return random.nextInt(10) < 9;
        }
        
        return false;
    }
    
    private String generateTransactionId() {
        // Generate a random transaction ID
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder sb = new StringBuilder();
        Random random = new Random();
        
        for (int i = 0; i < 12; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return "TXN" + sb.toString();
    }
}
