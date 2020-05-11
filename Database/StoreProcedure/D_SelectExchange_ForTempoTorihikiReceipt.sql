--  ======================================================================
--       ¼Öóüîñæ¾
--  ======================================================================
USE [CAP]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--  ======================================================================
--       Program Call    XÜæøV[góü@V[góüoÍ
--       Program ID      TempoTorihikiReceipt
--       Create date:    2020.02.24
--    ======================================================================
CREATE PROCEDURE [dbo].[D_SelectExchange_ForTempoTorihikiReceipt]
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
                                     ,TelphoneNO
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
          ,D.RegistDate                                                                              -- o^ú
          ,COUNT(*) ExchangeCount                                                                    -- ¼Öñ
          ,MAX(CASE D.DepositNO WHEN  1 THEN D.DenominationName     ELSE NULL END) Name1             -- ¼Ö¼1
          ,MAX(CASE D.DepositNO WHEN  1 THEN D.DepositGaku          ELSE NULL END) Amount1           -- ¼Öz1
          ,MAX(CASE D.DepositNO WHEN  1 THEN D.ExchangeDenomination ELSE NULL END) Denomination1     -- ¼Ö¼1
          ,MAX(CASE D.DepositNO WHEN  1 THEN D.ExchangeCount        ELSE NULL END) Count1            -- ¼Ö1
          ,MAX(CASE D.DepositNO WHEN  2 THEN D.DenominationName     ELSE NULL END) Name2             -- ¼Ö¼2
          ,MAX(CASE D.DepositNO WHEN  2 THEN D.DepositGaku          ELSE NULL END) Amount2           -- ¼Öz2
          ,MAX(CASE D.DepositNO WHEN  2 THEN D.ExchangeDenomination ELSE NULL END) Denomination2     -- ¼Ö¼2
          ,MAX(CASE D.DepositNO WHEN  2 THEN D.ExchangeCount        ELSE NULL END) Count2            -- ¼Ö2
          ,MAX(CASE D.DepositNO WHEN  3 THEN D.DenominationName     ELSE NULL END) Name3             -- ¼Ö¼3
          ,MAX(CASE D.DepositNO WHEN  3 THEN D.DepositGaku          ELSE NULL END) Amount3           -- ¼Öz3
          ,MAX(CASE D.DepositNO WHEN  3 THEN D.ExchangeDenomination ELSE NULL END) Denomination3     -- ¼Ö¼3
          ,MAX(CASE D.DepositNO WHEN  3 THEN D.ExchangeCount        ELSE NULL END) Count3            -- ¼Ö3
          ,MAX(CASE D.DepositNO WHEN  4 THEN D.DenominationName     ELSE NULL END) Name4             -- ¼Ö¼4
          ,MAX(CASE D.DepositNO WHEN  4 THEN D.DepositGaku          ELSE NULL END) Amount4           -- ¼Öz4
          ,MAX(CASE D.DepositNO WHEN  4 THEN D.ExchangeDenomination ELSE NULL END) Denomination4     -- ¼Ö¼4
          ,MAX(CASE D.DepositNO WHEN  4 THEN D.ExchangeCount        ELSE NULL END) Count4            -- ¼Ö4
          ,MAX(CASE D.DepositNO WHEN  5 THEN D.DenominationName     ELSE NULL END) Name5             -- ¼Ö¼5
          ,MAX(CASE D.DepositNO WHEN  5 THEN D.DepositGaku          ELSE NULL END) Amount5           -- ¼Öz5
          ,MAX(CASE D.DepositNO WHEN  5 THEN D.ExchangeDenomination ELSE NULL END) Denomination5     -- ¼Ö¼5
          ,MAX(CASE D.DepositNO WHEN  5 THEN D.ExchangeCount        ELSE NULL END) Count5            -- ¼Ö5
          ,MAX(CASE D.DepositNO WHEN  6 THEN D.DenominationName     ELSE NULL END) Name6             -- ¼Ö¼6
          ,MAX(CASE D.DepositNO WHEN  6 THEN D.DepositGaku          ELSE NULL END) Amount6           -- ¼Öz6
          ,MAX(CASE D.DepositNO WHEN  6 THEN D.ExchangeDenomination ELSE NULL END) Denomination6     -- ¼Ö¼6
          ,MAX(CASE D.DepositNO WHEN  6 THEN D.ExchangeCount        ELSE NULL END) Count6            -- ¼Ö6
          ,MAX(CASE D.DepositNO WHEN  7 THEN D.DenominationName     ELSE NULL END) Name7             -- ¼Ö¼7
          ,MAX(CASE D.DepositNO WHEN  7 THEN D.DepositGaku          ELSE NULL END) Amount7           -- ¼Öz7
          ,MAX(CASE D.DepositNO WHEN  7 THEN D.ExchangeDenomination ELSE NULL END) Denomination7     -- ¼Ö¼7
          ,MAX(CASE D.DepositNO WHEN  7 THEN D.ExchangeCount        ELSE NULL END) Count7            -- ¼Ö7
          ,MAX(CASE D.DepositNO WHEN  8 THEN D.DenominationName     ELSE NULL END) Name8             -- ¼Ö¼8
          ,MAX(CASE D.DepositNO WHEN  8 THEN D.DepositGaku          ELSE NULL END) Amount8           -- ¼Öz8
          ,MAX(CASE D.DepositNO WHEN  8 THEN D.ExchangeDenomination ELSE NULL END) Denomination8     -- ¼Ö¼8
          ,MAX(CASE D.DepositNO WHEN  8 THEN D.ExchangeCount        ELSE NULL END) Count8            -- ¼Ö8
          ,MAX(CASE D.DepositNO WHEN  9 THEN D.DenominationName     ELSE NULL END) Name9             -- ¼Ö¼9
          ,MAX(CASE D.DepositNO WHEN  9 THEN D.DepositGaku          ELSE NULL END) Amount9           -- ¼Öz9
          ,MAX(CASE D.DepositNO WHEN  9 THEN D.ExchangeDenomination ELSE NULL END) Denomination9     -- ¼Ö¼9
          ,MAX(CASE D.DepositNO WHEN  9 THEN D.ExchangeCount        ELSE NULL END) Count9            -- ¼Ö9
          ,MAX(CASE D.DepositNO WHEN 10 THEN D.DenominationName     ELSE NULL END) Name10            -- ¼Ö¼10
          ,MAX(CASE D.DepositNO WHEN 10 THEN D.DepositGaku          ELSE NULL END) Amount10          -- ¼Öz10
          ,MAX(CASE D.DepositNO WHEN 10 THEN D.ExchangeDenomination ELSE NULL END) Denomination10    -- ¼Ö¼10
          ,MAX(CASE D.DepositNO WHEN 10 THEN D.ExchangeCount        ELSE NULL END) Count10           -- ¼Ö10
          ,tempSales.StaffReceiptPrint                                                               -- SV[g\L
          ,tempSales.StoreReceiptPrint                                                               -- XÜV[g\L
          ,tempSales.StoreCD
      FROM (SELECT ROW_NUMBER() OVER(PARTITION BY history.DepositNO ORDER BY history.DepositDateTime DESC) as DepositNO
                  ,CONVERT(DATE, history.DepositDateTime) RegistDate
                  ,denominationKbn.DenominationName
                  ,history.DepositGaku
                  ,history.ExchangeDenomination
                  ,history.ExchangeCount
                  ,history.Number
              FROM D_DepositHistory history
              LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
              LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
             WHERE history.DepositNO = @DepositNO 
               AND history.DataKBN = 3
               AND history.DepositKBN = 4
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
