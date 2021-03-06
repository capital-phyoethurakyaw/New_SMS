SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--  ======================================================================
--       Program Call    店舗レジ ジャーナル印刷
--       Program ID      TempoRegiPoint
--       Create date:    2019.12.22
--       Update date:    2020.06.06  雑入金、雑支払、両替仕様変更
--                       2020.07.17  件数が増えるを修正
--  ======================================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'D_SelectData_ForTempoRegiJournal')
  DROP PROCEDURE [dbo].[D_SelectData_ForTempoRegiJournal]
GO


CREATE PROCEDURE [dbo].[D_SelectData_ForTempoRegiJournal]
(
    @StoreCD   varchar(4),
    @DateFrom  varchar(10),
    @DateTo    varchar(10)
)AS

--********************************************--
--                                            --
--                 処理開始                   --
--                                            --
--********************************************--

BEGIN
    SET NOCOUNT ON;

    -- 【店舗精算】ワークテーブル１作成
    SELECT * 
      INTO #Temp_D_StoreCalculation1
      FROM (
            SELECT CalculationDate                  -- 精算日
                  ,[10000yen] [10000yenNum]         -- 現金残高10,000枚数
                  ,[5000yen] [5000yenNum]           -- 現金残高5,000枚数
                  ,[2000yen] [2000yenNum]           -- 現金残高2,000枚数
                  ,[1000yen] [1000yenNum]           -- 現金残高1,000枚数
                  ,[500yen] [500yenNum]             -- 現金残高500枚数
                  ,[100yen] [100yenNum]             -- 現金残高100枚数
                  ,[50yen] [50yenNum]               -- 現金残高50枚数
                  ,[10yen] [10yenNum]               -- 現金残高10枚数
                  ,[5yen] [5yenNum]                 -- 現金残高5枚数
                  ,[1yen] [1yenNum]                 -- 現金残高1枚数
                  ,[10000yen]*10000 [10000yenGaku]  -- 現金残高10,000金額
                  ,[5000yen]*5000 [5000yenGaku]     -- 現金残高5,000金額
                  ,[2000yen]*2000 [2000yenGaku]     -- 現金残高2,000金額
                  ,[1000yen]*1000 [1000yenGaku]     -- 現金残高1,000金額
                  ,[500yen]*500 [500yenGaku]        -- 現金残高500金額
                  ,[100yen]*100 [100yenGaku]        -- 現金残高100金額
                  ,[50yen]*50 [50yenGaku]           -- 現金残高50金額
                  ,[10yen]*10 [10yenGaku]           -- 現金残高10金額
                  ,[5yen]*5 [5yenGaku]              -- 現金残高5金額
                  ,[1yen]*1 [1yenGaku]              -- 現金残高1金額
                  ,Change                           -- 釣銭準備金
                  ,Etcyen                           -- その他金額
              FROM D_StoreCalculation
             WHERE StoreCD = @StoreCD
               AND CalculationDate >= convert(date, @DateFrom)
               AND CalculationDate <= convert(date, @DateTo)
           ) S1;

    SELECT *
      INTO #Temp_D_DepositHistory0
      FROM (
            SELECT DepositDateTime                  -- 登録日
                  ,Number                           -- 伝票番号
                  ,StoreCD                          -- 店舗CD
                  ,SKUCD                            -- 
                  ,JanCD                            -- JanCD
                  ,SalesSU                          -- 
                  ,SalesUnitPrice                   -- 
                  ,TotalGaku                        -- 価格
                  ,SalesTax                         -- 税額
                  ,SalesTaxRate                     -- 税率
                  ,DataKBN                          -- 
                  ,DepositKBN                       -- 
                  ,CancelKBN                        -- 
                  ,DenominationCD                   -- 
                  ,DepositGaku                      -- 
                  ,Refund                           -- 
                  ,DepositNO                        -- 
                  ,DiscountGaku                     -- 
                  ,CustomerCD                       -- 
                  ,ExchangeDenomination             -- 
                  ,ExchangeCount                    -- 
                  ,[Rows]                           -- 
                  ,AccountingDate                   -- 
              FROM D_DepositHistory
             WHERE StoreCD = @StoreCD
               AND AccountingDate >= convert(date, @DateFrom)
               AND AccountingDate <= convert(date, @DateTo)
           ) H1;

    -- 【販売】ワークテーブル１作成
    SELECT * 
      INTO #Temp_D_DepositHistory1
      FROM (
            SELECT distinct history.DepositDateTime RegistDate                  -- 登録日
                  ,history.Number SalesNO                                       -- 伝票番号
                  ,history.StoreCD                                              -- 店舗CD
                  ,1 DetailOrder                                                -- 明細表示順
                  ,history.JanCD                                                -- JanCD
                  ,sku.SKUShortName                                             -- 商品名
                  ,CASE
                     WHEN history.SalesSU = 1 THEN NULL
                     ELSE history.SalesUnitPrice
                   END AS SalesUnitPrice                                        -- 単価
                  ,CASE
                     WHEN history.SalesSU = 1 THEN NULL
                     ELSE history.SalesSU
                   END AS SalesSU                                               -- 数量
                  ,history.TotalGaku Kakaku                                     -- 価格
                  ,history.SalesTax                                             -- 税額
                  ,history.SalesTaxRate                                         -- 税率
                  ,history.TotalGaku                                            -- 販売合計額
                  ,sales.SalesHontaiGaku8 + sales.SalesTax8 TargetAmount8       -- 8％対象額
                  ,sales.SalesHontaiGaku10 + sales.SalesTax10 TargetAmount10    -- 10％対象額
                  ,sales.SalesTax8                                              -- 外税8％
                  ,sales.SalesTax10                                             -- 外税10％
                  ,staff.ReceiptPrint StaffReceiptPrint                         -- 担当レシート表記
                  ,store.ReceiptPrint StoreReceiptPrint                         -- 店舗レシート表記
                  ,history.AccountingDate
              FROM #Temp_D_DepositHistory0 history
              LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                                           AND sales.DeleteDateTime IS NULL
                                           AND sales.BillingType = 1
              LEFT OUTER JOIN (
                               SELECT ROW_NUMBER() OVER(PARTITION BY AdminNO ORDER BY ChangeDate DESC) as RANK
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
                                   AND sku.DeleteFlg = 0
              LEFT OUTER JOIN (
                               SELECT ROW_NUMBER() OVER(PARTITION BY StaffCD ORDER BY ChangeDate DESC) AS RANK
                                     ,StaffCD
                                     ,ChangeDate
                                     ,ReceiptPrint
                                     ,DeleteFlg
                                 FROM M_Staff
                              ) staff ON staff.RANK = 1
                                     AND staff.StaffCD = sales.StaffCD
                                     AND staff.ChangeDate <= sales.SalesDate
                                     AND staff.DeleteFlg = 0
              LEFT OUTER JOIN (
                               SELECT ROW_NUMBER() OVER(PARTITION BY StoreCD ORDER BY ChangeDate DESC) as RANK
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
                                     AND store.DeleteFlg = 0
             WHERE history.DataKBN = 2
               AND history.DepositKBN = 1
               AND history.CancelKBN = 0
           ) D1;

    -- 【販売】ワークテーブル２作成
    SELECT * 
      INTO #Temp_D_DepositHistory2
      FROM (
            SELECT D.SalesNO                                                                     -- 伝票番号
                  ,MAX(CASE D.RANK WHEN  1 THEN D.DenominationName ELSE NULL END) PaymentName1   -- 支払方法名1
                  ,MAX(CASE D.RANK WHEN  1 THEN D.DepositGaku      ELSE NULL END) AmountPay1     -- 支払方法額1
                  ,MAX(CASE D.RANK WHEN  2 THEN D.DenominationName ELSE NULL END) PaymentName2   -- 支払方法名2
                  ,MAX(CASE D.RANK WHEN  2 THEN D.DepositGaku      ELSE NULL END) AmountPay2     -- 支払方法額2
                  ,MAX(CASE D.RANK WHEN  3 THEN D.DenominationName ELSE NULL END) PaymentName3   -- 支払方法名3
                  ,MAX(CASE D.RANK WHEN  3 THEN D.DepositGaku      ELSE NULL END) AmountPay3     -- 支払方法額3
                  ,MAX(CASE D.RANK WHEN  4 THEN D.DenominationName ELSE NULL END) PaymentName4   -- 支払方法名4
                  ,MAX(CASE D.RANK WHEN  4 THEN D.DepositGaku      ELSE NULL END) AmountPay4     -- 支払方法額4
                  ,MAX(CASE D.RANK WHEN  5 THEN D.DenominationName ELSE NULL END) PaymentName5   -- 支払方法名5
                  ,MAX(CASE D.RANK WHEN  5 THEN D.DepositGaku      ELSE NULL END) AmountPay5     -- 支払方法額5
                  ,MAX(CASE D.RANK WHEN  6 THEN D.DenominationName ELSE NULL END) PaymentName6   -- 支払方法名6
                  ,MAX(CASE D.RANK WHEN  6 THEN D.DepositGaku      ELSE NULL END) AmountPay6     -- 支払方法額6
                  ,MAX(CASE D.RANK WHEN  7 THEN D.DenominationName ELSE NULL END) PaymentName7   -- 支払方法名7
                  ,MAX(CASE D.RANK WHEN  7 THEN D.DepositGaku      ELSE NULL END) AmountPay7     -- 支払方法額7
                  ,MAX(CASE D.RANK WHEN  8 THEN D.DenominationName ELSE NULL END) PaymentName8   -- 支払方法名8
                  ,MAX(CASE D.RANK WHEN  8 THEN D.DepositGaku      ELSE NULL END) AmountPay8     -- 支払方法額8
                  ,MAX(CASE D.RANK WHEN  9 THEN D.DenominationName ELSE NULL END) PaymentName9   -- 支払方法名9
                  ,MAX(CASE D.RANK WHEN  9 THEN D.DepositGaku      ELSE NULL END) AmountPay9     -- 支払方法額9
                  ,MAX(CASE D.RANK WHEN 10 THEN D.DenominationName ELSE NULL END) PaymentName10  -- 支払方法名10
                  ,MAX(CASE D.RANK WHEN 10 THEN D.DepositGaku      ELSE NULL END) AmountPay10    -- 支払方法額10
              FROM (
                    SELECT history.Number SalesNO
                          ,history.DenominationCD
                          ,denominationKbn.DenominationName
                          ,history.DepositGaku + history.Refund DepositGaku
                          ,history.DepositDateTime
                          ,ROW_NUMBER() OVER(PARTITION BY history.Number ORDER BY history.DepositDateTime ASC) as RANK
                      FROM #Temp_D_DepositHistory0 history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                                                   AND sales.DeleteDateTime IS NULL
                                                   AND sales.BillingType = 1
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 1
                       AND history.CancelKBN = 0
                   ) D
             GROUP BY D.SalesNO
           ) D2;

    -- 【販売】ワークテーブル３作成
    SELECT * 
      INTO #Temp_D_DepositHistory3
      FROM (
            SELECT history.Number  SalesNO                   -- 伝票番号
                  ,SUM(history.Refund) Refund                -- 釣銭
                  ,SUM(history.DiscountGaku) DiscountGaku    -- 値引額
              FROM #Temp_D_DepositHistory0 history
              LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                                           AND sales.DeleteDateTime IS NULL
                                           AND sales.BillingType = 1
             WHERE history.DataKBN = 3 
               AND history.DepositKBN = 1
               AND history.CancelKBN = 0
             GROUP BY history.Number
           ) D3;

    -- 【釣銭準備】ワークテーブル４作成
    SELECT * 
      INTO #Temp_D_DepositHistory4
      FROM (
            SELECT CONVERT(Date, D.DepositDateTime) RegistDate                             -- 登録日
                  ,FORMAT(D.DepositDateTime, 'yyyy/MM/dd HH:mm') ChangePreparationDate1    -- 釣銭準備日1
                  ,'現金' ChangePreparationName1                                           -- 釣銭準備名1
                  ,D.DepositGaku ChangePreparationAmount1                                  -- 釣銭準備額1
                  ,NULL ChangePreparationDate2                                             -- 釣銭準備日2
                  ,NULL ChangePreparationName2                                             -- 釣銭準備名2
                  ,NULL ChangePreparationAmount2                                           -- 釣銭準備額2
                  ,NULL ChangePreparationDate3                                             -- 釣銭準備日3
                  ,NULL ChangePreparationName3                                             -- 釣銭準備名3
                  ,NULL ChangePreparationAmount3                                           -- 釣銭準備額3
                  ,NULL ChangePreparationDate4                                             -- 釣銭準備日4
                  ,NULL ChangePreparationName4                                             -- 釣銭準備名4
                  ,NULL ChangePreparationAmount4                                           -- 釣銭準備額4
                  ,NULL ChangePreparationDate5                                             -- 釣銭準備日5
                  ,NULL ChangePreparationName5                                             -- 釣銭準備名5
                  ,NULL ChangePreparationAmount5                                           -- 釣銭準備額5
                  ,NULL ChangePreparationDate6                                             -- 釣銭準備日6
                  ,NULL ChangePreparationName6                                             -- 釣銭準備名6
                  ,NULL ChangePreparationAmount6                                           -- 釣銭準備額6
                  ,NULL ChangePreparationDate7                                             -- 釣銭準備日7
                  ,NULL ChangePreparationName7                                             -- 釣銭準備名7
                  ,NULL ChangePreparationAmount7                                           -- 釣銭準備額7
                  ,NULL ChangePreparationDate8                                             -- 釣銭準備日8
                  ,NULL ChangePreparationName8                                             -- 釣銭準備名8
                  ,NULL ChangePreparationAmount8                                           -- 釣銭準備額8
                  ,NULL ChangePreparationDate9                                             -- 釣銭準備日9
                  ,NULL ChangePreparationName9                                             -- 釣銭準備名9
                  ,NULL ChangePreparationAmount9                                           -- 釣銭準備額9
                  ,NULL ChangePreparationDate10                                            -- 釣銭準備日10
                  ,NULL ChangePreparationName10                                            -- 釣銭準備名10
                  ,NULL ChangePreparationAmount10                                          -- 釣銭準備額10
              FROM #Temp_D_DepositHistory0 D
             WHERE D.DepositNO IN (
                                   SELECT MAX(history.DepositNO)
                                     FROM D_DepositHistory history
                                     LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                                    WHERE history.DataKBN = 3
                                      AND history.DepositKBN = 6
                                      AND history.CancelKBN = 0
                                    GROUP BY history.AccountingDate
                                  )
           ) D4;

    -- 【雑入金】ワークテーブル５作成
    SELECT * 
      INTO #Temp_D_DepositHistory5
      FROM (
            SELECT D.RegistDate                                                                          -- 登録日
                  ,MAX(CASE D.RANK WHEN  1 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate1       -- 雑入金日1
                  ,MAX(CASE D.RANK WHEN  1 THEN D.DenominationName ELSE NULL END) MiscDepositName1       -- 雑入金名1
                  ,MAX(CASE D.RANK WHEN  1 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount1     -- 雑入金額1
                  ,MAX(CASE D.RANK WHEN  2 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate2       -- 雑入金日2
                  ,MAX(CASE D.RANK WHEN  2 THEN D.DenominationName ELSE NULL END) MiscDepositName2       -- 雑入金名2
                  ,MAX(CASE D.RANK WHEN  2 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount2     -- 雑入金額2
                  ,MAX(CASE D.RANK WHEN  3 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate3       -- 雑入金日3
                  ,MAX(CASE D.RANK WHEN  3 THEN D.DenominationName ELSE NULL END) MiscDepositName3       -- 雑入金名3
                  ,MAX(CASE D.RANK WHEN  3 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount3     -- 雑入金額3
                  ,MAX(CASE D.RANK WHEN  4 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate4       -- 雑入金日4
                  ,MAX(CASE D.RANK WHEN  4 THEN D.DenominationName ELSE NULL END) MiscDepositName4       -- 雑入金名4
                  ,MAX(CASE D.RANK WHEN  4 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount4     -- 雑入金額4
                  ,MAX(CASE D.RANK WHEN  5 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate5       -- 雑入金日5
                  ,MAX(CASE D.RANK WHEN  5 THEN D.DenominationName ELSE NULL END) MiscDepositName5       -- 雑入金名5
                  ,MAX(CASE D.RANK WHEN  5 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount5     -- 雑入金額5
                  ,MAX(CASE D.RANK WHEN  6 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate6       -- 雑入金日6
                  ,MAX(CASE D.RANK WHEN  6 THEN D.DenominationName ELSE NULL END) MiscDepositName6       -- 雑入金名6
                  ,MAX(CASE D.RANK WHEN  6 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount6     -- 雑入金額6
                  ,MAX(CASE D.RANK WHEN  7 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate7       -- 雑入金日7
                  ,MAX(CASE D.RANK WHEN  7 THEN D.DenominationName ELSE NULL END) MiscDepositName7       -- 雑入金名7
                  ,MAX(CASE D.RANK WHEN  7 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount7     -- 雑入金額7
                  ,MAX(CASE D.RANK WHEN  8 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate8       -- 雑入金日8
                  ,MAX(CASE D.RANK WHEN  8 THEN D.DenominationName ELSE NULL END) MiscDepositName8       -- 雑入金名8
                  ,MAX(CASE D.RANK WHEN  8 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount8     -- 雑入金額8
                  ,MAX(CASE D.RANK WHEN  9 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate9       -- 雑入金日9
                  ,MAX(CASE D.RANK WHEN  9 THEN D.DenominationName ELSE NULL END) MiscDepositName9       -- 雑入金名9
                  ,MAX(CASE D.RANK WHEN  9 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount9     -- 雑入金額9
                  ,MAX(CASE D.RANK WHEN  10 THEN D.DepositDateTime ELSE NULL END) MiscDepositDate10      -- 雑入金日10
                  ,MAX(CASE D.RANK WHEN 10 THEN D.DenominationName ELSE NULL END) MiscDepositName10      -- 雑入金名10
                  ,MAX(CASE D.RANK WHEN 10 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount10    -- 雑入金額10
              FROM (
                    SELECT CONVERT(Date, history.DepositDateTime) RegistDate
                          ,FORMAT(history.DepositDateTime,  'yyyy/MM/dd HH:mm') DepositDateTime
                          ,denominationKbn.DenominationName
                          ,history.DepositGaku
                          ,ROW_NUMBER() OVER(PARTITION BY history.Number ORDER BY history.DepositDateTime ASC) as RANK
                      FROM #Temp_D_DepositHistory0 history
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 2
                       AND history.CustomerCD IS NULL
                       AND history.CancelKBN = 0
                   ) D
             GROUP BY D.RegistDate
           ) D5;

    -- 【入金】ワークテーブル５１作成
    SELECT * 
      INTO #Temp_D_DepositHistory51
      FROM (
            SELECT D.RegistDate                                                                     -- 登録日
                  ,MAX(CustomerCD) CustomerCD                                                       -- 入金元CD
                  ,MAX(CustomerName) CustomerName                                                   -- 入金元名
                  ,MAX(CASE D.RANK WHEN  1 THEN D.DepositDateTime  ELSE NULL END) DepositDate1      -- 入金日1
                  ,MAX(CASE D.RANK WHEN  1 THEN D.DenominationName ELSE NULL END) DepositName1      -- 入金名1
                  ,MAX(CASE D.RANK WHEN  1 THEN D.DepositGaku      ELSE NULL END) DepositAmount1    -- 入金額1
                  ,MAX(CASE D.RANK WHEN  2 THEN D.DepositDateTime  ELSE NULL END) DepositDate2      -- 入金日2
                  ,MAX(CASE D.RANK WHEN  2 THEN D.DenominationName ELSE NULL END) DepositName2      -- 入金名2
                  ,MAX(CASE D.RANK WHEN  2 THEN D.DepositGaku      ELSE NULL END) DepositAmount2    -- 入金額2
                  ,MAX(CASE D.RANK WHEN  3 THEN D.DepositDateTime  ELSE NULL END) DepositDate3      -- 入金日3
                  ,MAX(CASE D.RANK WHEN  3 THEN D.DenominationName ELSE NULL END) DepositName3      -- 入金名3
                  ,MAX(CASE D.RANK WHEN  3 THEN D.DepositGaku      ELSE NULL END) DepositAmount3    -- 入金額3
                  ,MAX(CASE D.RANK WHEN  4 THEN D.DepositDateTime  ELSE NULL END) DepositDate4      -- 入金日4
                  ,MAX(CASE D.RANK WHEN  4 THEN D.DenominationName ELSE NULL END) DepositName4      -- 入金名4
                  ,MAX(CASE D.RANK WHEN  4 THEN D.DepositGaku      ELSE NULL END) DepositAmount4    -- 入金額4
                  ,MAX(CASE D.RANK WHEN  5 THEN D.DepositDateTime  ELSE NULL END) DepositDate5      -- 入金日5
                  ,MAX(CASE D.RANK WHEN  5 THEN D.DenominationName ELSE NULL END) DepositName5      -- 入金名5
                  ,MAX(CASE D.RANK WHEN  5 THEN D.DepositGaku      ELSE NULL END) DepositAmount5    -- 入金額5
                  ,MAX(CASE D.RANK WHEN  6 THEN D.DepositDateTime  ELSE NULL END) DepositDate6      -- 入金日6
                  ,MAX(CASE D.RANK WHEN  6 THEN D.DenominationName ELSE NULL END) DepositName6      -- 入金名6
                  ,MAX(CASE D.RANK WHEN  6 THEN D.DepositGaku      ELSE NULL END) DepositAmount6    -- 入金額6
                  ,MAX(CASE D.RANK WHEN  7 THEN D.DepositDateTime  ELSE NULL END) DepositDate7      -- 入金日7
                  ,MAX(CASE D.RANK WHEN  7 THEN D.DenominationName ELSE NULL END) DepositName7      -- 入金名7
                  ,MAX(CASE D.RANK WHEN  7 THEN D.DepositGaku      ELSE NULL END) DepositAmount7    -- 入金額7
                  ,MAX(CASE D.RANK WHEN  8 THEN D.DepositDateTime  ELSE NULL END) DepositDate8      -- 入金日8
                  ,MAX(CASE D.RANK WHEN  8 THEN D.DenominationName ELSE NULL END) DepositName8      -- 入金名8
                  ,MAX(CASE D.RANK WHEN  8 THEN D.DepositGaku      ELSE NULL END) DepositAmount8    -- 入金額8
                  ,MAX(CASE D.RANK WHEN  9 THEN D.DepositDateTime  ELSE NULL END) DepositDate9      -- 入金日9
                  ,MAX(CASE D.RANK WHEN  9 THEN D.DenominationName ELSE NULL END) DepositName9      -- 入金名9
                  ,MAX(CASE D.RANK WHEN  9 THEN D.DepositGaku      ELSE NULL END) DepositAmount9    -- 入金額9
                  ,MAX(CASE D.RANK WHEN 10 THEN D.DepositDateTime  ELSE NULL END) DepositDate10     -- 入金日10
                  ,MAX(CASE D.RANK WHEN 10 THEN D.DenominationName ELSE NULL END) DepositName10     -- 入金名10
                  ,MAX(CASE D.RANK WHEN 10 THEN D.DepositGaku      ELSE NULL END) DepositAmount10   -- 入金額10
              FROM (
                    SELECT CONVERT(Date, history.DepositDateTime) RegistDate
                          ,FORMAT(history.DepositDateTime, 'yyyy/MM/dd HH:mm') DepositDateTime
                          ,customer.CustomerCD
                          ,customer.CustomerName
                          ,denominationKbn.DenominationName
                          ,history.DenominationCD 
                          ,history.DepositGaku
                          ,ROW_NUMBER() OVER(PARTITION BY history.Number ORDER BY history.DepositDateTime ASC) as RANK
                     FROM #Temp_D_DepositHistory0 history
                     LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                                                  AND sales.DeleteDateTime IS NULL
                                                  AND sales.BillingType = 1
                     LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     LEFT OUTER JOIN (
                                      SELECT ROW_NUMBER() OVER(PARTITION BY CustomerCD ORDER BY ChangeDate DESC) AS RANK
                                            ,CustomerCD
                                            ,CustomerName
                                            ,ChangeDate
                                            ,DeleteFlg
                                        FROM M_Customer) customer ON customer.RANK = 1
                                                                 AND customer.CustomerCD = history.CustomerCD
                                                                 AND customer.ChangeDate <= history.DepositDateTime
                      AND customer.DeleteFlg = 0
                    WHERE history.DataKBN = 3
                      AND history.DepositKBN = 2
                      AND history.CustomerCD IS NOT NULL
                      AND history.CancelKBN = 0
                   ) D
             GROUP BY D.RegistDate
           ) D51;

    -- 【雑支払】ワークテーブル６作成
    SELECT * 
      INTO #Temp_D_DepositHistory6
      FROM (
            SELECT D.RegistDate                                                                            -- 登録日
                  ,MAX(CASE D.RANK WHEN  1 THEN D.DepositDateTime  ELSE NULL END) MiscPaymentDate1         -- 雑支払日1
                  ,MAX(CASE D.RANK WHEN  1 THEN D.DenominationName ELSE NULL END) MiscPaymentName1         -- 雑支払名1
                  ,MAX(CASE D.RANK WHEN  1 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount1       -- 雑支払額1
                  ,MAX(CASE D.RANK WHEN  2 THEN D.DepositDateTime  ELSE NULL END) MiscPaymentDate2         -- 雑支払日2
                  ,MAX(CASE D.RANK WHEN  2 THEN D.DenominationName ELSE NULL END) MiscPaymentName2         -- 雑支払名2
                  ,MAX(CASE D.RANK WHEN  2 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount2       -- 雑支払額2
                  ,MAX(CASE D.RANK WHEN  3 THEN D.DepositDateTime  ELSE NULL END) MiscPaymentDate3         -- 雑支払日3
                  ,MAX(CASE D.RANK WHEN  3 THEN D.DenominationName ELSE NULL END) MiscPaymentName3         -- 雑支払名3
                  ,MAX(CASE D.RANK WHEN  3 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount3       -- 雑支払額3
                  ,MAX(CASE D.RANK WHEN  4 THEN D.DepositDateTime  ELSE NULL END) MiscPaymentDate4         -- 雑支払日4
                  ,MAX(CASE D.RANK WHEN  4 THEN D.DenominationName ELSE NULL END) MiscPaymentName4         -- 雑支払名4
                  ,MAX(CASE D.RANK WHEN  4 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount4       -- 雑支払額4
                  ,MAX(CASE D.RANK WHEN  5 THEN D.DepositDateTime  ELSE NULL END) MiscPaymentDate5         -- 雑支払日5
                  ,MAX(CASE D.RANK WHEN  5 THEN D.DenominationName ELSE NULL END) MiscPaymentName5         -- 雑支払名5
                  ,MAX(CASE D.RANK WHEN  5 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount5       -- 雑支払額5
                  ,MAX(CASE D.RANK WHEN  6 THEN D.DepositDateTime  ELSE NULL END) MiscPaymentDate6         -- 雑支払日6
                  ,MAX(CASE D.RANK WHEN  6 THEN D.DenominationName ELSE NULL END) MiscPaymentName6         -- 雑支払名6
                  ,MAX(CASE D.RANK WHEN  6 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount6       -- 雑支払額6
                  ,MAX(CASE D.RANK WHEN  7 THEN D.DepositDateTime  ELSE NULL END) MiscPaymentDate7         -- 雑支払日7
                  ,MAX(CASE D.RANK WHEN  7 THEN D.DenominationName ELSE NULL END) MiscPaymentName7         -- 雑支払名7
                  ,MAX(CASE D.RANK WHEN  7 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount7       -- 雑支払額7
                  ,MAX(CASE D.RANK WHEN  8 THEN D.DepositDateTime  ELSE NULL END) MiscPaymentDate8         -- 雑支払日8
                  ,MAX(CASE D.RANK WHEN  8 THEN D.DenominationName ELSE NULL END) MiscPaymentName8         -- 雑支払名8
                  ,MAX(CASE D.RANK WHEN  8 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount8       -- 雑支払額8
                  ,MAX(CASE D.RANK WHEN  9 THEN D.DepositDateTime  ELSE NULL END) MiscPaymentDate9         -- 雑支払日9
                  ,MAX(CASE D.RANK WHEN  9 THEN D.DenominationName ELSE NULL END) MiscPaymentName9         -- 雑支払名9
                  ,MAX(CASE D.RANK WHEN  9 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount9       -- 雑支払額9
                  ,MAX(CASE D.RANK WHEN 10 THEN D.DepositDateTime  ELSE NULL END) MiscPaymentDate10        -- 雑支払日10
                  ,MAX(CASE D.RANK WHEN 10 THEN D.DenominationName ELSE NULL END) MiscPaymentName10        -- 雑支払名10
                  ,MAX(CASE D.RANK WHEN 10 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount10      -- 雑支払額10
              FROM (
                    SELECT CONVERT(Date, history.DepositDateTime) RegistDate
                          ,FORMAT(history.DepositDateTime, 'yyyy/MM/dd HH:mm') DepositDateTime
                          ,history.DenominationCD
                          ,denominationKbn.DenominationName
                          ,history.DepositGaku
                          ,ROW_NUMBER() OVER(PARTITION BY history.Number ORDER BY history.DepositDateTime ASC) as RANK
                      FROM #Temp_D_DepositHistory0 history
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 3
                       AND history.CancelKBN = 0
                   ) D
             GROUP BY D.RegistDate
           ) D6;

    -- 【両替】ワークテーブル７作成
    SELECT * 
      INTO #Temp_D_DepositHistory7
      FROM (
            SELECT D.RegistDate                                                                               -- 登録日
                  ,COUNT(*) ExchangeCount                                                                     -- 両替回数
                  ,MAX(CASE D.RANK WHEN  1 THEN D.DepositDateTime      ELSE NULL END) ExchangeDate1           -- 両替日1
                  ,MAX(CASE D.RANK WHEN  1 THEN D.DenominationName     ELSE NULL END) ExchangeName1           -- 両替名1
                  ,MAX(CASE D.RANK WHEN  1 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount1         -- 両替額1
                  ,MAX(CASE D.RANK WHEN  1 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination1   -- 両替紙幣1
                  ,MAX(CASE D.RANK WHEN  1 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount1          -- 両替枚数1
                  ,MAX(CASE D.RANK WHEN  2 THEN D.DepositDateTime      ELSE NULL END) ExchangeDate2           -- 両替日2
                  ,MAX(CASE D.RANK WHEN  2 THEN D.DenominationName     ELSE NULL END) ExchangeName2           -- 両替名2
                  ,MAX(CASE D.RANK WHEN  2 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount2         -- 両替額2
                  ,MAX(CASE D.RANK WHEN  2 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination2   -- 両替紙幣2
                  ,MAX(CASE D.RANK WHEN  2 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount2          -- 両替枚数2
                  ,MAX(CASE D.RANK WHEN  3 THEN D.DepositDateTime      ELSE NULL END) ExchangeDate3           -- 両替日3
                  ,MAX(CASE D.RANK WHEN  3 THEN D.DenominationName     ELSE NULL END) ExchangeName3           -- 両替名3
                  ,MAX(CASE D.RANK WHEN  3 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount3         -- 両替額3
                  ,MAX(CASE D.RANK WHEN  3 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination3   -- 両替紙幣3
                  ,MAX(CASE D.RANK WHEN  3 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount3          -- 両替枚数3
                  ,MAX(CASE D.RANK WHEN  4 THEN D.DepositDateTime      ELSE NULL END) ExchangeDate4           -- 両替日4
                  ,MAX(CASE D.RANK WHEN  4 THEN D.DenominationName     ELSE NULL END) ExchangeName4           -- 両替名4
                  ,MAX(CASE D.RANK WHEN  4 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount4         -- 両替額4
                  ,MAX(CASE D.RANK WHEN  4 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination4   -- 両替紙幣4
                  ,MAX(CASE D.RANK WHEN  4 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount4          -- 両替枚数4
                  ,MAX(CASE D.RANK WHEN  5 THEN D.DepositDateTime      ELSE NULL END) ExchangeDate5           -- 両替日5
                  ,MAX(CASE D.RANK WHEN  5 THEN D.DenominationName     ELSE NULL END) ExchangeName5           -- 両替名5
                  ,MAX(CASE D.RANK WHEN  5 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount5         -- 両替額5
                  ,MAX(CASE D.RANK WHEN  5 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination5   -- 両替紙幣5
                  ,MAX(CASE D.RANK WHEN  5 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount5          -- 両替枚数5
                  ,MAX(CASE D.RANK WHEN  6 THEN D.DepositDateTime      ELSE NULL END) ExchangeDate6           -- 両替日6
                  ,MAX(CASE D.RANK WHEN  6 THEN D.DenominationName     ELSE NULL END) ExchangeName6           -- 両替名6
                  ,MAX(CASE D.RANK WHEN  6 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount6         -- 両替額6
                  ,MAX(CASE D.RANK WHEN  6 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination6   -- 両替紙幣6
                  ,MAX(CASE D.RANK WHEN  6 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount6          -- 両替枚数6
                  ,MAX(CASE D.RANK WHEN  7 THEN D.DepositDateTime      ELSE NULL END) ExchangeDate7           -- 両替日7
                  ,MAX(CASE D.RANK WHEN  7 THEN D.DenominationName     ELSE NULL END) ExchangeName7           -- 両替名7
                  ,MAX(CASE D.RANK WHEN  7 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount7         -- 両替額7
                  ,MAX(CASE D.RANK WHEN  7 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination7   -- 両替紙幣7
                  ,MAX(CASE D.RANK WHEN  7 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount7          -- 両替枚数7
                  ,MAX(CASE D.RANK WHEN  8 THEN D.DepositDateTime      ELSE NULL END) ExchangeDate8           -- 両替日8
                  ,MAX(CASE D.RANK WHEN  8 THEN D.DenominationName     ELSE NULL END) ExchangeName8           -- 両替名8
                  ,MAX(CASE D.RANK WHEN  8 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount8         -- 両替額8
                  ,MAX(CASE D.RANK WHEN  8 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination8   -- 両替紙幣8
                  ,MAX(CASE D.RANK WHEN  8 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount8          -- 両替枚数8
                  ,MAX(CASE D.RANK WHEN  9 THEN D.DepositDateTime      ELSE NULL END) ExchangeDate9           -- 両替日9
                  ,MAX(CASE D.RANK WHEN  9 THEN D.DenominationName     ELSE NULL END) ExchangeName9           -- 両替名9
                  ,MAX(CASE D.RANK WHEN  9 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount9         -- 両替額9
                  ,MAX(CASE D.RANK WHEN  9 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination9   -- 両替紙幣9
                  ,MAX(CASE D.RANK WHEN  9 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount9          -- 両替枚数9
                  ,MAX(CASE D.RANK WHEN 10 THEN D.DepositDateTime      ELSE NULL END) ExchangeDate10          -- 両替日10
                  ,MAX(CASE D.RANK WHEN 10 THEN D.DenominationName     ELSE NULL END) ExchangeName10          -- 両替名10
                  ,MAX(CASE D.RANK WHEN 10 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount10        -- 両替額10
                  ,MAX(CASE D.RANK WHEN 10 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination10  -- 両替紙幣10
                  ,MAX(CASE D.RANK WHEN 10 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount10         -- 両替枚数10
              FROM (
                    SELECT CONVERT(Date, history.DepositDateTime) RegistDate
                          ,FORMAT(history.DepositDateTime, 'yyyy/MM/dd HH:mm') DepositDateTime
                          ,denominationKbn.DenominationName
                          ,history.DepositGaku
                          ,history.ExchangeDenomination
                          ,history.ExchangeCount
                          ,ROW_NUMBER() OVER (PARTITION BY  history.Number ORDER BY history.DepositDateTime) AS RANK
                      FROM #Temp_D_DepositHistory0 history
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 4
                       AND history.CancelKBN = 0
                   ) D
             GROUP BY D.RegistDate
           ) D7;

    -- 【精算処理：現金売上(+)】ワークテーブル９作成
    SELECT * 
      INTO #Temp_D_DepositHistory9
      FROM (
            SELECT D.RegistDate    -- 登録日
                  ,SUM(D.DepositGaku) DepositGaku                 -- 現金売上(+)
              FROM (
                    SELECT history.DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,history.DepositGaku
                      FROM #Temp_D_DepositHistory0 history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                                                   AND sales.DeleteDateTime IS NULL
                                                   AND sales.BillingType = 1
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                                                                       AND denominationKbn.SystemKBN = 1
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 1
                       AND history.CancelKBN = 0
                   ) D
             GROUP BY D.RegistDate
           ) D9;

    -- 【精算処理：現金入金(+)】ワークテーブル１０作成
    SELECT * 
      INTO #Temp_D_DepositHistory10
      FROM (
            SELECT D.RegistDate                                   -- 登録日
                  ,SUM(D.DepositGaku) DepositGaku                 -- 現金売上(+)
              FROM (
                    SELECT history.DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,history.DepositGaku
                      FROM #Temp_D_DepositHistory0 history
                     INNER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                                                                 AND denominationKbn.SystemKBN = 1
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 2
                       AND history.CancelKBN = 0
                   ) D
             GROUP BY D.RegistDate
           ) D10;

    -- 【精算処理：現金支払(-)】ワークテーブル１１作成
    SELECT * 
      INTO #Temp_D_DepositHistory11
      FROM (
            SELECT D.RegistDate                                   -- 登録日
                  ,SUM(D.DepositGaku) DepositGaku                 -- 現金支払(-)
              FROM (
                    SELECT history.DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,history.DepositGaku
                      FROM #Temp_D_DepositHistory0 history
                     INNER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                                                                 AND denominationKbn.SystemKBN = 1
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 3
                       AND history.CancelKBN = 0
                   ) D
             GROUP BY D.RegistDate
           ) D11;

    -- 【精算処理】ワークテーブル１２作成
    SELECT * 
      INTO #Temp_D_DepositHistory12
      FROM (
            SELECT D.RegistDate                                   -- 登録日
                  ,COUNT(D.SalesNO) SalesNOCount                  -- 伝票数
                  ,COUNT(D.CustomerCD) CustomerCDCount            -- 客数
                  ,SUM(D.SalesSU) SalesSUSum                      -- 売上数量
                  ,SUM(D.TotalGaku) TotalGakuSum                  -- 売上金額
                  ,SUM(D.DiscountGaku) DiscountGaku               -- 値引額
              FROM (
                    SELECT history.DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate 
                          ,sales.SalesNO
                          ,sales.CustomerCD
                          ,history.SalesSU
                          ,history.TotalGaku
                          ,history.DiscountGaku
                      FROM #Temp_D_DepositHistory0 history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                                                   AND sales.DeleteDateTime IS NULL
                                                   AND sales.BillingType = 1
                     WHERE history.DataKBN = 2
                       AND history.DepositKBN = 1
                       AND history.CancelKBN = 0
                   ) D
             GROUP BY D.RegistDate
           ) D12;

    -- 【精算処理】ワークテーブル１３作成
    SELECT * 
      INTO #Temp_D_DepositHistory13
      FROM (
            SELECT D.RegistDate                                                 -- 登録日
                  ,SUM(D.TaxableAmount) TaxableAmount                           -- 内税分販売額の合計
                  ,SUM(D.ForeignTaxableAmount) ForeignTaxableAmount             -- 外税分販売額の合計
                  ,SUM(D.TaxExemptionAmount) TaxExemptionAmount                 -- 非課税分販売額の合計
                  ,SUM(D.TotalWithoutTax) TotalWithoutTax                       -- 税抜合計の合計
                  ,SUM(D.Tax) Tax                                               -- 内税の合計
                  ,SUM(D.OutsideTax) OutsideTax                                 -- 外税の合計
                  ,SUM(D.ConsumptionTax) ConsumptionTax                         -- 消費税計の合計
                  ,SUM(D.TaxIncludedTotal) TaxIncludedTotal                     -- 税込合計の合計
              FROM (
                    SELECT history.DepositNO                                    -- 
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate    -- 登録日
                          ,salesDetails.SalesGaku TaxableAmount                 -- 内税分販売額
                          ,0 ForeignTaxableAmount                               -- 外税分販売額
                          ,0 TaxExemptionAmount                                 -- 非課税分販売額
                          ,salesDetails.SalesHontaiGaku TotalWithoutTax         -- 税抜合計
                          ,salesDetails.SalesTax Tax                            -- 内税
                          ,0 OutsideTax                                         -- 外税
                          ,salesDetails.SalesTax ConsumptionTax                 -- 消費税計
                          ,salesDetails.SalesGaku TaxIncludedTotal              -- 税込合計
                      FROM #Temp_D_DepositHistory0 history
                      LEFT OUTER JOIN D_SalesDetails salesDetails ON salesDetails.SalesNO = history.Number
                                                                 AND salesDetails.SalesRows = history.[Rows]
                                                                 AND salesDetails.DeleteDateTime IS NULL
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = salesDetails.SalesNO
                                                   AND sales.DeleteDateTime IS NULL
                                                   AND sales.BillingType = 1
                     WHERE history.DataKBN = 2
                       AND history.DepositKBN = 1
                       AND history.CancelKBN = 0
                   ) D
             GROUP BY D.RegistDate
           ) D13;

    -- 【精算処理】ワークテーブル１４作成
    SELECT * 
      INTO #Temp_D_DepositHistory14
      FROM (
            SELECT D.RegistDate                                                                            -- 登録日
                  ,MAX(CASE d.RANK WHEN 1 THEN D.DenominationName  ELSE null END) AS denominationName1     -- 金種区分名1
                  ,MAX(CASE d.RANK WHEN 1 THEN D.Kingaku           ELSE null END) AS Kingaku1              -- 金額1
                  ,MAX(CASE d.RANK WHEN 2 THEN D.DenominationName  ELSE null END) AS denominationName2     -- 金種区分名2
                  ,MAX(CASE d.RANK WHEN 2 THEN D.Kingaku           ELSE null END) AS Kingaku2              -- 金額2
                  ,MAX(CASE d.RANK WHEN 3 THEN D.DenominationName  ELSE null END) AS denominationName3     -- 金種区分名3
                  ,MAX(CASE d.RANK WHEN 3 THEN D.Kingaku           ELSE null END) AS Kingaku3              -- 金額3
                  ,MAX(CASE d.RANK WHEN 4 THEN D.DenominationName  ELSE null END) AS denominationName4     -- 金種区分名4
                  ,MAX(CASE d.RANK WHEN 4 THEN D.Kingaku           ELSE null END) AS Kingaku4              -- 金額4
                  ,MAX(CASE d.RANK WHEN 5 THEN D.DenominationName  ELSE null END) AS denominationName5     -- 金種区分名5
                  ,MAX(CASE d.RANK WHEN 5 THEN D.Kingaku           ELSE null END) AS Kingaku5              -- 金額5
                  ,MAX(CASE d.RANK WHEN 6 THEN D.DenominationName  ELSE null END) AS denominationName6     -- 金種区分名6
                  ,MAX(CASE d.RANK WHEN 6 THEN D.Kingaku           ELSE null END) AS Kingaku6              -- 金額6
                  ,MAX(CASE d.RANK WHEN 7 THEN D.DenominationName  ELSE null END) AS denominationName7     -- 金種区分名7
                  ,MAX(CASE d.RANK WHEN 7 THEN D.Kingaku           ELSE null END) AS Kingaku7              -- 金額7
                  ,MAX(CASE d.RANK WHEN 8 THEN D.DenominationName  ELSE null END) AS denominationName8     -- 金種区分名8
                  ,MAX(CASE d.RANK WHEN 8 THEN D.Kingaku           ELSE null END) AS Kingaku8              -- 金額8
                  ,MAX(CASE d.RANK WHEN 9 THEN D.DenominationName  ELSE null END) AS denominationName9     -- 金種区分名9
                  ,MAX(CASE d.RANK WHEN 9 THEN D.Kingaku           ELSE null END) AS Kingaku9              -- 金額9
                  ,MAX(CASE d.RANK WHEN 10 THEN D.DenominationName ELSE null END) AS denominationName10    -- 金種区分名10
                  ,MAX(CASE d.RANK WHEN 10 THEN D.Kingaku          ELSE null END) AS Kingaku10             -- 金額10
              FROM (
                    SELECT CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,history.DepositDateTime
                          ,denominationKbn.DenominationCD 
                          ,MAX(CASE WHEN denominationKbn.SystemKBN = 2 THEN multiPorpose.IDName
                                    ELSE denominationKbn.DenominationName 
                               END) DenominationName
                          ,SUM(history.DepositGaku) Kingaku
                          ,history.Number
                          ,ROW_NUMBER() OVER (PARTITION BY  history.Number ORDER BY history.DepositDateTime) AS RANK
                      FROM #Temp_D_DepositHistory0 history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                                                   AND sales.DeleteDateTime IS NULL
                                                   AND sales.BillingType = 1
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                      LEFT OUTER JOIN M_MultiPorpose multiPorpose ON multiPorpose.ID = 303
                                                                 AND multiPorpose.[KEY] = denominationKbn.CardCompany
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 1
                       AND history.CancelKBN = 0
                     GROUP BY history.DepositDateTime
                             ,denominationKbn.DenominationCD
                             ,denominationKbn.CardCompany
                             ,history.Number
                   ) D
             GROUP BY D.RegistDate
           ) D14;

    -- 【精算処理】ワークテーブル１５作成
    SELECT * 
      INTO #Temp_D_DepositHistory15
      FROM (
            SELECT D.RegistDate
                  ,SUM(DepositTransfer) DepositTransfer      -- 入金 振込
                  ,SUM(DepositCash) DepositCash              -- 入金 現金
                  ,SUM(DepositCheck) DepositCheck            -- 入金 小切手
                  ,SUM(DepositBill) DepositBill              -- 入金 手形
                  ,SUM(DepositOffset) DepositOffset          -- 入金 相殺
                  ,SUM(DepositAdjustment) DepositAdjustment  -- 入金 調整
                  ,SUM(PaymentTransfer) PaymentTransfer      -- 支払 振込
                  ,SUM(PaymentCash) PaymentCash              -- 支払 現金
                  ,SUM(PaymentCheck) PaymentCheck            -- 支払 小切手
                  ,SUM(PaymentBill) PaymentBill              -- 支払 手形
                  ,SUM(PaymentOffset) PaymentOffset          -- 支払 相殺
                  ,SUM(PaymentAdjustment) PaymentAdjustment  -- 支払 調整
              FROM (
                    SELECT history.DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,CASE WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 5 THEN history.DepositGaku
                                ELSE 0
                           END AS DepositTransfer    -- 入金 振込
                          ,CASE WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 1 THEN history.DepositGaku
                                ELSE 0
                           END AS DepositCash        -- 入金 現金
                          ,CASE WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 6 THEN history.DepositGaku
                                ELSE 0
                           END AS DepositCheck       -- 入金 小切手
                          ,CASE WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 11 THEN history.DepositGaku
                                ELSE 0
                           END AS DepositBill        -- 入金 手形
                          ,CASE WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 7 THEN history.DepositGaku
                                ELSE 0
                           END AS DepositOffset      -- 入金 相殺
                          ,CASE WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 12 THEN history.DepositGaku
                                ELSE 0
                           END AS DepositAdjustment  -- 入金 調整
                          ,CASE WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 5 THEN history.DepositGaku
                                ELSE 0
                           END AS PaymentTransfer    -- 支払 振込
                          ,CASE WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 1 THEN history.DepositGaku
                                ELSE 0
                           END AS PaymentCash        -- 支払 現金
                          ,CASE WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 6 THEN history.DepositGaku
                                ELSE 0
                           END AS PaymentCheck       -- 支払 小切手
                          ,CASE WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 11 THEN history.DepositGaku
                                ELSE 0
                           END AS PaymentBill        -- 支払 手形
                          ,CASE WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 7 THEN history.DepositGaku
                                ELSE 0
                           END AS PaymentOffset      -- 支払 相殺
                          ,CASE WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 12 THEN history.DepositGaku
                                ELSE 0
                           END AS PaymentAdjustment  -- 支払 調整
                      FROM #Temp_D_DepositHistory0 history
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 3
                       AND history.CancelKBN = 0
                   ) D
             GROUP BY D.RegistDate
           ) D15;

    -- 【精算処理】ワークテーブル１６作成
    SELECT * 
      INTO #Temp_D_DepositHistory16
      FROM (
            SELECT RegistDate                                                              -- 登録日
                  ,SUM(OtherAmountReturns) OtherAmountReturns                              -- 他現金 返品
                  ,SUM(OtherAmountDiscount) OtherAmountDiscount                            -- 他現金 値引
                  ,SUM(OtherAmountCancel) OtherAmountCancel                                -- 他現金 値引
                  ,SUM(OtherAmountDelivery) OtherAmountDelivery                            -- 他現金 配達
              FROM (
                    SELECT history.DepositNO 
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate               -- 登録日
                          ,CASE WHEN history.CancelKBN = 2 THEN history.DepositGaku
                                ELSE 0
                           END AS OtherAmountReturns                                       -- 他現金 返品
                          ,0 OtherAmountDiscount                                           -- 他現金 値引
                          ,CASE WHEN history.CancelKBN = 1 THEN history.DepositGaku
                                ELSE 0
                           END AS OtherAmountCancel                                        -- 他現金 値引
                          ,0 OtherAmountDelivery                                           -- 他現金 配達
                      FROM #Temp_D_DepositHistory0 history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                                                   AND sales.DeleteDateTime IS NULL
                                                   AND sales.BillingType = 1
                     WHERE history.DataKBN = 2
                       AND history.DepositKBN = 1
                       AND history.CancelKBN IN (1, 2)
                   ) D
             GROUP BY D.RegistDate
           ) D16;

    -- 【精算処理】ワークテーブル１７作成
    SELECT * 
      INTO #Temp_D_DepositHistory17
      FROM (
            SELECT RegistDate                                                              -- 登録日
                  ,SUM(ByTimeZoneTaxIncluded_0000_0100) ByTimeZoneTaxIncluded_0000_0100    -- 時間帯別(税込) 00:00〜01:00
                  ,SUM(ByTimeZoneTaxIncluded_0100_0200) ByTimeZoneTaxIncluded_0100_0200    -- 時間帯別(税込) 01:00〜02:00
                  ,SUM(ByTimeZoneTaxIncluded_0200_0300) ByTimeZoneTaxIncluded_0200_0300    -- 時間帯別(税込) 02:00〜03:00
                  ,SUM(ByTimeZoneTaxIncluded_0300_0400) ByTimeZoneTaxIncluded_0300_0400    -- 時間帯別(税込) 03:00〜04:00
                  ,SUM(ByTimeZoneTaxIncluded_0400_0500) ByTimeZoneTaxIncluded_0400_0500    -- 時間帯別(税込) 04:00〜05:00
                  ,SUM(ByTimeZoneTaxIncluded_0500_0600) ByTimeZoneTaxIncluded_0500_0600    -- 時間帯別(税込) 05:00〜06:00
                  ,SUM(ByTimeZoneTaxIncluded_0600_0700) ByTimeZoneTaxIncluded_0600_0700    -- 時間帯別(税込) 06:00〜07:00
                  ,SUM(ByTimeZoneTaxIncluded_0700_0800) ByTimeZoneTaxIncluded_0700_0800    -- 時間帯別(税込) 07:00〜08:00
                  ,SUM(ByTimeZoneTaxIncluded_0800_0900) ByTimeZoneTaxIncluded_0800_0900    -- 時間帯別(税込) 08:00〜09:00
                  ,SUM(ByTimeZoneTaxIncluded_0900_1000) ByTimeZoneTaxIncluded_0900_1000    -- 時間帯別(税込) 09:00〜10:00
                  ,SUM(ByTimeZoneTaxIncluded_1000_1100) ByTimeZoneTaxIncluded_1000_1100    -- 時間帯別(税込) 10:00〜11:00
                  ,SUM(ByTimeZoneTaxIncluded_1100_1200) ByTimeZoneTaxIncluded_1100_1200    -- 時間帯別(税込) 11:00〜12:00
                  ,SUM(ByTimeZoneTaxIncluded_1200_1300) ByTimeZoneTaxIncluded_1200_1300    -- 時間帯別(税込) 12:00〜13:00
                  ,SUM(ByTimeZoneTaxIncluded_1300_1400) ByTimeZoneTaxIncluded_1300_1400    -- 時間帯別(税込) 13:00〜14:00
                  ,SUM(ByTimeZoneTaxIncluded_1400_1500) ByTimeZoneTaxIncluded_1400_1500    -- 時間帯別(税込) 14:00〜15:00
                  ,SUM(ByTimeZoneTaxIncluded_1500_1600) ByTimeZoneTaxIncluded_1500_1600    -- 時間帯別(税込) 15:00〜16:00
                  ,SUM(ByTimeZoneTaxIncluded_1600_1700) ByTimeZoneTaxIncluded_1600_1700    -- 時間帯別(税込) 16:00〜17:00
                  ,SUM(ByTimeZoneTaxIncluded_1700_1800) ByTimeZoneTaxIncluded_1700_1800    -- 時間帯別(税込) 17:00〜18:00
                  ,SUM(ByTimeZoneTaxIncluded_1800_1900) ByTimeZoneTaxIncluded_1800_1900    -- 時間帯別(税込) 18:00〜19:00
                  ,SUM(ByTimeZoneTaxIncluded_1900_2000) ByTimeZoneTaxIncluded_1900_2000    -- 時間帯別(税込) 19:00〜20:00
                  ,SUM(ByTimeZoneTaxIncluded_2000_2100) ByTimeZoneTaxIncluded_2000_2100    -- 時間帯別(税込) 20:00〜21:00
                  ,SUM(ByTimeZoneTaxIncluded_2100_2200) ByTimeZoneTaxIncluded_2100_2200    -- 時間帯別(税込) 21:00〜22:00
                  ,SUM(ByTimeZoneTaxIncluded_2200_2300) ByTimeZoneTaxIncluded_2200_2300    -- 時間帯別(税込) 22:00〜23:00
                  ,SUM(ByTimeZoneTaxIncluded_2300_2400) ByTimeZoneTaxIncluded_2300_2400    -- 時間帯別(税込) 23:00〜24:00
                  ,COUNT(ByTimeZoneSalesNO_0000_0100) ByTimeZoneSalesNO_0000_0100          -- 時間帯別(売上番号) 00:00〜01:00
                  ,COUNT(ByTimeZoneSalesNO_0100_0200) ByTimeZoneSalesNO_0100_0200          -- 時間帯別(売上番号) 01:00〜02:00
                  ,COUNT(ByTimeZoneSalesNO_0200_0300) ByTimeZoneSalesNO_0200_0300          -- 時間帯別(売上番号) 02:00〜03:00
                  ,COUNT(ByTimeZoneSalesNO_0300_0400) ByTimeZoneSalesNO_0300_0400          -- 時間帯別(売上番号) 03:00〜04:00
                  ,COUNT(ByTimeZoneSalesNO_0400_0500) ByTimeZoneSalesNO_0400_0500          -- 時間帯別(売上番号) 04:00〜05:00
                  ,COUNT(ByTimeZoneSalesNO_0500_0600) ByTimeZoneSalesNO_0500_0600          -- 時間帯別(売上番号) 05:00〜06:00
                  ,COUNT(ByTimeZoneSalesNO_0600_0700) ByTimeZoneSalesNO_0600_0700          -- 時間帯別(売上番号) 06:00〜07:00
                  ,COUNT(ByTimeZoneSalesNO_0700_0800) ByTimeZoneSalesNO_0700_0800          -- 時間帯別(売上番号) 07:00〜08:00
                  ,COUNT(ByTimeZoneSalesNO_0800_0900) ByTimeZoneSalesNO_0800_0900          -- 時間帯別(売上番号) 08:00〜09:00
                  ,COUNT(ByTimeZoneSalesNO_0900_1000) ByTimeZoneSalesNO_0900_1000          -- 時間帯別(売上番号) 09:00〜10:00
                  ,COUNT(ByTimeZoneSalesNO_1000_1100) ByTimeZoneSalesNO_1000_1100          -- 時間帯別(売上番号) 10:00〜11:00
                  ,COUNT(ByTimeZoneSalesNO_1100_1200) ByTimeZoneSalesNO_1100_1200          -- 時間帯別(売上番号) 11:00〜12:00
                  ,COUNT(ByTimeZoneSalesNO_1200_1300) ByTimeZoneSalesNO_1200_1300          -- 時間帯別(売上番号) 12:00〜13:00
                  ,COUNT(ByTimeZoneSalesNO_1300_1400) ByTimeZoneSalesNO_1300_1400          -- 時間帯別(売上番号) 13:00〜14:00
                  ,COUNT(ByTimeZoneSalesNO_1400_1500) ByTimeZoneSalesNO_1400_1500          -- 時間帯別(売上番号) 14:00〜15:00
                  ,COUNT(ByTimeZoneSalesNO_1500_1600) ByTimeZoneSalesNO_1500_1600          -- 時間帯別(売上番号) 15:00〜16:00
                  ,COUNT(ByTimeZoneSalesNO_1600_1700) ByTimeZoneSalesNO_1600_1700          -- 時間帯別(売上番号) 16:00〜17:00
                  ,COUNT(ByTimeZoneSalesNO_1700_1800) ByTimeZoneSalesNO_1700_1800          -- 時間帯別(売上番号) 17:00〜18:00
                  ,COUNT(ByTimeZoneSalesNO_1800_1900) ByTimeZoneSalesNO_1800_1900          -- 時間帯別(売上番号) 18:00〜19:00
                  ,COUNT(ByTimeZoneSalesNO_1900_2000) ByTimeZoneSalesNO_1900_2000          -- 時間帯別(売上番号) 19:00〜20:00
                  ,COUNT(ByTimeZoneSalesNO_2000_2100) ByTimeZoneSalesNO_2000_2100          -- 時間帯別(売上番号) 20:00〜21:00
                  ,COUNT(ByTimeZoneSalesNO_2100_2200) ByTimeZoneSalesNO_2100_2200          -- 時間帯別(売上番号) 21:00〜22:00
                  ,COUNT(ByTimeZoneSalesNO_2200_2300) ByTimeZoneSalesNO_2200_2300          -- 時間帯別(売上番号) 22:00〜23:00
                  ,COUNT(ByTimeZoneSalesNO_2300_2400) ByTimeZoneSalesNO_2300_2400          -- 時間帯別(売上番号) 23:00〜24:00
              FROM (
                    SELECT history.DepositNO 
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate  -- 登録日
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '00:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '01:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_0000_0100  -- 時間帯別(税込) 00:00〜01:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '01:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '02:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_0100_0200  -- 時間帯別(税込) 01:00〜02:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '02:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '03:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_0200_0300  -- 時間帯別(税込) 02:00〜03:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '03:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '04:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_0300_0400  -- 時間帯別(税込) 03:00〜04:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '04:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '05:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_0400_0500  -- 時間帯別(税込) 04:00〜05:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '05:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '06:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_0500_0600  -- 時間帯別(税込) 05:00〜06:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '06:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '07:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_0600_0700  -- 時間帯別(税込) 06:00〜07:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '07:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '08:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_0700_0800  -- 時間帯別(税込) 07:00〜08:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '08:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '09:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_0800_0900  -- 時間帯別(税込) 08:00〜09:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '09:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '10:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_0900_1000  -- 時間帯別(税込) 09:00〜10:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '10:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '11:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_1000_1100  -- 時間帯別(税込) 10:00〜11:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '11:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '12:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_1100_1200  -- 時間帯別(税込) 11:00〜12:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '12:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '13:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_1200_1300  -- 時間帯別(税込) 12:00〜13:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '13:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '14:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_1300_1400  -- 時間帯別(税込) 13:00〜14:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '14:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '15:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_1400_1500  -- 時間帯別(税込) 14:00〜15:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '15:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '16:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_1500_1600  -- 時間帯別(税込) 15:00〜16:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '16:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '17:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_1600_1700  -- 時間帯別(税込) 16:00〜17:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '17:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '18:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_1700_1800  -- 時間帯別(税込) 17:00〜18:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '18:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '19:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_1800_1900  -- 時間帯別(税込) 18:00〜19:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '19:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '20:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_1900_2000  -- 時間帯別(税込) 19:00〜20:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '20:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '21:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_2000_2100  -- 時間帯別(税込) 20:00〜21:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '21:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '22:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_2100_2200  -- 時間帯別(税込) 21:00〜22:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '22:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '23:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_2200_2300  -- 時間帯別(税込) 22:00〜23:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '23:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '24:00' THEN history.TotalGaku
                                ELSE 0
                           END AS ByTimeZoneTaxIncluded_2300_2400  -- 時間帯別(税込) 23:00〜24:00
                           -- ----------------------------------------------------------------------------------------------------------------------------------------
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '00:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '01:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_0000_0100  -- 時間帯別(売上番号) 00:00〜01:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '01:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '02:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_0100_0200  -- 時間帯別(売上番号) 01:00〜02:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '02:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '03:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_0200_0300  -- 時間帯別(売上番号) 02:00〜03:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '03:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '04:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_0300_0400  -- 時間帯別(売上番号) 03:00〜04:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '04:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '05:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_0400_0500  -- 時間帯別(売上番号) 04:00〜05:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '05:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '06:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_0500_0600  -- 時間帯別(売上番号) 05:00〜06:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '06:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '07:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_0600_0700  -- 時間帯別(売上番号) 06:00〜07:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '07:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '08:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_0700_0800  -- 時間帯別(売上番号) 07:00〜08:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '08:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '09:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_0800_0900  -- 時間帯別(売上番号) 08:00〜09:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '09:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '10:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_0900_1000  -- 時間帯別(売上番号) 09:00〜10:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '10:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '11:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_1000_1100  -- 時間帯別(売上番号) 10:00〜11:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '11:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '12:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_1100_1200  -- 時間帯別(売上番号) 11:00〜12:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '12:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '13:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_1200_1300  -- 時間帯別(売上番号) 12:00〜13:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '13:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '14:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_1300_1400  -- 時間帯別(売上番号) 13:00〜14:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '14:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '15:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_1400_1500  -- 時間帯別(売上番号) 14:00〜15:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '15:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '16:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_1500_1600  -- 時間帯別(売上番号) 15:00〜16:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '16:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '17:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_1600_1700  -- 時間帯別(売上番号) 16:00〜17:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '17:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '18:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_1700_1800  -- 時間帯別(売上番号) 17:00〜18:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '18:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '19:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_1800_1900  -- 時間帯別(売上番号) 18:00〜19:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '19:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '20:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_1900_2000  -- 時間帯別(売上番号) 19:00〜20:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '20:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '21:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_2000_2100  -- 時間帯別(売上番号) 20:00〜21:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '21:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '22:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_2100_2200  -- 時間帯別(売上番号) 21:00〜22:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '22:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '23:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_2200_2300  -- 時間帯別(売上番号) 22:00〜23:00
                          ,CASE WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '23:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '24:00' THEN sales.SalesNO
                                ELSE NULL
                           END AS ByTimeZoneSalesNO_2300_2400  -- 時間帯別(売上番号) 23:00〜24:00
                      FROM #Temp_D_DepositHistory0 history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                                                   AND sales.DeleteDateTime IS NULL
                                                   AND sales.BillingType = 1
                     WHERE history.DataKBN = 2
                       AND history.DepositKBN = 1
                       AND history.CancelKBN = 0
                   ) D
             GROUP BY D.RegistDate
           ) D17;

    -- 【精算処理】ワークテーブル８作成
    SELECT * 
      INTO #Temp_D_DepositHistory8
      FROM (
            SELECT storeCalculation.CalculationDate RegistDate    -- 登録日
                  ,7 DisplayOrder                                 -- 明細表示順位
                  ,storeCalculation.[10000yenNum]                 -- 現金残高10,000枚数
                  ,storeCalculation.[5000yenNum]                  -- 現金残高5,000枚数
                  ,storeCalculation.[2000yenNum]                  -- 現金残高2,000枚数
                  ,storeCalculation.[1000yenNum]                  -- 現金残高1,000枚数
                  ,storeCalculation.[500yenNum]                   -- 現金残高500枚数
                  ,storeCalculation.[100yenNum]                   -- 現金残高100枚数
                  ,storeCalculation.[50yenNum]                    -- 現金残高50枚数
                  ,storeCalculation.[10yenNum]                    -- 現金残高10枚数
                  ,storeCalculation.[5yenNum]                     -- 現金残高5枚数
                  ,storeCalculation.[1yenNum]                     -- 現金残高1枚数
                  ,storeCalculation.[10000yenGaku]                -- 現金残高10,000金額
                  ,storeCalculation.[5000yenGaku]                 -- 現金残高5,000金額
                  ,storeCalculation.[2000yenGaku]                 -- 現金残高2,000金額
                  ,storeCalculation.[1000yenGaku]                 -- 現金残高1,000金額
                  ,storeCalculation.[500yenGaku]                  -- 現金残高500金額
                  ,storeCalculation.[100yenGaku]                  -- 現金残高100金額
                  ,storeCalculation.[50yenGaku]                   -- 現金残高50金額
                  ,storeCalculation.[10yenGaku]                   -- 現金残高10金額
                  ,storeCalculation.[5yenGaku]                    -- 現金残高5金額
                  ,storeCalculation.[1yenGaku]                    -- 現金残高1金額
                  ,storeCalculation.Etcyen                        -- その他金額
                  ,storeCalculation.Change                        -- 釣銭準備金
                  ,tempHistory9.DepositGaku                       -- 現金残高 現金売上(+)
                  ,tempHistory10.DepositGaku CashDeposit          -- 現金残高 現金入金(+)
                  ,tempHistory11.DepositGaku CashPayment          -- 現金残高 現金支払(-) 
                  ,storeCalculation.[10000yenGaku]
                    + storeCalculation.[5000yenGaku]
                    + storeCalculation.[2000yenGaku]
                    + storeCalculation.[1000yenGaku]
                    + storeCalculation.[500yenGaku]
                    + storeCalculation.[100yenGaku]
                    + storeCalculation.[50yenGaku]
                    + storeCalculation.[10yenGaku]
                    + storeCalculation.[5yenGaku]
                    + storeCalculation.[1yenGaku]
                    + storeCalculation.Etcyen
                   AS CashBalance                                 -- 現金残高 現金残高10,000金額〜その他金額までの合計
                  ,storeCalculation.Change
                    + tempHistory9.DepositGaku
                    + tempHistory10.DepositGaku
                    + tempHistory11.DepositGaku
                  AS ComputerTotal                               -- ｺﾝﾋﾟｭｰﾀ計 釣銭準備金〜現金残高 現金支払(-)までの合計
                  ,(
                    storeCalculation.[10000yenGaku]
                     + storeCalculation.[5000yenGaku]
                     + storeCalculation.[2000yenGaku]
                     + storeCalculation.[1000yenGaku]
                     + storeCalculation.[500yenGaku]
                     + storeCalculation.[100yenGaku]
                     + storeCalculation.[50yenGaku]
                     + storeCalculation.[10yenGaku]
                     + storeCalculation.[5yenGaku]
                     + storeCalculation.[1yenGaku]
                     + storeCalculation.Etcyen
                   ) - (
                    storeCalculation.Change
                     + tempHistory9.DepositGaku
                     + tempHistory10.DepositGaku
                     + tempHistory11.DepositGaku
                  ) AS CashShortage                              -- 現金過不足 現金残高-ｺﾝﾋﾟｭｰﾀ計
                  ,tempHistory12.SalesNOCount                     -- 総売 伝票数
                  ,tempHistory12.CustomerCDCount                  -- 総売 客数(人)
                  ,tempHistory12.SalesSUSum                       -- 総売 売上数量
                  ,tempHistory12.TotalGakuSum                     -- 総売 売上金額
                  ,tempHistory13.ForeignTaxableAmount             -- 取引別 外税対象額
                  ,tempHistory13.TaxableAmount                    -- 取引別 内税対象額
                  ,tempHistory13.TaxExemptionAmount               -- 取引別 非課税対象額
                  ,tempHistory13.TotalWithoutTax                  -- 取引別 税抜合計
                  ,tempHistory13.Tax                              -- 取引別 内税
                  ,tempHistory13.OutsideTax                       -- 取引別 外税
                  ,tempHistory13.ConsumptionTax                   -- 取引別 消費税計
                  ,tempHistory13.TaxIncludedTotal                 -- 取引別 税込合計
                  ,tempHistory14.DenominationName1                -- 決済別 金種区分名1
                  ,tempHistory14.Kingaku1                         -- 決済別 金額1
                  ,tempHistory14.DenominationName2                -- 決済別 金種区分名2
                  ,tempHistory14.Kingaku2                         -- 決済別 金額2
                  ,tempHistory14.DenominationName3                -- 決済別 金種区分名3
                  ,tempHistory14.Kingaku3                         -- 決済別 金額3
                  ,tempHistory14.DenominationName4                -- 決済別 金種区分名4
                  ,tempHistory14.Kingaku4                         -- 決済別 金額4
                  ,tempHistory14.DenominationName5                -- 決済別 金種区分名5
                  ,tempHistory14.Kingaku5                         -- 決済別 金額5
                  ,tempHistory14.DenominationName6                -- 決済別 金種区分名6
                  ,tempHistory14.Kingaku6                         -- 決済別 金額6
                  ,tempHistory14.DenominationName7                -- 決済別 金種区分名7
                  ,tempHistory14.Kingaku7                         -- 決済別 金額7
                  ,tempHistory14.DenominationName8                -- 決済別 金種区分名8
                  ,tempHistory14.Kingaku8                         -- 決済別 金額8
                  ,tempHistory14.DenominationName9                -- 決済別 金種区分名9
                  ,tempHistory14.Kingaku9                         -- 決済別 金額9
                  ,tempHistory14.DenominationName10               -- 決済別 金種区分名10
                  ,tempHistory14.Kingaku10                        -- 決済別 金額10
                  ,tempHistory15.DepositTransfer                  -- 入金支払計 入金 振込
                  ,tempHistory15.DepositCash                      -- 入金支払計 入金 現金
                  ,tempHistory15.DepositCheck                     -- 入金支払計 入金 小切手
                  ,tempHistory15.DepositBill                      -- 入金支払計 入金 手形
                  ,tempHistory15.DepositOffset                    -- 入金支払計 入金 相殺
                  ,tempHistory15.DepositAdjustment                -- 入金支払計 入金 調整
                  ,tempHistory15.PaymentTransfer                  -- 入金支払計 支払 振込
                  ,tempHistory15.PaymentCash                      -- 入金支払計 支払 現金
                  ,tempHistory15.PaymentCheck                     -- 入金支払計 支払 小切手
                  ,tempHistory15.PaymentBill                      -- 入金支払計 支払 手形
                  ,tempHistory15.PaymentOffset                    -- 入金支払計 支払 相殺
                  ,tempHistory15.PaymentAdjustment                -- 入金支払計 支払 調整
                  ,tempHistory16.OtherAmountReturns               -- 他金額 返品
                  ,tempHistory16.OtherAmountDiscount              -- 他金額 値引
                  ,tempHistory16.OtherAmountCancel                -- 他金額 取消
                  ,tempHistory16.OtherAmountDelivery              -- 他金額 配達
                  ,tempHistory7.ExchangeCount                     -- 両替回数
                  ,tempHistory17.ByTimeZoneTaxIncluded_0000_0100  -- 時間帯別(税込) 00:00〜01:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0100_0200  -- 時間帯別(税込) 01:00〜02:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0200_0300  -- 時間帯別(税込) 02:00〜03:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0300_0400  -- 時間帯別(税込) 03:00〜04:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0400_0500  -- 時間帯別(税込) 04:00〜05:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0500_0600  -- 時間帯別(税込) 05:00〜06:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0600_0700  -- 時間帯別(税込) 06:00〜07:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0700_0800  -- 時間帯別(税込) 07:00〜08:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0800_0900  -- 時間帯別(税込) 08:00〜09:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0900_1000  -- 時間帯別(税込) 09:00〜10:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1000_1100  -- 時間帯別(税込) 10:00〜11:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1100_1200  -- 時間帯別(税込) 11:00〜12:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1200_1300  -- 時間帯別(税込) 12:00〜13:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1300_1400  -- 時間帯別(税込) 13:00〜14:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1400_1500  -- 時間帯別(税込) 14:00〜15:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1500_1600  -- 時間帯別(税込) 15:00〜16:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1600_1700  -- 時間帯別(税込) 16:00〜17:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1700_1800  -- 時間帯別(税込) 17:00〜18:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1800_1900  -- 時間帯別(税込) 18:00〜19:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1900_2000  -- 時間帯別(税込) 19:00〜20:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_2000_2100  -- 時間帯別(税込) 20:00〜21:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_2100_2200  -- 時間帯別(税込) 21:00〜22:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_2200_2300  -- 時間帯別(税込) 22:00〜23:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_2300_2400  -- 時間帯別(税込) 23:00〜24:00
                  ,tempHistory17.ByTimeZoneSalesNO_0000_0100      -- 時間帯別件数 00:00〜01:00
                  ,tempHistory17.ByTimeZoneSalesNO_0100_0200      -- 時間帯別件数 01:00〜02:00
                  ,tempHistory17.ByTimeZoneSalesNO_0200_0300      -- 時間帯別件数 02:00〜03:00
                  ,tempHistory17.ByTimeZoneSalesNO_0300_0400      -- 時間帯別件数 03:00〜04:00
                  ,tempHistory17.ByTimeZoneSalesNO_0400_0500      -- 時間帯別件数 04:00〜05:00
                  ,tempHistory17.ByTimeZoneSalesNO_0500_0600      -- 時間帯別件数 05:00〜06:00
                  ,tempHistory17.ByTimeZoneSalesNO_0600_0700      -- 時間帯別件数 06:00〜07:00
                  ,tempHistory17.ByTimeZoneSalesNO_0700_0800      -- 時間帯別件数 07:00〜08:00
                  ,tempHistory17.ByTimeZoneSalesNO_0800_0900      -- 時間帯別件数 08:00〜09:00
                  ,tempHistory17.ByTimeZoneSalesNO_0900_1000      -- 時間帯別件数 09:00〜10:00
                  ,tempHistory17.ByTimeZoneSalesNO_1000_1100      -- 時間帯別件数 10:00〜11:00
                  ,tempHistory17.ByTimeZoneSalesNO_1100_1200      -- 時間帯別件数 11:00〜12:00
                  ,tempHistory17.ByTimeZoneSalesNO_1200_1300      -- 時間帯別件数 12:00〜13:00
                  ,tempHistory17.ByTimeZoneSalesNO_1300_1400      -- 時間帯別件数 13:00〜14:00
                  ,tempHistory17.ByTimeZoneSalesNO_1400_1500      -- 時間帯別件数 14:00〜15:00
                  ,tempHistory17.ByTimeZoneSalesNO_1500_1600      -- 時間帯別件数 15:00〜16:00
                  ,tempHistory17.ByTimeZoneSalesNO_1600_1700      -- 時間帯別件数 16:00〜17:00
                  ,tempHistory17.ByTimeZoneSalesNO_1700_1800      -- 時間帯別件数 17:00〜18:00
                  ,tempHistory17.ByTimeZoneSalesNO_1800_1900      -- 時間帯別件数 18:00〜19:00
                  ,tempHistory17.ByTimeZoneSalesNO_1900_2000      -- 時間帯別件数 19:00〜20:00
                  ,tempHistory17.ByTimeZoneSalesNO_2000_2100      -- 時間帯別件数 20:00〜21:00
                  ,tempHistory17.ByTimeZoneSalesNO_2100_2200      -- 時間帯別件数 21:00〜22:00
                  ,tempHistory17.ByTimeZoneSalesNO_2200_2300      -- 時間帯別件数 22:00〜23:00
                  ,tempHistory17.ByTimeZoneSalesNO_2300_2400      -- 時間帯別件数 23:00〜24:00
                  ,tempHistory12.DiscountGaku                     -- 値引額
              FROM #Temp_D_StoreCalculation1 storeCalculation
              LEFT OUTER JOIN #Temp_D_DepositHistory7 tempHistory7   ON tempHistory7.RegistDate  = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory9 tempHistory9   ON tempHistory9.RegistDate  = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory10 tempHistory10 ON tempHistory10.RegistDate = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory11 tempHistory11 ON tempHistory11.RegistDate = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory12 tempHistory12 ON tempHistory12.RegistDate = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory13 tempHistory13 ON tempHistory13.RegistDate = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory14 tempHistory14 ON tempHistory14.RegistDate = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory15 tempHistory15 ON tempHistory15.RegistDate = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory16 tempHistory16 ON tempHistory16.RegistDate = storeCalculation.CalculationDate
              LEFT OUTER JOIN #Temp_D_DepositHistory17 tempHistory17 ON tempHistory17.RegistDate = storeCalculation.CalculationDate
           ) D8;

    -- 最終
    SELECT  
           (SELECT Picture FROM M_Image WHERE ID = 2) Logo                 -- ロゴ
          ,calendar.CalendarDate                                           -- 日付
          ,store.StoreName                                                 -- 店舗名
          ,store.Address1                                                  -- 住所１
          ,store.Address2                                                  -- 住所２
          ,store.TelephoneNO                                               -- 電話番号
          ,tempHistory1.RegistDate IssueDate                               -- 発行日時
          ,tempHistory1.JanCD                                              -- JANCD
          ,tempHistory1.SKUShortName                                       -- 商品名
          ,tempHistory1.SalesUnitPrice                                     -- 単価
          ,tempHistory1.SalesSU                                            -- 数量
          ,tempHistory1.kakaku                                             -- 価格
          ,tempHistory1.SalesTax                                           -- 税額
          ,tempHistory1.SalesTaxRate                                       -- 税率
          ,tempHistory1.TotalGaku                                          -- 販売合計額
          --
          ,(SELECT SUM(CASE WHEN SalesSU IS NULL THEN 1 ELSE SalesSU END) FROM #Temp_D_DepositHistory1 t WHERE t.SalesNO= tempHistory1.SalesNO) SumSalesSU    -- 小計数量
          ,(SELECT SUM(kakaku) FROM #Temp_D_DepositHistory1 t WHERE t.SalesNO = tempHistory1.SalesNO) Subtotal                                                -- 小計金額
          ,tempHistory1.TargetAmount8                                                                                     -- 8％対象額
          ,tempHistory1.SalesTax8 ConsumptionTax8                                                                         -- 外税8％
          ,tempHistory1.TargetAmount10                                                                                    -- 10％対象額
          ,tempHistory1.SalesTax10 ConsumptionTax10                                                                       -- 外税10％
          ,(SELECT SUM(TotalGaku) FROM #Temp_D_DepositHistory1 t WHERE t.SalesNO = tempHistory1.SalesNO) Total            -- 合計
          --
          ,tempHistory2.PaymentName1                             -- 支払方法名1
          ,tempHistory2.AmountPay1                               -- 支払方法額1
          ,tempHistory2.PaymentName2                             -- 支払方法名2
          ,tempHistory2.AmountPay2                               -- 支払方法額2
          ,tempHistory2.PaymentName3                             -- 支払方法名3
          ,tempHistory2.AmountPay3                               -- 支払方法額3
          ,tempHistory2.PaymentName4                             -- 支払方法名4
          ,tempHistory2.AmountPay4                               -- 支払方法額4
          ,tempHistory2.PaymentName5                             -- 支払方法名5
          ,tempHistory2.AmountPay5                               -- 支払方法額5
          ,tempHistory2.PaymentName6                             -- 支払方法名6
          ,tempHistory2.AmountPay6                               -- 支払方法額6
          ,tempHistory2.PaymentName7                             -- 支払方法名7
          ,tempHistory2.AmountPay7                               -- 支払方法額7
          ,tempHistory2.PaymentName8                             -- 支払方法名8
          ,tempHistory2.AmountPay8                               -- 支払方法額8
          ,tempHistory2.PaymentName9                             -- 支払方法名9
          ,tempHistory2.AmountPay9                               -- 支払方法額9
          ,tempHistory2.PaymentName10                            -- 支払方法名10
          ,tempHistory2.AmountPay10                              -- 支払方法額10
          --
          ,tempHistory3.Refund                                   -- 釣銭
          ,tempHistory3.DiscountGaku                             -- 値引額
          --
          ,tempHistory1.StaffReceiptPrint                        -- 担当CD
          ,tempHistory1.StoreReceiptPrint                        -- 店舗CD
          ,tempHistory1.SalesNO                                  -- 売上番号
          --
          ,tempHistory4.RegistDate ChangePreparationRegistDate   -- 登録日
          ,tempHistory4.ChangePreparationDate1                   -- 釣銭準備日1
          ,tempHistory4.ChangePreparationName1                   -- 釣銭準備名1
          ,tempHistory4.ChangePreparationAmount1                 -- 釣銭準備額1
          ,tempHistory4.ChangePreparationDate2                   -- 釣銭準備日2
          ,tempHistory4.ChangePreparationName2                   -- 釣銭準備名2
          ,tempHistory4.ChangePreparationAmount2                 -- 釣銭準備額2
          ,tempHistory4.ChangePreparationDate3                   -- 釣銭準備日3
          ,tempHistory4.ChangePreparationName3                   -- 釣銭準備名3
          ,tempHistory4.ChangePreparationAmount3                 -- 釣銭準備額3
          ,tempHistory4.ChangePreparationDate4                   -- 釣銭準備日4
          ,tempHistory4.ChangePreparationName4                   -- 釣銭準備名4
          ,tempHistory4.ChangePreparationAmount4                 -- 釣銭準備額4
          ,tempHistory4.ChangePreparationDate5                   -- 釣銭準備日5
          ,tempHistory4.ChangePreparationName5                   -- 釣銭準備名5
          ,tempHistory4.ChangePreparationAmount5                 -- 釣銭準備額5
          ,tempHistory4.ChangePreparationDate6                   -- 釣銭準備日6
          ,tempHistory4.ChangePreparationName6                   -- 釣銭準備名6
          ,tempHistory4.ChangePreparationAmount6                 -- 釣銭準備額6
          ,tempHistory4.ChangePreparationDate7                   -- 釣銭準備日7
          ,tempHistory4.ChangePreparationName7                   -- 釣銭準備名7
          ,tempHistory4.ChangePreparationAmount7                 -- 釣銭準備額7
          ,tempHistory4.ChangePreparationDate8                   -- 釣銭準備日8
          ,tempHistory4.ChangePreparationName8                   -- 釣銭準備名8
          ,tempHistory4.ChangePreparationAmount8                 -- 釣銭準備額8
          ,tempHistory4.ChangePreparationDate9                   -- 釣銭準備日9
          ,tempHistory4.ChangePreparationName9                   -- 釣銭準備名9
          ,tempHistory4.ChangePreparationAmount9                 -- 釣銭準備額9
          ,tempHistory4.ChangePreparationDate10                  -- 釣銭準備日10
          ,tempHistory4.ChangePreparationName10                  -- 釣銭準備名10
          ,tempHistory4.ChangePreparationAmount10                -- 釣銭準備額10
          --
          ,tempHistory5.RegistDate MiscDepositRegistDate         -- 登録日
          ,tempHistory5.MiscDepositDate1                         -- 雑入金日1
          ,tempHistory5.MiscDepositName1                         -- 雑入金名1
          ,tempHistory5.MiscDepositAmount1                       -- 雑入金額1
          ,tempHistory5.MiscDepositDate2                         -- 雑入金日2
          ,tempHistory5.MiscDepositName2                         -- 雑入金名2
          ,tempHistory5.MiscDepositAmount2                       -- 雑入金額2
          ,tempHistory5.MiscDepositDate3                         -- 雑入金日3
          ,tempHistory5.MiscDepositName3                         -- 雑入金名3
          ,tempHistory5.MiscDepositAmount3                       -- 雑入金額3
          ,tempHistory5.MiscDepositDate4                         -- 雑入金日4
          ,tempHistory5.MiscDepositName4                         -- 雑入金名4
          ,tempHistory5.MiscDepositAmount4                       -- 雑入金額4
          ,tempHistory5.MiscDepositDate5                         -- 雑入金日5
          ,tempHistory5.MiscDepositName5                         -- 雑入金名5
          ,tempHistory5.MiscDepositAmount5                       -- 雑入金額5
          ,tempHistory5.MiscDepositDate6                         -- 雑入金日6
          ,tempHistory5.MiscDepositName6                         -- 雑入金名6
          ,tempHistory5.MiscDepositAmount6                       -- 雑入金額6
          ,tempHistory5.MiscDepositDate7                         -- 雑入金日7
          ,tempHistory5.MiscDepositName7                         -- 雑入金名7
          ,tempHistory5.MiscDepositAmount7                       -- 雑入金額7
          ,tempHistory5.MiscDepositDate8                         -- 雑入金日8
          ,tempHistory5.MiscDepositName8                         -- 雑入金名8
          ,tempHistory5.MiscDepositAmount8                       -- 雑入金額8
          ,tempHistory5.MiscDepositDate9                         -- 雑入金日9
          ,tempHistory5.MiscDepositName9                         -- 雑入金名9
          ,tempHistory5.MiscDepositAmount9                       -- 雑入金額9
          ,tempHistory5.MiscDepositDate10                        -- 雑入金日10
          ,tempHistory5.MiscDepositName10                        -- 雑入金名10
          ,tempHistory5.MiscDepositAmount10                      -- 雑入金額10
          --
          ,tempHistory51.RegistDate DepositRegistDate            -- 登録日
          ,tempHistory51.CustomerCD                              -- 入金元CD
          ,tempHistory51.CustomerName                            -- 入金元名
          ,tempHistory51.DepositDate1                            -- 入金日1
          ,tempHistory51.DepositName1                            -- 入金名1
          ,tempHistory51.DepositAmount1                          -- 入金額1
          ,tempHistory51.DepositDate2                            -- 入金日2
          ,tempHistory51.DepositName2                            -- 入金名2
          ,tempHistory51.DepositAmount2                          -- 入金額2
          ,tempHistory51.DepositDate3                            -- 入金日3
          ,tempHistory51.DepositName3                            -- 入金名3
          ,tempHistory51.DepositAmount3                          -- 入金額3
          ,tempHistory51.DepositDate4                            -- 入金日4
          ,tempHistory51.DepositName4                            -- 入金名4
          ,tempHistory51.DepositAmount4                          -- 入金額4
          ,tempHistory51.DepositDate5                            -- 入金日5
          ,tempHistory51.DepositName5                            -- 入金名5
          ,tempHistory51.DepositAmount5                          -- 入金額5
          ,tempHistory51.DepositDate6                            -- 入金日6
          ,tempHistory51.DepositName6                            -- 入金名6
          ,tempHistory51.DepositAmount6                          -- 入金額6
          ,tempHistory51.DepositDate7                            -- 入金日7
          ,tempHistory51.DepositName7                            -- 入金名7
          ,tempHistory51.DepositAmount7                          -- 入金額7
          ,tempHistory51.DepositDate8                            -- 入金日8
          ,tempHistory51.DepositName8                            -- 入金名8
          ,tempHistory51.DepositAmount8                          -- 入金額8
          ,tempHistory51.DepositDate9                            -- 入金日9
          ,tempHistory51.DepositName9                            -- 入金名9
          ,tempHistory51.DepositAmount9                          -- 入金額9
          ,tempHistory51.DepositDate10                           -- 入金日10
          ,tempHistory51.DepositName10                           -- 入金名10
          ,tempHistory51.DepositAmount10                         -- 入金額10
          --
          ,tempHistory6.RegistDate MiscPaymentRegistDate         -- 登録日
          ,tempHistory6.MiscPaymentDate1                         -- 雑支払日1
          ,tempHistory6.MiscPaymentName1                         -- 雑支払名1
          ,tempHistory6.MiscPaymentAmount1                       -- 雑支払額1
          ,tempHistory6.MiscPaymentDate2                         -- 雑支払日2
          ,tempHistory6.MiscPaymentName2                         -- 雑支払名2
          ,tempHistory6.MiscPaymentAmount2                       -- 雑支払額2
          ,tempHistory6.MiscPaymentDate3                         -- 雑支払日3
          ,tempHistory6.MiscPaymentName3                         -- 雑支払名3
          ,tempHistory6.MiscPaymentAmount3                       -- 雑支払額3
          ,tempHistory6.MiscPaymentDate4                         -- 雑支払日4
          ,tempHistory6.MiscPaymentName4                         -- 雑支払名4
          ,tempHistory6.MiscPaymentAmount4                       -- 雑支払額4
          ,tempHistory6.MiscPaymentDate5                         -- 雑支払日5
          ,tempHistory6.MiscPaymentName5                         -- 雑支払名5
          ,tempHistory6.MiscPaymentAmount5                       -- 雑支払額5
          ,tempHistory6.MiscPaymentDate6                         -- 雑支払日6
          ,tempHistory6.MiscPaymentName6                         -- 雑支払名6
          ,tempHistory6.MiscPaymentAmount6                       -- 雑支払額6
          ,tempHistory6.MiscPaymentDate7                         -- 雑支払日7
          ,tempHistory6.MiscPaymentName7                         -- 雑支払名7
          ,tempHistory6.MiscPaymentAmount7                       -- 雑支払額7
          ,tempHistory6.MiscPaymentDate8                         -- 雑支払日8
          ,tempHistory6.MiscPaymentName8                         -- 雑支払名8
          ,tempHistory6.MiscPaymentAmount8                       -- 雑支払額8
          ,tempHistory6.MiscPaymentDate9                         -- 雑支払日9
          ,tempHistory6.MiscPaymentName9                         -- 雑支払名9
          ,tempHistory6.MiscPaymentAmount9                       -- 雑支払額9
          ,tempHistory6.MiscPaymentDate10                        -- 雑支払日10
          ,tempHistory6.MiscPaymentName10                        -- 雑支払名10
          ,tempHistory6.MiscPaymentAmount10                      -- 雑支払額10
          --
          ,tempHistory7.RegistDate ExchangeRegistDate            -- 登録日
          ,tempHistory7.ExchangeDate1                            -- 両替日1
          ,tempHistory7.ExchangeName1                            -- 両替名1
          ,tempHistory7.ExchangeAmount1                          -- 両替額1
          ,tempHistory7.ExchangeDenomination1                    -- 両替紙幣1
          ,tempHistory7.ExchangeCount1                           -- 両替枚数1
          ,tempHistory7.ExchangeDate2                            -- 両替日2
          ,tempHistory7.ExchangeName2                            -- 両替名2
          ,tempHistory7.ExchangeAmount2                          -- 両替額2
          ,tempHistory7.ExchangeDenomination2                    -- 両替紙幣2
          ,tempHistory7.ExchangeCount2                           -- 両替枚数2
          ,tempHistory7.ExchangeDate3                            -- 両替日3
          ,tempHistory7.ExchangeName3                            -- 両替名3
          ,tempHistory7.ExchangeAmount3                          -- 両替額3
          ,tempHistory7.ExchangeDenomination3                    -- 両替紙幣3
          ,tempHistory7.ExchangeCount3                           -- 両替枚数3
          ,tempHistory7.ExchangeDate4                            -- 両替日4
          ,tempHistory7.ExchangeName4                            -- 両替名4
          ,tempHistory7.ExchangeAmount4                          -- 両替額4
          ,tempHistory7.ExchangeDenomination4                    -- 両替紙幣4
          ,tempHistory7.ExchangeCount4                           -- 両替枚数4
          ,tempHistory7.ExchangeDate5                            -- 両替日5
          ,tempHistory7.ExchangeName5                            -- 両替名5
          ,tempHistory7.ExchangeAmount5                          -- 両替額5
          ,tempHistory7.ExchangeDenomination5                    -- 両替紙幣5
          ,tempHistory7.ExchangeCount5                           -- 両替枚数5
          ,tempHistory7.ExchangeDate6                            -- 両替日6
          ,tempHistory7.ExchangeName6                            -- 両替名6
          ,tempHistory7.ExchangeAmount6                          -- 両替額6
          ,tempHistory7.ExchangeDenomination6                    -- 両替紙幣6
          ,tempHistory7.ExchangeCount6                           -- 両替枚数6
          ,tempHistory7.ExchangeDate7                            -- 両替日7
          ,tempHistory7.ExchangeName7                            -- 両替名7
          ,tempHistory7.ExchangeAmount7                          -- 両替額7
          ,tempHistory7.ExchangeDenomination7                    -- 両替紙幣7
          ,tempHistory7.ExchangeCount7                           -- 両替枚数7
          ,tempHistory7.ExchangeDate8                            -- 両替日8
          ,tempHistory7.ExchangeName8                            -- 両替名8
          ,tempHistory7.ExchangeAmount8                          -- 両替額8
          ,tempHistory7.ExchangeDenomination8                    -- 両替紙幣8
          ,tempHistory7.ExchangeCount8                           -- 両替枚数8
          ,tempHistory7.ExchangeDate9                            -- 両替日9
          ,tempHistory7.ExchangeName9                            -- 両替名9
          ,tempHistory7.ExchangeAmount9                          -- 両替額9
          ,tempHistory7.ExchangeDenomination9                    -- 両替紙幣9
          ,tempHistory7.ExchangeCount9                           -- 両替枚数9
          ,tempHistory7.ExchangeDate10                           -- 両替日10
          ,tempHistory7.ExchangeName10                           -- 両替名10
          ,tempHistory7.ExchangeAmount10                         -- 両替額10
          ,tempHistory7.ExchangeDenomination10                   -- 両替紙幣10
          ,tempHistory7.ExchangeCount10                          -- 両替枚数10
          --
          ,tempHistory8.RegistDate CashBalanceRegistDate         -- 登録日
          ,tempHistory8.[10000yenNum]                            --【精算処理】現金残高　10,000　枚数
          ,tempHistory8.[5000yenNum]                             --【精算処理】現金残高　5,000　枚数
          ,tempHistory8.[2000yenNum]                             --【精算処理】現金残高　2,000　枚数
          ,tempHistory8.[1000yenNum]                             --【精算処理】現金残高　1,000　枚数
          ,tempHistory8.[500yenNum]                              --【精算処理】現金残高　500　枚数
          ,tempHistory8.[100yenNum]                              --【精算処理】現金残高　100　枚数
          ,tempHistory8.[50yenNum]                               --【精算処理】現金残高　50　枚数
          ,tempHistory8.[10yenNum]                               --【精算処理】現金残高　10　枚数
          ,tempHistory8.[5yenNum]                                --【精算処理】現金残高　5　枚数
          ,tempHistory8.[1yenNum]                                --【精算処理】現金残高　1　枚数
          ,tempHistory8.[10000yenGaku]                           --【精算処理】現金残高　10,000　金額
          ,tempHistory8.[5000yenGaku]                            --【精算処理】現金残高　5,000　金額
          ,tempHistory8.[2000yenGaku]                            --【精算処理】現金残高　2,000　金額
          ,tempHistory8.[1000yenGaku]                            --【精算処理】現金残高　1,000　金額
          ,tempHistory8.[500yenGaku]                             --【精算処理】現金残高　500　金額
          ,tempHistory8.[100yenGaku]                             --【精算処理】現金残高　100　金額
          ,tempHistory8.[50yenGaku]                              --【精算処理】現金残高　50　金額
          ,tempHistory8.[10yenGaku]                              --【精算処理】現金残高　10　金額
          ,tempHistory8.[5yenGaku]                               --【精算処理】現金残高　5　金額
          ,tempHistory8.[1yenGaku]                               --【精算処理】現金残高　1　金額
          ,tempHistory8.Etcyen                                   --【精算処理】その他金額
          ,tempHistory8.Change                                   --【精算処理】釣銭準備金
          ,tempHistory8.DepositGaku                              --【精算処理】現金残高 現金売上(+)
          ,tempHistory8.CashDeposit                              --【精算処理】現金残高 現金入金(+)
          ,tempHistory8.CashPayment                              --【精算処理】現金残高 現金支払(-)
          ,tempHistory8.CashBalance                              --【精算処理】現金残高 その他金額〜現金残高現金支払(-)までの合計
          ,tempHistory8.ComputerTotal                            --【精算処理】ｺﾝﾋﾟｭｰﾀ計 現金残高 10,000　金額〜現金残高　1　金額までの合計
          ,tempHistory8.CashShortage                             --【精算処理】現金残高 現金過不足
          ,tempHistory8.SalesNOCount                             --【精算処理】総売　伝票数
          ,tempHistory8.CustomerCDCount                          --【精算処理】総売　客数(人)
          ,tempHistory8.SalesSUSum                               --【精算処理】総売　売上数量
          ,tempHistory8.TotalGakuSum                             --【精算処理】総売　売上金額
          ,tempHistory8.ForeignTaxableAmount                     --【精算処理】取引別　外税対象額
          ,tempHistory8.TaxableAmount                            --【精算処理】取引別　内税対象額
          ,tempHistory8.TaxExemptionAmount                       --【精算処理】取引別　非課税対象額
          ,tempHistory8.TotalWithoutTax                          --【精算処理】取引別　税抜合計
          ,tempHistory8.Tax                                      --【精算処理】取引別　内税
          ,tempHistory8.OutsideTax                               --【精算処理】取引別　外税
          ,tempHistory8.ConsumptionTax                           --【精算処理】取引別　消費税計
          ,tempHistory8.TaxIncludedTotal                         --【精算処理】取引別　税込合計
          ,tempHistory8.DiscountGaku                             --【精算処理】取引別　値引額
          ,tempHistory8.DenominationName1                        --【精算処理】決済別  金種区分名1
          ,tempHistory8.Kingaku1                                 --【精算処理】決済別  金額1
          ,tempHistory8.DenominationName2                        --【精算処理】決済別  金種区分名2
          ,tempHistory8.Kingaku2                                 --【精算処理】決済別  金額2
          ,tempHistory8.DenominationName3                        --【精算処理】決済別  金種区分名3
          ,tempHistory8.Kingaku3                                 --【精算処理】決済別  金額3
          ,tempHistory8.DenominationName4                        --【精算処理】決済別  金種区分名4
          ,tempHistory8.Kingaku4                                 --【精算処理】決済別  金額4
          ,tempHistory8.DenominationName5                        --【精算処理】決済別  金種区分名5
          ,tempHistory8.Kingaku5                                 --【精算処理】決済別  金額5
          ,tempHistory8.DenominationName6                        --【精算処理】決済別  金種区分名6
          ,tempHistory8.Kingaku6                                 --【精算処理】決済別  金額6
          ,tempHistory8.DenominationName7                        --【精算処理】決済別  金種区分名7
          ,tempHistory8.Kingaku7                                 --【精算処理】決済別  金額7
          ,tempHistory8.DenominationName8                        --【精算処理】決済別  金種区分名8
          ,tempHistory8.Kingaku8                                 --【精算処理】決済別  金額8
          ,tempHistory8.DenominationName9                        --【精算処理】決済別  金種区分名9
          ,tempHistory8.Kingaku9                                 --【精算処理】決済別  金額9
          ,tempHistory8.DenominationName10                       --【精算処理】決済別  金種区分名10
          ,tempHistory8.Kingaku10                                --【精算処理】決済別  金額10
          ,tempHistory8.DepositTransfer                          --【精算処理】入金支払計 入金 振込
          ,tempHistory8.DepositCash                              --【精算処理】入金支払計 入金 現金
          ,tempHistory8.DepositCheck                             --【精算処理】入金支払計 入金 小切手
          ,tempHistory8.DepositBill                              --【精算処理】入金支払計 入金 手形
          ,tempHistory8.DepositOffset                            --【精算処理】入金支払計 入金 相殺
          ,tempHistory8.DepositAdjustment                        --【精算処理】入金支払計 入金 調整
          ,tempHistory8.PaymentTransfer                          --【精算処理】入金支払計 支払 振込
          ,tempHistory8.PaymentCash                              --【精算処理】入金支払計 支払 現金
          ,tempHistory8.PaymentCheck                             --【精算処理】入金支払計 支払 小切手
          ,tempHistory8.PaymentBill                              --【精算処理】入金支払計 支払 手形
          ,tempHistory8.PaymentOffset                            --【精算処理】入金支払計 支払 相殺
          ,tempHistory8.PaymentAdjustment                        --【精算処理】入金支払計 支払 調整
          ,tempHistory8.OtherAmountReturns                       --【精算処理】他金額 返品
          ,tempHistory8.OtherAmountDiscount                      --【精算処理】他金額 値引
          ,tempHistory8.OtherAmountCancel                        --【精算処理】他金額 取消
          ,tempHistory8.OtherAmountDelivery                      --【精算処理】他金額 配達
          ,tempHistory8.ExchangeCount                            --【精算処理】両替回数
          ,tempHistory8.ByTimeZoneTaxIncluded_0000_0100          --【精算処理】時間帯別(税込) 00:00〜01:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0100_0200          --【精算処理】時間帯別(税込) 01:00〜02:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0200_0300          --【精算処理】時間帯別(税込) 02:00〜03:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0300_0400          --【精算処理】時間帯別(税込) 03:00〜04:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0400_0500          --【精算処理】時間帯別(税込) 04:00〜05:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0500_0600          --【精算処理】時間帯別(税込) 05:00〜06:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0600_0700          --【精算処理】時間帯別(税込) 06:00〜07:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0700_0800          --【精算処理】時間帯別(税込) 07:00〜08:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0800_0900          --【精算処理】時間帯別(税込) 08:00〜09:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0900_1000          --【精算処理】時間帯別(税込) 09:00〜10:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1000_1100          --【精算処理】時間帯別(税込) 10:00〜11:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1100_1200          --【精算処理】時間帯別(税込) 11:00〜12:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1200_1300          --【精算処理】時間帯別(税込) 12:00〜13:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1300_1400          --【精算処理】時間帯別(税込) 13:00〜14:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1400_1500          --【精算処理】時間帯別(税込) 14:00〜15:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1500_1600          --【精算処理】時間帯別(税込) 15:00〜16:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1600_1700          --【精算処理】時間帯別(税込) 16:00〜17:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1700_1800          --【精算処理】時間帯別(税込) 17:00〜18:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1800_1900          --【精算処理】時間帯別(税込) 18:00〜19:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1900_2000          --【精算処理】時間帯別(税込) 19:00〜20:00
          ,tempHistory8.ByTimeZoneTaxIncluded_2000_2100          --【精算処理】時間帯別(税込) 20:00〜21:00
          ,tempHistory8.ByTimeZoneTaxIncluded_2100_2200          --【精算処理】時間帯別(税込) 21:00〜22:00
          ,tempHistory8.ByTimeZoneTaxIncluded_2200_2300          --【精算処理】時間帯別(税込) 22:00〜23:00
          ,tempHistory8.ByTimeZoneTaxIncluded_2300_2400          --【精算処理】時間帯別(税込) 23:00〜24:00
          ,tempHistory8.ByTimeZoneSalesNO_0000_0100              --【精算処理】時間帯別件数 00:00〜01:00
          ,tempHistory8.ByTimeZoneSalesNO_0100_0200              --【精算処理】時間帯別件数 01:00〜02:00
          ,tempHistory8.ByTimeZoneSalesNO_0200_0300              --【精算処理】時間帯別件数 02:00〜03:00
          ,tempHistory8.ByTimeZoneSalesNO_0300_0400              --【精算処理】時間帯別件数 03:00〜04:00
          ,tempHistory8.ByTimeZoneSalesNO_0400_0500              --【精算処理】時間帯別件数 04:00〜05:00
          ,tempHistory8.ByTimeZoneSalesNO_0500_0600              --【精算処理】時間帯別件数 05:00〜06:00
          ,tempHistory8.ByTimeZoneSalesNO_0600_0700              --【精算処理】時間帯別件数 06:00〜07:00
          ,tempHistory8.ByTimeZoneSalesNO_0700_0800              --【精算処理】時間帯別件数 07:00〜08:00
          ,tempHistory8.ByTimeZoneSalesNO_0800_0900              --【精算処理】時間帯別件数 08:00〜09:00
          ,tempHistory8.ByTimeZoneSalesNO_0900_1000              --【精算処理】時間帯別件数 09:00〜10:00
          ,tempHistory8.ByTimeZoneSalesNO_1000_1100              --【精算処理】時間帯別件数 10:00〜11:00
          ,tempHistory8.ByTimeZoneSalesNO_1100_1200              --【精算処理】時間帯別件数 11:00〜12:00
          ,tempHistory8.ByTimeZoneSalesNO_1200_1300              --【精算処理】時間帯別件数 12:00〜13:00
          ,tempHistory8.ByTimeZoneSalesNO_1300_1400              --【精算処理】時間帯別件数 13:00〜14:00
          ,tempHistory8.ByTimeZoneSalesNO_1400_1500              --【精算処理】時間帯別件数 14:00〜15:00
          ,tempHistory8.ByTimeZoneSalesNO_1500_1600              --【精算処理】時間帯別件数 15:00〜16:00
          ,tempHistory8.ByTimeZoneSalesNO_1600_1700              --【精算処理】時間帯別件数 16:00〜17:00
          ,tempHistory8.ByTimeZoneSalesNO_1700_1800              --【精算処理】時間帯別件数 17:00〜18:00
          ,tempHistory8.ByTimeZoneSalesNO_1800_1900              --【精算処理】時間帯別件数 18:00〜19:00
          ,tempHistory8.ByTimeZoneSalesNO_1900_2000              --【精算処理】時間帯別件数 19:00〜20:00
          ,tempHistory8.ByTimeZoneSalesNO_2000_2100              --【精算処理】時間帯別件数 20:00〜21:00
          ,tempHistory8.ByTimeZoneSalesNO_2100_2200              --【精算処理】時間帯別件数 21:00〜22:00
          ,tempHistory8.ByTimeZoneSalesNO_2200_2300              --【精算処理】時間帯別件数 22:00〜23:00
          ,tempHistory8.ByTimeZoneSalesNO_2300_2400              --【精算処理】時間帯別件数 23:00〜24:00
      FROM M_Calendar calendar
      LEFT OUTER JOIN (
                       SELECT ROW_NUMBER() OVER(PARTITION BY StoreCD ORDER BY ChangeDate DESC) as RANK
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
                             AND store.StoreCD = @StoreCD
                             AND store.ChangeDate <= CONVERT(DATE, GETDATE())
                             AND store.DeleteFlg = 0
      LEFT OUTER JOIN #Temp_D_DepositHistory1 tempHistory1   ON tempHistory1.StoreCD = store.StoreCD
                                                            AND tempHistory1.AccountingDate = calendar.CalendarDate
      LEFT OUTER JOIN #Temp_D_DepositHistory2 tempHistory2   ON tempHistory2.SalesNO = tempHistory1.SalesNO
      LEFT OUTER JOIN #Temp_D_DepositHistory3 tempHistory3   ON tempHistory3.SalesNO = tempHistory1.SalesNO
      LEFT OUTER JOIN #Temp_D_DepositHistory4 tempHistory4   ON tempHistory4.RegistDate = calendar.CalendarDate
      LEFT OUTER JOIN #Temp_D_DepositHistory5 tempHistory5   ON tempHistory5.RegistDate = calendar.CalendarDate
      LEFT OUTER JOIN #Temp_D_DepositHistory51 tempHistory51 ON tempHistory51.RegistDate = calendar.CalendarDate
      LEFT OUTER JOIN #Temp_D_DepositHistory6 tempHistory6   ON tempHistory6.RegistDate = calendar.CalendarDate
      LEFT OUTER JOIN #Temp_D_DepositHistory7 tempHistory7   ON tempHistory7.RegistDate = calendar.CalendarDate
      LEFT OUTER JOIN #Temp_D_DepositHistory8 tempHistory8   ON tempHistory8.RegistDate = calendar.CalendarDate
     WHERE calendar.CalendarDate >= convert(date, @DateFrom)
       AND calendar.CalendarDate <= convert(date, @DateTo)
     ORDER BY tempHistory1.RegistDate ASC
         ;
    
    -- ワークテーブルを削除
        DROP TABLE #Temp_D_StoreCalculation1;
        DROP TABLE #Temp_D_DepositHistory0;
        DROP TABLE #Temp_D_DepositHistory1;
        DROP TABLE #Temp_D_DepositHistory2;
        DROP TABLE #Temp_D_DepositHistory3;
        DROP TABLE #Temp_D_DepositHistory4;
        DROP TABLE #Temp_D_DepositHistory5;
        DROP TABLE #Temp_D_DepositHistory51;
        DROP TABLE #Temp_D_DepositHistory6;
        DROP TABLE #Temp_D_DepositHistory7;
        DROP TABLE #Temp_D_DepositHistory8;
        DROP TABLE #Temp_D_DepositHistory9;
        DROP TABLE #Temp_D_DepositHistory10;
        DROP TABLE #Temp_D_DepositHistory11;
        DROP TABLE #Temp_D_DepositHistory12;
        DROP TABLE #Temp_D_DepositHistory13;
        DROP TABLE #Temp_D_DepositHistory14;
        DROP TABLE #Temp_D_DepositHistory15;
        DROP TABLE #Temp_D_DepositHistory16;
        DROP TABLE #Temp_D_DepositHistory17;

END
