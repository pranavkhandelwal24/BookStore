<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Online Bookstore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .dashboard-card {
            border-radius: 15px;
            transition: transform 0.3s;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .stat-icon {
            font-size: 3rem;
            opacity: 0.8;
        }
        .sidebar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            border-radius: 10px;
            margin: 0.2rem 0;
        }
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: rgba(255,255,255,0.2);
            color: white;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0">
                <div class="sidebar p-3">
                    <div class="text-center mb-4">
                        <h4 class="text-white">
                            <i class="fas fa-user-shield"></i> Admin Panel
                        </h4>
                        <small class="text-white-50">Welcome, ${sessionScope.username}</small>
                    </div>
                    
                    <nav class="nav flex-column">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin?action=books">
                            <i class="fas fa-book"></i> Manage Books
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin?action=orders">
                            <i class="fas fa-shopping-bag"></i> Manage Orders
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin?action=users">
                            <i class="fas fa-users"></i> Manage Users
                        </a>
                        <hr class="text-white-50">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">
                            <i class="fas fa-home"></i> Back to Store
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </nav>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <div class="p-4">
                    <h2><i class="fas fa-tachometer-alt"></i> Dashboard</h2>
                    <p class="text-muted">Overview of your bookstore</p>
                    <hr>

                    <!-- Statistics Cards -->
                    <div class="row mb-4">
                        <div class="col-md-3 mb-3">
                            <div class="card dashboard-card bg-primary text-white">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h4>${totalBooks}</h4>
                                            <p class="mb-0">Total Books</p>
                                        </div>
                                        <div class="stat-icon">
                                            <i class="fas fa-book"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card dashboard-card bg-success text-white">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h4>${totalOrders}</h4>
                                            <p class="mb-0">Total Orders</p>
                                        </div>
                                        <div class="stat-icon">
                                            <i class="fas fa-shopping-cart"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card dashboard-card bg-info text-white">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h4>${totalUsers}</h4>
                                            <p class="mb-0">Total Users</p>
                                        </div>
                                        <div class="stat-icon">
                                            <i class="fas fa-users"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card dashboard-card bg-warning text-white">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h4>₹0</h4>
                                            <p class="mb-0">Revenue</p>
                                        </div>
                                        <div class="stat-icon">
                                            <i class="fas fa-rupee-sign"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Orders -->
                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5><i class="fas fa-clock"></i> Recent Orders</h5>
                                    <a href="${pageContext.request.contextPath}/admin?action=orders" class="btn btn-sm btn-outline-primary">
                                        View All Orders
                                    </a>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${empty recentOrders}">
                                            <div class="text-center py-4">
                                                <i class="fas fa-shopping-bag fa-2x text-muted mb-2"></i>
                                                <p class="text-muted">No recent orders</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive">
                                                <table class="table table-hover">
                                                    <thead>
                                                        <tr>
                                                            <th>Order ID</th>
                                                            <th>Date</th>
                                                            <th>Customer</th>
                                                            <th>Amount</th>
                                                            <th>Status</th>
                                                            <th>Payment</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="order" items="${recentOrders}">
                                                            <tr>
                                                                <td>#${order.orderId}</td>
                                                                <td>
                                                                    <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy"/>
                                                                </td>
                                                                <td>User #${order.userId}</td>
                                                                <td>₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                                                                <td>
                                                                    <span class="badge 
                                                                        <c:choose>
                                                                            <c:when test="${order.status == 'pending'}">bg-warning</c:when>
                                                                            <c:when test="${order.status == 'confirmed'}">bg-info</c:when>
                                                                            <c:when test="${order.status == 'shipped'}">bg-primary</c:when>
                                                                            <c:when test="${order.status == 'delivered'}">bg-success</c:when>
                                                                            <c:when test="${order.status == 'cancelled'}">bg-danger</c:when>
                                                                            <c:otherwise>bg-secondary</c:otherwise>
                                                                        </c:choose>">
                                                                        ${order.status}
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span class="badge 
                                                                        <c:choose>
                                                                            <c:when test="${order.paymentStatus == 'completed'}">bg-success</c:when>
                                                                            <c:when test="${order.paymentStatus == 'pending'}">bg-warning</c:when>
                                                                            <c:when test="${order.paymentStatus == 'failed'}">bg-danger</c:when>
                                                                            <c:otherwise>bg-secondary</c:otherwise>
                                                                        </c:choose>">
                                                                        ${order.paymentStatus}
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5><i class="fas fa-bolt"></i> Quick Actions</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-3 mb-2">
                                            <a href="${pageContext.request.contextPath}/admin?action=addBook" class="btn btn-primary w-100">
                                                <i class="fas fa-plus"></i> Add New Book
                                            </a>
                                        </div>
                                        <div class="col-md-3 mb-2">
                                            <a href="${pageContext.request.contextPath}/admin?action=books" class="btn btn-info w-100">
                                                <i class="fas fa-edit"></i> Manage Books
                                            </a>
                                        </div>
                                        <div class="col-md-3 mb-2">
                                            <a href="${pageContext.request.contextPath}/admin?action=orders" class="btn btn-success w-100">
                                                <i class="fas fa-shopping-bag"></i> View Orders
                                            </a>
                                        </div>
                                        <div class="col-md-3 mb-2">
                                            <a href="${pageContext.request.contextPath}/admin?action=users" class="btn btn-warning w-100">
                                                <i class="fas fa-users"></i> Manage Users
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
