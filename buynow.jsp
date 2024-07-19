<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Set" %>
<%@ page import="dao.ProductDao" %>
<%@ page import="bean.Product" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Custom CSS -->
    <style>
        .table-striped tbody tr:nth-of-type(odd) {
            background-color: rgba(0, 0, 0, 0.05);
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #004085;
        }
        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }
        .btn-danger:hover {
            background-color: #c82333;
            border-color: #bd2130;
        }
        .btn-success {
            background-color: #28a745;
            border-color: #28a745;
        }
        .btn-success:hover {
            background-color: #218838;
            border-color: #1e7e34;
        }
        .order-summary {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
        }
        .order-summary h4 {
            border-bottom: 1px solid #dee2e6;
            padding-bottom: 10px;
        }
    </style>
    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>
    <div class="container mt-5">
        <h2>Checkout</h2>
        <div class="order-summary">
            <h4>Order Summary</h4>
            <%
                // Get the session object
                HttpSession httpsession = request.getSession();

                // Get the cart from the session
                Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
                if (cart == null) {
                    cart = new HashMap<>();
                }

                // Get the product IDs from the cart
                Set<Integer> productIds = cart.keySet();
                Map<Integer, Product> products = new HashMap<>();
                if (!productIds.isEmpty()) {
                    try {
                        products = ProductDao.getProductsByIds(productIds);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }

                double totalAmount = 0;
                for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                    int productId = entry.getKey();
                    int quantity = entry.getValue();
                    Product product = products.get(productId);
                    if (product != null) {
                        double totalPrice = product.getPrice() * quantity;
                        totalAmount += totalPrice;
            %>
            <div class="row mb-3">
                <div class="col-md-8">
                    <p><strong><%= product.getName() %></strong> (x<%= quantity %>)</p>
                </div>
                <div class="col-md-4 text-right">
                    <p><%= totalPrice %></p>
                </div>
            </div>
            <%
                    }
                }
            %>
            <hr>
            <div class="row">
                <div class="col-md-8">
                    <h5>Total Amount:</h5>
                </div>
                <div class="col-md-4 text-right">
                    <h5>&#x20A8; <%= totalAmount %></h5>
                </div>
            </div>
        </div>
        <div class="text-right mt-4">
            <form action="placeOrder.jsp" method="post">
                <button type="submit" class="btn btn-success btn-lg">Place Order</button>
            </form>
        </div>
    </div>
</body>
</html>