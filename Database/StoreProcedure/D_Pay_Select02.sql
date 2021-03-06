 BEGIN TRY 
 Drop Procedure dbo.[D_Pay_Select02]
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
CREATE PROCEDURE [dbo].[D_Pay_Select02]
    -- Add the parameters for the stored procedure here
    @LargePayNo as varchar(11),
    @PayNo as varchar(11)
    --,
    --@VendorCD varchar(13),
    --@PayeeDate date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    --支払登録
    --画面項目転送表02（第二画面ヘッダ部）
	SELECT CONVERT(varchar, dp.PayPlanDate,111) as PayPlanDate,
		dp.PayeeCD,
        (SELECT top 1 fv.VendorName
            from M_Vendor as fv 
            WHERE fv.VendorCD=dp.PayeeCD
            and fv.MoneyPayeeFlg=1
            and fv.DeleteFlg=0
            and fv.ChangeDate <= dp.PayDate
            order by fv.ChangeDate desc) as VendorName,
        dp.TransferGaku,
        dp.BankCD,
        dp.BranchCD,
        dp.KouzaKBN,
        dp.KouzaNO,
        dp.KouzaMeigi,
        dp.FeeKBN,
        dp.TransferFeeGaku as Fee,
        dp.CashGaku,
        dp.OffsetGaku,
        dp.BillGaku,
        dp.BillNO,
        CONVERT(varchar, dp.BillDate,111) as BillDate,
        dp.ERMCGaku,
        CONVERT(varchar, dp.ERMCDate,111) as ERMCDate,
        dp.OtherGaku1,
        dp.Account1,
        mmp11.Char1 as start1,
        dp.SubAccount1,
        mmp21.Char3 as end1label,
        dp.OtherGaku2,
        dp.Account2,
        mmp12.Char1 as start2,
        dp.SubAccount2,
        mmp22.Char3 as end2label,

    --画面項目転送表03（第二画面明細部）
        dpp.PayPlanNO,
        dpp.PayeeCD,
        CONVERT(varchar, dpp.PayPlanDate,111) as PayPlanDate,
        1 as Chk,
        dpp.Number 'Number',
        CONVERT(varchar, dpp.RecordedDate,111) as RecordedDate,
        dpp.PayPlanGaku,
        dpp.PayConfirmGaku,
        dpd.PayGaku  UnpaidAmount1,
        Isnull(dpp.PayPlanGaku,0)- Isnull(dpp.PayConfirmGaku,0) as UnpaidAmount2

        from D_Pay as dp
        
        left outer join  D_PayDetails as dpd
        on dp.PayNO=dpd.PayNO
        and dpd.DeleteDateTime is null
        
        left outer join  D_PayPlan as dpp 
        on dpp.PayPlanNO=dpd.PayPlanNO
        and dpp.DeleteDateTime is null
        
        left outer join M_MultiPorpose as mmp11 on mmp11.ID = '217' 
                                                and mmp11.[Key] = dp.Account1 
        left Outer join M_MultiPorpose as mmp12 on mmp12.ID = '217' 
                                                and  mmp12.[Key] = dp.Account2
        left outer join M_MultiPorpose as mmp21 on mmp21.ID = '218' 
                                                and mmp21.Char1 = dp.Account1 
                                                and mmp21.Char2 = dp.SubAccount1
        left Outer join M_MultiPorpose as mmp22 on mmp22.ID = '218'     
                                                and  mmp22.Char1 = dp.Account2  
                                                and mmp22.Char2 = dp.SubAccount2

        where dp.DeleteDateTime is null
        and dp.FBCreateDate is null
        and ((@LargePayNo is Null) or (@LargePayNo is not Null and dp.LargePayNO = @LargePayNo))
        and ((@PayNo is null) or (@PayNo is not null and dp.PayNO = @PayNo))
        --and( @VendorCD is null or dp.PayeeCD=@VendorCD)
        --and( @PayeeDate is null or dp.PayPlanDate=@PayeeDate)
        order by dp.PayNO, dpp.RecordedDate, dpp.Number
        ;
END

