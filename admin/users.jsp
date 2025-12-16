<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Admin Panel</title>
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
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin?action=orders">
                            <i class="fas fa-shopping-bag"></i> Manage Orders
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin?action=users">
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
                            <h2><i class="fas fa-users"></i> Manage Users</h2>
                            <p class="text-muted">View and manage registered users</p>
                        </div>
                        <div class="d-flex gap-2">
                            <select class="form-select" onchange="filterUsers(this.value)">
                                <option value="">All Users</option>
                                <option value="user">Regular Users</option>
                                <option value="admin">Administrators</option>
                            </select>
                            <input type="text" class="form-control" placeholder="Search users..." 
                                   onkeyup="searchUsers(this.value)" style="max-width: 200px;">
                        </div>
                    </div>

                    <!-- Users Table -->
                    <div class="card">
                        <div class="card-header">
                            <h5><i class="fas fa-list"></i> Registered Users (${users.size()} users)</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty users}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                        <h4>No users found</h4>
                                        <p class="text-muted">Registered users will appear here.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover" id="usersTable">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>User</th>
                                                    <th>Contact Info</th>
                                                    <th>Role</th>
                                                    <th>Registration Date</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="user" items="${users}">
                                                    <tr data-role="${user.role}" data-search="${user.username} ${user.fullName} ${user.email}">
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <div class="user-avatar me-3">
                                                                    ${user.fullName.substring(0,1).toUpperCase()}
                                                                </div>
                                                                <div>
                                                                    <strong>${user.fullName}</strong>
                                                                    <br><small class="text-muted">@${user.username}</small>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div>
                                                                <i class="fas fa-envelope text-muted"></i> ${user.email}
                                                            </div>
                                                            <c:if test="${not empty user.phone}">
                                                                <div class="mt-1">
                                                                    <i class="fas fa-phone text-muted"></i> ${user.phone}
                                                                </div>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${user.role == 'admin'}">
                                                                    <span class="badge bg-danger">
                                                                        <i class="fas fa-user-shield"></i> Admin
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-primary">
                                                                        <i class="fas fa-user"></i> User
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <fmt:formatDate value="${user.createdAt}" pattern="dd MMM yyyy"/>
                                                            <br><small class="text-muted">
                                                                <fmt:formatDate value="${user.createdAt}" pattern="hh:mm a"/>
                                                            </small>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-success">Active</span>
                                                        </td>
                                                        <td>
                                                            <div class="btn-group" role="group">
                                                                <button type="button" class="btn btn-sm btn-outline-info" 
                                                                        onclick="viewUserDetails(${user.userId})" title="View Details">
                                                                    <i class="fas fa-eye"></i>
                                                                </button>
                                                                <button type="button" class="btn btn-sm btn-outline-primary" 
                                                                        onclick="viewUserOrders(${user.userId})" title="View Orders">
                                                                    <i class="fas fa-shopping-bag"></i>
                                                                </button>
                                                                <c:if test="${user.userId != sessionScope.userId}">
                                                                    <button type="button" class="btn btn-sm btn-outline-warning" 
                                                                            onclick="toggleUserStatus(${user.userId})" title="Toggle Status">
                                                                        <i class="fas fa-ban"></i>
                                                                    </button>
                                                                </c:if>
                                                            </div>
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

                    <!-- User Statistics -->
                    <div class="row mt-4">
                        <div class="col-md-4">
                            <div class="card text-center">
                                <div class="card-body">
                                    <h5 class="text-primary">Total Users</h5>
                                    <h3 id="totalUsers">${users.size()}</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card text-center">
                                <div class="card-body">
                                    <h5 class="text-success">Regular Users</h5>
                                    <h3 id="regularUsers">0</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card text-center">
                                <div class="card-body">
                                    <h5 class="text-danger">Administrators</h5>
                                    <h3 id="adminUsers">0</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- User Details Modal -->
    <div class="modal fade" id="userDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">User Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="userDetailsContent">
                    <!-- User details will be loaded here -->
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Calculate and display user statistics
        function updateUserStats() {
            const rows = document.querySelectorAll('tbody tr[data-role]');
            let regularUsers = 0;
            let adminUsers = 0;

            rows.forEach(row => {
                const role = row.getAttribute('data-role');
                if (role === 'user') {
                    regularUsers++;
                } else if (role === 'admin') {
                    adminUsers++;
                }
            });

            document.getElementById('regularUsers').textContent = regularUsers;
            document.getElementById('adminUsers').textContent = adminUsers;
        }

        // Filter users by role
        function filterUsers(role) {
            const rows = document.querySelectorAll('tbody tr[data-role]');
            
            rows.forEach(row => {
                if (role === '' || row.getAttribute('data-role') === role) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        // Search users
        function searchUsers(searchTerm) {
            const rows = document.querySelectorAll('tbody tr[data-search]');
            const term = searchTerm.toLowerCase();
            
            rows.forEach(row => {
                const searchData = row.getAttribute('data-search').toLowerCase();
                if (searchData.includes(term)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        // View user details
        function viewUserDetails(userId) {
            const modal = new bootstrap.Modal(document.getElementById('userDetailsModal'));
            document.getElementById('userDetailsContent').innerHTML = 
                '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading user details...</div>';
            modal.show();
            
            // Simulate loading
            setTimeout(() => {
                document.getElementById('userDetailsContent').innerHTML = 
                    '<div class="row">' +
                    '<div class="col-md-6">' +
                    '<h6>Personal Information</h6>' +
                    '<p><strong>User ID:</strong> ' + userId + '</p>' +
                    '<p><strong>Full Name:</strong> John Doe</p>' +
                    '<p><strong>Username:</strong> johndoe</p>' +
                    '<p><strong>Email:</strong> john@example.com</p>' +
                    '</div>' +
                    '<div class="col-md-6">' +
                    '<h6>Contact Information</h6>' +
                    '<p><strong>Phone:</strong> +1234567890</p>' +
                    '<p><strong>Address:</strong> 123 Main St, City, State</p>' +
                    '<p><strong>Registration:</strong> Jan 15, 2024</p>' +
                    '</div>' +
                    '</div>';
            }, 1000);
        }

        // View user orders
        function viewUserOrders(userId) {
            // In a real implementation, this would redirect to orders page filtered by user
            window.open('${pageContext.request.contextPath}/admin?action=orders&userId=' + userId, '_blank');
        }

        // Toggle user status
        function toggleUserStatus(userId) {
            if (confirm('Are you sure you want to toggle this user\'s status?')) {
                // In a real implementation, this would make an AJAX call to toggle user status
                alert('User status toggle functionality would be implemented here for User #' + userId);
            }
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            updateUserStats();
        });
    </script>
</body>
</html>
