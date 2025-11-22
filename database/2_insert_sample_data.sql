-- File: 2_insert_sample_data.sql
-- Description: Filling tables with sample data
-- Author: Palash Chaudhary


-- 1. Author table
INSERT INTO Author(name, country, birth_date)
VALUES('George Orwell', 'United Kingdom', '1903-06-25'),
('Jane Austen', 'United Kingdom', '1775-12-16'),
('Mark Twain', 'United States', '1835-11-30'),
('J.K. Rowling', 'United Kingdom', '1965-07-31'),
('Haruki Murakami', 'Japan', '1949-01-12'),
('Ernest Hemingway', 'United States', '1899-07-21'),
('F. Scott Fitzgerald', 'United States', '1896-09-24'),
('Agatha Christie', 'United Kingdom', '1890-09-15'),
('Harper Lee', 'United States', '1926-04-28'),
('J.D. Salinger', 'United States', '1919-01-01'),
('J.R.R. Tolkien', 'United Kingdom', '1892-01-03'),
('Ray Bradbury', 'United States', '1920-08-22'),
('Aldous Huxley', 'United Kingdom', '1894-07-26'),
('Herman Melville', 'United States', '1819-08-01'),
('Charlotte Brontë', 'United Kingdom', '1816-04-21'),
('Dan Brown', 'United States', '1964-06-22'),
('Paulo Coelho', 'Brazil', '1947-08-24'),
('Khaled Hosseini', 'Afghanistan', '1965-03-04'),
('George R.R. Martin', 'United States', '1948-09-20'),
('Stieg Larsson', 'Sweden', '1954-08-15'),
('John Green', 'United States', '1977-08-24'),
('Michelle Obama', 'United States', '1964-01-17'),
('Tara Westover', 'United States', '1986-09-27'),
('Susan Cain', 'United States', '1968-03-20'),
('R.K. Narayan', 'India', '1906-10-10'),
('Arundhati Roy', 'India', '1961-11-24'),
('Chetan Bhagat', 'India', '1974-04-22'),
('Amish Tripathi', 'India', '1974-10-18'),
('Ruskin Bond', 'India', '1934-05-19'),
('Vikram Seth', 'India', '1952-06-20'),
('Jhumpa Lahiri', 'India', '1967-07-11');

-- 2. Category table
INSERT INTO Category(category_name)
VALUES('Fiction'),
('Classic Literature'),
('Mystery'),
('Fantasy'),
('Science Fiction'),
('Non-fiction'),
('Biography'),
('Romance'),
('Contemporary'),
('Indian Literature');

-- 3. Books table
INSERT INTO Books(title, author_id, edition, category_id, total_copies, available_copies, status)
VALUES('1984', 1, 1, 2, 10, 8, 'Available'),
('Animal Farm', 1, 2, 2, 5, 2, 'Available'),
('Pride and Prejudice', 2, 1, 8, 6, 4, 'Available'),
('Adventures of Huckleberry Finn', 3, 3, 2, 7, 6, 'Available'),
('Harry Potter and the Sorcerer\'s Stone', 4, 1, 4, 15, 10, 'Available'),
('Kafka on the Shore', 5, 1, 1, 4, 1, 'Available'),
('The Old Man and the Sea', 6, 1, 2, 6, 5, 'Available'),
('The Great Gatsby', 7, 1, 2, 8, 7, 'Available'),
('Murder on the Orient Express', 8, 1, 3, 5, 3, 'Available'),
('To Kill a Mockingbird', 9, 1, 3, 10, 8, 'Available'),
('The Catcher in the Rye', 10, 1, 1, 6, 6, 'Available'),
('The Hobbit', 11, 3, 2, 9, 8, 'Available'),
('Fahrenheit 451', 12, 1, 1, 4, 3, 'Available'),
('Brave New World', 13, 1, 3, 6, 5, 'Available'),
('Moby Dick', 14, 2, 2, 5, 4, 'Available'),
('Jane Eyre', 15, 2, 2, 7, 7, 'Available'),
('The Lord of the Rings', 11, 3, 3, 12, 10, 'Available'),
('The Da Vinci Code', 16, 4, 1, 10, 9, 'Available'),
('Angels and Demons', 16, 4, 1, 10, 8, 'Available'),
('Harry Potter and the Chamber of Secrets', 4, 1, 1, 15, 13, 'Available'),
('Harry Potter and the Prisoner of Azkaban', 4, 1, 1, 15, 14, 'Available'),
('The Alchemist', 17, 5, 2, 6, 5, 'Available'),
('The Kite Runner', 18, 5, 2, 7, 6, 'Available'),
('A Game of Thrones', 19, 3, 1, 9, 9, 'Available'),
('The Girl with the Dragon Tattoo', 20, 4, 1, 8, 8, 'Available'),
('The Fault in Our Stars', 21, 5, 1, 5, 5, 'Available'),
('Becoming', 22, 6, 1, 10, 9, 'Available'),
('Educated', 23, 6, 1, 8, 7, 'Available'),
('Quiet: The Power of Introverts', 24, 6, 1, 6, 6, 'Available'),
('Malgudi Days', 25, 7, 3, 10, 8, 'Available'),
('The God of Small Things', 26, 7, 1, 7, 6, 'Available'),
('Five Point Someone', 27, 7, 1, 12, 11, 'Available'),
('The Immortals of Meluha', 28, 7, 2, 10, 9, 'Available');

-- 4. Members table
INSERT INTO Members(name_of_member, email, phone_number,address, membership_date, status)
VALUES('Alice Johnson', 'alice.johnson@example.com', '+91-00000-00001', '12 Baker Street, Mumbai', '2023-01-15', 'Active'),
('Robert Brown', 'robert.brown@example.com', '+91-00000-00002', '22 Elm Street, Delhi', '2023-03-20', 'Active'),
('Sophia Lee', 'sophia.lee@example.com', '+91-00000-00003', '45 Cherry Lane, Bengaluru', '2023-05-10', 'Active'),
('David Miller', 'david.miller@example.com', '+91-00000-00004', '78 Sunset Blvd, Chennai', '2023-06-18', 'Inactive'),
('Emily Davis', 'emily.davis@example.com', '+91-00000-00005', '34 Pine Street, Hyderabad', '2023-09-02', 'Active');

-- 5. Borrow_Records table
INSERT INTO Borrow_Records(member_id, book_id, borrow_date, due_date,return_date, return_status)
VALUES(1, 1, '2023-09-01', '2023-09-15', '2023-09-10', 'Returned'),
(1, 2, '2023-10-01', '2023-10-15', NULL, 'Pending'),
(2, 3, '2023-09-10', '2023-09-24', '2023-09-23', 'Returned'),
(3, 5, '2023-09-25', '2023-10-09', NULL, 'Overdue'),
(4, 6, '2023-08-20', '2023-09-03', '2023-09-10', 'Returned'),
(5, 7, '2023-09-15', '2023-09-29', '2023-10-02', 'Overdue');

-- 6. Fine table
INSERT INTO Fine(borrow_id, fine_amount, fine_date, payment_status, payment_date)
VALUES(4, 50.00, '2023-10-10', 'Unpaid', NULL),
(6, 30.00, '2023-10-05', 'Paid', '2023-10-07');