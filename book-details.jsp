<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${book.title} - Online Bookstore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .book-image {
            max-height: 400px;
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
        .book-details {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 2rem;
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
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/books">Books</a></li>
                <li class="breadcrumb-item active" aria-current="page">${book.title}</li>
            </ol>
        </nav>

        <div class="row">
            <!-- Book Image -->
            <div class="col-md-4">
                <img src="${book.imageUrl}" class="img-fluid book-image rounded" alt="${book.title}">
            </div>

            <!-- Book Details -->
            <div class="col-md-8">
                <div class="book-details">
                    <h1 class="mb-3">${book.title}</h1>
                    <h5 class="text-muted mb-3">by ${book.author}</h5>
                    
                    <c:if test="${not empty book.isbn}">
                        <p><strong>ISBN:</strong> ${book.isbn}</p>
                    </c:if>
                    
                    <c:if test="${not empty book.category}">
                        <p><strong>Category:</strong> 
                            <a href="${pageContext.request.contextPath}/books?action=category&name=${book.category}" 
                               class="badge bg-secondary text-decoration-none">${book.category}</a>
                        </p>
                    </c:if>

                    <div class="mb-4">
                        <h3>
                            <c:choose>
                                <c:when test="${book.hasDiscount()}">
                                    <span class="price-original">₹${book.price}</span>
                                    <span class="price-discount">₹${book.discountPrice}</span>
                                    <span class="badge bg-success ms-2">
                                        ${Math.round((1 - book.discountPrice.doubleValue() / book.price.doubleValue()) * 100)}% OFF
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-primary">₹${book.price}</span>
                                </c:otherwise>
                            </c:choose>
                        </h3>
                    </div>

                    <div class="mb-4">
                        <strong>Availability: </strong>
                        <c:choose>
                            <c:when test="${book.stock > 0}">
                                <span class="text-success">
                                    <i class="fas fa-check-circle"></i> In Stock (${book.stock} available)
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="text-danger">
                                    <i class="fas fa-times-circle"></i> Out of Stock
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:if test="${not empty sessionScope.user and book.stock > 0}">
                        <form action="${pageContext.request.contextPath}/cart" method="post" class="mb-4">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="bookId" value="${book.bookId}">
                            <div class="row align-items-end">
                                <div class="col-md-3">
                                    <label for="quantity" class="form-label">Quantity:</label>
                                    <select class="form-select" id="quantity" name="quantity">
                                        <c:forEach begin="1" end="${book.stock > 10 ? 10 : book.stock}" var="i">
                                            <option value="${i}">${i}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="fas fa-cart-plus"></i> Add to Cart
                                    </button>
                                </div>
                            </div>
                        </form>
                    </c:if>

                    <c:if test="${empty sessionScope.user}">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i> 
                            Please <a href="${pageContext.request.contextPath}/login">login</a> to add items to cart.
                        </div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-triangle"></i> ${error}
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Book Description -->
        <div class="row mt-5">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h4><i class="fas fa-info-circle"></i> Description</h4>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty book.description}">
                                <p class="lead">${book.description}</p>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted">No description available for this book.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Back to Books -->
        <div class="row mt-4">
            <div class="col-12">
                <a href="${pageContext.request.contextPath}/books" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Books
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
