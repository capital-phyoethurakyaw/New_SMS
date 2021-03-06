
 BEGIN TRY 
 Drop Procedure dbo.[D_Sales_SelectForRegi]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[D_Sales_SelectForRegi]
    (@OperateMode    tinyint,                 -- 処理区分（1:新規 2:修正 3:削除）
    @SalesNO varchar(11)
    )AS
    
--********************************************--
--                                            --
--                 処理開始                   --
--                                            --
--********************************************--

BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here

        SELECT DH.SalesNO
              ,DH.StoreCD
              ,CONVERT(varchar,DH.SalesDate,111) AS SalesDate
              ,DH.ShippingNO
              ,DH.CustomerCD
              ,DH.CustomerName
              ,DH.CustomerName2
              ,DH.BillingType
              ,ISNULL(DH.Age,0) AS Age	--2019.12.16 add
              ,ISNULL((CASE WHEN DS.ProcessKBN = 4 THEN -1 ELSE 1 END),1) * DH.SalesHontaiGaku AS SalesHontaiGaku
              ,ISNULL((CASE WHEN DS.ProcessKBN = 4 THEN -1 ELSE 1 END),1) * DH.SalesHontaiGaku0 AS SalesHontaiGaku0
              ,ISNULL((CASE WHEN DS.ProcessKBN = 4 THEN -1 ELSE 1 END),1) * DH.SalesHontaiGaku8 AS SalesHontaiGaku8 
              ,ISNULL((CASE WHEN DS.ProcessKBN = 4 THEN -1 ELSE 1 END),1) * DH.SalesHontaiGaku10 AS SalesHontaiGaku10
--              ,DH.SalesTax	明細のデータと間違える
              ,ISNULL((CASE WHEN DS.ProcessKBN = 4 THEN -1 ELSE 1 END),1) * DH.SalesTax8 AS SalesTax8
              ,ISNULL((CASE WHEN DS.ProcessKBN = 4 THEN -1 ELSE 1 END),1) * DH.SalesTax10 AS SalesTax10
--              ,DH.SalesGaku	明細のデータと間違える
              ,DH.LastPoint
              ,DH.WaitingPoint
              ,DH.StaffCD
              ,CONVERT(varchar,DH.PrintDate,111) AS PrintDate
              ,DH.PrintStaffCD
              
              ,DH.InsertOperator
              ,CONVERT(varchar,DH.InsertDateTime) AS InsertDateTime
              ,DH.UpdateOperator
              ,CONVERT(varchar,DH.UpdateDateTime) AS UpdateDateTime
              ,DH.DeleteOperator
              ,CONVERT(varchar,DH.DeleteDateTime) AS DeleteDateTime
              
              ,DM.SalesRows
              ,DM.JuchuuNO
              ,DM.JuchuuRows
              ,DM.ShippingNO
              ,DM.AdminNO
              ,DM.SKUCD
              ,DM.JanCD
              ,(SELECT top 1 M.SKUName FROM M_SKU AS M
                WHERE M.AdminNO = DM.AdminNO
                AND M.ChangeDate <= DH.SalesDate
                AND M.DeleteFLG = 0
                ORDER BY M.ChangeDate DESC) AS SKUName
              ,(SELECT top 1 M.ColorName FROM M_SKU AS M
                WHERE M.AdminNO = DM.AdminNO
                AND M.ChangeDate <= DH.SalesDate
                AND M.DeleteFLG = 0
                ORDER BY M.ChangeDate DESC) AS ColorName
              ,(SELECT top 1 M.SizeName FROM M_SKU AS M
                WHERE M.AdminNO = DM.AdminNO
                AND M.ChangeDate <= DH.SalesDate
                AND M.DeleteFLG = 0
                ORDER BY M.ChangeDate DESC) AS SizeName
              ,(SELECT top 1 ISNULL(M.ColorName,'') + ' ' + ISNULL(M.SizeName,'') FROM M_SKU AS M
                WHERE M.AdminNO = DM.AdminNO
                AND M.ChangeDate <= DH.SalesDate
                AND M.DeleteFLG = 0
                ORDER BY M.ChangeDate DESC) AS ColorSizeName
              ,(CASE (SELECT top 1 M.TaxRateFLG FROM M_SKU AS M
                WHERE M.AdminNO = DM.AdminNO
                AND M.ChangeDate <= DH.SalesDate
                AND M.DeleteFLG = 0
                ORDER BY M.ChangeDate DESC)
                WHEN 1 THEN (Select top 1 T.TaxRate1 FROM M_SalesTax AS T
                        WHERE T.ChangeDate <= DH.SalesDate
                        ORDER BY T.ChangeDate DESC)
                WHEN 2 THEN (Select top 1 T.TaxRate2 FROM M_SalesTax AS T
                        WHERE T.ChangeDate <= DH.SalesDate
                        ORDER BY T.ChangeDate DESC)
                ELSE 0
                END)AS TaxRitsu
              ,(SELECT top 1 M.DiscountKBN FROM M_SKU AS M
                WHERE M.AdminNO = DM.AdminNO
                AND M.ChangeDate <= DH.SalesDate
                AND M.DeleteFLG = 0
                ORDER BY M.ChangeDate DESC) AS DiscountKBN
              ,(SELECT top 1 M.SaleExcludedFlg FROM M_SKU AS M
                WHERE M.AdminNO = DM.AdminNO
                AND M.ChangeDate <= DH.SalesDate
                AND M.DeleteFLG = 0
                ORDER BY M.ChangeDate DESC) AS SaleExcludedFlg
              ,ISNULL((CASE WHEN DS.ProcessKBN = 4 THEN -1 ELSE 1 END),1) * DM.SalesSU AS SalesSU
              ,DM.SalesUnitPrice
              ,DM.TaniCD
              ,ISNULL((CASE WHEN DS.ProcessKBN = 4 THEN -1 ELSE 1 END),1) * DM.SalesHontaiGaku AS SalesHontaiGaku
              ,ISNULL((CASE WHEN DS.ProcessKBN = 4 THEN -1 ELSE 1 END),1) * DM.SalesTax AS SalesTax
              ,ISNULL((CASE WHEN DS.ProcessKBN = 4 THEN -1 ELSE 1 END),1) * DM.SalesGaku AS SalesGaku
              ,DM.SalesTaxRitsu
              ,DM.CommentOutStore
              ,DM.CommentInStore
              ,DM.IndividualClientName
              ,DM.DeliveryNoteFLG
              ,DM.BillingPrintFLG
              ,DM.ProperGaku
              
              ,0 AS SalesHontaiGaku10
              ,0 AS SalesHontaiGaku8
              ,0 AS SalesHontaiGaku0
              ,0 AS SalesTax10
              ,0 AS SalesTax8
              ,0 AS Discount
              ,0 AS Discount10
              ,0 AS Discount8
              ,0 AS Discount0
              ,0 AS DiscountTax10
              ,0 AS DiscountTax8

          FROM D_Sales DH

          LEFT OUTER JOIN D_SalesDetails AS DM ON DH.SalesNO = DM.SalesNO AND DM.DeleteDateTime IS NULL
          
          --返品の訂正時はマイナスをプラスに
          LEFT OUTER JOIN (select ds.SalesNO, ds.ProcessKBN 
                from D_SalesTran As DS  
                inner join (select a.SalesNO, max(a.DataNo) as DataNo
                        from D_SalesTran As a 
                        group by a.SalesNO) as A
                        ON A.SalesNO = DS.SalesNO
                        AND A.DataNo = DS.DataNo
                        ) As DS
            ON DS.SalesNO = DH.SalesNO
          
          WHERE DH.SalesNO = @SalesNO 
              AND DH.DeleteDateTime IS Null
            ORDER BY DH.SalesNO, DM.SalesRows
            ;

END

