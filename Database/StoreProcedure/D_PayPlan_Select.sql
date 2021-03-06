 BEGIN TRY 
 Drop Procedure dbo.[D_PayPlan_Select]
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
CREATE PROCEDURE [dbo].[D_PayPlan_Select]
    -- Add the parameters for the stored procedure here

    @PayeePlanDateFrom date,
    @PayeePlanDateTo date,
    @Operator varchar(11),
    @PayeeCD varchar(13)
    
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    --支払登録
    --画面項目転送表04（第一画面明細部）
    SELECT 
    	'' AS PayNO,
    	(SELECT fs.StaffName FROM F_Staff(GETDATE()) as fs WHERE fs.StaffCD=@Operator
                                                              AND fs.DeleteFlg=0) as 'StaffName',
        MAX(fvpm.KouzaCD) KouzaCD,
        dpp.PayeeCD AS PayeeCD,
        MAX(fvp.VendorName) 'VendorName',
        CONVERT(varchar, dpp.PayPlanDate,111) as 'PayPlanDate',
        SUM(dpp.PayPlanGaku) as 'PayPlanGaku',
        SUM(dpp.PayConfirmGaku) as 'PayConfirmGaku',
        SUM(dpp.PayPlanGaku-dpp.PayConfirmGaku) as 'PayGaku',
        SUM(dpp.PayPlanGaku-dpp.PayConfirmGaku) as 'TransferGaku',
        Isnull(dbo.F_GetKouzaFee(MAX(fvpm.BankCD),MAX(fvpm.BranchCD),SUM(dpp.PayPlanGaku-dpp.PayConfirmGaku),MAX(fvpm.KouzaCD)),0) as 'TransferFeeGaku',
        '自社' as 'FeeKBN',	--1：自社、2：相手負担
        0 as 'Gaku',
        0 as 'PayPlan',	--SUM(dpp.PayPlanGaku-dpp.PayConfirmGaku)
        MAX(dpp.PayCloseNO) as 'PayCloseNO',
        MAX(CONVERT(varchar, dpp.PayCloseDate,111)) as 'PayCloseDate',
        SUM(dpp.HontaiGaku8) as 'HontaiGaku8',
        SUM(dpp.HontaiGaku10) as 'HontaiGaku10',
        SUM(dpp.TaxGaku8) as 'TaxGaku8',
        SUM(dpp.TaxGaku10) as 'TaxGaku10',

		--画面項目転送表05（第二画面ヘッダ部）
        MAX(fvpm.BankCD) as 'BankCD',
        MAX(fb.BankName) as 'BankName',
        MAX(fvpm.BranchCD) as 'BranchCD',
        MAX(fbs.BranchName) as 'BranchName',
        MAX(fvpm.KouzaKBN) as 'KouzaKBN',
        MAX(fvpm.KouzaNO) as 'KouzaNO',
        MAX(fvpm.KouzaMeigi) as 'KouzaMeigi',
        1 as 'FeeKBNVal',	--1：自社、2：相手負担
        --dbo.F_GetKouzaFee(fvpm.BankCD,fvpm.BranchCD,t1.PayPlanGaku,fvpm.KouzaCD) as 'Fee',
        0 as 'CashGaku',
        0 as 'OffsetGaku',
        0 as 'BillGaku',
        '' as 'BillDate',
        '' as 'BillNO',
        0 as 'ERMCGaku',
        '' as 'ERMCNO',
        '' as 'ERMCDate',
        0 as 'OtherGaku1',
        '' as 'Account1',
        '' as 'start1',
        '' as 'SubAccount1',
        '' as 'end1label',
        0 as 'OtherGaku2',
        '' as 'Account2',
        '' as 'start2',
        '' as 'SubAccount2' ,
        '' as 'end2label'
            
    FROM D_PayPlan as dpp 
    left outer join F_Vendor(GETDATE()) as fvp 
    on dpp.PayeeCD=fvp.VendorCD 
    and fvp.PayeeFlg=1 
    and fvp.DeleteFlg=0
	left outer join F_Vendor(GETDATE()) as fvpm 
    on fvp.MoneyPayeeCD=fvpm.VendorCD 
    and fvpm.MoneyPayeeFlg=1
    and fvpm.DeleteFlg=0
    left outer join F_Bank(GETDATE()) fb 
    on fb.BankCD=fvpm.BankCD 
    and fb.DeleteFlg=0
    
    left outer join F_BankShiten(GETDATE()) fbs 
    on fbs.BranchCD=fvpm.BranchCD
    and fbs.BankCD=fvpm.BankCD
    and fbs.DeleteFlg=0
    
    WHERE dpp.PayConfirmFinishedKBN=0
    and dpp.DeleteDateTime is null
    and dpp.PayCloseNO IS NOT NULL
    and ((@PayeePlanDateFrom is null) or (@PayeePlanDateFrom is not null and dpp.PayPlanDate>=@PayeePlanDateFrom))
    and ((@PayeePlanDateTo is null) or (@PayeePlanDateTo is not null and dpp.PayPlanDate<=@PayeePlanDateTo))
    and fvp.MoneyPayeeCD = (CASE WHEN @PayeeCD <> '' THEN @PayeeCD ELSE fvp.MoneyPayeeCD END)
    
    Group by dpp.PayeeCD, dpp.PayPlanDate
    order by dpp.PayeeCD, dpp.PayPlanDate asc
    ;
    
END

