<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - Online Bookstore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .cart-item {
            border-bottom: 1px solid #dee2e6;
            padding: 1rem 0;
        }
        .cart-item:last-child {
            border-bottom: none;
        }
        .book-image {
            width: 80px;
            height: 100px;
            object-fit: cover;
        }
        .quantity-input {
            width: 80px;
        }
        .price-original {
            text-decoration: line-through;
            color: #6c757d;
        }
        .price-discount {
            color: #dc3545;
            font-weight: bold;
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
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/books">Books</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/cart">
                            <i class="fas fa-shopping-cart"></i> Cart
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/order">Orders</a>
                    </li>
                    <c:if test="${sessionScope.role == 'admin'}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin">Admin</a>
                        </li>
                    </c:if>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user"></i> ${sessionScope.username}
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h2><i class="fas fa-shopping-cart"></i> Shopping Cart</h2>
                <hr>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle"></i> ${error}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="text-center py-5">
                    <i class="fas fa-shopping-cart fa-3x text-muted mb-3"></i>
                    <h4>Your cart is empty</h4>
                    <p class="text-muted">Add some books to your cart to get started!</p>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-primary">
                        <i class="fas fa-book"></i> Browse Books
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header">
                                <h5><i class="fas fa-list"></i> Cart Items</h5>
                            </div>
                            <div class="card-body">
                                <c:set var="total" value="0" />
                                <c:forEach var="item" items="${cartItems}">
                                    <div class="cart-item">
                                        <div class="row align-items-center">
                                            <div class="col-md-2">
                                                <img src="${item.book.imageUrl}" class="img-fluid book-image rounded" alt="${item.book.title}">
                                            </div>
                                            <div class="col-md-4">
                                                <h6>${item.book.title}</h6>
                                                <p class="text-muted mb-1">by ${item.book.author}</p>
                                                <div>
                                                    <c:choose>
                                                        <c:when test="${item.book.hasDiscount()}">
                                                            <span class="price-original">₹${item.book.price}</span>
                                                            <span class="price-discount">₹${item.book.discountPrice}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="fw-bold">₹${item.book.price}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                                <form action="${pageContext.request.contextPath}/cart" method="post" class="d-inline">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="bookId" value="${item.bookId}">
                                                    <input type="number" name="quantity" value="${item.quantity}" 
                                                           min="1" max="${item.book.stock}" class="form-control quantity-input"
                                                           onchange="this.form.submit()">
                                                </form>
                                            </div>
                                            <div class="col-md-2">
                                                <strong>₹<fmt:formatNumber value="${item.totalPrice}" pattern="#,##0.00"/></strong>
                                            </div>
                                            <div class="col-md-2">
                                                <a href="${pageContext.request.contextPath}/cart?action=remove&bookId=${item.bookId}" 
                                                   class="btn btn-outline-danger btn-sm"
                                                   onclick="return confirm('Remove this item from cart?')">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    <c:set var="total" value="${total + item.totalPrice}" />
                                </c:forEach>
                            </div>
                        </div>

                        <div class="mt-3">
                            <a href="${pageContext.request.contextPath}/books" class="btn btn-outline-primary">
                                <i class="fas fa-arrow-left"></i> Continue Shopping
                            </a>
                            <form action="${pageContext.request.contextPath}/cart" method="post" class="d-inline">
                                <input type="hidden" name="action" value="clear">
                                <button type="submit" class="btn btn-outline-danger ms-2"
                                        onclick="return confirm('Clear all items from cart?')">
                                    <i class="fas fa-trash"></i> Clear Cart
                                </button>
                            </form>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-header">
                                <h5><i class="fas fa-calculator"></i> Order Summary</h5>
                            </div>
                            <div class="card-body">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Subtotal:</span>
                                    <span>₹<fmt:formatNumber value="${total}" pattern="#,##0.00"/></span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Shipping:</span>
                                    <span class="text-success">Free</span>
                                </div>
                                <hr>
                                <div class="d-flex justify-content-between mb-3">
                                    <strong>Total:</strong>
                                    <strong>₹<fmt:formatNumber value="${total}" pattern="#,##0.00"/></strong>
                                </div>
                                <a href="${pageContext.request.contextPath}/order?action=checkout" 
                                   class="btn btn-success btn-lg w-100">
                                    <i class="fas fa-credit-card"></i> Proceed to Checkout
                                </a>
                            </div>
                        </div>

                        <div class="card mt-3">
                            <div class="card-body">
                                <h6><i class="fas fa-shield-alt"></i> Secure Checkout</h6>
                                <p class="small text-muted mb-0">
                                    Your payment information is encrypted and secure. We support UPI payments for your convenience.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
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
</body>
</html>
