<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Successfully Placed - Online Bookstore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .success-container {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: black;
            border-radius: 20px;
            padding: 3rem;
            text-align: center;
            margin: 2rem 0;
            box-shadow: 0 10px 30px rgba(40, 167, 69, 0.3);
        }
        .success-icon {
            font-size: 5rem;
            margin-bottom: 1.5rem;
            animation: bounce 2s infinite;
        }
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-20px);
            }
            60% {
                transform: translateY(-10px);
            }
        }
        .order-card {
            background: #fff;
            border-radius: 15px;
            padding: 2rem;
            margin: 1rem 0;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .timeline {
            position: relative;
            padding-left: 2rem;
        }
        .timeline::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #dee2e6;
        }
        .timeline-item {
            position: relative;
            margin-bottom: 2rem;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -25px;
            top: 5px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #28a745;
        }
        .timeline-item.pending::before {
            background: #6c757d;
        }
        .book-item {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            background: white;
        }
        .book-image {
            width: 60px;
            height: 75px;
            object-fit: cover;
            border-radius: 5px;
        }
        .pulse {
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
            100% {
                transform: scale(1);
            }
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
            <div class="col-lg-10">
                <!-- Success Message -->
                <div class="success-container">
                    <div class="success-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h1 class="mb-3">Order Successfully Placed!</h1>
                    <p class="lead mb-3">Thank you for your order! We've received your request and are processing it.</p>
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <div class="bg-white bg-opacity-20 rounded-3 p-3 mb-3">
                                <h4 class="mb-2">Order #${order.orderId}</h4>
                                <p class="mb-1"><i class="fas fa-calendar"></i> Placed on: <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a"/></p>
                                <p class="mb-0"><i class="fas fa-rupee-sign"></i> Total Amount: ₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-8">
                        <!-- Order Details -->
                        <div class="order-card">
                            <h4 class="mb-4"><i class="fas fa-receipt text-primary"></i> Order Summary</h4>
                            
                            <!-- Order Items -->
                            <c:if test="${not empty order.orderItems}">
                                <h6 class="mb-3">Items Ordered (${order.orderItems.size()} items):</h6>
                                <c:forEach var="item" items="${order.orderItems}">
                                    <div class="book-item">
                                        <div class="row align-items-center">
                                            <div class="col-auto">
                                                <img src="${item.book.imageUrl}" class="book-image" alt="${item.book.title}">
                                            </div>
                                            <div class="col">
                                                <h6 class="mb-1">${item.book.title}</h6>
                                                <p class="text-muted mb-1">by ${item.book.author}</p>
                                                <small class="text-muted">Quantity: ${item.quantity}</small>
                                            </div>
                                            <div class="col-auto text-end">
                                                <div class="fw-bold">₹<fmt:formatNumber value="${item.price * item.quantity}" pattern="#,##0.00"/></div>
                                                <small class="text-muted">₹<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/> each</small>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>

                            <!-- Order Totals -->
                            <div class="border-top pt-3 mt-3">
                                <div class="row">
                                    <div class="col-6">
                                        <p class="mb-2"><strong>Payment Method:</strong></p>
                                        <p class="mb-2"><strong>Order Status:</strong></p>
                                        <p class="mb-0"><strong>Total Amount:</strong></p>
                                    </div>
                                    <div class="col-6 text-end">
                                        <p class="mb-2">
                                            <span class="badge bg-info">
                                                <i class="fas fa-${order.paymentMethod == 'UPI' ? 'mobile-alt' : 'truck'}"></i>
                                                ${order.paymentMethod}
                                            </span>
                                        </p>
                                        <p class="mb-2">
                                            <span class="badge bg-warning">
                                                <i class="fas fa-clock"></i> ${order.status}
                                            </span>
                                        </p>
                                        <p class="mb-0 h5 text-success">₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Shipping Information -->
                        <div class="order-card">
                            <h5 class="mb-3"><i class="fas fa-shipping-fast text-info"></i> Shipping Information</h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <p class="mb-2"><strong>Delivery Address:</strong></p>
                                    <div class="bg-light p-3 rounded">
                                        <p class="mb-1"><strong>${user.fullName}</strong></p>
                                        <p class="mb-1">${order.shippingAddress}</p>
                                        <p class="mb-0"><i class="fas fa-phone"></i> ${user.phone}</p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <p class="mb-2"><strong>Estimated Delivery:</strong></p>
                                    <div class="bg-light p-3 rounded">
                                        <p class="mb-1"><i class="fas fa-calendar-alt"></i> 3-5 Business Days</p>
                                        <p class="mb-1"><i class="fas fa-truck"></i> Standard Delivery</p>
                                        <p class="mb-0 text-success"><i class="fas fa-check"></i> Free Shipping</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <!-- Order Status Timeline -->
                        <div class="order-card">
                            <h5 class="mb-4"><i class="fas fa-list-ol text-success"></i> Order Progress</h5>
                            <div class="timeline">
                                <div class="timeline-item">
                                    <h6 class="mb-1">Order Placed</h6>
                                    <p class="text-muted small mb-0">
                                        <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a"/>
                                    </p>
                                    <p class="text-success small"><i class="fas fa-check"></i> Completed</p>
                                </div>
                                <div class="timeline-item pending">
                                    <h6 class="mb-1">Payment Processing</h6>
                                    <p class="text-muted small mb-0">Waiting for payment confirmation</p>
                                    <p class="text-warning small"><i class="fas fa-clock"></i> In Progress</p>
                                </div>
                                <div class="timeline-item pending">
                                    <h6 class="mb-1">Order Confirmed</h6>
                                    <p class="text-muted small mb-0">After payment verification</p>
                                    <p class="text-muted small"><i class="fas fa-hourglass-half"></i> Pending</p>
                                </div>
                                <div class="timeline-item pending">
                                    <h6 class="mb-1">Shipped</h6>
                                    <p class="text-muted small mb-0">Order dispatched</p>
                                    <p class="text-muted small"><i class="fas fa-hourglass-half"></i> Pending</p>
                                </div>
                                <div class="timeline-item pending">
                                    <h6 class="mb-1">Delivered</h6>
                                    <p class="text-muted small mb-0">Order delivered to you</p>
                                    <p class="text-muted small"><i class="fas fa-hourglass-half"></i> Pending</p>
                                </div>
                            </div>
                        </div>

                        <!-- Next Steps -->
                        <div class="order-card">
                            <h5 class="mb-3"><i class="fas fa-arrow-right text-primary"></i> What's Next?</h5>
                            <c:choose>
                                <c:when test="${order.paymentMethod == 'UPI'}">
                                    <div class="alert alert-info">
                                        <h6><i class="fas fa-mobile-alt"></i> Complete Payment</h6>
                                        <p class="mb-2 small">Complete your UPI payment to confirm your order.</p>
                                        <a href="${pageContext.request.contextPath}/payment?orderId=${order.orderId}" 
                                           class="btn btn-primary btn-sm pulse">
                                            <i class="fas fa-credit-card"></i> Pay Now
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-success">
                                        <h6><i class="fas fa-truck"></i> Cash on Delivery</h6>
                                        <p class="mb-2 small">Your order will be delivered within 3-5 business days. Keep ₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/> ready for payment.</p>
                                        <p class="mb-0 small"><strong>COD charges included in total amount</strong></p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="text-center mt-4 mb-4">
                    <div class="btn-group" role="group">
                        <c:if test="${order.paymentMethod == 'UPI'}">
                            <a href="${pageContext.request.contextPath}/payment?orderId=${order.orderId}" 
                               class="btn btn-success btn-lg me-2">
                                <i class="fas fa-credit-card"></i> Complete Payment
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/order" class="btn btn-primary btn-lg me-2">
                            <i class="fas fa-list"></i> View All Orders
                        </a>
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-outline-primary btn-lg">
                            <i class="fas fa-book"></i> Continue Shopping
                        </a>
                    </div>
                </div>

                <!-- Important Notes -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="alert alert-info">
                            <h6><i class="fas fa-envelope"></i> Email Confirmation</h6>
                            <p class="mb-0 small">Order confirmation has been sent to your registered email address.</p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <c:choose>
                            <c:when test="${order.paymentMethod == 'UPI'}">
                                <div class="alert alert-warning">
                                    <h6><i class="fas fa-exclamation-triangle"></i> Important</h6>
                                    <p class="mb-0 small">Please complete payment within 24 hours to avoid order cancellation.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-success">
                                    <h6><i class="fas fa-check-circle"></i> COD Order Confirmed</h6>
                                    <p class="mb-0 small">Your order is confirmed! No online payment required. Pay when delivered.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4 mt-5">
        <div class="container">
            <div class="text-center">
                <p>&copy; 2025 Online Bookstore. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Celebration Animation -->
    <script>
        // Create floating particles
        function createCelebration() {
            const particles = ['🎉', '🎊', '📚', '✨', '🎈'];
            for (let i = 0; i < 30; i++) {
                const particle = document.createElement('div');
                particle.innerHTML = particles[Math.floor(Math.random() * particles.length)];
                particle.style.position = 'fixed';
                particle.style.left = Math.random() * 100 + 'vw';
                particle.style.top = '-50px';
                particle.style.fontSize = '2rem';
                particle.style.pointerEvents = 'none';
                particle.style.zIndex = '9999';
                particle.style.animation = `celebrate ${Math.random() * 3 + 2}s linear forwards`;
                
                document.body.appendChild(particle);
                
                setTimeout(() => {
                    particle.remove();
                }, 5000);
            }
        }
        
        // Add CSS for celebration animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes celebrate {
                to {
                    transform: translateY(100vh) rotate(720deg);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
        
        // Trigger celebration on page load
        window.addEventListener('load', () => {
            setTimeout(createCelebration, 500);
        });

        // Payment reminder for UPI orders
        const paymentMethod = '${order.paymentMethod}';
        if (paymentMethod === 'UPI') {
            setTimeout(function() {
                const payButton = document.querySelector('a[href*="/payment"]');
                if (payButton && !payButton.classList.contains('clicked')) {
                    payButton.style.animation = 'pulse 1s infinite';
                    payButton.title = 'Click to complete your payment';
                }
            }, 5000);
        }
    </script>
</body>
</html>
