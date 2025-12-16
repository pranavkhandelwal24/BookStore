<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Online Bookstore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .register-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 2rem 0;
        }
        .register-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .register-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        .register-body {
            padding: 2rem;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6">
                    <div class="register-card">
                        <div class="register-header">
                            <h3><i class="fas fa-book"></i> BookStore</h3>
                            <p class="mb-0">Create Your Account</p>
                        </div>
                        <div class="register-body">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger" role="alert">
                                    <i class="fas fa-exclamation-triangle"></i> ${error}
                                </div>
                            </c:if>
                            
                            <form action="${pageContext.request.contextPath}/register" method="post">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="username" class="form-label">
                                            <i class="fas fa-user"></i> Username *
                                        </label>
                                        <input type="text" class="form-control" id="username" name="username" 
                                               required placeholder="Choose a username">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="email" class="form-label">
                                            <i class="fas fa-envelope"></i> Email *
                                        </label>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               required placeholder="Enter your email">
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="fullName" class="form-label">
                                        <i class="fas fa-id-card"></i> Full Name *
                                    </label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" 
                                           required placeholder="Enter your full name">
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="password" class="form-label">
                                            <i class="fas fa-lock"></i> Password *
                                        </label>
                                        <input type="password" class="form-control" id="password" name="password" 
                                               required placeholder="Enter password (min 6 characters)">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="confirmPassword" class="form-label">
                                            <i class="fas fa-lock"></i> Confirm Password *
                                        </label>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                               required placeholder="Confirm your password">
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="phone" class="form-label">
                                        <i class="fas fa-phone"></i> Phone Number
                                    </label>
                                    <input type="tel" class="form-control" id="phone" name="phone" 
                                           placeholder="Enter your phone number">
                                </div>
                                
                                <div class="mb-3">
                                    <label for="address" class="form-label">
                                        <i class="fas fa-map-marker-alt"></i> Address
                                    </label>
                                    <textarea class="form-control" id="address" name="address" rows="3" 
                                              placeholder="Enter your address"></textarea>
                                </div>
                                
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="fas fa-user-plus"></i> Create Account
                                    </button>
                                </div>
                            </form>
                            
                            <div class="text-center mt-4">
                                <p>Already have an account? 
                                    <a href="${pageContext.request.contextPath}/login" class="text-decoration-none">
                                        Login here
                                    </a>
                                </p>
                                <a href="${pageContext.request.contextPath}/" class="text-muted">
                                    <i class="fas fa-arrow-left"></i> Back to Home
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Password confirmation validation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if (password !== confirmPassword) {
                this.setCustomValidity('Passwords do not match');
            } else {
                this.setCustomValidity('');
            }
        });
    </script>
</body>
</html>
