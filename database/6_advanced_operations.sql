-- File: 6_advanced_queries.sql
-- Description: Advanced queries to make tasks easier and automated
-- Author: Palash Chaudhary

-- identify members with overdue books
SELECT br.member_id, m.name_of_member, b.title, br.borrow_date, CURRENT_DATE() - br.borrow_date AS overdue_days
FROM Borrow_Records br
JOIN Members m ON br.member_id = m.member_id
JOIN Books b ON br.book_id = b.book_id
WHERE return_status = 'Pending' AND ( CURRENT_DATE() - br.borrow_date) > 14
ORDER BY m.member_id;

-- procedure to handle book borrowing
DELIMITER $$
CREATE PROCEDURE borrowBook(p_member_id INT, p_book_id INT)
BEGIN
    DECLARE v_available INT;

    -- check availability:
    SELECT availabile_copies INTO v_available
    FROM Books
    WHERE book_id = p_book_id;

    -- Conditional check
    IF v_available > 0 THEN
        
        -- UPDATE Borrow_records
        INSERT INTO Borrow_Records(member_id, book_id, borrow_date, due_date)
        VALUE(p_member_id, p_book_id, CURRENT_DATE(), DATE_ADD(CURRENT_DATE(), INTERVAL 14 DAY));

        -- update book TABLE
        UPDATE Books
        SET available_copies  = available_copies - 1
        WHERE book_id = p_book_id;
    ELSE 
        SELECT 'Book is not available' AS Message;
    END IF;
END $$
DELIMITER;

-- call the procedure to let it do its magic
EXEC borrowBook (p_member_id = 2, p_booK_id =3)


-- update book status on return
DELIMITER $$

CREATE PROCEDURE returnBook(p_book_id  INT, p_member_id INT, p_borrow_id INT)
BEGINd
    -- update Books table
    UPDATE Books
    SET available_copies = available_copies + 1, status = 'Available'
    WHERE book_id = p_book_id;

    -- update Borrow_Records table
    UPDATE Borrow_Records
    SET return_date = CURRENT_DATE(),
        return_status = CASE WHEN CURRENT_DATE()> due_date THEN 'Overdue' ELSE 'Returned' END
    WHERE book_id = p_book_id and return_status = 'Pending' AND member_id = p_member_id;
END $$
DELIMITER;

-- trigger to calculate fine 
DELIMITER $$
CREATE TRIGGER trg_calculate_fine
AFTER UPDATE ON Borrow_Records
FOR EACH ROW
BEGIN
    -- Run only when a book is returned (not borrowred)
    IF OLD.return_status <> 'Returned' AND NEW.return_status ='Returned' THEN

        DECLARE fine_amt DECIMAL(10, 2);

        IF NEW.return_date > NEW.due_date THEN
        SET fine_amt = DATEDIFF(NEW.return_date, NEW.due_date) * 0.5;

        -- insert values in the  fine TABLE
        INSERT INTO Fine(borrow_id, fine_amount, fine_date, payment_status)
        VALUES(NEW.borrow_id, fine_amt, CURRENT_DATE(), 'Unpaid');
        END IF;
    END IF;
END $$
DELIMITER;
