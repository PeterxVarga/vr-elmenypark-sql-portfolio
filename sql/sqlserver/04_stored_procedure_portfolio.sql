-- Modernized T-SQL version of original assignment's Q18 (SQL Server).
-- NOT byte-identical to the student's original stored procedure.
-- Requires only VRElmenyparkPortfolio database and schema.
-- NOT tested on a native SQL Server instance.
-- Financial semantic correction: only Completed payments are counted.
-- Use CREATE OR ALTER on SQL Server 2016 SP1+.
IF DB_NAME() <> N'VRElmenyparkPortfolio'
    THROW 51003, 'Wrong database: expected isolated VRElmenyparkPortfolio', 1;
-- Keep database guard and CREATE PROCEDURE in the SAME batch.
EXEC sys.sp_executesql N'CREATE OR ALTER PROCEDURE dbo.sp_VendegOsszesSikeresBefizetese
    @KeresettVendegID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        CONCAT(g.first_name, N'' '', g.last_name) AS [Vendég neve],
        COALESCE(SUM(CASE WHEN p.payment_status = ''C'' THEN p.amount_paid ELSE 0 END), 0) AS [Sikeres befizetések]
    FROM dbo.GUESTS AS g
    LEFT JOIN dbo.BOOKINGS AS b ON b.guest_id = g.guest_id
    LEFT JOIN dbo.PAYMENTS AS p ON p.booking_id = b.booking_id
    WHERE g.guest_id = @KeresettVendegID
    GROUP BY g.guest_id, g.first_name, g.last_name;
END;';

-- EXEC dbo.sp_VendegOsszesSikeresBefizetese @KeresettVendegID = 1;
