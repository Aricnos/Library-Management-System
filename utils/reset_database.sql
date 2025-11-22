-- File: reset_database.sql
-- Description: Database reset utility- use with Caution
-- Author: Palash Chaudhary

-- ========================================
-- COMPLETE DATABASE RESET
-- ========================================

USE library_db;

--  Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Drop all tables
DROP TABLE IF EXISTS Fine;
DROP TABLE IF EXISTS Borrow_Records;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Author;

-- Drop views if they exists
DROP VIEW IF EXISTS v_currently_borrowed;
DROP VIEW IF EXISTS v_book_availability;
DROP VIEW IF EXISTS v_unpaid_fines;

-- Drop procedure if they exists
DROP PROCEDURE IF EXISTS borrow_book;
DROP PROCEDURE IF EXISTS return_book;

-- Drop triggers if they exists
DROP TRIGGER IF EXISTS trg_calculate_fine;

-- Enable back the foreign key check
SET FOREIGN_KEY_CHECKS = 1;

-- ========================================
-- RECREATE DATABASE FROM SCRATCH
-- ========================================
-- After running this reset, execute the setup files in order:
-- 1. SOURCE database/1_libmain_schema.sql;
-- 2. SOURCE database/2_insert_sample_data.sql;
-- 3. SOURCE database/3_core_crud_operations.sql;
-- 4. SOURCE database/4_inventory_management_features.sql;
-- 5. SOURCE database/5_borrow_management_features.sql;
-- 6. SOURCE database/6_advanced_operations.sql;
-- 7. SOURCE database/7_indexes_and_optimization.sql;
-- 8. SOURCE database/8_views_and_reports.sql;
