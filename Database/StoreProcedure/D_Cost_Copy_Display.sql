BEGIN TRY 
Drop Procedure [dbo].[D_Cost_Copy_Display]
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
CREATE PROCEDURE [dbo].[D_Cost_Copy_Display]
	-- Add the parameters for the stored procedure here
	@CostNO as VARCHAR(11),
	@VendorCD as varchar(13),
	@RecordDate as varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @PlanDate as varchar(10), @Yoteibi as varchar(10);

	--EXEC @PlanDate = Fnc_PlanDate_SP 1, @VendorCD, @RecordDate, 0, @Yoteibi = @Yoteidate

	EXEC Fnc_PlanDate_SP
		1,
		@VendorCD,
		@RecordDate,
		0,
		@Yoteibi OUTPUT;
             
    -- Insert statements for procedure here
	select 
		ROW_NUMBER() OVER (Order By D.CostRows ASC) AS [No],
		(SELECT VendorCD FROM F_Vendor(GetDate())WHERE VendorCD = C.PayeeCD) AS [VendorCD],
		(SELECT VendorName FROM F_Vendor(GetDate())WHERE VendorCD = C.PayeeCD) AS [VendorName],
		CONVERT(VARCHAR(10),GETDATE(),111) AS [RecordedDate],
		--CONVERT(VARCHAR(10),(select dbo.Fnc_PlanDate_SP( 1,@VendorCD,@RecordDate,0))) as PayPlanDate,
		@Yoteibi AS [PayPlanDate],
		(SELECT StaffCD FROM F_Staff(GetDate())WHERE StaffCD = C.StaffCD) AS [StaffCD],
		(SELECT StaffName FROM F_Staff(GetDate())WHERE StaffCD = C.StaffCD) AS [StaffName],
		D.CostCD,
		D.Summary,
		(SELECT [Key] FROM M_MultiPorpose WHERE ID = 209 and [Key] = D.DepartmentCD) AS [DepartmentCD],
		(SELECT Char1 FROM M_MultiPorpose WHERE ID = 209 and [Key] = D.DepartmentCD) AS [Department],
		D.CostGaku,
		C.TotalGaku
	FROM F_Cost(GETDATE()) C
	LEFT Outer Join D_CostDetails D ON C.CostNO = D.CostNO
	WHERE C.CostNO = @CostNO
	AND C.DeleteDateTime IS NULL
	AND D.DeleteDateTime IS NULL
END
GO
