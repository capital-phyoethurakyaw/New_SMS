 BEGIN TRY 
 Drop Procedure dbo.[D_Purchase_Select]
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
CREATE PROCEDURE [dbo].[D_Purchase_Select]
	-- Add the parameters for the stored procedure here
	@DeliveryNo as varchar(10),
	@VendorCD as varchar(10),
	@PayeeFLg as tinyint,
	@ArrivalDateFrom as varchar(10),
	@ArrivalDateTo as varchar(10),
	@PurchaseDateFrom as varchar(10),
	@PurchaseDateTo as varchar(10),
	@PaymentDueDateFrom as varchar(10),
	@PaymentDueDateTo as varchar(10),
	@StaffCD as varchar(10),
	@ChkValue as tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	--declare @query as varchar(1000)
      select Distinct DP.PurchaseNO,
		CONVERT(VARCHAR(10),DP.PurchaseDate , 111) as PurchaseDate,	 
		DP.VendorCD+' '+(select VendorName from F_Vendor(DP.PurchaseDate) where VendorCD = DP.VendorCD) as VendorName,
		IsNull(FORMAT(Convert(Int,DP.PurchaseGaku), '#,#') ,0)as  PurchaseGaku,
		IsNull(FORMAT(Convert(Int,DP.PurchaseTax), '#,#') ,0)as  PurchaseTax,
		IsNull(FORMAT(Convert(Int,DP.TotalPurchaseGaku), '#,#') ,0)as  TotalPurchaseGaku,
		DP.CommentInStore,
		CONVERT(VARCHAR(10),DP.PaymentPlanDate , 111) as PaymentPlanDate,
		CONVERT(VARCHAR(10),DPP.PayConfirmFinishedDate , 111) as PayConfirmFinishedDate,
		DPD.DeliveryNo,
		(select StoreName from F_Store(DP.PurchaseDate) where StoreCD = DP.StoreCD) as StoreName,
		(select StaffName from F_Staff(DP.PurchaseDate) where StaffCD = DP.StaffCD) as StaffName

	FROM D_Purchase as DP

		Left Outer Join D_PurchaseDetails AS DPD
		ON DPD.PurchaseNO=DP.PurchaseNO
		AND DPD.DeleteDateTime is NULL		--DPD
		AND (@DeliveryNo is Null or (DPD.DeliveryNO =@DeliveryNo))
		AND DPD.DisplayRows = (select Min(DisplayRows) from D_PurchaseDetails )

		Left Outer Join F_Vendor(getdate()) as FV
		ON FV.VendorCD=dp.VendorCD
		AND FV.PayeeCD=@VendorCD

		Left Outer Join  D_OrderDetails AS DOrderD
		ON DOrderD.OrderNO=DPD.OrderNO
		AND DOrderD.OrderRows=DPD.OrderRows
		AND DOrderD.DeleteDateTime is Null
		

		Left Outer Join D_Order AS DO
		ON DO.OrderNO=DOrderD.OrderNO
		AND DO.DeleteDateTime is NUll
		AND (@ArrivalDateFrom is null or (DO.LastArriveDate>=CONVERT(DATE, @ArrivalDateFrom)))
		AND (@ArrivalDateTo is null or  (DO.LastArriveDate<=CONVERT(DATE, @ArrivalDateTo)))


		Left Outer Join D_PayPlan AS DPP
		ON DPP.Number=DP.PurchaseNO
		AND (@ChkValue IS NULL OR  (dpp.PayConfirmFinishedKBN=@ChkValue))
		
		WHERE DP.DeleteDateTime IS NULL
		AND (@PurchaseDateFrom is null or (DP.PurchaseDate>=CONVERT(DATE, @PurchaseDateFrom)))
		AND (@PurchaseDateTo is null or  (DP.PurchaseDate<=CONVERT(DATE, @PurchaseDateTo)))
		AND (@PaymentDueDateFrom is null or (DP.PaymentPlanDate>=CONVERT(DATETIME, @PaymentDueDateFrom)))
		AND (@PaymentDueDateTo is null or  (DP.PaymentPlanDate<=CONVERT(DATETIME, @PaymentDueDateTo)))
		
		AND (@StaffCD is null or  (DP.StaffCD=@StaffCD))
		AND (@VendorCD is null or (DP.VendorCD=@VendorCD))

		Order By
		DP.PurchaseNO ASC
	
END

