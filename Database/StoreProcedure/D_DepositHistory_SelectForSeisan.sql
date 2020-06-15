 BEGIN TRY 
 Drop Procedure dbo.[D_DepositHistory_SelectForSeisan]
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
CREATE PROCEDURE [dbo].[D_DepositHistory_SelectForSeisan]
	-- Add the parameters for the stored procedure here
	@StoreCD as VarChar(6) ,
	@Date as date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Create table #tmp_DepositＨistory
	(
		CashSale  Money,
		Gift  Money,
		CashDeposit Money,
		CashPayment Money,
		DepositTransfer Money,
		DepositCash Money,
		DepositCheck Money,
		DepositBill Money,
		DepositOffset Money,
		DepositAdjustment Money,
		DepositReturns Money,
		DepositDiscount Money,
		DepositCancel Money,
		PaymentTransfer Money,
		PaymentCash Money,
		Paymentcheck Money,
		PaymentBill Money,
		PaymentOffset Money,
		PaymentAdjustment Money,
		Change Money,
		DepositDateTime datetime
	)
		insert into #tmp_DepositＨistory(CashSale,Gift ,CashDeposit ,CashPayment ,DepositTransfer ,DepositCash ,DepositCheck ,DepositBill ,DepositOffset ,DepositAdjustment ,DepositReturns ,DepositDiscount ,DepositCancel ,
	PaymentTransfer ,PaymentCash ,Paymentcheck ,PaymentBill ,PaymentOffset,PaymentAdjustment,Change,DepositDateTime)
	SELECT 
		Sum(CASE 
		  WHEN ddh.DepositKBN = 1 and mdkbn .SystemKBN = 1 THEN ddh.DepositGaku
		  END) AS CashSale,

		Sum(CASE 
		  WHEN ddh.DepositKBN = 7 and mdkbn .SystemKBN = 1 THEN ddh.DepositGaku
		  END) AS Gift,

		Sum(CASE 
		  WHEN (ddh.DepositKBN = 2 or ddh.DepositKBN = 4) and mdkbn .SystemKBN = 1 THEN ddh.DepositGaku
		  END) AS CashDeposit,	
		
		Sum(CASE 
		   WHEN (ddh.DepositKBN = 3 or ddh.DepositKBN = 5) and mdkbn .SystemKBN = 1 THEN ddh.DepositGaku
		   END) AS CashPayment,
		
		Sum(CASE 
		   WHEN (ddh.DepositKBN = 2 or ddh.DepositKBN = 4) and mdkbn .SystemKBN = 5 THEN ddh.DepositGaku
		    END) AS DepositTransfer,

		Sum(CASE 
		    WHEN (ddh.DepositKBN = 2 or ddh.DepositKBN = 4) and mdkbn .SystemKBN = 1 THEN ddh.DepositGaku
		    END) AS DepositCash,

		Sum(CASE 
		  WHEN (ddh.DepositKBN = 2 or ddh.DepositKBN = 4) and mdkbn .SystemKBN = 6 THEN ddh.DepositGaku
		  END) AS DepositCheck,	
		
		Sum(CASE 
		   WHEN (ddh.DepositKBN = 2 or ddh.DepositKBN = 4) and mdkbn .SystemKBN = 8 THEN ddh.DepositGaku
		   END) AS DepositBill,
		
		Sum(CASE 
		   WHEN (ddh.DepositKBN = 2 or ddh.DepositKBN = 4) and mdkbn .SystemKBN = 7 THEN ddh.DepositGaku
		    END) AS DepositOffset,

		Sum(CASE 
		    WHEN (ddh.DepositKBN = 2 or ddh.DepositKBN = 4) and mdkbn .SystemKBN = 9 THEN ddh.DepositGaku
		    END) AS DepositAdjustment,

		Sum(CASE 
		  WHEN ddh.DepositKBN = 9  THEN ddh.DepositGaku
		  END) AS DepositReturns ,

		Sum(CASE 
		  WHEN ddh.DepositKBN = 2 and mdkbn .SystemKBN = 10 THEN ddh.DepositGaku
		  END) AS DepositDiscount,
 
		Sum(CASE 
		  WHEN ddh.DepositKBN = 8  THEN ddh.DepositGaku
		  END) AS DepositCancel,

		Sum(CASE 
		  WHEN (ddh.DepositKBN = 3 or ddh.DepositKBN = 5) and mdkbn .SystemKBN = 5 THEN ddh.DepositGaku
		  END) AS PaymentTransfer,	
		
		Sum(CASE 
		   WHEN (ddh.DepositKBN = 3 or ddh.DepositKBN = 5 )and mdkbn .SystemKBN = 1 THEN ddh.DepositGaku
		   END) AS PaymentCash,
		
		Sum(CASE
		   WHEN (ddh.DepositKBN = 3 or ddh.DepositKBN = 5) and mdkbn .SystemKBN = 6 THEN ddh.DepositGaku
		    END) AS Paymentcheck,

		Sum(CASE 
		    WHEN (ddh.DepositKBN = 3 or ddh.DepositKBN = 5) and mdkbn .SystemKBN = 8 THEN ddh.DepositGaku
		    END) AS PaymentBill,

		Sum(CASE 
		  WHEN (ddh.DepositKBN = 3 or ddh.DepositKBN = 5) and mdkbn .SystemKBN = 7 THEN ddh.DepositGaku
		  END) AS PaymentOffset,	
		
		Sum(CASE 
		   WHEN (ddh.DepositKBN = 3 or ddh.DepositKBN = 5) and mdkbn .SystemKBN = 9 THEN ddh.DepositGaku
		   END) AS PaymentAdjustment,

		(select DepositGaku from D_DepositHistory
		where DepositNO = (select max(ddh1.DepositNO) from D_DepositHistory as ddh1
								where ddh1.DepositKBN=6
								And CAST(ddh1.DepositDateTime AS DATE)=@date
								And ddh1.StoreCD = @StoreCD
								Group by CAST(ddh1.DepositDateTime AS DATE)))as Change,

		 CAST (ddh.DepositDateTime as Date) as DepositDateTime

	FROM D_DepositＨistory ddh
	Left Outer Join M_DenominationKBN mdkbn on mdkbn.DenominationCD = ddh.DenominationCD
	Left Outer Join F_Store(cast(@Date as varchar(10))) fs on fs.StoreCD = ddh.StoreCD and fs.ChangeDate <= ddh.AccountingDate
	--Left Outer Join M_Store ms on ms.StoreCD = ddh.StoreCD and ms.ChangeDate <= ddh.DepositDateTime 
	Where CAST(ddh.DepositDateTime as Date) = @Date 
	and ddh.StoreCD = @StoreCD 
	and fs.DeleteFlg = 0
	and fs.StoreKBN = 1
	Group By CAST (ddh.DepositDateTime as Date)

	Select
	IsNull(FORMAT(Convert(Int, tmpddh.Change),'#,#'),0) as Change,	
	IsNull(FORMAT(Convert(Int,tmpddh.CashSale),'#,#'),0) as CashSale,
	IsNull(FORMAT(Convert(Int,tmpddh.Gift),'#,#'),0) as Gift,
	IsNull(FORMAT(Convert(Int,tmpddh.CashDeposit),'#,#'),0) as CashDeposit,
	IsNull(FORMAT(Convert(Int,tmpddh.CashPayment),'#,#'),0) as CashPayment,
	--dsc.Change  + IsNull(FORMAT(Convert(Int, tmpddh.CashSale - tmpddh.Gift + tmpddh.CashDeposit - tmpddh.CashPayment),'#,#'),0) as CashTotal,
	--IsNull(FORMAT(IsNull(tmpddh.Change,0)+ IsNull(tmpddh.CashSale,0) -  IsNull(tmpddh.Gift,0) + IsNull(tmpddh.CashDeposit,0) - IsNull(tmpddh.CashPayment,0),'#,#'),0) as CashTotal,
	--IsNull(FORMAT(Convert(Int,tmpddh.Change + tmpddh.CashSale - tmpddh.Gift + tmpddh.CashDeposit - tmpddh.CashPayment),'#,#'),0) as CashTotal,
	--IsNull(FORMAT(Convert(Int,IsNull(tmpddh.Change,0) + IsNull(tmpddh.CashSale,0) - IsNull(tmpddh.Gift,0) + IsNull(tmpddh.CashDeposit,0) - IsNull(tmpddh.CashPayment,0)),'#,#'),0) as CashTotal,

	  ---CashStorage
	IsNull(FORMAT(Convert(Int,tmpddh.DepositTransfer),'#,#'),0)as DepositTransfer,
	IsNull(FORMAT(Convert(Int,tmpddh.DepositCash),'#,#'),0)as DepositCash,
	IsNull(FORMAT(Convert(Int,tmpddh.DepositCheck),'#,#'),0)as DepositCheck,
	IsNull(FORMAT(Convert(Int,tmpddh.DepositBill),'#,#'),0)as DepositBill ,
	IsNull(FORMAT(Convert(Int,tmpddh.DepositOffset),'#,#'),0)as DepositOffset,
	IsNull(FORMAT(Convert(Int,tmpddh.DepositAdjustment),'#,#'),0)as DepositAdjustment,
	--IsNull(FORMAT(Convert(Int, IsNull(tmpddh.DepositTransfer,0) + IsNull(tmpddh.DepositCash,0)+ IsNull(tmpddh.DepositCheck,0)+ IsNull(tmpddh.DepositBill,0) + IsNull(tmpddh.DepositOffset,0) + IsNull(tmpddh.DepositAdjustment,0)),'#,#'),0) as DepositTotal,
	--IsNull(FORMAT(Convert(Int,tmpddh.DepositTransfer + tmpddh.DepositCash + tmpddh.DepositCheck + tmpddh.DepositBill + tmpddh.DepositOffset + tmpddh.DepositAdjustment),'#,#'),0) as DepositTotal,
	--(IsNull(tmpddh.DepositTransfer,0) + IsNull(tmpddh.DepositCash,0) + IsNull(tmpddh.DepositCheck,0) + IsNull(tmpddh.DepositBill,0) + IsNull(tmpddh.DepositOffset,0) + IsNull(tmpddh.DepositAdjustment,0)) as DepositTotal,
	--IsNull(FORMAT(Convert(Int, IsNull(tmpddh.DepositTransfer,0) + IsNull(tmpddh.DepositCash,0)+ IsNull(tmpddh.DepositCheck,0)+ IsNull(tmpddh.DepositBill,0) + IsNull(tmpddh.DepositOffset,0) + IsNull(tmpddh.DepositAdjustment,0)),'#,#'),0) as DepositTotal,
	--IsNull(FORMAT(Convert(Int, IsNull(tmpddh.DepositTransfer,0) + IsNull(tmpddh.DepositCash,0)+ IsNull(tmpddh.DepositCheck,0)+ IsNull(tmpddh.DepositBill,0) + IsNull(tmpddh.DepositOffset,0) + IsNull(tmpddh.DepositAdjustment,0)),'#,#'),0) as DepositTotal,
	--IsNull(FORMAT(Convert(Int, IsNull(tmpddh.DepositTransfer,0) + IsNull(tmpddh.DepositCash,0)+ IsNull(tmpddh.DepositCheck,0)+ IsNull(tmpddh.DepositBill,0) + IsNull(tmpddh.DepositOffset,0) + IsNull(tmpddh.DepositAdjustment,0)),'#,#'),0) as DepositTotal,
	--IsNull(FORMAT(Convert(Int, tmpddh.DepositTransfer + tmpddh.DepositCash+tmpddh.DepositCheck+ tmpddh.DepositBill + tmpddh.DepositOffset + tmpddh.DepositAdjustment),'#,#'),0) as DepositTotal,
	
	
	
    IsNull(FORMAT(Convert(Int, tmpddh.DepositTransfer + tmpddh.DepositCash ),'#,#'),0) as total,
	IsNull(FORMAT(Convert(Int,tmpddh.DepositReturns),'#,#'),0)as DepositReturns ,
	IsNull(FORMAT(Convert(Int,tmpddh.DepositDiscount),'#,#'),0)as DepositDiscount,
	IsNull(FORMAT(Convert(Int,tmpddh.DepositCancel),'#,#'),0)as DepositCancel,
	IsNull(FORMAT(Convert(Int,tmpddh.PaymentTransfer),'#,#'),0)as PaymentTransfer,
	IsNull(FORMAT(Convert(Int,tmpddh.PaymentCash),'#,#'),0)as PaymentCash,
	IsNull(FORMAT(Convert(Int,tmpddh.Paymentcheck),'#,#'),0)as PaymentCheck,
	IsNull(FORMAT(Convert(Int,tmpddh.PaymentBill),'#,#'),0)as PaymentBill,
	IsNull(FORMAT(Convert(Int,tmpddh.PaymentOffset),'#,#'),0)as PaymentOffset,
	IsNull(FORMAT(Convert(Int,tmpddh.PaymentAdjustment),'#,#'),0) as PaymentAdjustment ,
    --IsNull(FORMAT(Convert(Int,IsNull(tmpddh.PaymentTransfer,0) +IsNull(tmpddh.PaymentCash,0) + IsNull(tmpddh.Paymentcheck,0) + IsNull(tmpddh.PaymentBill,0) + IsNull(tmpddh.PaymentOffset,0) + IsNull(tmpddh.PaymentAdjustment,0)),'#,#'),0) as TotalPayment
	IsNull(FORMAT(Convert(Int,tmpddh.PaymentTransfer + tmpddh.PaymentCash + tmpddh.Paymentcheck + tmpddh.PaymentBill + tmpddh.PaymentOffset + tmpddh.PaymentAdjustment ),'#,#'),0) as TotalPayment

	

	From  #tmp_DepositＨistory tmpddh 
	Where tmpddh.DepositDateTime = @Date
	
	drop table #tmp_DepositＨistory
END
