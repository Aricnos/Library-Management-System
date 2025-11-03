CREATE DATABASE library_db;
USE library_db;

DROP TABLE IF EXISTS Author;
CREATE TABLE Author (
    author_id INT AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(250) NOT NULL,
    country VARCHAR(100),
    birth_date DATE
);

DROP TABLE IF EXISTS Category;
CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(250) NOT NULL,
    author_id INT,
    edition INT,
    category_id INT, 
    total_copies INT CHECK (total_copies >= 0),
    available_copies INT CHECK (available_copies >= 0),
    status VARCHAR(50) CHECK (status in ('Issued', 'Shelf')) DEFAULT 'Shelf',
    FOREIGN KEY (author_id) REFERENCES Author(author_id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE SET NULL
);

DROP TABLE IF EXISTS Members;
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name_of_member VARCHAR(250) NOT NULL,
    email VARCHAR(250) UNIQUE,
    phone_number VARCHAR(20),
    address VARCHAR(500),
    membership_date DATE,
    status VARCHAR(50)
);

DROP TABLE IF EXISTS Borrow_Records;
CREATE TABLE Borrow_Records (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    book_id INT,
    borrow_date DATE,
    due_date DATE,
    return_date DATE,
    return_status VARCHAR(50) CHECK(return_status in ('Returned', 'Overdue', 'Pending')) DEFAULT 'Pending',
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE
);

-- added fine table for auto-calculate fine feature using trigger
DROP TABLE IF EXISTS Fine;
CREATE TABLE Fine(
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    borrow_id INT NOT NULL,
    fine_amount DECIMAL(10, 2) NOT NULL,
    fine_date DATE NOT NULL,
    payment_status ENUM('Paid', 'Unpaid') DEFAULT 'Unpaid',
    payment_date DATE,
    FOREIGN KEY (borrow_id) REFERENCES Borrow_Records(borrow_id) ON DELETE CASCADE
)

