<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Books - Online Bookstore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .book-card {
            transition: transform 0.3s;
            height: 100%;
        }
        .book-card:hover {
            transform: translateY(-5px);
        }
        .book-image {
            height: 250px;
            object-fit: cover;
        }
        .price-original {
            text-decoration: line-through;
            color: #6c757d;
        }
        .price-discount {
            color: #dc3545;
            font-weight: bold;
        }
        .sidebar {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/books">Books</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
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
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/register">Register</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3">
                <div class="sidebar">
                    <h5><i class="fas fa-search"></i> Search Books</h5>
                    <form action="${pageContext.request.contextPath}/books" method="get">
                        <input type="hidden" name="action" value="search">
                        <div class="input-group mb-3">
                            <input type="text" class="form-control" name="q" placeholder="Search books..." 
                                   value="${searchTerm}">
                            <button class="btn btn-outline-primary" type="submit">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </form>

                    <h5><i class="fas fa-list"></i> Categories</h5>
                    <div class="list-group">
                        <a href="${pageContext.request.contextPath}/books" 
                           class="list-group-item list-group-item-action ${empty selectedCategory ? 'active' : ''}">
                            All Categories
                        </a>
                        <c:forEach var="category" items="${categories}">
                            <a href="${pageContext.request.contextPath}/books?action=category&name=${category}" 
                               class="list-group-item list-group-item-action ${selectedCategory == category ? 'active' : ''}">
                                ${category}
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-9">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>
                        <c:choose>
                            <c:when test="${not empty searchTerm}">
                                Search Results for "${searchTerm}"
                            </c:when>
                            <c:when test="${not empty selectedCategory}">
                                ${selectedCategory} Books
                            </c:when>
                            <c:otherwise>
                                All Books
                            </c:otherwise>
                        </c:choose>
                    </h2>
                    <span class="badge bg-primary">${books.size()} books found</span>
                </div>

                <c:choose>
                    <c:when test="${empty books}">
                        <div class="text-center py-5">
                            <i class="fas fa-book fa-3x text-muted mb-3"></i>
                            <h4>No books found</h4>
                            <p class="text-muted">Try adjusting your search criteria or browse all categories.</p>
                            <a href="${pageContext.request.contextPath}/books" class="btn btn-primary">
                                View All Books
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="row">
                            <c:forEach var="book" items="${books}">
                                <div class="col-md-4 mb-4">
                                    <div class="card book-card h-100">
                                        <img src="${book.imageUrl}" class="card-img-top book-image" alt="${book.title}">
                                        <div class="card-body d-flex flex-column">
                                            <h5 class="card-title">${book.title}</h5>
                                            <p class="card-text text-muted">by ${book.author}</p>
                                            <p class="card-text flex-grow-1">
                                                ${book.description.length() > 100 ? book.description.substring(0, 100).concat('...') : book.description}
                                            </p>
                                            <div class="mt-auto">
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <div>
                                                        <c:choose>
                                                            <c:when test="${book.hasDiscount()}">
                                                                <span class="price-original">₹${book.price}</span>
                                                                <span class="price-discount">₹${book.discountPrice}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="h5">₹${book.price}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <small class="text-muted">
                                                        <c:choose>
                                                            <c:when test="${book.stock > 0}">
                                                                <span class="text-success">In Stock (${book.stock})</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-danger">Out of Stock</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </small>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/books?action=view&id=${book.bookId}" 
                                                   class="btn btn-primary btn-sm w-100">
                                                    <i class="fas fa-eye"></i> View Details
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
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
