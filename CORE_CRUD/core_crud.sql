-- Core CRUD operations for databas schema
INSERT INTO Author(name, country, birth_date)
VALUES ('J.K. Rowling', 'United Kingdom', '1965-07-31'),
         ('George R.R. Martin', 'United States', '1948-09-20'),
         ('Haruki Murakami', 'Japan', '1949-01-12'),
         ('Isabel Allende', 'Chile', '1942-08-02'),
         ('Chinua Achebe', 'Nigeria', '1930-11-16');

-- VIEW all authors
SELECT * FROM Author;

-- Update author details by id
UPDATE Author
SET name = 'Joanne Kathleen Rowling', country ='UK', birth_date = '1965-07-31'
WHERE author_id = 1;

-- View The update author
SELECT * FROM Author;

-- Delete an author by id
DELETE FROM Author WHERE author_id = 5;

-- VIEW all authors after delete
SELECT * FROM Author;



-- Add a new category
INSERT INTO Category(category_name)
VALUES ('Fantasy'),
       ('Science Fiction'),
       ('Mystery'),
       ('Romance'),
       ('Non-Fiction'),
       ('Historical Fiction'),
       ('Thriller'),
       ('Biography'),
       ('Self-Help'),
       ('Young Adult');
-- VIEW all categories
SELECT * FROM Category;

-- Update category by id
UPDATE Category SET category_name = 'Sci-Fi' WHERE category_id = 2;

-- View the updated category
SELECT * FROM Category;

-- DELETE a category by id
DELETE FROM Category WHERE category_id = 10;

-- View all categories after delete
SELECT * FROM Category;


-- Add a new book
INSERT INTO Books(title, author_id, edition, category_id, total_copies, available_copies, status)
VALUES ('Harry Potter and the Philosopher''s Stone', 1, 1, 1, 10, 10, 'Shelf'),
       ('A Game of Thrones', 2, 1, 1, 8, 8, 'Shelf'),
       ('Norwegian Wood', 3, 1, 5, 5, 5, 'Shelf'),
       ('The House of the Spirits', 4, 1, 6, 7, 7, 'Shelf');

-- VIEW all books
SELECT * From Books;

-- Update a book by id
UPDATE Books
SET title = 'Harry Potter and the Sorcerer''s Stone', author_id = 1, edition = 2, category_id = 1, total_copies = 12, available_copies = 12, status = 'Shelf'
WHERE book_id = 1;

-- View the updated book
SELECT * FROM Books;

-- Delete a book by id
DELETE FROM Books WHERE book_id = 4;

-- View all books after delete
SELECT * FROM Books;

-- Add a new memeber
INSERT INTO Members(name_of_member, email, phone_number, address, membership_date, status)
VALUES  ('Alice Johnson', 'alice_tong@email.com', '123-456-7890', '123 Maple St, Springfield', '2023-01-15', 'Active'),
        ('Bob Smith', 'bob_sacromato@email.com', '987-654-3210', '456 Oak St, Springfield', '2023-02-20', 'Active'),
        ('Cathy Brown', 'cathy_bowmna@email.com', '555-666-7777', '789 Pine St, Springfield', '2023-03-10', 'Inactive'),
        ('David Wilson', 'david_shwinner@email.com', '444-555-6666', '321 Birch St, Springfield', '2023-04-05', 'Active'),
        ('Eva Green', 'evan_stewen@email.com', '333-444-5555', '654 Cedar St, Springfield', '2023-05-12', 'Inactive'),
        ('Frank Harris', 'horror_frank@email.com', '222-333-4444', '987 Spruce St, Springfield', '2023-06-18', 'Active'),
        ('Grace Lee', 'grace_lee@email.com', '111-222-3333', '159 Walnut St, Springfield', '2023-07-22', 'Active');

-- Voew all members
SELECT * FROM Members;

-- Update member using id
UPDATE Members
SET name_of_member = 'Alice M. Johnson', email = 'alice_wonderland@email.com', phone_number = '123-456-7899', address = '123 Maple St, Springfield', membership_date = '2023-01-15', status = 'Active'
WHERE member_id = 1;

-- ciew updated member
SELECT * FROM Members;

-- delete a member by id
DELETE FROM Members WHERE member_id =4;

-- view all members after delete
SELECT * FROM Members;

