 BEGIN TRY 
 Drop Procedure dbo.[D_Purchase_SearchselectAll]
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
CREATE PROCEDURE [dbo].[D_Purchase_SearchselectAll]
	-- Add the parameters for the stored procedure here
	@VendorCD as varchar(13),
	@JanCD as  varchar(150),
	@SKUCD as varchar(320),
	@ItemCD as varchar(350),
	@ItemName as varchar(80),	--searchcase
	@MakerItemCD as varchar(30),--searchcase
	@PurchaseSDate as date,
	@PurchaseEDate as date,
	@PlanSDate as date,
	@PlanEDate as date,
	@OrderSDate as date,
	@OrderEDate as date,
	@ChkValue as tinyint,
	--@ChkSumi as tinyint,
	--@ChkMi as tinyint,
	@StaffCD as varchar(10)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT


--select 
--dp.PurchaseNO,
--CONVERT(VARCHAR(10),dp.PurchaseDate,111)as PurchaseDate,
--(dp.VendorCD+'  '+fv.VendorName) as PurchaseCDName,
--dpd.SKUCD,
--dpd.JanCD,
--dpd.ItemName,
--(dpd.ColorName+' '+dpd.SizeName) as ColorSize,
--dpd.OrderNO,
--CONVERT(VARCHAR(10),dod.ArrivePlanDate , 111) as ArrivePlanDate,
--CONVERT(VARCHAR(10), dp.PaymentPlanDate , 111) as PaymentPlanDate,
--dpd.DeliveryNo
--from D_Purchase dp
--left outer join D_PurchaseDetails dpd on dpd.PurchaseNO=dp.PurchaseNO
--left outer join F_Vendor(getdate())fv on fv.VendorCD=dp.VendorCD
--left outer join D_OrderDetails dod on dod.OrderNO=dpd.OrderNO
--left outer join D_Order do on do.OrderNO=dod.OrderNO
--left outer join F_SKU(getdate()) fsku on dpd.AdminNO=fsku.AdminNO
--left outer join D_PayPlan dpp on dpp.Number=dp.PurchaseNO
--left outer join F_Store(getdate())fst on fst.StoreCD=dp.StoreCD
--left outer join F_Staff(getdate())fstaff on fstaff.StaffCD=dp.StaffCD


--where dpd.DeleteDateTime is null
--AND (@JanCD IS NULL OR  (dpd.JanCD in  (select Item from SplitString(@JanCD,','))))

--and fv.ChangeDate<=dp.PurchaseDate

--and do.DeleteDateTime is null


--and dod.OrderRows=dpd.OrderRows

END
