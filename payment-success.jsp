<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Successful - Online Bookstore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .success-container {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border-radius: 15px;
            padding: 3rem;
            text-align: center;
            margin: 2rem 0;
        }
        .success-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }
        .order-details {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 2rem;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-book"></i> BookStore
            </a>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text">
                    <i class="fas fa-user"></i> ${sessionScope.username}
                </span>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <!-- Success Message -->
                <div class="success-container">
                    <div class="success-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h1>Payment Successful!</h1>
                    <p class="lead">Thank you for your purchase. Your order has been confirmed.</p>
                    <p>Transaction ID: <strong>${transactionId}</strong></p>
                </div>

                <!-- Order Details -->
                <div class="order-details">
                    <h4><i class="fas fa-receipt"></i> Order Details</h4>
                    <hr>
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Order ID:</strong> #${order.orderId}</p>
                            <p><strong>Order Date:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a"/></p>
                            <p><strong>Payment Method:</strong> ${order.paymentMethod}</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Total Amount:</strong> ₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></p>
                            <p><strong>Payment Status:</strong> <span class="badge bg-success">Completed</span></p>
                            <p><strong>Order Status:</strong> <span class="badge bg-info">Confirmed</span></p>
                        </div>
                    </div>
                </div>

                <!-- What's Next -->
                <div class="card mt-4">
                    <div class="card-header">
                        <h5><i class="fas fa-info-circle"></i> What's Next?</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4 text-center mb-3">
                                <i class="fas fa-box fa-2x text-primary mb-2"></i>
                                <h6>Order Processing</h6>
                                <p class="small text-muted">Your order is being prepared for shipment</p>
                            </div>
                            <div class="col-md-4 text-center mb-3">
                                <i class="fas fa-shipping-fast fa-2x text-info mb-2"></i>
                                <h6>Shipping</h6>
                                <p class="small text-muted">We'll notify you when your order ships</p>
                            </div>
                            <div class="col-md-4 text-center mb-3">
                                <i class="fas fa-home fa-2x text-success mb-2"></i>
                                <h6>Delivery</h6>
                                <p class="small text-muted">Your books will be delivered to your address</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/order" class="btn btn-primary btn-lg me-3">
                        <i class="fas fa-list"></i> View My Orders
                    </a>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-outline-primary btn-lg">
                        <i class="fas fa-book"></i> Continue Shopping
                    </a>
                </div>

                <!-- Email Confirmation Notice -->
                <div class="alert alert-info mt-4">
                    <i class="fas fa-envelope"></i>
                    <strong>Email Confirmation:</strong> 
                    A confirmation email with order details has been sent to your registered email address.
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4 mt-5">
        <div class="container">
            <div class="text-center">
                <p>&copy; 2024 Online Bookstore. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Confetti Animation -->
    <script>
        // Simple confetti effect
        function createConfetti() {
            const colors = ['#ff6b6b', '#4ecdc4', '#45b7d1', '#96ceb4', '#feca57'];
            for (let i = 0; i < 50; i++) {
                const confetti = document.createElement('div');
                confetti.style.position = 'fixed';
                confetti.style.left = Math.random() * 100 + 'vw';
                confetti.style.top = '-10px';
                confetti.style.width = '10px';
                confetti.style.height = '10px';
                confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.borderRadius = '50%';
                confetti.style.pointerEvents = 'none';
                confetti.style.zIndex = '9999';
                confetti.style.animation = `fall ${Math.random() * 3 + 2}s linear forwards`;
                
                document.body.appendChild(confetti);
                
                setTimeout(() => {
                    confetti.remove();
                }, 5000);
            }
        }
        
        // Add CSS for falling animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes fall {
                to {
                    transform: translateY(100vh) rotate(360deg);
                }
            }
        `;
        document.head.appendChild(style);
        
        // Trigger confetti on page load
        window.addEventListener('load', createConfetti);
    </script>
</body>
</html>
