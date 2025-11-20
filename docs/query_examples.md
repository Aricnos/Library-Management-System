# SQL Query Examples

Comprehensive collection of useful queries for the Library Management System

## Table of contents
1. [Basic Queries](#basic-queries)
2. [Inventory Management](#inventory-namagement)
3. [Member Management](#member-manamgement)
4. [Borrowing Analytics](#borrowing-analytics)
5. [Fine Management](#fine-management)
6. [Advanced Reporting](#advannced-reporting)

---

## Basic Queries

### View all books
SELECT b.book_id, b.title, a.name AS author, c.category_name
FROM Books b
JOIN Author a ON b.author_id = a.author_Id
JOIN Category c ON b.category_id = c.category_id
ORDER BY b.title DESC;

### List all members
SELECT member_id, name_of_member, email, phone_number, address, membership_date, ststus
FROM Members
ORDER BY name_of_member;

### View active borrows
SELECT br.borrow_id, m.name_of_member, b.title, br.borrow_date, br.due_date, br.return_status
FROM Borrow_Records br
JOIN Members m ON br.member_id = m.member_id
JOIN Books b ON br.book_id = b.book_id
WHERE br.return_status in ('Pending', 'Overdue')
ORDER BY br.due_date;

## Inventory Management

### Check book avilability by category
SELECT c.category_name, 
    COUNT(b.book_id) AS total_titles,
    SUM(b.total_copies) AS total_copies
    SUM(b.available_copies) AS available_copies
FROM Category c
LEFT JOIN Books b ON c.category_id = b.category_id
GROUP BY c.category_id, c.category_name
ORDER BY c.category_name;

### Find low stock books
SELECT b.book_id, b.title, a.name AS author, b.total_copies, b.available_copies,
CASE WHEN b.available_copies =0 THEN 'Out of stock'
     WHEN b.available_copies <=2 THEN 'Low stock'
     ELSE 'In stock'
END AS stock_status
FROM Books b 
JOIN Author a ON b.author_id = a.author_id
WHERE b.available_copies <=2
ORDER BY b.available_copies;

### Search book by title
SELECT b.book_id, b.title, a.name AS author, c.category_name
FROM Books b
JOIN Author a ON b.author_id = a.author_id
JOIN Category c ON b.category_id = c.category_id
WHERE b.title LIKE '%Harry Potter%'
ORDER BY b.title;

### Search books by author
SELECT b.book_id, b.title, b.edition, c.category_name, b.available_copies
FROM Books b
JOIN Author a ON b.author_id = a.author_id
JOIN Category c ON b.category_id = c.category_id
WHERE a.name LIKE '%Harper Lee%'
ORDER BY b.title;

## Member Management

### Recently registered members
SELECT member_id, name_of_member, email, phone_number, membership_date, status
FROM Members
WHERE membership_date >= DATE_SUB(CURDATE(),INTERVAL 6 MONTH)
ORDER BY name_of_member;

### Top borrowers (Most active members)
SELECT m.member_id, m.name_of_member, m.email,
COUNT(br.borrow_id) as total_borrows,
COUNT(CASE WHEN br.return_status = 'Pending'
    THEN 1 END) as current_borrows
FROM Members m
LEFT JOIN Borrow_Records br ON m.member_id = br.member_id
GROUP BY m.member_id, m.name_of_member, m.email
HAVING total_borrows > 0
ORDER BY total_borrows DESC
LIMIT 10;

### Members with unpaid fines
SELECT DISTINCT m.member_id, m.name_of_member, m.email,
COUNT(f.fine_id) AS unpaid_fines,
SUM(f.fine_amount) AS total_owed
FROM Members m
JOIN Borrow_Records br ON m.member_id = br.member_id
JOIN Fine f ON br.borrow_id = f.borrow_id
WHERE f.payment_status = 'Unpaid'
GROUP BY m.member_id, m.name_of_member, m.email
ORDER BY total_owed DESC;

### Members borrowing history
SELECT br.borrow_id, b.title, a.name AS author,
br.borrow_date, br.due_date, br.return_date,
br.return_status,
CASE
WHEN br.return_date IS NOT NULL AND br.return_date > br.due_date
THEN DATEDIFF(br.return_date, br.due_date)
WHEN br.return_date IS NULL AND CURDATE() > br.due_date
THEN DATEDIFF(CURDATE(), br.due_date)
ELSE 0
END AS days_overdue
FROM Borrow_Records br
JOIN Books b ON br.book_id = b.book_id
JOIN Author a ON b.author_id = a.author_id
WHERE br.member_id = 1 -- Replace with specific member ID
ORDER BY br.borrow_date DESC;

## Borrowing Analytics

### Most popular books
SELECT b.book_id, b.title, a.name AS author, 
COUNT(br.borrow_id) AS time_borrowed,
b.total_copies
FROM Books b
JOIN Author a ON b.author_id = a.author_id
LEFT JOIN Borrow_Records br ON b.book_id = br.book_id
GROUP BY b.book_id, b.title, a.name, b.total_copies
HAVING time_borrowed >0
ORDER BY time_borrowed DESC
LIMIT 10;

### Borrowing trends per month
SELECT DATE_FORMAT(borrow_date, '%y-%m') AS borrow_month,
    COUNT(borrow_id) AS total_borrows,
    COUNT(DISTINCT member_id) AS unique_borrowers,
    COUNT(DISTINCT book_id) AS unique_books
FROM Borrow_Records
GROUP BY borrow_month
ORDER BY borrow_month;

### Category popularity
SELECT c.category_name,
    COUNT(DISTINCT b.book_id) AS total_titles,
    COUNT(br.borrow_id) AS total_borrows,
    ROUND(AVG(CASE WHEN br.borrow_id IS NOT NULL
    THEN 1 ELSE 0 END), 2) AS avg_borrows_per_title
FROM Category c
LEFT JOIN Books b ON c.category_id = b.category_id
LEFT JOIN Borrow_Records br ON b.book_id = br.book_id
GROUP BY c.category_id, c.category_name
ORDER BY total_borrows DESC;

### Currently borrowed books
SELECT b.book_id, b.title, a.name AS author, c.category_name, b.total_copies,
(b.total_copies -  b.available_copies) AS copies_borrowed
FROM Books b
JOIN Author a ON b.author_id = a.author_id
JOIN Category c ON b.category_id = c.category_id
WHERE b.available_copies < b.total_copies
ORDER BY b.title;

## Fine Management

### All unpaid fines
SELECT f.fine_id, m.member_id, m.name_of_member, b.title, br.due_date, br.return_date,
DATEDIFF(br.return_date, br.due_date) AS days_overdue,
f.fine_amount, f.fine_date
FROM Fine f
JOIN Borrow_Records br ON f.borrow_id = br.borrow_id
JOIN Members m ON br.member_id = m.member_id
JOIN Books b ON br.book_id = b.book_id
WHERE f.payment_status = 'Unpaid'
ORDER BY f.fine_date DESC;

### Fine payment history
SELECT f.fine_id, m.member_id, m.name_of_member, b.title, f.fine_amount, 
f.fine_date, f.payment_status, f.payment_date, 
DATEDIFF(f.payment_date, f.fine_date) AS days_to_payment
FROM Fine f
JOIN Borrow_Records br ON f.borrow_id = br.borrow_id
JOIN Members m ON br.member_id = m.member_id
JOIN Books b ON br.book_id = b.book_id
WHERE f.payment_status = 'Paid'
ORDER BY f.payment_date DESC;

### Total fine summary
SELECT
COUNT(CASE WHEN payment_status = 'Unpaid' THEN 1 END ) AS unpaid_count,
SUM(CASE WHEN payment_status='Unpaid' THEN fine_amount ELSE 0 END) AS total_unpaid,
COUNT(CASE WHEN payment_status='Paid' THEN 1 END) AS paid_count,
SUM(CASE WHEN payment_status='Paid' THEN fine_amount ELSE 0 END) AS total_paid,
COUNT(*) AS total_fines,
SUM(fine_amount) AS total_amount
FROM Fine;

## Advanced Reporting

### Library performance dashborad
SELECT
(SELECT COUNT(*) FROM Books) AS total_books,
(SELECT SUM(total_copies) FROM Books) AS total_book_copies,
(SELECT SUM(available_copies) FROM Books) AS available_copies,
(SELECT COUNT(*) FROM Members WHERE status = 'Active') AS active_members,
(SELECT COUNT(*) FROM Borrow_Records WHERE return_status = 'Pending') AS current_borrows,
(SELECT COUNT(*) FROM Borrow_Records
WHERE return_status = 'Pending' AND due_date < CURDATE()) AS overdue_borrows,
(SELECT COUNT(*) FROM Fine WHERE payment_status = 'Unpaid') AS unpaid_fines,
(SELECT SUM(fine_amount) FROM Fine WHERE payment_status = 'Unpaid') AS unpaid_fine_amount;

### Author statistics
SELECT a.author_id, a.name, a.country, 
COUNT(DISTINCT b.book_id) AS total_books,
SUM(b.total_copies) AS total_copies,
COUNT(br.borrow_id) AS total_borrows,
ROUND(COUNT(br.borrow_id)/COUNT(DISTINCT b.book_id), 2) AS avg_borrows_per_book
FROM Author a
LEFT JOIN Books b ON a.author_id = b.author_id
LEFT JOIN Borrow_Records br ON b.book_id = br.book_id
GROUP BY a.author_id, a.name, a.country
HAVING total_books > 0
ORDER BY total_borrows DESC;

### Overdue books report
SELECT br.borrow_id, m.member_id, m.name_of_member, m.email, m.phone_number,
b.title, a.name AS author, 
br.borrow_date, br.due_date, 
DATEDIFF(CURDATE(), br.due_date) AS days_overdue,
DATEDIFF(CURDATE(), br.due_date)* 0.5 AS projected_fine
FROM Borrow_Records br
JOIN Members m ON br.member_id = m.member_id
JOIN Books b ON br.book_id = b.book_id
JOIN Author a ON b.author_id = a.author_id
WHERE br.return_status IN ('Pending', 'Overdue')
AND br.due_date < CURDATE()
ORDER By days_overdue DESC;