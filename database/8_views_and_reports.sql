-- File: 8_views_and_reports.sql
-- Description: Create views for commonly used queries
-- Author: Palash Chaudhary

-- View for currently borrowed books
CREATE VIEW v_currently_borrowed AS
SELECT 
    br.borrow_id,
    m.name_of_member,
    m.email,
    b.title,
    a.name AS author_name,
    br.borrow_date,
    br.due_date,
    br.return_status,
    DATEDIFF(CURRENT_DATE(), br.due_date) AS days_overdue
FROM Borrow_Records br
JOIN Members m ON br.member_id = m.member_id
JOIN Books b ON br.book_id = b.book_id
JOIN Author a ON b.author_id = a.author_id
WHERE br.return_status IN ('Pending','Overdue');

-- View for book availability
CREATE VIEW v_book_availability AS
SELECT
    b.book_id,
    b.title,
    a.name AS author_name,
    c.category_name,
    b.total_copies,
    b.available_copies,
    (b.total_copies - b.available_copies) AS borrowed_copies
FROM Books b
JOIN Author a ON b.author_id = a.author_id
JOIN Category c ON b.category_id = c.category_id;

-- View for unpaid fines
CREATE VIEW v_unpaid_fines AS
SELECT
    f.fine_id,
    m.name_of_member,
    m.email,
    b.title,
    f.fine_amount,
    f.fine_date,
    f.payment_status
FROM Fine f
JOIN Borrow_Records br ON f.borrow_id = br.borrow_id
JOIN Members m ON br.member_id = m.member_id
JOIN Books b ON br.book_id = b.book_id
WHERE f.payment_status ='Unpaid';
