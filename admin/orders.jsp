<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders - Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
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
        .table th {
            border-top: none;
        }
        .status-select {
            border: none;
            background: transparent;
            font-size: 0.875rem;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin?action=books">
                            <i class="fas fa-book"></i> Manage Books
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin?action=orders">
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
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h2><i class="fas fa-shopping-bag"></i> Manage Orders</h2>
                            <p class="text-muted">View and manage customer orders</p>
                        </div>
                        <div class="d-flex gap-2">
                            <form method="get" action="${pageContext.request.contextPath}/admin" class="d-flex gap-2">
                                <input type="hidden" name="action" value="orders">
                                <input type="text" name="search" class="form-control" placeholder="Search by Order ID or Customer" 
                                       value="${searchQuery}" style="width: 250px;">
                                <select name="status" class="form-select" style="width: 150px;">
                                    <option value="">All Status</option>
                                    <option value="pending" ${statusFilter == 'pending' ? 'selected' : ''}>Pending</option>
                                    <option value="confirmed" ${statusFilter == 'confirmed' ? 'selected' : ''}>Confirmed</option>
                                    <option value="shipped" ${statusFilter == 'shipped' ? 'selected' : ''}>Shipped</option>
                                    <option value="delivered" ${statusFilter == 'delivered' ? 'selected' : ''}>Delivered</option>
                                    <option value="cancelled" ${statusFilter == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                                </select>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Search
                                </button>
                                <a href="${pageContext.request.contextPath}/admin?action=orders" class="btn btn-outline-secondary">
                                    <i class="fas fa-times"></i> Clear
                                </a>
                            </form>
                        </div>
                    </div>

                    <c:if test="${not empty sessionScope.success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle"></i> ${sessionScope.success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="success" scope="session" />
                    </c:if>
                    
                    <c:if test="${not empty sessionScope.error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle"></i> ${sessionScope.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="error" scope="session" />
                    </c:if>

                    <!-- Orders Table -->
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5><i class="fas fa-list"></i> All Orders (${totalOrders} orders)</h5>
                            <div class="text-muted">
                                Page ${currentPage} of ${totalPages} | Showing ${orders.size()} orders
                            </div>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty orders}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-shopping-bag fa-3x text-muted mb-3"></i>
                                        <h4>No orders found</h4>
                                        <p class="text-muted">Orders will appear here when customers make purchases.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Order ID</th>
                                                    <th>Date</th>
                                                    <th>Customer</th>
                                                    <th>Items</th>
                                                    <th>Amount</th>
                                                    <th>Payment</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="order" items="${orders}">
                                                    <tr>
                                                        <td><strong>#${order.orderId}</strong></td>
                                                        <td>
                                                            <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy"/>
                                                            <br><small class="text-muted">
                                                                <fmt:formatDate value="${order.orderDate}" pattern="hh:mm a"/>
                                                            </small>
                                                        </td>
                                                        <td>
                                                            <strong>User #${order.userId}</strong>
                                                            <c:if test="${not empty order.user}">
                                                                <br><small class="text-muted">${order.user.fullName}</small>
                                                                <br><small class="text-muted">${order.user.email}</small>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty order.orderItems}">
                                                                    ${order.orderItems.size()} item(s)
                                                                    <br><small class="text-muted">
                                                                        <c:forEach var="item" items="${order.orderItems}" varStatus="status" end="1">
                                                                            ${item.book.title}<c:if test="${!status.last && status.index < 1}">, </c:if>
                                                                            <c:if test="${status.index == 1 && fn:length(order.orderItems) > 2}">...</c:if>
                                                                        </c:forEach>
                                                                    </small>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">No items</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <strong>₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></strong>
                                                        </td>
                                                        <td>
                                                            <form action="${pageContext.request.contextPath}/admin" method="post" class="d-inline">
                                                                <input type="hidden" name="action" value="updatePaymentStatus">
                                                                <input type="hidden" name="orderId" value="${order.orderId}">
                                                                <input type="hidden" name="page" value="${currentPage}">
                                                                <input type="hidden" name="statusFilter" value="${statusFilter}">
                                                                <input type="hidden" name="searchQuery" value="${searchQuery}">
                                                                <select name="paymentStatus" class="form-select form-select-sm payment-status-select
                                                                    <c:choose>
                                                                        <c:when test="${order.paymentStatus == 'pending'}">bg-warning text-dark</c:when>
                                                                        <c:when test="${order.paymentStatus == 'paid'}">bg-success text-white</c:when>
                                                                        <c:when test="${order.paymentStatus == 'failed'}">bg-danger text-white</c:when>
                                                                        <c:otherwise>bg-secondary text-white</c:otherwise>
                                                                    </c:choose>"
                                                                    onchange="this.form.submit()" data-order-id="${order.orderId}" data-current-payment-status="${order.paymentStatus}">
                                                                    <option value="pending" ${order.paymentStatus == 'pending' ? 'selected' : ''}>
                                                                        <i class="fas fa-clock"></i> Pending
                                                                    </option>
                                                                    <option value="paid" ${order.paymentStatus == 'paid' ? 'selected' : ''}>
                                                                        <i class="fas fa-check-circle"></i> Paid
                                                                    </option>
                                                                    <option value="failed" ${order.paymentStatus == 'failed' ? 'selected' : ''}>
                                                                        <i class="fas fa-times-circle"></i> Failed
                                                                    </option>
                                                                </select>
                                                            </form>
                                                            <small class="text-muted d-block mt-1">${order.paymentMethod}</small>
                                                        </td>
                                                        <td>
                                                            <form action="${pageContext.request.contextPath}/admin" method="post" class="d-inline">
                                                                <input type="hidden" name="action" value="updateOrderStatus">
                                                                <input type="hidden" name="orderId" value="${order.orderId}">
                                                                <input type="hidden" name="page" value="${currentPage}">
                                                                <input type="hidden" name="statusFilter" value="${statusFilter}">
                                                                <input type="hidden" name="searchQuery" value="${searchQuery}">
                                                                <select name="status" class="form-select form-select-sm status-select
                                                                    <c:choose>
                                                                        <c:when test="${order.status == 'pending'}">bg-warning text-dark</c:when>
                                                                        <c:when test="${order.status == 'confirmed'}">bg-info text-white</c:when>
                                                                        <c:when test="${order.status == 'shipped'}">bg-primary text-white</c:when>
                                                                        <c:when test="${order.status == 'delivered'}">bg-success text-white</c:when>
                                                                        <c:when test="${order.status == 'cancelled'}">bg-danger text-white</c:when>
                                                                        <c:otherwise>bg-secondary text-white</c:otherwise>
                                                                    </c:choose>"
                                                                    onchange="this.form.submit()" data-order-id="${order.orderId}" data-current-status="${order.status}">
                                                                    <option value="pending" ${order.status == 'pending' ? 'selected' : ''}>
                                                                        <i class="fas fa-clock"></i> Pending
                                                                    </option>
                                                                    <option value="confirmed" ${order.status == 'confirmed' ? 'selected' : ''}>
                                                                        <i class="fas fa-check"></i> Confirmed
                                                                    </option>
                                                                    <option value="shipped" ${order.status == 'shipped' ? 'selected' : ''}>
                                                                        <i class="fas fa-truck"></i> Shipped
                                                                    </option>
                                                                    <option value="delivered" ${order.status == 'delivered' ? 'selected' : ''}>
                                                                        <i class="fas fa-check-circle"></i> Delivered
                                                                    </option>
                                                                    <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>
                                                                        <i class="fas fa-times-circle"></i> Cancelled
                                                                    </option>
                                                                </select>
                                                            </form>
                                                        </td>
                                                        <td>
                                                            <div class="btn-group" role="group">
                                                                <button type="button" class="btn btn-sm btn-outline-info" 
                                                                        onclick="viewOrderDetails('${order.orderId}')" title="View Details">
                                                                    <i class="fas fa-eye"></i>
                                                                </button>
                                                                <button type="button" class="btn btn-sm btn-outline-primary" 
                                                                        onclick="printOrder('${order.orderId}')" title="Print">
                                                                    <i class="fas fa-print"></i>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                    
                                    <!-- Pagination -->
                                    <c:if test="${totalPages > 1}">
                                        <nav aria-label="Orders pagination" class="mt-4">
                                            <ul class="pagination justify-content-center">
                                                <!-- Previous button -->
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/admin?action=orders&page=${currentPage - 1}&status=${statusFilter}&search=${searchQuery}">
                                                        <i class="fas fa-chevron-left"></i> Previous
                                                    </a>
                                                </li>
                                                
                                                <!-- Page numbers -->
                                                <c:forEach begin="${currentPage > 3 ? currentPage - 2 : 1}" 
                                                          end="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" 
                                                          var="pageNum">
                                                    <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/admin?action=orders&page=${pageNum}&status=${statusFilter}&search=${searchQuery}">
                                                            ${pageNum}
                                                        </a>
                                                    </li>
                                                </c:forEach>
                                                
                                                <!-- Next button -->
                                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/admin?action=orders&page=${currentPage + 1}&status=${statusFilter}&search=${searchQuery}">
                                                        Next <i class="fas fa-chevron-right"></i>
                                                    </a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Order Statistics -->
                    <div class="row mt-4">
                        <div class="col-md-2">
                            <div class="card text-center">
                                <div class="card-body">
                                    <h5 class="text-warning">Pending</h5>
                                    <h3>${pendingCount}</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="card text-center">
                                <div class="card-body">
                                    <h5 class="text-info">Confirmed</h5>
                                    <h3>${confirmedCount}</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="card text-center">
                                <div class="card-body">
                                    <h5 class="text-primary">Shipped</h5>
                                    <h3>${shippedCount}</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="card text-center">
                                <div class="card-body">
                                    <h5 class="text-success">Delivered</h5>
                                    <h3>${deliveredCount}</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="card text-center">
                                <div class="card-body">
                                    <h5 class="text-danger">Cancelled</h5>
                                    <h3>${cancelledCount}</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="card text-center">
                                <div class="card-body">
                                    <h5 class="text-dark">Total</h5>
                                    <h3>${totalOrders}</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Order Details Modal -->
    <div class="modal fade" id="orderDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Order Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="orderDetailsContent">
                    <!-- Order details will be loaded here -->
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Update order status with confirmation
        function updateOrderStatus(selectElement) {
            const orderId = selectElement.getAttribute('data-order-id');
            const currentStatus = selectElement.getAttribute('data-current-status');
            const newStatus = selectElement.value;
            
            if (currentStatus === newStatus) {
                return; // No change
            }
            
            const statusMessages = {
                'pending': 'Pending',
                'confirmed': 'Confirmed',
                'shipped': 'Shipped',
                'delivered': 'Delivered',
                'cancelled': 'Cancelled'
            };
            
            const message = `Are you sure you want to change Order #${orderId} status from "${statusMessages[currentStatus]}" to "${statusMessages[newStatus]}"?`;
            
            if (confirm(message)) {
                // Show loading state
                selectElement.disabled = true;
                selectElement.style.opacity = '0.6';
                
                // Submit the form
                selectElement.form.submit();
            } else {
                // Reset to original value
                selectElement.value = currentStatus;
            }
        }
        
        // Confirm payment status change
        function confirmPaymentStatusChange(selectElement) {
            const orderId = selectElement.getAttribute('data-order-id');
            const currentPaymentStatus = selectElement.getAttribute('data-current-payment-status');
            const newPaymentStatus = selectElement.value;
            
            if (currentPaymentStatus === newPaymentStatus) {
                return false; // Prevent submission if no change
            }
            
            const message = `Are you sure you want to change payment status for Order #${orderId} from "${currentPaymentStatus.toUpperCase()}" to "${newPaymentStatus.toUpperCase()}"?`;
            
            if (confirm(message)) {
                // Show loading state
                selectElement.disabled = true;
                selectElement.style.opacity = '0.6';
                
                // Submit the form
                selectElement.form.submit();
            } else {
                // Reset to original value
                selectElement.value = currentPaymentStatus;
            }
        }

        // Confirm status change (backup function)
        function confirmStatusChange(form) {
            const selectElement = form.querySelector('select[name="status"]');
            const orderId = selectElement.getAttribute('data-order-id');
            const currentStatus = selectElement.getAttribute('data-current-status');
            const newStatus = selectElement.value;
            
            if (currentStatus === newStatus) {
                return false; // Prevent submission if no change
            }
            
            return true; // Allow submission
        }

        // View order details
        function viewOrderDetails(orderId) {
            const modal = new bootstrap.Modal(document.getElementById('orderDetailsModal'));
            document.getElementById('orderDetailsContent').innerHTML = 
                '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading order details...</div>';
            modal.show();
            
            // Simulate loading order details
            setTimeout(() => {
                document.getElementById('orderDetailsContent').innerHTML = 
                    '<div class="row">' +
                    '<div class="col-md-6">' +
                    '<h6><i class="fas fa-info-circle"></i> Order Information</h6>' +
                    '<p><strong>Order ID:</strong> #' + orderId + '</p>' +
                    '<p><strong>Status:</strong> <span class="badge bg-primary">Processing</span></p>' +
                    '<p><strong>Payment:</strong> <span class="badge bg-success">Completed</span></p>' +
                    '</div>' +
                    '<div class="col-md-6">' +
                    '<h6><i class="fas fa-user"></i> Customer Information</h6>' +
                    '<p><strong>Name:</strong> Customer Name</p>' +
                    '<p><strong>Email:</strong> customer@email.com</p>' +
                    '<p><strong>Phone:</strong> +1234567890</p>' +
                    '</div>' +
                    '</div>' +
                    '<hr>' +
                    '<h6><i class="fas fa-box"></i> Order Items</h6>' +
                    '<div class="table-responsive">' +
                    '<table class="table table-sm">' +
                    '<thead><tr><th>Item</th><th>Qty</th><th>Price</th><th>Total</th></tr></thead>' +
                    '<tbody>' +
                    '<tr><td>Sample Book</td><td>1</td><td>₹299</td><td>₹299</td></tr>' +
                    '</tbody>' +
                    '</table>' +
                    '</div>';
            }, 1000);
        }

        // Print order
        function printOrder(orderId) {
            if (confirm('Generate printable receipt for Order #' + orderId + '?')) {
                // In a real implementation, this would open a print-friendly page
                window.open('/bookstore/admin/print-order?id=' + orderId, '_blank');
            }
        }

        // Auto-dismiss alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function(alert) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 5000);
        });
    </script>
</body>
</html>
