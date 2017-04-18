/******************************************************************************************
Sagar Amin
SQL Drill questions
******************************************************************************************/

--1. How many copies of the book title 'the Lost Tribe' at Library Branch 'Sharpstown'
SELECT LB.BranchName, BC.NumberOfCopies
FROM BookCopies AS BC INNER JOIN LibraryBranch AS LB
ON BC.BranchID=LB.BranchID
WHERE BC.BookID = '1'
AND LB.BranchName = 'Sharpstown' 

--2. How many copies of the book title 'the Lost Tribe' at each Library Branch
SELECT Book.BookID, Book.Title --To see which Book ID number the title refers to.
FROM Book

SELECT LB.BranchName, BC.NumberOfCopies
FROM LibraryBranch AS LB INNER JOIN BookCopies AS BC
ON LB.BranchID = BC.BranchID
INNER JOIN Book AS BK
ON BK.BookID = BC.BookID
WHERE BK.Title = 'The Lost Tribe'

--3. Retrieve the names of all borrowers who don't have any books checked out.
SELECT BO.[Name]
FROM Borrower AS BO INNER JOIN BookLoans AS BL
ON BO.CardNumber = BL.CardNumber
WHERE BL.DateOut = NULL

--4. For each book that is loaned out from the "Sharpstown" branch and whose
--   due date is today, retrieve the book title, the borrower's name, and the 
--   borrtower's address.
SELECT BK.Title, BO.[Name]  
FROM Borrower AS BO 
INNER JOIN BookLoans AS BL
ON BO.CardNumber=BL.CardNumber
INNER JOIN Book AS BK 
ON BK.BookID=BL.BookID
WHERE BL.BranchID =5 AND BL.DueDate = '2017-04-17' --BranchID 5 is 'Sharpstown'

--5. For each library branch, retrieve the branch name and the total number of books
--   loaned out from that branch.
SELECT LB.BranchName, COUNT(BL.BookID) AS 'Number of Loans'
FROM LibraryBranch AS LB INNER JOIN BookLoans AS BL
ON LB.BranchID = BL.BranchID
GROUP BY LB.BranchName

--6. Retrieve the names, addresses, and number of books checked out for all borrowers
--   who have more than five books checked out.
SELECT BO.[Name], BO.[Address], COUNT(BL.CardNumber) AS 'No. Books checked out'
FROM Borrower AS BO INNER JOIN BookLoans AS BL
ON BO.CardNumber = BL.CardNumber
GROUP BY BO.[Name], BO.[Address]
HAVING COUNT(BL.CardNumber) > 5

--7. For each book authored (or co-authored) by "Stephen King", retrieve the title and
--   the number of copies owned by the library branch whose name is "Central".
SELECT BA.AuthorName, BK.Title, Count(BC.NumberOfCopies) AS 'No. Copies', LB.BranchName 
FROM Book AS BK INNER JOIN BookCopies AS BC
ON BK.BookID = BC.BookID
INNER JOIN LibraryBranch AS LB
ON LB.BranchID = BC.BranchID
INNER JOIN BookAuthors AS BA
ON BA.BookID = BC.BookID
GROUP BY BA.AuthorName, BK.Title, LB.BranchName
HAVING BA.AuthorName = 'Stephen King' AND LB.BranchName = 'Central'

--Stored Procedure example
CREATE PROC spSearchForBook @Title nVARCHAR(80) = NULL
AS
	SELECT BK.Title, BC.NumberOfCopies,LB.BranchName
	FROM Book AS BK INNER JOIN BookCopies AS BC
	ON BK.BookID = BC.BookID
	INNER JOIN LibraryBranch AS LB
	ON LB.BranchID = BC.BranchID
	WHERE BK.Title = ISNULL(@Title, BK.Title)	
GO