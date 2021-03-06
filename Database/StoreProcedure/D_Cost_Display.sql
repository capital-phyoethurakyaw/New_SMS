BEGIN TRY 
Drop Procedure [dbo].[D_Cost_Display]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[D_Cost_Display]
	-- Add the parameters for the stored procedure here
	@CostNO as VARCHAR(11)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		ROW_NUMBER() OVER (Order By D.CostRows ASC) AS No,
		(SELECT VendorCD FROM F_Vendor(C.RecordedDate)WHERE VendorCD = C.PayeeCD) AS VendorCD,
		(SELECT VendorName FROM F_Vendor(C.RecordedDate)WHERE VendorCD = C.PayeeCD) AS VendorName,
		CONVERT(VARCHAR(10),C.RecordedDate,111) AS RecordedDate,
		CONVERT(VARCHAR(10),C.PayPlanDate,111) AS PayPlanDate,
		(SELECT StaffCD FROM F_Staff(C.RecordedDate)WHERE StaffCD = C.StaffCD) AS StaffCD,
		(SELECT StaffName FROM F_Staff(C.RecordedDate)WHERE StaffCD = C.StaffCD) AS StaffName,
		D.CostCD,
		D.Summary,
		(SELECT Char1 FROM M_MultiPorpose WHERE ID = 209 and [Key] = D.DepartmentCD) AS Department,
		(SELECT [Key] FROM M_MultiPorpose WHERE ID = 209 and [Key] = D.DepartmentCD) AS DepartmentCD,
		(CASE WHEN CONVERT(VARCHAR,CONVERT(int,D.CostGaku)) = '0' THEN NULL 
			  ELSE CONVERT(VARCHAR,CONVERT(int,D.CostGaku)) END) AS CostGaku,
		CONVERT(VARCHAR,CONVERT(int,C.TotalGaku)) AS TotalGaku
	FROM F_Cost(GETDATE()) C
	LEFT OUTER JOIN D_CostDetails D ON C.CostNO = D.CostNO
	WHERE C.CostNO = @CostNO
	AND C.DeleteDateTime IS NULL
	AND D.DeleteDateTime IS NULL
END
GO
