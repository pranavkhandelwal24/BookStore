<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Book - Admin Panel</title>
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
        .form-container {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 2rem;
        }
        .book-preview {
            max-width: 200px;
            max-height: 250px;
            object-fit: cover;
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
                            <h2><i class="fas fa-edit"></i> Edit Book</h2>
                            <p class="text-muted">Update book information</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin?action=books" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Books
                        </a>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                            <i class="fas fa-exclamation-triangle"></i> ${error}
                        </div>
                    </c:if>

                    <div class="row">
                        <div class="col-md-8">
                            <div class="form-container">
                                <form action="${pageContext.request.contextPath}/admin" method="post">
                                    <input type="hidden" name="action" value="updateBook">
                                    <input type="hidden" name="bookId" value="${book.bookId}">
                                    
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="title" class="form-label">
                                                <i class="fas fa-book"></i> Book Title *
                                            </label>
                                            <input type="text" class="form-control" id="title" name="title" 
                                                   required value="${book.title}">
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="author" class="form-label">
                                                <i class="fas fa-user-edit"></i> Author *
                                            </label>
                                            <input type="text" class="form-control" id="author" name="author" 
                                                   required value="${book.author}">
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="isbn" class="form-label">
                                                <i class="fas fa-barcode"></i> ISBN
                                            </label>
                                            <input type="text" class="form-control" id="isbn" name="isbn" 
                                                   value="${book.isbn}">
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="category" class="form-label">
                                                <i class="fas fa-tags"></i> Category
                                            </label>
                                            <select class="form-select" id="category" name="category">
                                                <option value="">Select Category</option>
                                                <option value="Fiction" ${book.category == 'Fiction' ? 'selected' : ''}>Fiction</option>
                                                <option value="Non-Fiction" ${book.category == 'Non-Fiction' ? 'selected' : ''}>Non-Fiction</option>
                                                <option value="Science Fiction" ${book.category == 'Science Fiction' ? 'selected' : ''}>Science Fiction</option>
                                                <option value="Fantasy" ${book.category == 'Fantasy' ? 'selected' : ''}>Fantasy</option>
                                                <option value="Romance" ${book.category == 'Romance' ? 'selected' : ''}>Romance</option>
                                                <option value="Mystery" ${book.category == 'Mystery' ? 'selected' : ''}>Mystery</option>
                                                <option value="Biography" ${book.category == 'Biography' ? 'selected' : ''}>Biography</option>
                                                <option value="History" ${book.category == 'History' ? 'selected' : ''}>History</option>
                                                <option value="Self-Help" ${book.category == 'Self-Help' ? 'selected' : ''}>Self-Help</option>
                                                <option value="Technology" ${book.category == 'Technology' ? 'selected' : ''}>Technology</option>
                                                <option value="Education" ${book.category == 'Education' ? 'selected' : ''}>Education</option>
                                                <option value="Children" ${book.category == 'Children' ? 'selected' : ''}>Children</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="description" class="form-label">
                                            <i class="fas fa-align-left"></i> Description
                                        </label>
                                        <textarea class="form-control" id="description" name="description" rows="4">${book.description}</textarea>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-4 mb-3">
                                            <label for="price" class="form-label">
                                                <i class="fas fa-rupee-sign"></i> Price *
                                            </label>
                                            <input type="number" class="form-control" id="price" name="price" 
                                                   required min="0" step="0.01" value="${book.price}">
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <label for="discountPrice" class="form-label">
                                                <i class="fas fa-percentage"></i> Discount Price
                                            </label>
                                            <input type="number" class="form-control" id="discountPrice" name="discountPrice" 
                                                   min="0" step="0.01" value="${book.discountPrice}">
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <label for="stock" class="form-label">
                                                <i class="fas fa-boxes"></i> Stock Quantity *
                                            </label>
                                            <input type="number" class="form-control" id="stock" name="stock" 
                                                   required min="0" value="${book.stock}">
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <label for="imageUrl" class="form-label">
                                            <i class="fas fa-image"></i> Book Cover Image URL
                                        </label>
                                        <input type="url" class="form-control" id="imageUrl" name="imageUrl" 
                                               value="${book.imageUrl}">
                                        <div class="form-text">
                                            Enter a URL for the book cover image, or 
                                            <button type="button" class="btn btn-link p-0" onclick="uploadImage()">
                                                upload a new image
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Image Upload Section (Hidden by default) -->
                                    <div id="uploadSection" class="mb-4" style="display: none;">
                                        <div class="card">
                                            <div class="card-header">
                                                <h6><i class="fas fa-upload"></i> Upload New Book Cover</h6>
                                            </div>
                                            <div class="card-body">
                                                <input type="file" class="form-control" id="fileUpload" accept="image/*">
                                                <div class="mt-2">
                                                    <button type="button" class="btn btn-sm btn-primary" onclick="performUpload()">
                                                        <i class="fas fa-upload"></i> Upload
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-secondary" onclick="cancelUpload()">
                                                        Cancel
                                                    </button>
                                                </div>
                                                <div id="uploadProgress" class="mt-2" style="display: none;">
                                                    <div class="progress">
                                                        <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <a href="${pageContext.request.contextPath}/admin?action=books" 
                                           class="btn btn-outline-secondary me-md-2">
                                            <i class="fas fa-times"></i> Cancel
                                        </a>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Update Book
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5><i class="fas fa-eye"></i> Book Preview</h5>
                                </div>
                                <div class="card-body text-center">
                                    <c:choose>
                                        <c:when test="${not empty book.imageUrl}">
                                            <img src="${book.imageUrl}" class="img-fluid book-preview rounded mb-3" alt="${book.title}">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="bg-light rounded mb-3 d-flex align-items-center justify-content-center" style="height: 250px;">
                                                <i class="fas fa-image fa-3x text-muted"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <h6>${book.title}</h6>
                                    <p class="text-muted">by ${book.author}</p>
                                    <c:choose>
                                        <c:when test="${book.hasDiscount()}">
                                            <p>
                                                <span class="text-decoration-line-through text-muted">₹${book.price}</span>
                                                <br><strong class="text-danger">₹${book.discountPrice}</strong>
                                            </p>
                                        </c:when>
                                        <c:otherwise>
                                            <p><strong>₹${book.price}</strong></p>
                                        </c:otherwise>
                                    </c:choose>
                                    <p><small class="text-muted">Stock: ${book.stock}</small></p>
                                    <a href="${pageContext.request.contextPath}/books?action=view&id=${book.bookId}" 
                                       class="btn btn-sm btn-outline-primary" target="_blank">
                                        <i class="fas fa-external-link-alt"></i> View in Store
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function uploadImage() {
            document.getElementById('uploadSection').style.display = 'block';
        }

        function cancelUpload() {
            document.getElementById('uploadSection').style.display = 'none';
            document.getElementById('fileUpload').value = '';
        }

        function performUpload() {
            const fileInput = document.getElementById('fileUpload');
            const file = fileInput.files[0];
            
            if (!file) {
                alert('Please select a file to upload');
                return;
            }

            const formData = new FormData();
            formData.append('file', file);

            const progressBar = document.querySelector('#uploadProgress .progress-bar');
            const progressSection = document.getElementById('uploadProgress');
            
            progressSection.style.display = 'block';
            progressBar.style.width = '0%';

            fetch('${pageContext.request.contextPath}/upload', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                progressBar.style.width = '100%';
                
                if (data.success) {
                    document.getElementById('imageUrl').value = data.fileUrl;
                    alert('Image uploaded successfully!');
                    cancelUpload();
                    // Refresh preview
                    location.reload();
                } else {
                    alert('Upload failed: ' + data.error);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Upload failed. Please try again.');
            })
            .finally(() => {
                setTimeout(() => {
                    progressSection.style.display = 'none';
                }, 1000);
            });
        }

        // Validate discount price
        document.getElementById('discountPrice').addEventListener('input', function() {
            const price = parseFloat(document.getElementById('price').value) || 0;
            const discountPrice = parseFloat(this.value) || 0;
            
            if (discountPrice > price && price > 0) {
                this.setCustomValidity('Discount price cannot be greater than original price');
            } else {
                this.setCustomValidity('');
            }
        });

        document.getElementById('price').addEventListener('input', function() {
            const discountInput = document.getElementById('discountPrice');
            const price = parseFloat(this.value) || 0;
            const discountPrice = parseFloat(discountInput.value) || 0;
            
            if (discountPrice > price && price > 0) {
                discountInput.setCustomValidity('Discount price cannot be greater than original price');
            } else {
                discountInput.setCustomValidity('');
            }
        });
    </script>
</body>
</html>
