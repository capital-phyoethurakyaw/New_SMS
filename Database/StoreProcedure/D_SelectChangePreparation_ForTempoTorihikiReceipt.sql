 BEGIN TRY 
 Drop Procedure dbo.[D_Coupon_Select]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  ======================================================================
--       Program Call    XÜæøV[góü@V[góüoÍ
--       Program ID      TempoTorihikiReceipt
--       Create date:    2020.02.24
--    ======================================================================
CREATE PROCEDURE [dbo].[D_SelectChangePreparation_ForTempoTorihikiReceipt]
(
    @DepositNO        int
)AS

--********************************************--
--                                            --
--                 Jn                   --
--                                            --
--********************************************--

BEGIN
    SET NOCOUNT ON;

    -- [Ne[uªcÁÄ¢éêÍí
    IF OBJECT_ID( N'#Temp_Sales', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_Sales];
    END

    -- yÌz[Ne[uì¬
    SELECT * 
      INTO #Temp_Sales
      FROM (SELECT CONVERT(DATE, history.DepositDateTime) RegistDate  -- o^ú
                  ,history.Number                                     -- `[Ô
                  ,sales.SalesNO                                      -- ãÔ
                  ,history.DepositDateTime RegistDateTime             -- o^ú
                  ,history.StoreCD                                    -- XÜCD
                  ,1 DetailOrder                                      -- ¾×\¦
                  ,history.JanCD                                      -- JanCD
                  ,sku.SKUShortName                                   -- ¤i¼
                  ,history.DepositDateTime IssueDate                  -- ­sú
                  ,CASE
                     WHEN history.SalesSU = 1 THEN NULL
                     ELSE history.SalesUnitPrice
                   END AS SalesUnitPrice                              -- P¿
                  ,CASE
                     WHEN history.SalesSU = 1 THEN NULL
                     ELSE history.SalesSU
                   END AS SalesSU                                     -- Ê
                  ,history.SalesGaku                                  -- Ìz
                  ,history.SalesTax                                   -- Åz
                  ,history.SalesTaxRate                               -- Å¦
                  ,history.TotalGaku                                  -- Ìvz
                  ,staff.ReceiptPrint StaffReceiptPrint               -- SV[g\L
                  ,store.ReceiptPrint StoreReceiptPrint               -- XÜV[g\L
              FROM D_DepositHistory history
              LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
              LEFT OUTER JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY AdminNO ORDER BY ChangeDate DESC) as RANK
                                     ,AdminNO
                                     ,SKUCD
                                     ,JanCD
                                     ,ChangeDate
                                     ,SKUShortName
                                     ,DeleteFlg
                                 FROM M_SKU 
                              ) sku ON sku.RANK = 1
                                   AND sku.SKUCD = history.SKUCD
                                   AND sku.JanCD = history.JanCD
                                   AND sku.ChangeDate <= history.AccountingDate
              LEFT OUTER JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY StaffCD ORDER BY ChangeDate DESC) AS RANK
                                     ,StaffCD
                                     ,ChangeDate
                                     ,ReceiptPrint
                                     ,DeleteFlg
                                 FROM M_Staff
                              ) staff ON staff.RANK = 1
                                     AND staff.StaffCD = sales.StaffCD
                                     AND staff.ChangeDate <= sales.SalesDate
              LEFT OUTER JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY StoreCD ORDER BY ChangeDate DESC) as RANK
                                     ,StoreCD
                                     ,StoreName
                                     ,Address1
                                     ,Address2
                                     ,TelephoneNO
                                     ,ChangeDate
                                     ,ReceiptPrint
                                     ,DeleteFlg 
                                 FROM M_Store 
                              ) store ON store.RANK = 1
                                     AND store.StoreCD = sales.StoreCD
                                     AND store.ChangeDate <= sales.SalesDate
             WHERE history.DataKBN = 2
               AND history.DepositKBN = 1
               AND history.CancelKBN = 0
               AND sales.DeleteDateTime IS NULL
               AND sales.BillingType = 1
               AND sku.DeleteFlg = 0
               AND staff.DeleteFlg = 0
               AND store.DeleteFlg = 0
           ) sales;

    SELECT D.Number
          ,D.RegistDate                                                                    -- o^ú
          ,MAX(CASE D.DepositNO WHEN  1 THEN D.DenominationName ELSE NULL END) Name1       -- ÞKõ¼1
          ,MAX(CASE D.DepositNO WHEN  1 THEN D.DepositGaku      ELSE NULL END) Amount1     -- ÞKõz1
          ,MAX(CASE D.DepositNO WHEN  2 THEN D.DenominationName ELSE NULL END) Name2       -- ÞKõ¼2
          ,MAX(CASE D.DepositNO WHEN  2 THEN D.DepositGaku      ELSE NULL END) Amount2     -- ÞKõz2
          ,MAX(CASE D.DepositNO WHEN  3 THEN D.DenominationName ELSE NULL END) Name3       -- ÞKõ¼3
          ,MAX(CASE D.DepositNO WHEN  3 THEN D.DepositGaku      ELSE NULL END) Amount3     -- ÞKõz3
          ,MAX(CASE D.DepositNO WHEN  4 THEN D.DenominationName ELSE NULL END) Name4       -- ÞKõ¼4
          ,MAX(CASE D.DepositNO WHEN  4 THEN D.DepositGaku      ELSE NULL END) Amount4     -- ÞKõz4
          ,MAX(CASE D.DepositNO WHEN  5 THEN D.DenominationName ELSE NULL END) Name5       -- ÞKõ¼5
          ,MAX(CASE D.DepositNO WHEN  5 THEN D.DepositGaku      ELSE NULL END) Amount5     -- ÞKõz5
          ,MAX(CASE D.DepositNO WHEN  6 THEN D.DenominationName ELSE NULL END) Name6       -- ÞKõ¼6
          ,MAX(CASE D.DepositNO WHEN  6 THEN D.DepositGaku      ELSE NULL END) Amount6     -- ÞKõz6
          ,MAX(CASE D.DepositNO WHEN  7 THEN D.DenominationName ELSE NULL END) Name7       -- ÞKõ¼7
          ,MAX(CASE D.DepositNO WHEN  7 THEN D.DepositGaku      ELSE NULL END) Amount7     -- ÞKõz7
          ,MAX(CASE D.DepositNO WHEN  8 THEN D.DenominationName ELSE NULL END) Name8       -- ÞKõ¼8
          ,MAX(CASE D.DepositNO WHEN  8 THEN D.DepositGaku      ELSE NULL END) Amount8     -- ÞKõz8
          ,MAX(CASE D.DepositNO WHEN  9 THEN D.DenominationName ELSE NULL END) Name9       -- ÞKõ¼9
          ,MAX(CASE D.DepositNO WHEN  9 THEN D.DepositGaku      ELSE NULL END) Amount9     -- ÞKõz9
          ,MAX(CASE D.DepositNO WHEN 10 THEN D.DenominationName ELSE NULL END) Name10      -- ÞKõ¼10
          ,MAX(CASE D.DepositNO WHEN 10 THEN D.DepositGaku      ELSE NULL END) Amount10    -- ÞKõz10
          ,tempSales.StaffReceiptPrint                                                     -- SV[g\L
          ,tempSales.StoreReceiptPrint                                                     -- XÜV[g\L
          ,tempSales.StoreCD
      FROM (SELECT ROW_NUMBER() OVER(PARTITION BY history.DepositNO ORDER BY history.DepositDateTime DESC) as DepositNO
                  ,CONVERT(DATE, history.DepositDateTime) RegistDate
                  ,denominationKbn.DenominationName
                  ,history.DepositGaku
                  ,history.Number
              FROM D_DepositHistory history
              LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
              LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
             WHERE history.DepositNO = @DepositNO 
               AND history.DataKBN = 3
               AND history.DepositKBN = 6
               AND history.CancelKBN = 0
               AND sales.DeleteDateTime IS NULL
               AND sales.BillingType = 1
           ) D
      LEFT OUTER JOIN #Temp_Sales tempSales ON tempSales.RegistDate = D.RegistDate 
                                           AND tempSales.Number = D.Number
     GROUP BY D.Number
             ,D.RegistDate
             ,tempSales.StaffReceiptPrint
             ,tempSales.StoreReceiptPrint
             ,tempSales.StoreCD
        ;
END

GO
