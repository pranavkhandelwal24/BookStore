<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - Online Bookstore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .order-card {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            margin-bottom: 1rem;
            transition: box-shadow 0.3s;
        }
        .order-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .status-badge {
            font-size: 0.8rem;
        }
        .book-image {
            width: 50px;
            height: 60px;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/order">Orders</a>
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
                <h2><i class="fas fa-shopping-bag"></i> My Orders</h2>
                <hr>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty orders}">
                <div class="text-center py-5">
                    <i class="fas fa-shopping-bag fa-3x text-muted mb-3"></i>
                    <h4>No orders found</h4>
                    <p class="text-muted">You haven't placed any orders yet. Start shopping to see your orders here!</p>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-primary">
                        <i class="fas fa-book"></i> Browse Books
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="order" items="${orders}">
                    <div class="order-card">
                        <div class="card-header bg-light">
                            <div class="row align-items-center">
                                <div class="col-md-3">
                                    <strong>Order #${order.orderId}</strong>
                                </div>
                                <div class="col-md-3">
                                    <small class="text-muted">
                                        <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a"/>
                                    </small>
                                </div>
                                <div class="col-md-3">
                                    <span class="badge status-badge
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
                                <div class="col-md-3 text-end">
                                    <strong>₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></strong>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-8">
                                    <div class="d-flex flex-wrap">
                                        <c:forEach var="item" items="${order.orderItems}" varStatus="status">
                                            <div class="d-flex align-items-center me-3 mb-2">
                                                <img src="${item.book.imageUrl}" class="book-image rounded me-2" alt="${item.book.title}">
                                                <div>
                                                    <small class="fw-bold">${item.book.title}</small>
                                                    <br>
                                                    <small class="text-muted">Qty: ${item.quantity}</small>
                                                </div>
                                            </div>
                                            <c:if test="${status.index >= 2}">
                                                <small class="text-muted align-self-center">
                                                    +${order.orderItems.size() - 3} more items
                                                </small>
                                                <c:set var="shouldBreak" value="true"/>
                                            </c:if>
                                            <c:if test="${shouldBreak}">
                                                <c:remove var="shouldBreak"/>
                                                <c:set var="shouldBreak" value="false"/>
                                                <c:if test="${!shouldBreak}">
                                                    <c:set var="shouldBreak" value="true"/>
                                                </c:if>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="col-md-4 text-end">
                                    <div class="mb-2">
                                        <small class="text-muted">Payment: </small>
                                        <span class="badge 
                                            <c:choose>
                                                <c:when test="${order.paymentStatus == 'completed'}">bg-success</c:when>
                                                <c:when test="${order.paymentStatus == 'pending'}">bg-warning</c:when>
                                                <c:when test="${order.paymentStatus == 'failed'}">bg-danger</c:when>
                                                <c:otherwise>bg-secondary</c:otherwise>
                                            </c:choose>">
                                            ${order.paymentStatus.toUpperCase()}
                                        </span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/order?action=view&id=${order.orderId}" 
                                       class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-eye"></i> View Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
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
</body>
</html>
