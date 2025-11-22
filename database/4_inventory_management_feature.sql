-- File: 4_inventory_management_feature.sql
-- Description: Queries to manage and organize the inventory of books
-- Author: Palash Chaudhary

-- List all the books that are available for borrowung (Availability Check)
SELECT b.book_id, b.title, a.name AS author, c.category_name, b.available_copies
FROM Books b
JOIN Author a ON b.author_id = a.author_id
JOIN Category c ON b.category_id = c.category_id
WHERE b.available_copies > 0
ORDER BY b.title;

-- Update available copies after a book is borrowed
UPDATE Books 
SET available_copies = available_copies - 1,
    status = CASE 
        WHEN (available_copies - 1) > 0 THEN 'Available'
        WHEN (available_copies - 1) = 0 THEN 'Not available' 
    END
WHERE book_id = 2;

-- Update available copies after a book is returned
UPDATE Books 
SET available_copies = available_copies +1, status = 'Available'
WHERE book_id = 3;

-- Check total books per category
SELECT c.category_id, c.category_name, 
    CASE WHEN SUM(b.total_copies) > 0 THEN SUM(b.total_copies) 
    ELSE 0 END AS total_books 
FROM Category c 
LEFT JOIN Books b ON b.category_id = c.category_id
GROUP BY c.category_id;

-- Search book_id by title
SELECT book_id, title
FROM Books 
WHERE title LIKE '%Harry Potter%';

-- Search book_id by author or category
SELECT b.book_id, b.title
FROM Books b
JOIN Author a on b.author_id = a.author_id
JOIN Category c ON b.category_id = c.category_id
WHERE a.name LIKE '%Haruki Murakami%'
OR c.category_name LIKE '%Fantasy%';

-- Retrieve all books by category
SELECT b.book_id, b.title, c.category_name, a.name AS author, b.available_copies
FROM Books b
JOIN Category c on b.category_id = c.category_id
JOIN Author a on b.author_id = a.author_id
WHERE c.category_name LIKE '%Fiction%'
ORDER BY b.title;

-- Check if the book is in stock or not
SELECT book_id, title, 
    CASE WHEN available_copies >3 THEN 'In Stock'
    WHEN available_copies <3 and available_copies >0 THEN 'Low Stock'
    ELSE 'Out of Stock' END AS stock_status
FROM Books;

-- Summary table of books based on number of times they are borrowed
CREATE TABLE Book_Issue_Summary AS
SELECT b.book_id, b.title, a.name AS author, c.category_name, COUNT(br.borrow_id) AS time_borrowed
FROM Books b
LEFT JOIN Borrow_Records br ON b.book_id = br.book_id
JOIN Author a ON b.author_id = a.author_id
JOIN Category c ON b.category_id = c.category_id
GROUP BY b.book_id, b.title, a.name, c.category_name;