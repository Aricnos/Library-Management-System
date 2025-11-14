-- File 3: 3_core_crud_operations.sql
-- Description: Basic insert, delete and update queries
-- Author: Palash Chaudhary

-- 1. Simple select queries
-- View all books order by total_copies
SELECT * FROM Books
ORDER BY total_copies DESC;
-- List all members in alphabatical order
SELECT * FROM Members
ORDER BY name_of_member;


-- 2.Conditional or filtered Updates
-- Update books with NULL edition
UPDATE Books
SET edition = 1
WHERE edition = NULL;
-- update auhtor country_name
UPDATE Author
SET country = 'UK' WHERE country = 'United Kingdom';


-- 3. Aggregation queries(Basic 'read' operations)
-- Count total number of books by category
SELECT c.category_name, COUNT(*) FROM Books b
JOIN Category c ON b.category_id = c.category_id
GROUP BY b.category_id
ORDER BY COUNT(*) DESC;
-- Count author by country
SELECT country, COUNT(*) FROM Author
GROUP BY country
ORDER BY country;


--4. Minor maintenance task
-- delete an author by id
DELETE FROM Author
WHERE author_id = 8;
--delete a category by id
DELETE FROM Category 
WHERE category_id = 5;

use library_db;
select * from category;
-- Demonstration Inserts
INSERT INTO Books(title, author_id, edition, category_id, total_copies, available_copies, status)
VALUES('The Blue Umbrella', 29, 7, 1, 8, 8, 'Available'),
('A Suitable Boy', 30, 7, 1, 9, 9, 'Available'),
('The Namesake', 31, 7, 1, 7, 6, 'Available');
