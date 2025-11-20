-- File 7: 7_indexes_and_optimization.sql
-- Description: Add indexes for query performance optimization
-- Author: Palash Chaudhary

-- Indexes on frequently searched columns
CREATE INDEX idx_books_title ON Books(title);
CREATE INDEX idx_books_author ON Books(author_id);
CREATE INDEX idx_books_category ON Books(category_id);

-- Indexes for borrow records queries
CREATE INDEX idx_borrow_member ON Borrow_Records(member_id);
CREATE INDEX idx_borrow_book ON Borrow_Records(book_id);
CREATE INDEX idx_borrow_status ON Borrow_Records(return_status);
CREATE INDEX idx_borrow_date ON Borrow_Records(borrow_date, due_date);

-- Index for member email lookup
CREATE INDEX idx_member_email ON Members(email);

-- Index for fine_queries
CREATE INDEX idx_fine_status ON Fine(payment_status);

-- Composite index for common queries
CREATE INDEX idx_books_availability ON Books(category_id, available_copies);