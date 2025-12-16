<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Book - Admin Panel</title>
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
                            <h2><i class="fas fa-plus"></i> Add New Book</h2>
                            <p class="text-muted">Add a new book to your inventory</p>
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

                    <div class="form-container">
                        <form action="${pageContext.request.contextPath}/admin" method="post" id="addBookForm">
                            <input type="hidden" name="action" value="addBook">
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="title" class="form-label">
                                        <i class="fas fa-book"></i> Book Title *
                                    </label>
                                    <input type="text" class="form-control" id="title" name="title" 
                                           required placeholder="Enter book title">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="author" class="form-label">
                                        <i class="fas fa-user-edit"></i> Author *
                                    </label>
                                    <input type="text" class="form-control" id="author" name="author" 
                                           required placeholder="Enter author name">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="isbn" class="form-label">
                                        <i class="fas fa-barcode"></i> ISBN
                                    </label>
                                    <input type="text" class="form-control" id="isbn" name="isbn" 
                                           placeholder="Enter ISBN (optional)">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="category" class="form-label">
                                        <i class="fas fa-tags"></i> Category
                                    </label>
                                    <select class="form-select" id="category" name="category">
                                        <option value="">Select Category</option>
                                        <option value="Fiction">Fiction</option>
                                        <option value="Non-Fiction">Non-Fiction</option>
                                        <option value="Science Fiction">Science Fiction</option>
                                        <option value="Fantasy">Fantasy</option>
                                        <option value="Romance">Romance</option>
                                        <option value="Mystery">Mystery</option>
                                        <option value="Biography">Biography</option>
                                        <option value="History">History</option>
                                        <option value="Self-Help">Self-Help</option>
                                        <option value="Technology">Technology</option>
                                        <option value="Education">Education</option>
                                        <option value="Children">Children</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label">
                                    <i class="fas fa-align-left"></i> Description
                                </label>
                                <textarea class="form-control" id="description" name="description" rows="4" 
                                          placeholder="Enter book description"></textarea>
                            </div>

                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label for="price" class="form-label">
                                        <i class="fas fa-rupee-sign"></i> Price *
                                    </label>
                                    <input type="number" class="form-control" id="price" name="price" 
                                           required min="0" step="0.01" placeholder="0.00">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="discountPrice" class="form-label">
                                        <i class="fas fa-percentage"></i> Discount Price
                                    </label>
                                    <input type="number" class="form-control" id="discountPrice" name="discountPrice" 
                                           min="0" step="0.01" placeholder="0.00 (optional)">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="stock" class="form-label">
                                        <i class="fas fa-boxes"></i> Stock Quantity *
                                    </label>
                                    <input type="number" class="form-control" id="stock" name="stock" 
                                           required min="0" placeholder="0">
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label">
                                    <i class="fas fa-image"></i> Book Cover Image
                                </label>
                                
                                <!-- Tab Navigation -->
                                <ul class="nav nav-tabs" id="imageTab" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active" id="url-tab" data-bs-toggle="tab" data-bs-target="#url-pane" type="button" role="tab">
                                            <i class="fas fa-link"></i> Image URL
                                        </button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="upload-tab" data-bs-toggle="tab" data-bs-target="#upload-pane" type="button" role="tab">
                                            <i class="fas fa-upload"></i> Upload File
                                        </button>
                                    </li>
                                </ul>
                                
                                <!-- Tab Content -->
                                <div class="tab-content border border-top-0 p-3" id="imageTabContent">
                                    <!-- URL Tab -->
                                    <div class="tab-pane fade show active" id="url-pane" role="tabpanel">
                                        <input type="url" class="form-control" id="imageUrl" name="imageUrl" 
                                               placeholder="https://example.com/book-cover.jpg">
                                        <div class="form-text">Enter a direct URL to the book cover image</div>
                                    </div>
                                    
                                    <!-- Upload Tab -->
                                    <div class="tab-pane fade" id="upload-pane" role="tabpanel">
                                        <input type="file" class="form-control" id="imageFile" accept="image/*">
                                        <div class="form-text">Select an image file from your computer (JPG, PNG, GIF - Max 5MB)</div>
                                        
                                        <!-- Upload Progress -->
                                        <div id="uploadProgress" class="mt-3" style="display: none;">
                                            <div class="progress">
                                                <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style="width: 0%"></div>
                                            </div>
                                            <small class="text-muted">Uploading image...</small>
                                        </div>
                                        
                                        <!-- Upload Result -->
                                        <div id="uploadResult" class="mt-2"></div>
                                    </div>
                                </div>
                                
                                <!-- Image Preview -->
                                <div id="imagePreview" class="mt-3" style="display: none;">
                                    <label class="form-label">Preview:</label>
                                    <div class="border rounded p-2 text-center">
                                        <img id="previewImg" src="" alt="Book cover preview" style="max-width: 200px; max-height: 250px;">
                                    </div>
                                </div>
                            </div>

                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="${pageContext.request.contextPath}/admin?action=books" 
                                   class="btn btn-outline-secondary me-md-2">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Add Book
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Image URL preview
            document.getElementById('imageUrl').addEventListener('input', function() {
                const url = this.value.trim();
                if (url) {
                    showImagePreview(url);
                } else {
                    hideImagePreview();
                }
            });

            // File upload handling
            document.getElementById('imageFile').addEventListener('change', function() {
                const file = this.files[0];
                if (file) {
                    // Validate file type
                    if (!file.type.startsWith('image/')) {
                        showUploadResult('Please select a valid image file.', 'danger');
                        this.value = '';
                        return;
                    }
                    
                    // Validate file size (5MB)
                    if (file.size > 5 * 1024 * 1024) {
                        showUploadResult('File size must be less than 5MB.', 'danger');
                        this.value = '';
                        return;
                    }
                    
                    // Show preview from file
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        showImagePreview(e.target.result);
                    };
                    reader.readAsDataURL(file);
                    
                    // Upload file
                    uploadFile(file);
                }
            });
        
            function uploadFile(file) {
                const formData = new FormData();
                formData.append('file', file);
                
                // Show progress
                const progressContainer = document.getElementById('uploadProgress');
                const progressBar = progressContainer.querySelector('.progress-bar');
                
                progressContainer.style.display = 'block';
                progressBar.style.width = '0%';
                
                // Simulate progress
                let progress = 0;
                const progressInterval = setInterval(() => {
                    progress += Math.random() * 30;
                    if (progress > 90) progress = 90;
                    progressBar.style.width = progress + '%';
                }, 200);
                
                fetch('${pageContext.request.contextPath}/upload', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    clearInterval(progressInterval);
                    progressBar.style.width = '100%';
                    
                    if (data.success) {
                        // Set the uploaded image URL in the imageUrl field
                        document.getElementById('imageUrl').value = data.fileUrl;
                        
                        // Show success message
                        const successMsg = document.createElement('div');
                        successMsg.className = 'alert alert-success mt-2';
                        successMsg.innerHTML = '<i class="fas fa-check-circle"></i> Image uploaded successfully!';
                        progressContainer.appendChild(successMsg);
                        
                        // Hide progress after 2 seconds
                        setTimeout(() => {
                            progressContainer.style.display = 'none';
                            if (successMsg.parentNode) {
                                successMsg.parentNode.removeChild(successMsg);
                            }
                        }, 2000);
                    } else {
                        const errorMsg = document.createElement('div');
                        errorMsg.className = 'alert alert-danger mt-2';
                        errorMsg.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Upload failed: ' + (data.error || 'Unknown error');
                        progressContainer.appendChild(errorMsg);
                        
                        setTimeout(() => {
                            progressContainer.style.display = 'none';
                            if (errorMsg.parentNode) {
                                errorMsg.parentNode.removeChild(errorMsg);
                            }
                        }, 3000);
                    }
                })
                .catch(error => {
                    clearInterval(progressInterval);
                    console.error('Upload error:', error);
                    
                    const errorMsg = document.createElement('div');
                    errorMsg.className = 'alert alert-danger mt-2';
                    errorMsg.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Upload failed: ' + error.message;
                    progressContainer.appendChild(errorMsg);
                    
                    setTimeout(() => {
                        progressContainer.style.display = 'none';
                        if (errorMsg.parentNode) {
                            errorMsg.parentNode.removeChild(errorMsg);
                        }
                    }, 3000);
                });
            }

            function showImagePreview(src) {
                const preview = document.getElementById('imagePreview');
                const img = document.getElementById('previewImg');
                
                img.src = src;
                preview.style.display = 'block';
                
                // Handle image load error
                img.onerror = function() {
                    hideImagePreview();
                    if (src.startsWith('http')) {
                        showUploadResult('Unable to load image from URL. Please check the URL.', 'warning');
                    }
                };
            }

            function hideImagePreview() {
                document.getElementById('imagePreview').style.display = 'none';
            }

            function showUploadResult(message, type) {
                const resultDiv = document.getElementById('uploadResult');
                if (message) {
                    resultDiv.innerHTML = `<div class="alert alert-${type} alert-dismissible fade show" role="alert">
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>`;
                } else {
                    resultDiv.innerHTML = '';
                }
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
        });

        function hideImagePreview() {
            document.getElementById('imagePreview').style.display = 'none';
        }

        function showUploadResult(message, type) {
            const resultDiv = document.getElementById('uploadResult');
            if (message) {
                resultDiv.innerHTML = `<div class="alert alert-${type} alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>`;
            } else {
                resultDiv.innerHTML = '';
            }
        }
    </script>
</body>
</html>
