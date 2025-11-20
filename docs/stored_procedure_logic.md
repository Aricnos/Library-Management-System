# Stored Procedure Documentation

## Overview

The Library Management System includes two critical stored procedure that automate complex workflows for borrowing and returning books.


## 1. borrow_book Procedure

### Purpose
Automate the complete book borrowing process including availability checking, transaction recording, and inventory updates.

### Signature
CALL borrow_book(p_member_id INT, p_book_id);

### Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| p_member_id | INT | ID of the member borrowing the book |
| p_book_id | INT | ID of the book to be borrowed |

### Logic Flow
START
↓
Check available_copies for p_book_id
↓
IF available_copies > 0
├── Insert new record in Borrow_Records
│ - member_id = p_member_id
│ - book_id = p_book_id
│ - borrow_date = CURRENT_DATE()
│ - due_date = CURRENT_DATE() + 14 days
│ - return_status = 'Pending'
│
├── Update Books table
│ - available_copies = available_copies - 1
│ - status = 'Not available' (if last copy)
│
└── Return success message
ELSE
└── Return "Book is not available" message
END

### Source Code
DELIMITER $$
CREATE PROCEDURE borrow_book(p_member_id INT, p_book_id INT)
BEGIN
    DECLARE v_available INT;

    -- check availability:
    SELECT available_copies INTO v_available
    FROM Books
    WHERE book_id = p_book_id;

    -- Conditional check
    IF v_available > 0 THEN
        
        -- UPDATE Borrow_records
        INSERT INTO Borrow_Records(member_id, book_id, borrow_date, due_date)
        VALUES(p_member_id, p_book_id, CURRENT_DATE(), DATE_ADD(CURRENT_DATE(), INTERVAL 14 DAY));

        -- update book TABLE
        UPDATE Books
        SET available_copies  = available_copies - 1
        WHERE book_id = p_book_id;
        SELECT 'Book borrowed successfully' AS Message;
    ELSE 
        SELECT 'Book is not available' AS Message;
    END IF;
END $$
DELIMITER ;

### Usage Example
-- Member 2 borrows Book 3
CALL borrow_book(2, 3);

### Expected Outcomes
**Success Case:**
- New record in `Borrow_Records` with status 'Pending'
- `available_copies` decreased by 1 in `Books`
- Message: "Book borrowed successfully"

**Failure Case:**
- No changes to database
- Message: "Book is not available"

### Error Handling
- Implicitly checks book availability before proceeding
- Prevents borrowing unavailable books
- Maintains data integrity through transactions


## 2. return_book Procedure

### Purpose
Handles the book return process including inventory updates, status changes, and automatic overdue detection.

### Signature
CALL return_book(p_book_id INT, p_member_id INT, p_borrow_id INT);

### Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| p_book_id | INT | ID of the book being returned |
| p_member_id | INT | ID of the member returning the book |
| p_borrow_id | INT | ID of the specific borrow transaction |

### Logic Flow
START
↓
Update Books table
├── available_copies = available_copies + 1
└── status = 'Available'
↓
Update Borrow_Records table
├── return_date = CURRENT_DATE()
└── return_status =
IF return_date > due_date THEN 'Overdue'
ELSE 'Returned'
↓
Trigger: trg_calculate_fine
├── IF return_status changed to 'Overdue'
│ ├── Calculate fine = days_late × $0.50
│ └── Insert record in Fine table
└── ELSE no fine
END

### Source Code
DELIMITER $$

CREATE PROCEDURE return_book(p_book_id  INT, p_member_id INT, p_borrow_id INT)
BEGIN
    -- update Books table
    UPDATE Books
    SET available_copies = available_copies + 1, status = 'Available'
    WHERE book_id = p_book_id;

    -- update Borrow_Records table
    UPDATE Borrow_Records
    SET return_date = CURRENT_DATE(),
        return_status = CASE WHEN CURRENT_DATE() > due_date THEN 'Overdue' ELSE 'Returned' END
    WHERE borrow_id = p_borrow_id;;
END $$
DELIMITER ;

### Usage Example
-- Return Book 4 for Member 2, Borrow ID 1
CALL return_book(4, 2, 1);

### Expected Outcomes
**On-Time Return:**
- `return_date` set to current date in `Borrow_Records`
- `return_status` = 'Returned'
- `available_copies` increased by 1 in `Books`
- No fine created

**Late Return:**
- `return_date` set to current date in `Borrow_Records`
- `return_status` = 'Overdue'
- `available_copies` increased by 1 in `Books`
- **Fine automatically created** via trigger
  - `fine_amount` = days_overdue × $0.50
  - `payment_status` = 'Unpaid'


