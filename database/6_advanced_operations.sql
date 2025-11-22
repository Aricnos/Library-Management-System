-- File: 6_advanced_queries.sql
-- Description: Advanced queries to make tasks easier and automated
-- Author: Palash Chaudhary

-- Identify members with overdue books
SELECT br.member_id, m.name_of_member, b.title, br.borrow_date, CURRENT_DATE() - br.borrow_date AS overdue_days
FROM Borrow_Records br
JOIN Members m ON br.member_id = m.member_id
JOIN Books b ON br.book_id = b.book_id
WHERE return_status = 'Pending' AND ( CURRENT_DATE() - br.borrow_date) > 14
ORDER BY m.member_id;

-- Procedure to handle book borrowing
DELIMITER $$
CREATE PROCEDURE borrow_book(p_member_id INT, p_book_id INT)
BEGIN
    DECLARE v_available INT;
    -- Check availability:
    SELECT available_copies INTO v_available
    FROM Books
    WHERE book_id = p_book_id;

    -- Conditional check
    IF v_available > 0 THEN
        
        -- UPDATE Borrow_records
        INSERT INTO Borrow_Records(member_id, book_id, borrow_date, due_date)
        VALUES(p_member_id, p_book_id, CURRENT_DATE(), DATE_ADD(CURRENT_DATE(), INTERVAL 14 DAY));

        -- Update book TABLE
        UPDATE Books
        SET available_copies  = available_copies - 1
        WHERE book_id = p_book_id;
        SELECT 'Book borrowed successfully' AS Message;
    ELSE 
        SELECT 'Book is not available' AS Message;
    END IF;
END $$
DELIMITER ;

-- Call the procedure to automatically update tables when book is borrowed
CALL borrow_book(2, 3);


-- Procedure to update book status on return
DELIMITER $$
CREATE PROCEDURE return_book(p_book_id  INT, p_member_id INT, p_borrow_id INT)
BEGIN
    -- Update Books table
    UPDATE Books
    SET available_copies = available_copies + 1, status = 'Available'
    WHERE book_id = p_book_id;

    -- Update Borrow_Records table
    UPDATE Borrow_Records
    SET return_date = CURRENT_DATE(),
        return_status = CASE WHEN CURRENT_DATE() > due_date THEN 'Overdue'
                        ELSE 'Returned' END
    WHERE borrow_id = p_borrow_id;
END $$
DELIMITER ;

-- Call the procedure to automatically upadte the tables when book is returned
CALL return_book(4, 2, 1);



-- Trigger to calculate fine 
DELIMITER $$
CREATE TRIGGER trg_calculate_fine
AFTER UPDATE ON Borrow_Records
FOR EACH ROW
BEGIN
    DECLARE fine_amt DECIMAL(10,2);

    -- Only when return_date is filled AND book was returned late
    IF NEW.return_date IS NOT NULL AND NEW.return_date > NEW.due_date THEN

        -- Calculate fine only if no existing fine record
        IF NOT EXISTS (SELECT 1 FROM Fine WHERE borrow_id = NEW.borrow_id) THEN
            SET fine_amt = DATEDIFF(NEW.return_date, NEW.due_date) * 0.5;

            INSERT INTO Fine(borrow_id, fine_amount, fine_date, payment_status)
            VALUES(NEW.borrow_id, fine_amt, CURRENT_DATE(), 'Unpaid');

        END IF;
    END IF;
END$$
DELIMITER ;
