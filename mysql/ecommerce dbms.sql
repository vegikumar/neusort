#CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    category_id INT,
    subcategory_id INsys_configT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Category(category_id),
    FOREIGN KEY (subcategory_id) REFERENCES SubCategory(subcategory_id)
);

INSERT INTO Product (title, description, price, stock, category_id, subcategory_id) VALUES 
('iPhone 14', 'Latest Apple smartphone', 999.99, 50, 1, 1), 
('Dell XPS 15', 'High-performance laptop', 1499.99, 30, 1, 2), 
('Men\'s T-shirt', 'Cotton T-shirt in various sizes', 19.99, 100, 2, 3), 
('Women\'s Dress', 'Stylish dress', 49.99, 80, 2, 4), 
('The Great Gatsby', 'Classic fiction novel', 10.99, 200, 3, 5), 
('Educated: A Memoir', 'Non-fiction book by Tara Westover', 14.99, 150, 3, 6);


CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);

INSERT INTO Category (category_name) VALUES ('Electronics'), ('Clothing'), ('Books');

CREATE TABLE SubCategory (
    subcategory_id INT AUTO_INCREMENT PRIMARY KEY,
    subcategory_name VARCHAR(255) NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

INSERT INTO SubCategory (subcategory_name, category_id) VALUES 
('Mobile Phones', 1), 
('Laptops', 1),
('Men\'s Wear', 2), 
('Women\'s Wear', 2), 
('Fiction', 3), 
('Non-Fiction', 3);


CREATE TABLE User (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    shipping_address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO User (name, email, password_hash, shipping_address) VALUES 
('John Doe', 'john.doe@example.com', 'passwordhash123', '123 Main St, City A'), 
('Jane Smith', 'jane.smith@example.com', 'passwordhash456', '456 Oak St, City B');

CREATE TABLE Review (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    product_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

INSERT INTO Review (user_id, product_id, rating, review_text) VALUES 
(1, 1, 5, 'Excellent product! Very satisfied.'), 
(2, 2, 4, 'Good laptop but a bit expensive.'), 
(1, 5, 5, 'A must-read for everyone.');

CREATE TABLE `Order` (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') NOT NULL,
    shipping_details TEXT,
    payment_status ENUM('Pending', 'Completed', 'Failed') NOT NULL,
    total_amount DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

INSERT INTO `Order` (user_id, order_status, shipping_details, payment_status, total_amount) VALUES 
(1, 'Shipped', '123 Main St, City A', 'Completed', 1029.98), 
(2, 'Delivered', '456 Oak St, City B', 'Completed', 49.99);

CREATE TABLE OrderItem (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

INSERT INTO OrderItem (order_id, product_id, quantity, price) VALUES 
(1, 1, 1, 999.99), 
(1, 5, 1, 10.99), 
(2, 4, 1, 49.99);

CREATE TABLE DiscountCode (
    discount_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_percentage DECIMAL(5, 2),
    start_date DATE,
    end_date DATE
);

INSERT INTO DiscountCode (code, discount_percentage, start_date, end_date) VALUES 
('WELCOME10', 10.00, '2024-01-01', '2024-12-31'), 
('SUMMER20', 20.00, '2024-06-01', '2024-08-31');

CREATE TABLE ProductVariation (
    variation_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    variation_type VARCHAR(255) NOT NULL, -- E.g., 'Color', 'Size'
    variation_value VARCHAR(255) NOT NULL, -- E.g., 'Red', 'Medium'
    stock INT NOT NULL,
    price DECIMAL(10, 2),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

INSERT INTO ProductVariation (product_id, variation_type, variation_value, stock, price) VALUES 
(3, 'Size', 'Small', 25, 19.99), 
(3, 'Size', 'Medium', 30, 19.99), 
(3, 'Size', 'Large', 45, 19.99), 
(4, 'Color', 'Red', 20, 49.99), 
(4, 'Color', 'Blue', 60, 49.99);

CREATE TABLE ShoppingCart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

INSERT INTO ShoppingCart (user_id) VALUES 
(1), 
(2);

CREATE TABLE CartItem (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT,
    product_id INT,
    quantity INT NOT NULL,
    FOREIGN KEY (cart_id) REFERENCES ShoppingCart(cart_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

INSERT INTO CartItem (cart_id, product_id, quantity) VALUES 
(1, 2, 1), 
(1, 6, 2), 
(2, 3, 3);

CREATE TABLE Inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    current_stock INT NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

INSERT INTO Inventory (product_id, current_stock) VALUES 
(1, 50), 
(2, 30), 
(3, 100), 
(4, 80), 
(5, 200), 
(6, 150);
