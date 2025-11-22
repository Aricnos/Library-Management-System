--File 5: 5_borrow_management_features.sql
-- Description: Queries to keep track of the borrow history
-- Author: Palash Chaudhary

-- Retrieve all the information details of the memebers who registered in last 6 MONTHES
SELECT member_id, name_of_member, email, phone_number, address, membership_date, status
FROM Members
WHERE membership_date >= CURDATE() - INTERVAL 6 MONTH;

-- Top borrowers
SELECT m.member_id, m.name_of_member, COUNT(br.borrow_id) AS time_borrowed
FROM Members m
LEFT JOIN Borrow_Records br ON m.member_id = br.member_id
GROUP BY m.member_id, m.name_of_member
ORDER BY time_borrowed DESC;

-- List all the borrowed books
SELECT b.book_id, b.title, (b.total_copies - b.available_copies) AS borrowed_copies, b.available_copies
FROM Books b JOIN Borrow_Records br ON b.book_id = br.book_id
WHERE br.return_status = 'Pending';

-- List the number of times a book is borrowed
SELECT b.book_id, b.title, count(br.borrow_id) AS times_borrowed
FROM Books b
LEFT JOIN Borrow_Records br ON b.book_id = br.book_id
GROUP BY b.book_id, b.title
ORDER BY times_borrowed DESC;

-- Borrowing trends per month
SELECT DATE_FORMAT(borrow_date, '%Y-%m') AS borrow_month, COUNT(borrow_id) as time_borrowed
FROM Borrow_Records
GROUP BY borrow_month
ORDER BY borrow_month DESC;

-- Update the borrow_records when the book is returned (manually)
UPDATE Borrow_Records 
SET return_date = CURRENT_DATE(), 
return_status = CASE WHEN return_date < due_date THEN 'Returned'
                 WHEN return_date > due_date THEN 'Overdue' END
WHERE borrow_id = 2;

--Retrieve the books that are not yet returned
SELECT br.borrow_id, m.name_of_member, b.book_id, b.title, a.name AS author_name, br.due_date, 
    CASE WHEN CURRENT_DATE() < br.due_date THEN 'Pending' 
    WHEN CURRENT_DATE() > br.due_date THEN 'Overdue' END AS return_status
FROM Borrow_Records br
JOIN Books b ON br.book_id = b.book_id
JOIN Author a ON b.author_id = a.author_id
JOIN Members m ON br.member_id = m.member_id
WHERE br.return_status = 'Pending'
ORDER BY br.due_date ASC;

-- Get a borrow history for a specific member
SELECT br.borrow_id, b.title, br.borrow_date, br.return_date, br.return_status
FROM Borrow_Records br
JOIN Books b ON br.book_id = b.book_id
WHERE br.member_id = 1 --for 'Alice Johnson'
ORDER BY br.borrow_date DESC;

-- View overdue books
SELECT b.book_id, b.title, br.due_date, br.return_status FROM Books b
JOIN Borrow_Records br ON b.book_id = br.book_id
WHERE br.due_date < CURRENT_DATE() AND br.return_status in ('Pending', 'Overdue') 