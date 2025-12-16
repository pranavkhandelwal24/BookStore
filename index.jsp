<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.bookstore.dao.BookDAO" %>
<%@ page import="com.bookstore.model.Book" %>
<%@ page import="java.util.List" %>

<%
    BookDAO bookDAO = new BookDAO();
    List<Book> featuredBooks = bookDAO.getAllBooks();
    if (featuredBooks.size() > 6) {
        featuredBooks = featuredBooks.subList(0, 6);
    }
    request.setAttribute("featuredBooks", featuredBooks);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Bookstore - Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 100px 0;
        }
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/books">Books</a>
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

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container text-center">
            <h1 class="display-4 mb-4">Welcome to Our Online Bookstore</h1>
            <p class="lead mb-4">Discover thousands of books from your favorite authors</p>
            <a href="${pageContext.request.contextPath}/books" class="btn btn-light btn-lg">
                <i class="fas fa-book-open"></i> Browse Books
            </a>
        </div>
    </section>

    <!-- Featured Books -->
    <section class="py-5">
        <div class="container">
            <h2 class="text-center mb-5">Featured Books</h2>
            <div class="row">
                <c:forEach var="book" items="${featuredBooks}">
                    <div class="col-md-4 mb-4">
                        <div class="card book-card h-100">
                            <img src="${book.imageUrl}" class="card-img-top book-image" alt="${book.title}">
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title">${book.title}</h5>
                                <p class="card-text text-muted">by ${book.author}</p>
                                <p class="card-text flex-grow-1">${book.description}</p>
                                <div class="mt-auto">
                                    <div class="d-flex justify-content-between align-items-center">
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
                                        <a href="${pageContext.request.contextPath}/books?action=view&id=${book.bookId}" 
                                           class="btn btn-primary btn-sm">View Details</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/books" class="btn btn-outline-primary">
                    View All Books <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>Online Bookstore</h5>
                    <p>Your one-stop destination for all your reading needs.</p>
                </div>
                <div class="col-md-6">
                    <h5>Quick Links</h5>
                    <ul class="list-unstyled">
                        <li><a href="/books" class="text-light">Browse Books</a></li>
                        <li><a href="${pageContext.request.contextPath}/register" class="text-light">Create Account</a></li>
                        <li><a href="${pageContext.request.contextPath}/login" class="text-light">Login</a></li>
                    </ul>
                </div>
            </div>
            <hr>
            <div class="text-center">
                <p>&copy; 2025 Online Bookstore. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
