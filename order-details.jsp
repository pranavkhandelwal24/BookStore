<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details - Online Bookstore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .order-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
            padding: 2rem;
            margin-bottom: 2rem;
        }
        .book-image {
            width: 80px;
            height: 100px;
            object-fit: cover;
        }
        .status-timeline {
            position: relative;
            padding-left: 2rem;
        }
        .status-timeline::before {
            content: '';
            position: absolute;
            left: 0.5rem;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #dee2e6;
        }
        .timeline-item {
            position: relative;
            margin-bottom: 1.5rem;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -0.5rem;
            top: 0.5rem;
            width: 1rem;
            height: 1rem;
            border-radius: 50%;
            background: #6c757d;
        }
        .timeline-item.active::before {
            background: #28a745;
        }
        .timeline-item.current::before {
            background: #007bff;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart">
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
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/order">Orders</a></li>
                <li class="breadcrumb-item active" aria-current="page">Order #${order.orderId}</li>
            </ol>
        </nav>

        <!-- Order Header -->
        <div class="order-header">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h2><i class="fas fa-receipt"></i> Order #${order.orderId}</h2>
                    <p class="mb-0">Placed on <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a"/></p>
                </div>
                <div class="col-md-6 text-md-end">
                    <h3>₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></h3>
                    <span class="badge fs-6
                        <c:choose>
                            <c:when test="${order.status == 'pending'}">bg-warning</c:when>
                            <c:when test="${order.status == 'confirmed'}">bg-info</c:when>
                            <c:when test="${order.status == 'shipped'}">bg-primary</c:when>
                            <c:when test="${order.status == 'delivered'}">bg-success</c:when>
                            <c:when test="${order.status == 'cancelled'}">bg-danger</c:when>
                            <c:otherwise>bg-secondary</c:otherwise>
                        </c:choose>">
                        ${order.status.toUpperCase()}
                    </span>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8">
                <!-- Order Items -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5><i class="fas fa-box"></i> Order Items</h5>
                    </div>
                    <div class="card-body">
                        <c:forEach var="item" items="${order.orderItems}">
                            <div class="row align-items-center mb-3 pb-3 border-bottom">
                                <div class="col-md-2">
                                    <img src="${item.book.imageUrl}" class="img-fluid book-image rounded" alt="${item.book.title}">
                                </div>
                                <div class="col-md-6">
                                    <h6>${item.book.title}</h6>
                                    <p class="text-muted mb-1">by ${item.book.author}</p>
                                    <small class="text-muted">Quantity: ${item.quantity}</small>
                                </div>
                                <div class="col-md-2">
                                    <strong>₹<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></strong>
                                    <small class="text-muted d-block">per item</small>
                                </div>
                                <div class="col-md-2 text-end">
                                    <strong>₹<fmt:formatNumber value="${item.totalPrice}" pattern="#,##0.00"/></strong>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Shipping Address -->
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-map-marker-alt"></i> Shipping Address</h5>
                    </div>
                    <div class="card-body">
                        <p class="mb-0">${order.shippingAddress}</p>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <!-- Order Summary -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5><i class="fas fa-calculator"></i> Order Summary</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-2">
                            <span>Subtotal:</span>
                            <span>₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Shipping:</span>
                            <span class="text-success">Free</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Tax:</span>
                            <span>₹0.00</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between">
                            <strong>Total:</strong>
                            <strong>₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></strong>
                        </div>
                    </div>
                </div>

                <!-- Payment Information -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5><i class="fas fa-credit-card"></i> Payment Information</h5>
                    </div>
                    <div class="card-body">
                        <p><strong>Method:</strong> ${order.paymentMethod}</p>
                        <p><strong>Status:</strong> 
                            <span class="badge 
                                <c:choose>
                                    <c:when test="${order.paymentStatus == 'completed'}">bg-success</c:when>
                                    <c:when test="${order.paymentStatus == 'pending'}">bg-warning</c:when>
                                    <c:when test="${order.paymentStatus == 'failed'}">bg-danger</c:when>
                                    <c:otherwise>bg-secondary</c:otherwise>
                                </c:choose>">
                                ${order.paymentStatus.toUpperCase()}
                            </span>
                        </p>
                    </div>
                </div>

                <!-- Order Status Timeline -->
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-truck"></i> Order Status</h5>
                    </div>
                    <div class="card-body">
                        <div class="status-timeline">
                            <div class="timeline-item ${order.status == 'pending' || order.status == 'confirmed' || order.status == 'shipped' || order.status == 'delivered' ? 'active' : ''}">
                                <strong>Order Placed</strong>
                                <br>
                                <small class="text-muted">
                                    <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a"/>
                                </small>
                            </div>
                            <div class="timeline-item ${order.status == 'confirmed' || order.status == 'shipped' || order.status == 'delivered' ? 'active' : ''} ${order.status == 'confirmed' ? 'current' : ''}">
                                <strong>Order Confirmed</strong>
                                <br>
                                <small class="text-muted">Payment verified and order confirmed</small>
                            </div>
                            <div class="timeline-item ${order.status == 'shipped' || order.status == 'delivered' ? 'active' : ''} ${order.status == 'shipped' ? 'current' : ''}">
                                <strong>Order Shipped</strong>
                                <br>
                                <small class="text-muted">Your order is on the way</small>
                            </div>
                            <div class="timeline-item ${order.status == 'delivered' ? 'active current' : ''}">
                                <strong>Order Delivered</strong>
                                <br>
                                <small class="text-muted">Order delivered successfully</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Back Button -->
        <div class="row mt-4">
            <div class="col-12">
                <a href="${pageContext.request.contextPath}/order" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Orders
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
</body>
</html>
