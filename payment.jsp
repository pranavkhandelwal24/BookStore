<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - Online Bookstore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .payment-container {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 2rem;
        }
        .upi-logos {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin: 1rem 0;
        }
        .upi-logo {
            width: 60px;
            height: 40px;
            background: white;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #dee2e6;
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
                <div class="payment-container">
                    <div class="text-center mb-4">
                        <h2><i class="fas fa-credit-card"></i> Complete Payment</h2>
                        <p class="text-muted">Order #${order.orderId}</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                            <i class="fas fa-exclamation-triangle"></i> ${error}
                        </div>
                    </c:if>

                    <!-- Order Summary -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5><i class="fas fa-receipt"></i> Order Summary</h5>
                        </div>
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-2">
                                <span>Order Total:</span>
                                <strong>₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></strong>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Payment Method:</span>
                                <span>${order.paymentMethod}</span>
                            </div>
                            <div class="d-flex justify-content-between">
                                <span>Status:</span>
                                <span class="badge bg-warning">${order.paymentStatus}</span>
                            </div>
                        </div>
                    </div>

                    <!-- UPI Payment Form -->
                    <div class="card">
                        <div class="card-header">
                            <h5><i class="fas fa-mobile-alt"></i> UPI Payment</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="text-center mb-3">
                                        <p>Scan QR Code to Pay</p>
                                        <img src="${pageContext.request.contextPath}/qr.jpg" alt="UPI QR Code" class="img-fluid" style="max-width: 200px; border: 2px solid #ddd; border-radius: 10px;">
                                        <p class="mt-2"><small class="text-muted">Scan with any UPI app</small></p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="text-center mb-3">
                                        <p>Or pay using your UPI ID</p>
                                        <div class="upi-logos">
                                            <div class="upi-logo">
                                                <small><strong>GPay</strong></small>
                                            </div>
                                            <div class="upi-logo">
                                                <small><strong>PhonePe</strong></small>
                                            </div>
                                            <div class="upi-logo">
                                                <small><strong>Paytm</strong></small>
                                            </div>
                                            <div class="upi-logo">
                                                <small><strong>BHIM</strong></small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <form action="${pageContext.request.contextPath}/payment" method="post">
                                <input type="hidden" name="action" value="process">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <input type="hidden" name="paymentMethod" value="UPI">

                                <div class="mb-3">
                                    <label for="upiId" class="form-label">
                                        <i class="fas fa-at"></i> UPI ID *
                                    </label>
                                    <input type="text" class="form-control" id="upiId" name="upiId" 
                                           required placeholder="yourname@paytm / yourname@oksbi" 
                                           pattern="[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+">
                                    <div class="form-text">Enter your UPI ID (e.g., 9876543210@paytm)</div>
                                </div>

                                <div class="mb-4">
                                    <label for="upiPin" class="form-label">
                                        <i class="fas fa-lock"></i> UPI PIN *
                                    </label>
                                    <input type="password" class="form-control" id="upiPin" name="upiPin" 
                                           required placeholder="Enter your 4-6 digit UPI PIN" 
                                           pattern="[0-9]{4,6}" maxlength="6">
                                    <div class="form-text">Enter your UPI PIN to authorize payment</div>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-success btn-lg">
                                        <i class="fas fa-lock"></i> Pay ₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/>
                                    </button>
                                    <a href="${pageContext.request.contextPath}/order" class="btn btn-outline-secondary">
                                        <i class="fas fa-arrow-left"></i> Back to Orders
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Cash on Delivery Payment Option -->
                    <div class="card mt-4">
                        <div class="card-header">
                            <h5><i class="fas fa-truck"></i> Cash on Delivery (COD)</h5>
                        </div>
                        <div class="card-body">
                            <div class="text-center mb-3">
                                <i class="fas fa-hand-holding-usd fa-3x text-success mb-3"></i>
                                <p>Pay when your order is delivered to your doorstep</p>
                                <div class="alert alert-success">
                                    <h6><i class="fas fa-check-circle"></i> Benefits of COD:</h6>
                                    <ul class="mb-0 text-start">
                                        <li>No online payment required</li>
                                        <li>Pay only when you receive your books</li>
                                        <li>Cash payment to delivery person</li>
                                        <li>100% secure and trusted</li>
                                    </ul>
                                </div>
                            </div>

                            <form action="${pageContext.request.contextPath}/payment" method="post">
                                <input type="hidden" name="action" value="process">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <input type="hidden" name="paymentMethod" value="COD">
                                <input type="hidden" name="upiId" value="cod@bookstore">
                                <input type="hidden" name="upiPin" value="0000">

                                <div class="alert alert-warning">
                                    <h6><i class="fas fa-info-circle"></i> COD Terms:</h6>
                                    <ul class="mb-0 small">
                                        <li>COD charges: ₹20 (included in total amount)</li>
                                        <li>Payment must be made in exact cash</li>
                                        <li>Order will be delivered within 3-5 business days</li>
                                        <li>Please keep the exact amount ready</li>
                                    </ul>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-warning btn-lg">
                                        <i class="fas fa-truck"></i> Place COD Order - ₹<fmt:formatNumber value="${order.totalAmount + 20}" pattern="#,##0.00"/>
                                    </button>
                                    <small class="text-muted text-center">
                                        Total: ₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/> + ₹20 COD charges
                                    </small>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Security Notice -->
                    <div class="alert alert-info mt-4">
                        <h6><i class="fas fa-shield-alt"></i> Security Notice</h6>
                        <ul class="mb-0 small">
                            <li>This is a demo payment system for educational purposes</li>
                            <li>No real money will be charged</li>
                            <li>Use any valid UPI ID format and 4-6 digit PIN</li>
                            <li>Payment success rate is simulated at 90%</li>
                        </ul>
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
    <script>
        // Auto-format UPI ID
        document.getElementById('upiId').addEventListener('input', function(e) {
            let value = e.target.value.toLowerCase();
            // Remove any spaces
            value = value.replace(/\s/g, '');
            e.target.value = value;
        });

        // UPI PIN validation
        document.getElementById('upiPin').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, ''); // Only digits
            e.target.value = value;
        });
    </script>
</body>
</html>
