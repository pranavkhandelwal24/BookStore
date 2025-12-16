<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Books - Admin Panel</title>
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
        .book-image {
            width: 60px;
            height: 75px;
            object-fit: cover;
        }
        .table th {
            border-top: none;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin?action=books">
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
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h2><i class="fas fa-book"></i> Manage Books</h2>
                            <p class="text-muted">Add, edit, and manage your book inventory</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin?action=addBook" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Add New Book
                        </a>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                            <i class="fas fa-exclamation-triangle"></i> ${error}
                        </div>
                    </c:if>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success" role="alert">
                            <i class="fas fa-check-circle"></i> ${success}
                        </div>
                    </c:if>

                    <!-- Books Table -->
                    <div class="card">
                        <div class="card-header">
                            <h5><i class="fas fa-list"></i> Book Inventory (${books.size()} books)</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty books}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-book fa-3x text-muted mb-3"></i>
                                        <h4>No books found</h4>
                                        <p class="text-muted">Start by adding some books to your inventory.</p>
                                        <a href="${pageContext.request.contextPath}/admin?action=addBook" class="btn btn-primary">
                                            <i class="fas fa-plus"></i> Add First Book
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Image</th>
                                                    <th>Title</th>
                                                    <th>Author</th>
                                                    <th>Category</th>
                                                    <th>Price</th>
                                                    <th>Stock</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="book" items="${books}">
                                                    <tr>
                                                        <td>
                                                            <img src="${book.imageUrl}" class="book-image rounded" alt="${book.title}">
                                                        </td>
                                                        <td>
                                                            <strong>${book.title}</strong>
                                                            <c:if test="${not empty book.isbn}">
                                                                <br><small class="text-muted">ISBN: ${book.isbn}</small>
                                                            </c:if>
                                                        </td>
                                                        <td>${book.author}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty book.category}">
                                                                    <span class="badge bg-secondary">${book.category}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">-</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${book.hasDiscount()}">
                                                                    <span class="text-decoration-line-through text-muted">₹${book.price}</span>
                                                                    <br><strong class="text-danger">₹${book.discountPrice}</strong>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <strong>₹${book.price}</strong>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${book.stock > 0}">
                                                                    <span class="badge bg-success">${book.stock}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-danger">Out of Stock</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${book.stock > 0}">
                                                                    <span class="badge bg-success">Active</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-warning">Inactive</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="btn-group" role="group">
                                                                <a href="${pageContext.request.contextPath}/admin?action=editBook&id=${book.bookId}" 
                                                                   class="btn btn-sm btn-outline-primary" title="Edit">
                                                                    <i class="fas fa-edit"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/books?action=view&id=${book.bookId}" 
                                                                   class="btn btn-sm btn-outline-info" title="View" target="_blank">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/admin?action=deleteBook&id=${book.bookId}" 
                                                                   class="btn btn-sm btn-outline-danger" title="Delete"
                                                                   onclick="return confirm('Are you sure you want to delete this book?')">
                                                                    <i class="fas fa-trash"></i>
                                                                </a>
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
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
