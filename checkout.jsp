<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Online Bookstore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .checkout-step {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1rem;
        }
        .book-image {
            width: 60px;
            height: 75px;
            object-fit: cover;
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
        <div class="row">
            <div class="col-12">
                <h2><i class="fas fa-credit-card"></i> Checkout</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/cart">Cart</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Checkout</li>
                    </ol>
                </nav>
                <hr>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle"></i> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/order" method="post">
            <input type="hidden" name="action" value="place">
            
            <div class="row">
                <div class="col-md-8">
                    <!-- Shipping Information -->
                    <div class="checkout-step">
                        <h4><i class="fas fa-shipping-fast"></i> Shipping Information</h4>
                        <div class="row">
                            <div class="col-md-6">
                                <label for="fullName" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="fullName" value="${user.fullName}" readonly>
                            </div>
                            <div class="col-md-6">
                                <label for="phone" class="form-label">Phone Number</label>
                                <input type="text" class="form-control" id="phone" value="${user.phone}" readonly>
                            </div>
                        </div>
                        <div class="mt-3">
                            <label for="shippingAddress" class="form-label">Shipping Address *</label>
                            <textarea class="form-control" id="shippingAddress" name="shippingAddress" 
                                      rows="3" required placeholder="Enter your complete shipping address">${user.address}</textarea>
                        </div>
                    </div>

                    <!-- Payment Method -->
                    <div class="checkout-step">
                        <h4><i class="fas fa-credit-card"></i> Payment Method</h4>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="upi" value="UPI" checked>
                            <label class="form-check-label" for="upi">
                                <i class="fas fa-mobile-alt"></i> UPI Payment
                                <small class="text-muted d-block">Pay securely using UPI (Google Pay, PhonePe, Paytm, etc.)</small>
                            </label>
                        </div>
                        <div class="form-check mt-2">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="cod" value="COD">
                            <label class="form-check-label" for="cod">
                                <i class="fas fa-money-bill-wave"></i> Cash on Delivery
                                <small class="text-muted d-block">Pay when your order is delivered (₹20 COD charges apply)</small>
                            </label>
                        </div>
                        
                        <!-- UPI QR Code Section (Hidden by default) -->
                        <div id="upiQrSection" class="mt-3" style="display: none;">
                            <div class="card">
                                <div class="card-body text-center">
                                    <h6><i class="fas fa-qrcode"></i> Scan QR Code to Pay</h6>
                                    <img src="${pageContext.request.contextPath}/qr.jpg" alt="UPI QR Code" 
                                         class="img-fluid" style="max-width: 200px; border: 2px solid #ddd; border-radius: 10px;">
                                    <p class="mt-2 mb-3"><small class="text-muted">Scan with any UPI app to complete payment</small></p>
                                    
                                    <!-- Transaction ID Form -->
                                    <div class="mt-3">
                                        <div class="alert alert-info">
                                            <i class="fas fa-info-circle"></i> After completing the payment, please enter your transaction ID below
                                        </div>
                                        <div class="mb-3">
                                            <label for="transactionId" class="form-label">
                                                <i class="fas fa-receipt"></i> Transaction ID *
                                            </label>
                                            <input type="text" class="form-control" id="transactionId" name="transactionId" 
                                                   required placeholder="Enter UPI transaction ID (e.g., 123456789012)" 
                                                   pattern="[A-Za-z0-9]{8,20}">
                                            <div class="form-text">Enter the transaction ID from your UPI payment confirmation</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <!-- Order Summary -->
                    <div class="card">
                        <div class="card-header">
                            <h5><i class="fas fa-receipt"></i> Order Summary</h5>
                        </div>
                        <div class="card-body">
                            <c:forEach var="item" items="${cartItems}">
                                <div class="d-flex align-items-center mb-3">
                                    <img src="${item.book.imageUrl}" class="book-image rounded me-3" alt="${item.book.title}">
                                    <div class="flex-grow-1">
                                        <h6 class="mb-1">${item.book.title}</h6>
                                        <small class="text-muted">Qty: ${item.quantity}</small>
                                    </div>
                                    <div class="text-end">
                                        <strong>₹<fmt:formatNumber value="${item.totalPrice}" pattern="#,##0.00"/></strong>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <hr>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Subtotal:</span>
                                <span>₹<fmt:formatNumber value="${total}" pattern="#,##0.00"/></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Shipping:</span>
                                <span class="text-success">Free</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2" id="codChargesRow" style="display: none;">
                                <span>COD Charges:</span>
                                <span class="text-warning">₹20.00</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Tax:</span>
                                <span>₹0.00</span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between mb-3">
                                <strong>Total:</strong>
                                <strong class="text-primary" id="totalAmount">₹<fmt:formatNumber value="${total}" pattern="#,##0.00"/></strong>
                            </div>
                            
                            <button type="button" id="placeOrderBtn" class="btn btn-success btn-lg w-100">
                                <i class="fas fa-lock"></i> Place Order
                            </button>
                        </div>
                    </div>

                    <!-- Security Info -->
                    <div class="card mt-3">
                        <div class="card-body">
                            <h6><i class="fas fa-shield-alt text-success"></i> Secure Checkout</h6>
                            <ul class="list-unstyled small mb-0">
                                <li><i class="fas fa-check text-success"></i> SSL Encrypted</li>
                                <li><i class="fas fa-check text-success"></i> Secure Payment Gateway</li>
                                <li><i class="fas fa-check text-success"></i> Money Back Guarantee</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </form>

        <div class="row mt-4">
            <div class="col-12">
                <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Cart
                </a>
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
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const upiRadio = document.getElementById('upi');
            const codRadio = document.getElementById('cod');
            const upiQrSection = document.getElementById('upiQrSection');
            const placeOrderBtn = document.getElementById('placeOrderBtn');
            const checkoutForm = document.querySelector('form[action*="/order"]');
            const codChargesRow = document.getElementById('codChargesRow');
            const totalAmount = document.getElementById('totalAmount');
            const baseTotal = parseFloat('${total}'); // Base total from server
            
            // Update total amount based on payment method
            function updateTotal() {
                const selectedPaymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
                let finalTotal = baseTotal;
                
                if (selectedPaymentMethod === 'COD') {
                    finalTotal = baseTotal + 20; // Add COD charges
                    codChargesRow.style.display = 'flex';
                } else {
                    codChargesRow.style.display = 'none';
                }
                
                totalAmount.textContent = '₹' + finalTotal.toFixed(2);
            }
            
            // Handle Place Order button click
            placeOrderBtn.addEventListener('click', function() {
                // Validate shipping address
                const shippingAddress = document.getElementById('shippingAddress').value.trim();
                if (!shippingAddress) {
                    alert('Please enter your shipping address');
                    document.getElementById('shippingAddress').focus();
                    return;
                }
                
                const selectedPaymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
                
                if (selectedPaymentMethod === 'UPI') {
                    // Show QR code for UPI payment
                    upiQrSection.style.display = 'block';
                    placeOrderBtn.innerHTML = '<i class="fas fa-qrcode"></i> Waiting for Payment...';
                    placeOrderBtn.disabled = true;
                    
                    // Scroll to QR code section
                    upiQrSection.scrollIntoView({ behavior: 'smooth' });
                    
                    // Change button to submit after transaction ID is entered
                    placeOrderBtn.innerHTML = '<i class="fas fa-check"></i> Complete Order';
                    placeOrderBtn.disabled = false;
                    
                    // Update button click handler for transaction ID validation
                    placeOrderBtn.onclick = function() {
                        const transactionId = document.getElementById('transactionId').value.trim();
                        if (!transactionId) {
                            alert('Please enter the transaction ID');
                            document.getElementById('transactionId').focus();
                            return;
                        }
                        if (transactionId.length < 8) {
                            alert('Transaction ID must be at least 8 characters long');
                            document.getElementById('transactionId').focus();
                            return;
                        }
                        
                        // Add transaction ID to form and submit
                        const hiddenTransactionId = document.createElement('input');
                        hiddenTransactionId.type = 'hidden';
                        hiddenTransactionId.name = 'transactionId';
                        hiddenTransactionId.value = transactionId;
                        checkoutForm.appendChild(hiddenTransactionId);
                        
                        checkoutForm.submit();
                    };
                } else if (selectedPaymentMethod === 'COD') {
                    // Add COD charges to form
                    const hiddenCodCharges = document.createElement('input');
                    hiddenCodCharges.type = 'hidden';
                    hiddenCodCharges.name = 'codCharges';
                    hiddenCodCharges.value = '20';
                    checkoutForm.appendChild(hiddenCodCharges);
                    
                    // For COD, directly submit the form
                    checkoutForm.submit();
                }
            });
            
            // Handle payment method changes
            upiRadio.addEventListener('change', function() {
                if (this.checked) {
                    upiQrSection.style.display = 'none';
                    resetPlaceOrderButton();
                    updateTotal();
                }
            });
            
            codRadio.addEventListener('change', function() {
                if (this.checked) {
                    upiQrSection.style.display = 'none';
                    resetPlaceOrderButton();
                    updateTotal();
                }
            });
            
            function resetPlaceOrderButton() {
                placeOrderBtn.innerHTML = '<i class="fas fa-lock"></i> Place Order';
                placeOrderBtn.disabled = false;
                placeOrderBtn.onclick = arguments.callee.caller; // Reset to original handler
            }
            
            // Initialize total on page load
            updateTotal();
        });
    </script>
</body>
</html>
