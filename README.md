# SQL-Movies-Database

This SQL Server Management database is based on actual IMDB Movie records with additional information for a working database.

The files include an ERD, a database setup file, and a data wrangling and queries file.

**The ERD comprises of the following:**
 - 10 total tables
 - 3rd normal form
 - Many to many relationships
 - One to many relationships
 - Use of Primary Keys/Foreign Keys
 
**The database setup file comprises of the following:**
 - Use of declaring Foreign Keys with IDENTITY(1,1) which represents starting with value 1 and incrementing 1 each time a new record is created.
 - Connecting many to many relationships using a junction table of Foreign Key
 - Creating additional non clustered indexes for additional processing speed.
 - Inserting data records
 
**The data wrangling and queries file comprises of the following:**
  - Updating the records to replace invalid values with NULL
  - Constraints to validate incoming data records
  - Use of the following:
    - CAST
    - Calculated fields
    - GROUP BY
    - HAVING
    - JOIN
    - ORDER BY
    - Subqueries
    - UNION
  - Created VIEWs for ease of queries
  - Working with VIEWs
  - Stored Procedures
  - Functions
  - IF ELSE statements
  - USER Permissions
