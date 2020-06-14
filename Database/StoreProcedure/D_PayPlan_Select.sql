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
    SELECT (SELECT fs.StaffName FROM F_Staff(GETDATE()) as fs WHERE fs.StaffCD=@Operator
                                                              AND fs.DeleteFlg=0) as 'StaffName',
        fvpm.KouzaCD 'KouzaCD',
        dpp.PayeeCD 'PayeeCD',
        fvp.VendorName 'VendorName',
        CONVERT(varchar, dpp.PayPlanDate,111) as 'PayPlanDate',
        dpp.PayPlanGaku 'PayPlanGaku',
        dpp.PayConfirmGaku 'PayConfirmGaku',
        dpp.PayPlanGaku-dpp.PayConfirmGaku 'PayGaku',
        dpp.PayPlanGaku-dpp.PayConfirmGaku 'TransferGaku',
        Isnull(dbo.F_GetKouzaFee(fvpm.BankCD,fvpm.BranchCD,(dpp.PayPlanGaku-dpp.PayConfirmGaku),fvpm.KouzaCD),0) as 'TransferFeeGaku',
        '1' 'FeeKBN',
        '0' 'Gaku',
        dpp.PayPlanGaku-dpp.PayConfirmGaku 'PayPlan',
        dpp.PayCloseNO 'PayCloseNO',
        dpp.PayCloseDate 'PayCloseDate',
        dpp.HontaiGaku8 'HontaiGaku8',
        dpp.HontaiGaku10 'HontaiGaku10',
        dpp.TaxGaku8 'TaxGaku8',
        dpp.TaxGaku10 'TaxGaku10'
    
    FROM D_PayPlan as dpp 
    left outer join F_Vendor(GETDATE()) as fvp 
    on dpp.PayeeCD=fvp.VendorCD 
    and fvp.PayeeFlg=1 
    and fvp.DeleteFlg=0
	left outer join F_Vendor(GETDATE()) as fvpm 
    on fvp.MoneyPayeeCD=fvpm.VendorCD 
    and fvpm.MoneyPayeeFlg=1
    and fvpm.DeleteFlg=0

    WHERE dpp.PayConfirmFinishedKBN=0
    and dpp.DeleteDateTime is null
    and (@PayeePlanDateFrom is null) or (@PayeePlanDateFrom is not null and dpp.PayPlanDate>=@PayeePlanDateFrom)
    and (@PayeePlanDateTo is null) or (@PayeePlanDateTo is not null and dpp.PayPlanDate<=@PayeePlanDateTo)
    and fvp.MoneyPayeeCD=@PayeeCD
    
    --Group by dpp.PayPlanDate
    order by PayPlanDate asc
    ;
    
END

