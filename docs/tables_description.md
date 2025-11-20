# Database Table Description

## Overview
The Library Management System consists of 6 interconnected tables that manage books, authors, category, members, borrowing transactions, and fines.

## Table Specifications

### 1. Author Table
Stores information about book authors to distinguish between authors with similar names.

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| author_id | INT | PRIMARY KEY | Unique identifier for each author |
| name | VARCHAR(250) | NOT NULL | Author's full name |
| country | VARCHAR(100) | | Country of origin |
| birth_date | DATE | | Date of birth |

**Purpose**
- Maintain unique author's records
- Support author-based search
- Track author demographics

### 2. Category Table
Contains all book categories available in the library system.

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| category_id | INT | PRIMARY KEY | Unique identifier for each category |
| category_name | VARCHAR(100) | NOT NULL | Name of the category |

**Purpose**
- Classifiy books by genre
- Enable category-based filtering
- Support collection analytics

**Sample Categories**
+--------------------+
| category_name      |
+--------------------+
| Fiction            |
| Classic Literature |
| Mystery            |
| Fantasy            |
| Science Fiction    |
| Non-fiction        |
| Biography          |
| Romance            |
| Contemporary       |
| Indian Literature  |
+--------------------+

### 3. Books Table
Central table tracking all books and their availability status.

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| book_id | INT | PRIMARY KEY | Unique identifier for each book |
| title | VARCHAR(250) | NOT NULL | Book title |
| author_id | INT | FOREIGN KEY | References Author(author_id) ON DELETE SET NULL |
| edition | VARCHAR(50) | | Edition information |
| category_id | INT | FOREIGN KEY | References Category(category_id) ON DELETE SET NULL |
| total_copies | INT | DEFAULT 0 | Total number of copies |
| available_copies | INT | DEFAULT 0 | Currently available copies |

**Purpose**
- Track realistic inventory of books
- Support searches based on category, author, and title
- Keep tracks of available copies

**Bussiness Rules**
- 'available_copies' should never exceed 'total_copies'
- When 'available_copies' = 0 then status should be 'Not Available'
- When Author is deleted, 'author_id' should be set to NULL

**Relationship**
- Author (many-to-one)
- Category (many-to-one)

### 4. Members Table
Stores library member information** and membership status.

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| member_id | INT | PRIMARY KEY | Unique identifier for each member |
| name_of_member | VARCHAR(250) | NOT NULL | Member's full name |
| email | VARCHAR(250) | UNIQUE | Email address |
| phone_number | VARCHAR(20) | | Contact number |
| address | VARCHAR(500) | | Residential address |
| membership_date | DATE | | Date of membership registration |
| status | VARCHAR(50) | DEFAULT 'Active' | Membership status |

**Puropose**
- Track members profile
- Manage members information
- Supoprt member-based queries
- Monitor membership status

**Status**
- Active - member is in good standing and can borrow books
- Inactive - members hasn't renewed membership or accound is temporirly suspended due to unpaid fines

**Status Computation**
- Active - if today <= membership end date
- Inactive - if today > membership end date or unpaid fines > threshold

### 5. Borrow_Records Table
Tracks all book borrowing transactions.

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| borrow_id | INT | PRIMARY KEY | Unique identifier for each transaction |
| member_id | INT | FOREIGN KEY | References Members(member_id) |
| book_id | INT | FOREIGN KEY | References Books(book_id) |
| borrow_date | DATE | NOT NULL | Date book was borrowed |
| due_date | DATE | NOT NULL | Expected return date |
| return_date | DATE | | Actual return date |
| return_status | VARCHAR(50) | DEFAULT 'Borrowed' | Current status |

**Purpose**
- Track borrowing/return transactions
- Enable fine calculations
- Monitor return status
- Track due dates and return dates

**Status Values**
- 'Pending' - Book currently borrowed, not yet returned
- 'Returned' - Book has been returned before or on due data
- 'Overdue' - Past due date, not yet returned

**Relationship**
- Memebrs (Many-to-One)
- Books (Many-to-One)

**Business Logics**
- Defaut load period is 14 days
- 'return_date' is NULL until the book is returned
- Status is automatically determined by stored procedure

### 6. Fine Table
Manages overdue fines and payment tracking.

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| fine_id | INT | PRIMARY KEY | Unique identifier for each fine |
| borrow_id | INT | FOREIGN KEY | References Borrow_Records(borrow_id) |
| fine_amount | DECIMAL(10, 2) | NOT NULL | Fine amount in currency |
| fine_date | DATE | NOT NULL | Date fine was calculated |
| payment_status | ENUM('Paid', 'Unpaid') Payment status |
| payment_date | DATE | | Date payment was made |

**Fine Calculations**
- Rate: ₹0.50 per day overdue
- Automatically calculated by 'trg_calculate_fine' trigger
- Created when book is returned late

**Payment Process**
- Initiaally created with payment_status = 'Unpaid'
- Updated to 'Paid' - when payment is processed
- 'payment_date' is recorded upon payment


## Indexes

For optimal performance, the following indexes are created:

**Books Table:**
- `idx_books_title` on title
- `idx_books_author` on author_id
- `idx_books_category` on category_id
- `idx_books_availability` on (category_id, available_copies)

**Borrow_Records Table:**
- `idx_borrow_member` on member_id
- `idx_borrow_book` on book_id
- `idx_borrow_status` on return_status
- `idx_borrow_date` on (borrow_date, due_date)

**Members Table:**
- `idx_member_email` on email

**Fine Table:**
- `idx_fine_status` on payment_status

## Data Integrity

**Referential Integrity:**
- Foreign keys ensure data consistency
- CASCADE delete for dependent records
- SET NULL for optional relationships

**Check Constraints:**
- Inventory counts cannot be negative
- Status values are restricted to valid options
- Payment status is enumerated

**Unique Constraints:**
- Member email addresses must be unique
- Prevents duplicate registrations
