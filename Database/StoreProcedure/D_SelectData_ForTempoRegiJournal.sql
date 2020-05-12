--  ======================================================================
--       �W���[�i��������擾
--  ======================================================================
USE [CAP]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--  ======================================================================
--       Program Call    �X�܃��W �W���[�i������@�W���[�i������o��
--       Program ID      TempoRegiJournal
--       Create date:    2019.12.11
--    ======================================================================
CREATE PROCEDURE [dbo].[D_SelectData_ForTempoRegiJournal]
(
    @StoreCD   varchar(4),
    @DateFrom  varchar(10),
    @DateTo    varchar(10)
)AS

--********************************************--
--                                            --
--                 �����J�n                   --
--                                            --
--********************************************--

BEGIN
    SET NOCOUNT ON;

    -- ���[�N�e�[�u�����c���Ă���ꍇ�͍폜
    IF OBJECT_ID( N'#Temp_D_StoreCalculation1', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_StoreCalculation1];
    END

    IF OBJECT_ID( N'#Temp_D_DepositHistory1', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_DepositHistory1];
    END

    IF OBJECT_ID( N'#Temp_D_DepositHistory2', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_DepositHistory2];
    END

    IF OBJECT_ID( N'#Temp_D_DepositHistory3', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_DepositHistory3];
    END

    IF OBJECT_ID( N'#Temp_D_DepositHistory4', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_DepositHistory4];
    END

    IF OBJECT_ID( N'#Temp_D_DepositHistory5', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_DepositHistory5];
    END

    IF OBJECT_ID( N'#Temp_D_DepositHistory6', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_DepositHistory6];
    END

    IF OBJECT_ID( N'#Temp_D_DepositHistory7', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_DepositHistory7];
    END

    IF OBJECT_ID( N'#Temp_D_DepositHistory8', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_DepositHistory8];
    END

    IF OBJECT_ID( N'#Temp_D_DepositHistory9', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_DepositHistory9];
    END

    IF OBJECT_ID( N'#Temp_D_DepositHistory10', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_DepositHistory10];
    END

    IF OBJECT_ID( N'#Temp_D_DepositHistory11', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_DepositHistory11];
    END

    IF OBJECT_ID( N'#Temp_D_DepositHistory12', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_DepositHistory12];
    END

    IF OBJECT_ID( N'#Temp_D_DepositHistory13', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_DepositHistory13];
    END

    IF OBJECT_ID( N'#Temp_D_DepositHistory14', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_DepositHistory14];
    END

    IF OBJECT_ID( N'#Temp_D_DepositHistory15', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_DepositHistory15];
    END

    IF OBJECT_ID( N'#Temp_D_DepositHistory16', N'U' ) IS NOT NULL
    BEGIN
        DROP TABLE [#Temp_D_DepositHistory16];
    END

    -- �y�X�ܐ��Z�z���[�N�e�[�u���P�쐬
    SELECT * 
      INTO #Temp_D_StoreCalculation1
      FROM (SELECT storeCalculation.CalculationDate                  -- ���Z��
                  ,storeCalculation.[10000yen] [10000yenNum]         -- �����c��10,000����
                  ,storeCalculation.[5000yen] [5000yenNum]           -- �����c��5,000����
                  ,storeCalculation.[2000yen] [2000yenNum]           -- �����c��2,000����
                  ,storeCalculation.[1000yen] [1000yenNum]           -- �����c��1,000����
                  ,storeCalculation.[500yen] [500yenNum]             -- �����c��500����
                  ,storeCalculation.[100yen] [100yenNum]             -- �����c��100����
                  ,storeCalculation.[50yen] [50yenNum]               -- �����c��50����
                  ,storeCalculation.[10yen] [10yenNum]               -- �����c��10����
                  ,storeCalculation.[5yen] [5yenNum]                 -- �����c��5����
                  ,storeCalculation.[1yen] [1yenNum]                 -- �����c��1����
                  ,storeCalculation.[10000yen]*10000 [10000yenGaku]  -- �����c��10,000���z
                  ,storeCalculation.[5000yen]*5000 [5000yenGaku]     -- �����c��5,000���z
                  ,storeCalculation.[2000yen]*2000 [2000yenGaku]     -- �����c��2,000���z
                  ,storeCalculation.[1000yen]*1000 [1000yenGaku]     -- �����c��1,000���z
                  ,storeCalculation.[500yen]*500 [500yenGaku]        -- �����c��500���z
                  ,storeCalculation.[100yen]*100 [100yenGaku]        -- �����c��100���z
                  ,storeCalculation.[50yen]*50 [50yenGaku]           -- �����c��50���z
                  ,storeCalculation.[10yen]*10 [10yenGaku]           -- �����c��10���z
                  ,storeCalculation.[5yen]*5 [5yenGaku]              -- �����c��5���z
                  ,storeCalculation.[1yen]*1 [1yenGaku]              -- �����c��1���z
                  ,storeCalculation.Change                           -- �ޑK������
                  ,storeCalculation.Etcyen                           -- ���̑����z
              FROM D_StoreCalculation storeCalculation
             WHERE storeCalculation.StoreCD = @StoreCD
               AND CONVERT(varchar, storeCalculation.CalculationDate, 111) >= @DateFrom
               AND CONVERT(varchar, storeCalculation.CalculationDate, 111) <= @DateTo
           ) S1

    -- �y�̔��z���[�N�e�[�u���P�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory1
      FROM (SELECT CONVERT(DATE, history.DepositDateTime) RegistDate  -- �o�^��
                  ,history.Number                                     -- �`�[�ԍ�
                  ,sales.SalesNO                                      -- ����ԍ�
                  ,history.DepositDateTime RegistDateTime             -- �o�^����
                  ,history.StoreCD                                    -- �X��CD
                  ,1 DetailOrder                                      -- ���ו\����
                  ,history.JanCD                                      -- JanCD
                  ,sku.SKUShortName                                   -- ���i��
                  ,history.DepositDateTime IssueDate                  -- ���s����
                  ,CASE
                     WHEN history.SalesSU = 1 THEN NULL
                     ELSE history.SalesUnitPrice
                   END AS SalesUnitPrice                              -- �P��
                  ,CASE
                     WHEN history.SalesSU = 1 THEN NULL
                     ELSE history.SalesSU
                   END AS SalesSU                                     -- ����
                  ,history.SalesGaku                                  -- �̔��z
                  ,history.SalesTax                                   -- �Ŋz
				  ,history.SalesTaxRate                               -- �ŗ�
				  ,history.TotalGaku                                  -- �̔����v�z
                  ,staff.ReceiptPrint StaffReceiptPrint               -- �S�����V�[�g�\�L
                  ,store.ReceiptPrint StoreReceiptPrint               -- �X�܃��V�[�g�\�L
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
               AND history.StoreCD = @StoreCD
               AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
               AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
               AND history.CancelKBN = 0
               AND sales.DeleteDateTime IS NULL
               AND sales.BillingType = 1
               AND sku.DeleteFlg = 0
               AND staff.DeleteFlg = 0
               AND store.DeleteFlg = 0
           ) D1;

    -- �y�̔��z���[�N�e�[�u���Q�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory2
      FROM (SELECT D.Number                                                                           -- �`�[�ԍ�
                  ,MAX(CASE D.DepositNO WHEN  1 THEN D.DenominationName ELSE NULL END) PaymentName1   -- �x�����@��1
                  ,MAX(CASE D.DepositNO WHEN  1 THEN D.DepositGaku      ELSE NULL END) AmountPay1     -- �x�����@�z1
                  ,MAX(CASE D.DepositNO WHEN  2 THEN D.DenominationName ELSE NULL END) PaymentName2   -- �x�����@��2
                  ,MAX(CASE D.DepositNO WHEN  2 THEN D.DepositGaku      ELSE NULL END) AmountPay2     -- �x�����@�z2
                  ,MAX(CASE D.DepositNO WHEN  3 THEN D.DenominationName ELSE NULL END) PaymentName3   -- �x�����@��3
                  ,MAX(CASE D.DepositNO WHEN  3 THEN D.DepositGaku      ELSE NULL END) AmountPay3     -- �x�����@�z3
                  ,MAX(CASE D.DepositNO WHEN  4 THEN D.DenominationName ELSE NULL END) PaymentName4   -- �x�����@��4
                  ,MAX(CASE D.DepositNO WHEN  4 THEN D.DepositGaku      ELSE NULL END) AmountPay4     -- �x�����@�z4
                  ,MAX(CASE D.DepositNO WHEN  5 THEN D.DenominationName ELSE NULL END) PaymentName5   -- �x�����@��5
                  ,MAX(CASE D.DepositNO WHEN  5 THEN D.DepositGaku      ELSE NULL END) AmountPay5     -- �x�����@�z5
                  ,MAX(CASE D.DepositNO WHEN  6 THEN D.DenominationName ELSE NULL END) PaymentName6   -- �x�����@��6
                  ,MAX(CASE D.DepositNO WHEN  6 THEN D.DepositGaku      ELSE NULL END) AmountPay6     -- �x�����@�z6
                  ,MAX(CASE D.DepositNO WHEN  7 THEN D.DenominationName ELSE NULL END) PaymentName7   -- �x�����@��7
                  ,MAX(CASE D.DepositNO WHEN  7 THEN D.DepositGaku      ELSE NULL END) AmountPay7     -- �x�����@�z7
                  ,MAX(CASE D.DepositNO WHEN  8 THEN D.DenominationName ELSE NULL END) PaymentName8   -- �x�����@��8
                  ,MAX(CASE D.DepositNO WHEN  8 THEN D.DepositGaku      ELSE NULL END) AmountPay8     -- �x�����@�z8
                  ,MAX(CASE D.DepositNO WHEN  9 THEN D.DenominationName ELSE NULL END) PaymentName9   -- �x�����@��9
                  ,MAX(CASE D.DepositNO WHEN  9 THEN D.DepositGaku      ELSE NULL END) AmountPay9     -- �x�����@�z9
                  ,MAX(CASE D.DepositNO WHEN 10 THEN D.DenominationName ELSE NULL END) PaymentName10  -- �x�����@��10
                  ,MAX(CASE D.DepositNO WHEN 10 THEN D.DepositGaku      ELSE NULL END) AmountPay10    -- �x�����@�z10
              FROM (SELECT ROW_NUMBER() OVER(PARTITION BY history.Number ORDER BY history.Rows DESC) as DepositNO
                          ,history.Number
                          ,denominationKbn.DenominationName
                          ,history.DepositGaku
                      FROM D_DepositHistory history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 1
                       AND history.StoreCD = @StoreCD
                       AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
                       AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
                       AND history.CancelKBN = 0
                       AND sales.DeleteDateTime IS NULL
                       AND sales.BillingType = 1
                   ) D
             GROUP BY D.Number
           ) D2;

    -- �y�̔��z���[�N�e�[�u���R�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory3
      FROM (SELECT history.Number                          -- �`�[�ԍ�
                  ,SUM(history.Refund) Refund              -- �ޑK
				  ,SUM(history.DiscountGaku) DiscountGaku  -- �l���z
              FROM D_DepositHistory history
              LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
             WHERE history.DataKBN = 1 
               AND history.DepositKBN = 1
               AND history.StoreCD = @StoreCD
               AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
               AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
               AND history.CancelKBN = 0
               AND sales.DeleteDateTime IS NULL
               AND sales.BillingType = 1
             GROUP BY history.Number
           ) D3;

    -- �y�ޑK�����z���[�N�e�[�u���S�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory4
      FROM (SELECT D.RegistDate                                                                                   -- �o�^��
                  ,MAX(CASE D.DepositNO WHEN  1 THEN D.DenominationName ELSE NULL END) ChangePreparationName1     -- �ޑK������1
                  ,MAX(CASE D.DepositNO WHEN  1 THEN D.DepositGaku      ELSE NULL END) ChangePreparationAmount1   -- �ޑK�����z1
                  ,MAX(CASE D.DepositNO WHEN  2 THEN D.DenominationName ELSE NULL END) ChangePreparationName2     -- �ޑK������2
                  ,MAX(CASE D.DepositNO WHEN  2 THEN D.DepositGaku      ELSE NULL END) ChangePreparationAmount2   -- �ޑK�����z2
                  ,MAX(CASE D.DepositNO WHEN  3 THEN D.DenominationName ELSE NULL END) ChangePreparationName3     -- �ޑK������3
                  ,MAX(CASE D.DepositNO WHEN  3 THEN D.DepositGaku      ELSE NULL END) ChangePreparationAmount3   -- �ޑK�����z3
                  ,MAX(CASE D.DepositNO WHEN  4 THEN D.DenominationName ELSE NULL END) ChangePreparationName4     -- �ޑK������4
                  ,MAX(CASE D.DepositNO WHEN  4 THEN D.DepositGaku      ELSE NULL END) ChangePreparationAmount4   -- �ޑK�����z4
                  ,MAX(CASE D.DepositNO WHEN  5 THEN D.DenominationName ELSE NULL END) ChangePreparationName5     -- �ޑK������5
                  ,MAX(CASE D.DepositNO WHEN  5 THEN D.DepositGaku      ELSE NULL END) ChangePreparationAmount5   -- �ޑK�����z5
                  ,MAX(CASE D.DepositNO WHEN  6 THEN D.DenominationName ELSE NULL END) ChangePreparationName6     -- �ޑK������6
                  ,MAX(CASE D.DepositNO WHEN  6 THEN D.DepositGaku      ELSE NULL END) ChangePreparationAmount6   -- �ޑK�����z6
                  ,MAX(CASE D.DepositNO WHEN  7 THEN D.DenominationName ELSE NULL END) ChangePreparationName7     -- �ޑK������7
                  ,MAX(CASE D.DepositNO WHEN  7 THEN D.DepositGaku      ELSE NULL END) ChangePreparationAmount7   -- �ޑK�����z7
                  ,MAX(CASE D.DepositNO WHEN  8 THEN D.DenominationName ELSE NULL END) ChangePreparationName8     -- �ޑK������8
                  ,MAX(CASE D.DepositNO WHEN  8 THEN D.DepositGaku      ELSE NULL END) ChangePreparationAmount8   -- �ޑK�����z8
                  ,MAX(CASE D.DepositNO WHEN  9 THEN D.DenominationName ELSE NULL END) ChangePreparationName9     -- �ޑK������9
                  ,MAX(CASE D.DepositNO WHEN  9 THEN D.DepositGaku      ELSE NULL END) ChangePreparationAmount9   -- �ޑK�����z9
                  ,MAX(CASE D.DepositNO WHEN 10 THEN D.DenominationName ELSE NULL END) ChangePreparationName10    -- �ޑK������10
                  ,MAX(CASE D.DepositNO WHEN 10 THEN D.DepositGaku      ELSE NULL END) ChangePreparationAmount10  -- �ޑK�����z10
              FROM (SELECT ROW_NUMBER() OVER(PARTITION BY history.DepositNO ORDER BY history.DepositDateTime DESC) as DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,denominationKbn.DenominationName
                          ,history.DepositGaku
                      FROM D_DepositHistory history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 6
                       AND history.StoreCD = @StoreCD
                       AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
                       AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
                       AND history.CancelKBN = 0
                       AND sales.DeleteDateTime IS NULL
                       AND sales.BillingType = 1
                   ) D
             GROUP BY D.RegistDate
           ) D4;

    -- �y�G�����z���[�N�e�[�u���T�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory5
      FROM (SELECT D.RegistDate                                                                             -- �o�^��
                  ,MAX(CASE D.DepositNO WHEN  1 THEN D.DenominationName ELSE NULL END) MiscDepositName1     -- �G������1
                  ,MAX(CASE D.DepositNO WHEN  1 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount1   -- �G�����z1
                  ,MAX(CASE D.DepositNO WHEN  2 THEN D.DenominationName ELSE NULL END) MiscDepositName2     -- �G������2
                  ,MAX(CASE D.DepositNO WHEN  2 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount2   -- �G�����z2
                  ,MAX(CASE D.DepositNO WHEN  3 THEN D.DenominationName ELSE NULL END) MiscDepositName3     -- �G������3
                  ,MAX(CASE D.DepositNO WHEN  3 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount3   -- �G�����z3
                  ,MAX(CASE D.DepositNO WHEN  4 THEN D.DenominationName ELSE NULL END) MiscDepositName4     -- �G������4
                  ,MAX(CASE D.DepositNO WHEN  4 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount4   -- �G�����z4
                  ,MAX(CASE D.DepositNO WHEN  5 THEN D.DenominationName ELSE NULL END) MiscDepositName5     -- �G������5
                  ,MAX(CASE D.DepositNO WHEN  5 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount5   -- �G�����z5
                  ,MAX(CASE D.DepositNO WHEN  6 THEN D.DenominationName ELSE NULL END) MiscDepositName6     -- �G������6
                  ,MAX(CASE D.DepositNO WHEN  6 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount6   -- �G�����z6
                  ,MAX(CASE D.DepositNO WHEN  7 THEN D.DenominationName ELSE NULL END) MiscDepositName7     -- �G������7
                  ,MAX(CASE D.DepositNO WHEN  7 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount7   -- �G�����z7
                  ,MAX(CASE D.DepositNO WHEN  8 THEN D.DenominationName ELSE NULL END) MiscDepositName8     -- �G������8
                  ,MAX(CASE D.DepositNO WHEN  8 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount8   -- �G�����z8
                  ,MAX(CASE D.DepositNO WHEN  9 THEN D.DenominationName ELSE NULL END) MiscDepositName9     -- �G������9
                  ,MAX(CASE D.DepositNO WHEN  9 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount9   -- �G�����z9
                  ,MAX(CASE D.DepositNO WHEN 10 THEN D.DenominationName ELSE NULL END) MiscDepositName10    -- �G������10
                  ,MAX(CASE D.DepositNO WHEN 10 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount10  -- �G�����z10
              FROM (SELECT ROW_NUMBER() OVER(PARTITION BY history.DepositNO ORDER BY history.DepositDateTime DESC) as DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,denominationKbn.DenominationName
                          ,history.DepositGaku
                      FROM D_DepositHistory history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 2
                       AND history.StoreCD = @StoreCD
                       AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
                       AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
                       AND history.CancelKBN = 0
                       AND sales.DeleteDateTime IS NULL
                       AND sales.BillingType = 1
					   AND history.CustomerCD IS NULL
                   ) D
             GROUP BY D.RegistDate
           ) D5;

    -- �y�����z���[�N�e�[�u���T�P�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory51
      FROM (SELECT D.RegistDate                                                                         -- �o�^��
                  ,MAX(D.CustomerCD) CustomerCD															-- ������CD
				  ,MAX(D.CustomerName) CustomerName														-- ��������
                  ,MAX(CASE D.DepositNO WHEN  1 THEN D.DenominationName ELSE NULL END) DepositName1     -- �G������1
                  ,MAX(CASE D.DepositNO WHEN  1 THEN D.DepositGaku      ELSE NULL END) DepositAmount1   -- �G�����z1
                  ,MAX(CASE D.DepositNO WHEN  2 THEN D.DenominationName ELSE NULL END) DepositName2     -- �G������2
                  ,MAX(CASE D.DepositNO WHEN  2 THEN D.DepositGaku      ELSE NULL END) DepositAmount2   -- �G�����z2
                  ,MAX(CASE D.DepositNO WHEN  3 THEN D.DenominationName ELSE NULL END) DepositName3     -- �G������3
                  ,MAX(CASE D.DepositNO WHEN  3 THEN D.DepositGaku      ELSE NULL END) DepositAmount3   -- �G�����z3
                  ,MAX(CASE D.DepositNO WHEN  4 THEN D.DenominationName ELSE NULL END) DepositName4     -- �G������4
                  ,MAX(CASE D.DepositNO WHEN  4 THEN D.DepositGaku      ELSE NULL END) DepositAmount4   -- �G�����z4
                  ,MAX(CASE D.DepositNO WHEN  5 THEN D.DenominationName ELSE NULL END) DepositName5     -- �G������5
                  ,MAX(CASE D.DepositNO WHEN  5 THEN D.DepositGaku      ELSE NULL END) DepositAmount5   -- �G�����z5
                  ,MAX(CASE D.DepositNO WHEN  6 THEN D.DenominationName ELSE NULL END) DepositName6     -- �G������6
                  ,MAX(CASE D.DepositNO WHEN  6 THEN D.DepositGaku      ELSE NULL END) DepositAmount6   -- �G�����z6
                  ,MAX(CASE D.DepositNO WHEN  7 THEN D.DenominationName ELSE NULL END) DepositName7     -- �G������7
                  ,MAX(CASE D.DepositNO WHEN  7 THEN D.DepositGaku      ELSE NULL END) DepositAmount7   -- �G�����z7
                  ,MAX(CASE D.DepositNO WHEN  8 THEN D.DenominationName ELSE NULL END) DepositName8     -- �G������8
                  ,MAX(CASE D.DepositNO WHEN  8 THEN D.DepositGaku      ELSE NULL END) DepositAmount8   -- �G�����z8
                  ,MAX(CASE D.DepositNO WHEN  9 THEN D.DenominationName ELSE NULL END) DepositName9     -- �G������9
                  ,MAX(CASE D.DepositNO WHEN  9 THEN D.DepositGaku      ELSE NULL END) DepositAmount9   -- �G�����z9
                  ,MAX(CASE D.DepositNO WHEN 10 THEN D.DenominationName ELSE NULL END) DepositName10    -- �G������10
                  ,MAX(CASE D.DepositNO WHEN 10 THEN D.DepositGaku      ELSE NULL END) DepositAmount10  -- �G�����z10
              FROM (SELECT ROW_NUMBER() OVER(PARTITION BY history.DepositNO ORDER BY history.DepositDateTime DESC) as DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
						  ,customer.CustomerCD
						  ,customer.CustomerName
                          ,denominationKbn.DenominationName
                          ,history.DepositGaku
                      FROM D_DepositHistory history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
					  LEFT OUTER JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY CustomerCD ORDER BY ChangeDate DESC) AS RANK
                                             ,CustomerCD
							                 ,CustomerName
                                             ,ChangeDate
                                             ,DeleteFlg
                                         FROM M_Customer) customer ON customer.RANK = 1
										                          AND customer.CustomerCD = history.CustomerCD
                                                                  AND CONVERT(varchar, customer.ChangeDate, 111) <= CONVERT(varchar, history.DepositDateTime, 111)
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 2
                       AND history.StoreCD = @StoreCD
                       AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
                       AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
                       AND history.CancelKBN = 0
                       AND sales.DeleteDateTime IS NULL
                       AND sales.BillingType = 1
					   AND history.CustomerCD IS NOT NULL
					   AND customer.DeleteFlg = 0
                   ) D
             GROUP BY D.RegistDate
           ) D51;

    -- �y�G�x���z���[�N�e�[�u���U�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory6
      FROM (SELECT D.RegistDate                                                                             -- �o�^��
                  ,MAX(CASE D.DepositNO WHEN  1 THEN D.DenominationName ELSE NULL END) MiscPaymentName1     -- �G�x����1
                  ,MAX(CASE D.DepositNO WHEN  1 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount1   -- �G�x���z1
                  ,MAX(CASE D.DepositNO WHEN  2 THEN D.DenominationName ELSE NULL END) MiscPaymentName2     -- �G�x����2
                  ,MAX(CASE D.DepositNO WHEN  2 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount2   -- �G�x���z2
                  ,MAX(CASE D.DepositNO WHEN  3 THEN D.DenominationName ELSE NULL END) MiscPaymentName3     -- �G�x����3
                  ,MAX(CASE D.DepositNO WHEN  3 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount3   -- �G�x���z3
                  ,MAX(CASE D.DepositNO WHEN  4 THEN D.DenominationName ELSE NULL END) MiscPaymentName4     -- �G�x����4
                  ,MAX(CASE D.DepositNO WHEN  4 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount4   -- �G�x���z4
                  ,MAX(CASE D.DepositNO WHEN  5 THEN D.DenominationName ELSE NULL END) MiscPaymentName5     -- �G�x����5
                  ,MAX(CASE D.DepositNO WHEN  5 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount5   -- �G�x���z5
                  ,MAX(CASE D.DepositNO WHEN  6 THEN D.DenominationName ELSE NULL END) MiscPaymentName6     -- �G�x����6
                  ,MAX(CASE D.DepositNO WHEN  6 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount6   -- �G�x���z6
                  ,MAX(CASE D.DepositNO WHEN  7 THEN D.DenominationName ELSE NULL END) MiscPaymentName7     -- �G�x����7
                  ,MAX(CASE D.DepositNO WHEN  7 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount7   -- �G�x���z7
                  ,MAX(CASE D.DepositNO WHEN  8 THEN D.DenominationName ELSE NULL END) MiscPaymentName8     -- �G�x����8
                  ,MAX(CASE D.DepositNO WHEN  8 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount8   -- �G�x���z8
                  ,MAX(CASE D.DepositNO WHEN  9 THEN D.DenominationName ELSE NULL END) MiscPaymentName9     -- �G�x����9
                  ,MAX(CASE D.DepositNO WHEN  9 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount9   -- �G�x���z9
                  ,MAX(CASE D.DepositNO WHEN 10 THEN D.DenominationName ELSE NULL END) MiscPaymentName10    -- �G�x����10
                  ,MAX(CASE D.DepositNO WHEN 10 THEN D.DepositGaku      ELSE NULL END) MiscPaymentAmount10  -- �G�x���z10
              FROM (SELECT ROW_NUMBER() OVER(PARTITION BY history.DepositNO ORDER BY history.DepositDateTime DESC) as DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,denominationKbn.DenominationName
                          ,history.DepositGaku
                      FROM D_DepositHistory history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 3
                       AND history.StoreCD = @StoreCD
                       AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
                       AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
                       AND history.CancelKBN = 0
                       AND sales.DeleteDateTime IS NULL
                       AND sales.BillingType = 1
                   ) D
             GROUP BY D.RegistDate
           ) D6;

    -- �y���ցz���[�N�e�[�u���V�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory7
      FROM (SELECT D.RegistDate                                                                                    -- �o�^��
                  ,COUNT(*) ExchangeCount                                                                          -- ���։�
                  ,MAX(CASE D.DepositNO WHEN  1 THEN D.DenominationName     ELSE NULL END) ExchangeName1           -- ���֖�1
                  ,MAX(CASE D.DepositNO WHEN  1 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount1         -- ���֊z1
                  ,MAX(CASE D.DepositNO WHEN  1 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination1   -- ���֎���1
                  ,MAX(CASE D.DepositNO WHEN  1 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount1          -- ���֖���1
                  ,MAX(CASE D.DepositNO WHEN  2 THEN D.DenominationName     ELSE NULL END) ExchangeName2           -- ���֖�2
                  ,MAX(CASE D.DepositNO WHEN  2 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount2         -- ���֊z2
                  ,MAX(CASE D.DepositNO WHEN  2 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination2   -- ���֎���2
                  ,MAX(CASE D.DepositNO WHEN  2 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount2          -- ���֖���2
                  ,MAX(CASE D.DepositNO WHEN  3 THEN D.DenominationName     ELSE NULL END) ExchangeName3           -- ���֖�3
                  ,MAX(CASE D.DepositNO WHEN  3 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount3         -- ���֊z3
                  ,MAX(CASE D.DepositNO WHEN  3 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination3   -- ���֎���3
                  ,MAX(CASE D.DepositNO WHEN  3 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount3          -- ���֖���3
                  ,MAX(CASE D.DepositNO WHEN  4 THEN D.DenominationName     ELSE NULL END) ExchangeName4           -- ���֖�4
                  ,MAX(CASE D.DepositNO WHEN  4 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount4         -- ���֊z4
                  ,MAX(CASE D.DepositNO WHEN  4 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination4   -- ���֎���4
                  ,MAX(CASE D.DepositNO WHEN  4 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount4          -- ���֖���4
                  ,MAX(CASE D.DepositNO WHEN  5 THEN D.DenominationName     ELSE NULL END) ExchangeName5           -- ���֖�5
                  ,MAX(CASE D.DepositNO WHEN  5 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount5         -- ���֊z5
                  ,MAX(CASE D.DepositNO WHEN  5 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination5   -- ���֎���5
                  ,MAX(CASE D.DepositNO WHEN  5 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount5          -- ���֖���5
                  ,MAX(CASE D.DepositNO WHEN  6 THEN D.DenominationName     ELSE NULL END) ExchangeName6           -- ���֖�6
                  ,MAX(CASE D.DepositNO WHEN  6 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount6         -- ���֊z6
                  ,MAX(CASE D.DepositNO WHEN  6 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination6   -- ���֎���6
                  ,MAX(CASE D.DepositNO WHEN  6 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount6          -- ���֖���6
                  ,MAX(CASE D.DepositNO WHEN  7 THEN D.DenominationName     ELSE NULL END) ExchangeName7           -- ���֖�7
                  ,MAX(CASE D.DepositNO WHEN  7 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount7         -- ���֊z7
                  ,MAX(CASE D.DepositNO WHEN  7 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination7   -- ���֎���7
                  ,MAX(CASE D.DepositNO WHEN  7 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount7          -- ���֖���7
                  ,MAX(CASE D.DepositNO WHEN  8 THEN D.DenominationName     ELSE NULL END) ExchangeName8           -- ���֖�8
                  ,MAX(CASE D.DepositNO WHEN  8 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount8         -- ���֊z8
                  ,MAX(CASE D.DepositNO WHEN  8 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination8   -- ���֎���8
                  ,MAX(CASE D.DepositNO WHEN  8 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount8          -- ���֖���8
                  ,MAX(CASE D.DepositNO WHEN  9 THEN D.DenominationName     ELSE NULL END) ExchangeName9           -- ���֖�9
                  ,MAX(CASE D.DepositNO WHEN  9 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount9         -- ���֊z9
                  ,MAX(CASE D.DepositNO WHEN  9 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination9   -- ���֎���9
                  ,MAX(CASE D.DepositNO WHEN  9 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount9          -- ���֖���9
                  ,MAX(CASE D.DepositNO WHEN 10 THEN D.DenominationName     ELSE NULL END) ExchangeName10          -- ���֖�10
                  ,MAX(CASE D.DepositNO WHEN 10 THEN D.DepositGaku          ELSE NULL END) ExchangeAmount10        -- ���֊z10
                  ,MAX(CASE D.DepositNO WHEN 10 THEN D.ExchangeDenomination ELSE NULL END) ExchangeDenomination10  -- ���֎���10
                  ,MAX(CASE D.DepositNO WHEN 10 THEN D.ExchangeCount        ELSE NULL END) ExchangeCount10         -- ���֖���10
              FROM (SELECT ROW_NUMBER() OVER(PARTITION BY history.DepositNO ORDER BY history.DepositDateTime DESC) as DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,denominationKbn.DenominationName
                          ,history.DepositGaku
                          ,history.ExchangeDenomination
                          ,history.ExchangeCount
                      FROM D_DepositHistory history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 4
                       AND history.StoreCD = @StoreCD
                       AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
                       AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
                       AND history.CancelKBN = 0
                       AND sales.DeleteDateTime IS NULL
                       AND sales.BillingType = 1
                   ) D
             GROUP BY D.RegistDate
           ) D7;

    -- �y���Z�����F��������(+)�z���[�N�e�[�u���X�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory9
      FROM (SELECT D.RegistDate                -- �o�^��
                  ,SUM(D.TotalGaku) TotalGaku  -- ��������(+)
              FROM (SELECT history.DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,history.TotalGaku
                      FROM D_DepositHistory history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 2
                       AND history.DepositKBN = 1
                       AND history.StoreCD = @StoreCD
                       AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
                       AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
                       AND history.CancelKBN = 0
                       AND sales.DeleteDateTime IS NULL
                       AND sales.BillingType = 1
					   AND denominationKbn.SystemKBN = 1
                   ) D
             GROUP BY D.RegistDate
           ) D9;

    -- �y���Z�����F��������(+)�z���[�N�e�[�u���P�O�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory10
      FROM (SELECT D.RegistDate                    -- �o�^��
                  ,SUM(D.DepositGaku) DepositGaku  -- ��������(+)
              FROM (SELECT history.DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,history.DepositGaku
                      FROM D_DepositHistory history
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 2
                       AND history.StoreCD = @StoreCD
                       AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
                       AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
                       AND history.CancelKBN = 0
                   ) D
             GROUP BY D.RegistDate
           ) D10;

    -- �y���Z�����F�����x��(-)�z���[�N�e�[�u���P�P�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory11
      FROM (SELECT D.RegistDate                    -- �o�^��
                  ,SUM(D.DepositGaku) DepositGaku  -- ��������(-)
              FROM (SELECT history.DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,history.DepositGaku
                      FROM D_DepositHistory history
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 3
                       AND history.StoreCD = @StoreCD
                       AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
                       AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
                       AND history.CancelKBN = 0
                   ) D
             GROUP BY D.RegistDate
           ) D11;

    -- �y���Z�����z���[�N�e�[�u���P�Q�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory12
      FROM (SELECT D.RegistDate                         -- �o�^��
                  ,COUNT(D.SalesNO) SalesNOCount        -- �`�[��
                  ,COUNT(D.CustomerCD) CustomerCDCount  -- �q��
                  ,SUM(D.SalesSU) SalesSUSum            -- ���㐔��
                  ,SUM(D.TotalGaku) TotalGakuSum        -- ������z
				  ,SUM(D.DiscountGaku) DiscountGaku     -- �l���z
              FROM (SELECT history.DepositNO
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,sales.SalesNO
                          ,sales.CustomerCD
                          ,history.SalesSU
                          ,history.TotalGaku
						  ,history.DiscountGaku
                      FROM D_DepositHistory history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                     WHERE history.DataKBN = 2
                       AND history.DepositKBN = 1
                       AND history.StoreCD = @StoreCD
                       AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
                       AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
                       AND history.CancelKBN = 0
                       AND sales.DeleteDateTime IS NULL
                       AND sales.BillingType = 1
                   ) D
             GROUP BY D.RegistDate
           ) D12;

    -- �y���Z�����z���[�N�e�[�u���P�R�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory13
      FROM (SELECT RegistDate  -- �o�^��
                  ,SUM(D.ForeignTaxableAmount) ForeignTaxableAmount           -- �O�őΏۊz�̍��v
                  ,SUM(D.TaxableAmount) TaxableAmount                         -- ���őΏۊz�̍��v
                  ,SUM(D.TaxExemptionAmount) TaxExemptionAmount               -- ��ېőΏۊz�̍��v
                  ,SUM(D.TotalWithoutTax) TotalWithoutTax                     -- �Ŕ����v�̍��v
                  ,SUM(D.Tax) Tax                                             -- ���ł̍��v
                  ,SUM(D.OutsideTax) OutsideTax                               -- �O�ł̍��v
                  ,SUM(D.ConsumptionTax) ConsumptionTax                       -- ����Ōv�̍��v
                  ,SUM(D.TaxIncludedTotal) TaxIncludedTotal                   -- �ō����v�̍��v
              FROM (SELECT history.DepositNO                                  -- 
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate  -- �o�^��
                          ,0 ForeignTaxableAmount                             -- �O�őΏۊz
                          ,salesDetails.SalesHontaiGaku TaxableAmount         -- ���őΏۊz
                          ,0 TaxExemptionAmount                               -- ��ېőΏۊz
                          ,salesDetails.SalesHontaiGaku TotalWithoutTax       -- �Ŕ����v
                          ,salesDetails.SalesTax Tax                          -- ����
                          ,0 OutsideTax                                       -- �O��
                          ,salesDetails.SalesTax ConsumptionTax               -- ����Ōv
                          ,salesDetails.SalesGaku TaxIncludedTotal            -- �ō����v
                      FROM D_DepositHistory history
                      LEFT OUTER JOIN D_SalesDetails salesDetails ON salesDetails.SalesNO = history.Number
                                                                 AND salesDetails.SalesRows = history.[Rows]
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = salesDetails.SalesNO
                     WHERE history.DataKBN = 2
                       AND history.DepositKBN = 1
                       AND history.StoreCD = @StoreCD
                       AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
                       AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
                       AND history.CancelKBN = 0
                       AND salesDetails.DeleteDateTime IS NULL
                       AND sales.DeleteDateTime IS NULL
                       AND sales.BillingType = 1
                   ) D
             GROUP BY D.RegistDate
           ) D13;

    -- �y���Z�����z���[�N�e�[�u���P�S�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory14
      FROM (SELECT D.RegistDate																				-- �o�^��
                  ,MAX(CASE d.rownum WHEN 1 THEN D.DenominationName ELSE null END) AS denominationName1		-- ����敪��1
                  ,MAX(CASE d.rownum WHEN 1 THEN D.Kingaku ELSE null END) AS Kingaku1						-- ���z1
                  ,MAX(CASE d.rownum WHEN 2 THEN D.DenominationName ELSE null END) AS denominationName2		-- ����敪��2
                  ,MAX(CASE d.rownum WHEN 2 THEN D.Kingaku ELSE null END) AS Kingaku2						-- ���z2
                  ,MAX(CASE d.rownum WHEN 3 THEN D.DenominationName ELSE null END) AS denominationName3		-- ����敪��3
                  ,MAX(CASE d.rownum WHEN 3 THEN D.Kingaku ELSE null END) AS Kingaku3						-- ���z3
                  ,MAX(CASE d.rownum WHEN 4 THEN D.DenominationName ELSE null END) AS denominationName4		-- ����敪��4
                  ,MAX(CASE d.rownum WHEN 4 THEN D.Kingaku ELSE null END) AS Kingaku4						-- ���z4
                  ,MAX(CASE d.rownum WHEN 5 THEN D.DenominationName ELSE null END) AS denominationName5		-- ����敪��5
                  ,MAX(CASE d.rownum WHEN 5 THEN D.Kingaku ELSE null END) AS Kingaku5						-- ���z5
                  ,MAX(CASE d.rownum WHEN 6 THEN D.DenominationName ELSE null END) AS denominationName6		-- ����敪��6
                  ,MAX(CASE d.rownum WHEN 6 THEN D.Kingaku ELSE null END) AS Kingaku6						-- ���z6
                  ,MAX(CASE d.rownum WHEN 7 THEN D.DenominationName ELSE null END) AS denominationName7		-- ����敪��7
                  ,MAX(CASE d.rownum WHEN 7 THEN D.Kingaku ELSE null END) AS Kingaku7						-- ���z7
                  ,MAX(CASE d.rownum WHEN 8 THEN D.DenominationName ELSE null END) AS denominationName8		-- ����敪��8
                  ,MAX(CASE d.rownum WHEN 8 THEN D.Kingaku ELSE null END) AS Kingaku8						-- ���z8
                  ,MAX(CASE d.rownum WHEN 9 THEN D.DenominationName ELSE null END) AS denominationName9		-- ����敪��9
                  ,MAX(CASE d.rownum WHEN 9 THEN D.Kingaku ELSE null END) AS Kingaku9						-- ���z9
                  ,MAX(CASE d.rownum WHEN 10 THEN D.DenominationName ELSE null END) AS denominationName10	-- ����敪��10
                  ,MAX(CASE d.rownum WHEN 10 THEN D.Kingaku ELSE null END) AS Kingaku10						-- ���z10
              FROM (SELECT D0.RegistDate
						  ,D0.DenominationCD 
	                      ,D0.DenominationName
				          ,SUM(D0.Kingaku) Kingaku
				          ,ROW_NUMBER() OVER (PARTITION BY D0.RegistDate ORDER BY D0.RegistDate) AS rownum
                      FROM (SELECT history.DepositNO 
                                  ,CONVERT(DATE, history.DepositDateTime) RegistDate
								  ,denominationKbn.DenominationCD 
                                  ,MAX(CASE WHEN denominationKbn.SystemKBN = 2 THEN multiPorpose.IDName
                                            ELSE denominationKbn.DenominationName 
                                       END) DenominationName
						          ,SUM(history.TotalGaku) Kingaku
                              FROM D_DepositHistory history
                              LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                              LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                              LEFT OUTER JOIN M_MultiPorpose multiPorpose ON multiPorpose.[KEY] = denominationKbn.CardCompany
                                                                         AND multiPorpose.ID = 303
                             WHERE history.DataKBN = 2
                               AND history.DepositKBN = 1
                               AND history.StoreCD = @StoreCD
                               AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
                               AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
                               AND history.CancelKBN = 0
                               AND sales.DeleteDateTime IS NULL
                               AND sales.BillingType = 1
					         GROUP BY history.DepositNO 
					                 ,CONVERT(DATE, history.DepositDateTime)
					                 ,denominationKbn.DenominationCD
							         ,denominationKbn.CardCompany
				           ) D0
                     GROUP BY D0.RegistDate
			                 ,D0.DenominationCD
							 ,D0.DenominationName 
                   ) D
             GROUP BY D.RegistDate
           ) D14;

    -- �y���Z�����z���[�N�e�[�u���P�T�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory15
      FROM (SELECT RegistDate
                  ,SUM(DepositTransfer) DepositTransfer      -- ���� �U��
                  ,SUM(DepositCash) DepositCash              -- ���� ����
                  ,SUM(DepositCheck) DepositCheck            -- ���� ���؎�
                  ,SUM(DepositBill) DepositBill              -- ���� ��`
                  ,SUM(DepositOffset) DepositOffset          -- ���� ���E
                  ,SUM(DepositAdjustment) DepositAdjustment  -- ���� ����
                  ,SUM(PaymentTransfer) PaymentTransfer      -- �x�� �U��
                  ,SUM(PaymentCash) PaymentCash              -- �x�� ����
                  ,SUM(PaymentCheck) PaymentCheck            -- �x�� ���؎�
                  ,SUM(PaymentBill) PaymentBill              -- �x�� ��`
                  ,SUM(PaymentOffset) PaymentOffset          -- �x�� ���E
                  ,SUM(PaymentAdjustment) PaymentAdjustment  -- �x�� ����
              FROM (SELECT history.DepositNO 
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate
                          ,CASE
                             WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 5 THEN history.DepositGaku
                             ELSE 0
                           END AS DepositTransfer    -- ���� �U��
                          ,CASE
                             WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 1 THEN history.DepositGaku
                             ELSE 0
                           END AS DepositCash        -- ���� ����
                          ,CASE
                             WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 6 THEN history.DepositGaku
                             ELSE 0
                           END AS DepositCheck       -- ���� ���؎�
                          ,CASE
                             WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 11 THEN history.DepositGaku
                             ELSE 0
                           END AS DepositBill        -- ���� ��`
                          ,CASE
                             WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 7 THEN history.DepositGaku
                             ELSE 0
                           END AS DepositOffset      -- ���� ���E
                          ,CASE
                             WHEN history.DepositKBN = 2 AND denominationKbn.SystemKBN = 12 THEN history.DepositGaku
                             ELSE 0
                           END AS DepositAdjustment  -- ���� ����
                          ,CASE
                             WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 5 THEN history.DepositGaku
                             ELSE 0
                           END AS PaymentTransfer    -- �x�� �U��
                          ,CASE
                             WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 1 THEN history.DepositGaku
                             ELSE 0
                           END AS PaymentCash        -- �x�� ����
                          ,CASE
                             WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 6 THEN history.DepositGaku
                             ELSE 0
                           END AS PaymentCheck       -- �x�� ���؎�
                          ,CASE
                             WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 11 THEN history.DepositGaku
                             ELSE 0
                           END AS PaymentBill        -- �x�� ��`
                          ,CASE
                             WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 7 THEN history.DepositGaku
                             ELSE 0
                           END AS PaymentOffset      -- �x�� ���E
                          ,CASE
                             WHEN history.DepositKBN = 3 AND denominationKbn.SystemKBN = 12 THEN history.DepositGaku
                             ELSE 0
                           END AS PaymentAdjustment  -- �x�� ����
                      FROM D_DepositHistory history
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
                     WHERE history.DataKBN = 3
                       AND history.StoreCD = @StoreCD
                       AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
                       AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
                       AND history.CancelKBN = 0
                   ) D
             GROUP BY D.RegistDate
           ) D15;

    -- �y���Z�����z���[�N�e�[�u���P�U�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory16
      FROM (SELECT RegistDate                                    -- �o�^��
                  ,SUM(OtherAmountReturns) OtherAmountReturns    -- ������ �ԕi
                  ,SUM(OtherAmountDiscount) OtherAmountDiscount  -- ������ �l��
                  ,SUM(OtherAmountCancel) OtherAmountCancel      -- ������ �l��
                  ,SUM(OtherAmountDelivery) OtherAmountDelivery  -- ������ �z�B
              FROM (SELECT history.DepositNO 
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate  -- �o�^��
                          ,CASE
                             WHEN history.CancelKBN = 2 THEN history.DepositGaku
                             ELSE 0
                           END AS OtherAmountReturns  -- ������ �ԕi
                          ,0 OtherAmountDiscount      -- ������ �l��
                          ,CASE
                             WHEN history.CancelKBN = 1 THEN history.DepositGaku
                             ELSE 0
                           END AS OtherAmountCancel   -- ������ �l��
                          ,0 OtherAmountDelivery      -- ������ �z�B
                      FROM D_DepositHistory history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                     WHERE history.DataKBN = 2
                       AND history.DepositKBN = 1
                       AND history.StoreCD = @StoreCD
                       AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
                       AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
                       AND history.CancelKBN IN (1, 2)
                       AND sales.DeleteDateTime IS NULL
                       AND sales.BillingType = 1
                   ) D
             GROUP BY D.RegistDate
           ) D16;

    -- �y���Z�����z���[�N�e�[�u���P�V�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory17
      FROM (SELECT RegistDate  -- �o�^��
                  ,SUM(ByTimeZoneTaxIncluded_0000_0100) ByTimeZoneTaxIncluded_0000_0100    -- ���ԑѕ�(�ō�) 00:00�`01:00
                  ,SUM(ByTimeZoneTaxIncluded_0100_0200) ByTimeZoneTaxIncluded_0100_0200    -- ���ԑѕ�(�ō�) 01:00�`02:00
                  ,SUM(ByTimeZoneTaxIncluded_0200_0300) ByTimeZoneTaxIncluded_0200_0300    -- ���ԑѕ�(�ō�) 02:00�`03:00
                  ,SUM(ByTimeZoneTaxIncluded_0300_0400) ByTimeZoneTaxIncluded_0300_0400    -- ���ԑѕ�(�ō�) 03:00�`04:00
                  ,SUM(ByTimeZoneTaxIncluded_0400_0500) ByTimeZoneTaxIncluded_0400_0500    -- ���ԑѕ�(�ō�) 04:00�`05:00
                  ,SUM(ByTimeZoneTaxIncluded_0500_0600) ByTimeZoneTaxIncluded_0500_0600    -- ���ԑѕ�(�ō�) 05:00�`06:00
                  ,SUM(ByTimeZoneTaxIncluded_0600_0700) ByTimeZoneTaxIncluded_0600_0700    -- ���ԑѕ�(�ō�) 06:00�`07:00
                  ,SUM(ByTimeZoneTaxIncluded_0700_0800) ByTimeZoneTaxIncluded_0700_0800    -- ���ԑѕ�(�ō�) 07:00�`08:00
                  ,SUM(ByTimeZoneTaxIncluded_0800_0900) ByTimeZoneTaxIncluded_0800_0900    -- ���ԑѕ�(�ō�) 08:00�`09:00
                  ,SUM(ByTimeZoneTaxIncluded_0900_1000) ByTimeZoneTaxIncluded_0900_1000    -- ���ԑѕ�(�ō�) 09:00�`10:00
                  ,SUM(ByTimeZoneTaxIncluded_1000_1100) ByTimeZoneTaxIncluded_1000_1100    -- ���ԑѕ�(�ō�) 10:00�`11:00
                  ,SUM(ByTimeZoneTaxIncluded_1100_1200) ByTimeZoneTaxIncluded_1100_1200    -- ���ԑѕ�(�ō�) 11:00�`12:00
                  ,SUM(ByTimeZoneTaxIncluded_1200_1300) ByTimeZoneTaxIncluded_1200_1300    -- ���ԑѕ�(�ō�) 12:00�`13:00
                  ,SUM(ByTimeZoneTaxIncluded_1300_1400) ByTimeZoneTaxIncluded_1300_1400    -- ���ԑѕ�(�ō�) 13:00�`14:00
                  ,SUM(ByTimeZoneTaxIncluded_1400_1500) ByTimeZoneTaxIncluded_1400_1500    -- ���ԑѕ�(�ō�) 14:00�`15:00
                  ,SUM(ByTimeZoneTaxIncluded_1500_1600) ByTimeZoneTaxIncluded_1500_1600    -- ���ԑѕ�(�ō�) 15:00�`16:00
                  ,SUM(ByTimeZoneTaxIncluded_1600_1700) ByTimeZoneTaxIncluded_1600_1700    -- ���ԑѕ�(�ō�) 16:00�`17:00
                  ,SUM(ByTimeZoneTaxIncluded_1700_1800) ByTimeZoneTaxIncluded_1700_1800    -- ���ԑѕ�(�ō�) 17:00�`18:00
                  ,SUM(ByTimeZoneTaxIncluded_1800_1900) ByTimeZoneTaxIncluded_1800_1900    -- ���ԑѕ�(�ō�) 18:00�`19:00
                  ,SUM(ByTimeZoneTaxIncluded_1900_2000) ByTimeZoneTaxIncluded_1900_2000    -- ���ԑѕ�(�ō�) 19:00�`20:00
                  ,SUM(ByTimeZoneTaxIncluded_2000_2100) ByTimeZoneTaxIncluded_2000_2100    -- ���ԑѕ�(�ō�) 20:00�`21:00
                  ,SUM(ByTimeZoneTaxIncluded_2100_2200) ByTimeZoneTaxIncluded_2100_2200    -- ���ԑѕ�(�ō�) 21:00�`22:00
                  ,SUM(ByTimeZoneTaxIncluded_2200_2300) ByTimeZoneTaxIncluded_2200_2300    -- ���ԑѕ�(�ō�) 22:00�`23:00
                  ,SUM(ByTimeZoneTaxIncluded_2300_2400) ByTimeZoneTaxIncluded_2300_2400    -- ���ԑѕ�(�ō�) 23:00�`24:00
                  ,COUNT(ByTimeZoneSalesNO_0000_0100) ByTimeZoneSalesNO_0000_0100          -- ���ԑѕ�(����ԍ�) 00:00�`01:00
                  ,COUNT(ByTimeZoneSalesNO_0100_0200) ByTimeZoneSalesNO_0100_0200          -- ���ԑѕ�(����ԍ�) 01:00�`02:00
                  ,COUNT(ByTimeZoneSalesNO_0200_0300) ByTimeZoneSalesNO_0200_0300          -- ���ԑѕ�(����ԍ�) 02:00�`03:00
                  ,COUNT(ByTimeZoneSalesNO_0300_0400) ByTimeZoneSalesNO_0300_0400          -- ���ԑѕ�(����ԍ�) 03:00�`04:00
                  ,COUNT(ByTimeZoneSalesNO_0400_0500) ByTimeZoneSalesNO_0400_0500          -- ���ԑѕ�(����ԍ�) 04:00�`05:00
                  ,COUNT(ByTimeZoneSalesNO_0500_0600) ByTimeZoneSalesNO_0500_0600          -- ���ԑѕ�(����ԍ�) 05:00�`06:00
                  ,COUNT(ByTimeZoneSalesNO_0600_0700) ByTimeZoneSalesNO_0600_0700          -- ���ԑѕ�(����ԍ�) 06:00�`07:00
                  ,COUNT(ByTimeZoneSalesNO_0700_0800) ByTimeZoneSalesNO_0700_0800          -- ���ԑѕ�(����ԍ�) 07:00�`08:00
                  ,COUNT(ByTimeZoneSalesNO_0800_0900) ByTimeZoneSalesNO_0800_0900          -- ���ԑѕ�(����ԍ�) 08:00�`09:00
                  ,COUNT(ByTimeZoneSalesNO_0900_1000) ByTimeZoneSalesNO_0900_1000          -- ���ԑѕ�(����ԍ�) 09:00�`10:00
                  ,COUNT(ByTimeZoneSalesNO_1000_1100) ByTimeZoneSalesNO_1000_1100          -- ���ԑѕ�(����ԍ�) 10:00�`11:00
                  ,COUNT(ByTimeZoneSalesNO_1100_1200) ByTimeZoneSalesNO_1100_1200          -- ���ԑѕ�(����ԍ�) 11:00�`12:00
                  ,COUNT(ByTimeZoneSalesNO_1200_1300) ByTimeZoneSalesNO_1200_1300          -- ���ԑѕ�(����ԍ�) 12:00�`13:00
                  ,COUNT(ByTimeZoneSalesNO_1300_1400) ByTimeZoneSalesNO_1300_1400          -- ���ԑѕ�(����ԍ�) 13:00�`14:00
                  ,COUNT(ByTimeZoneSalesNO_1400_1500) ByTimeZoneSalesNO_1400_1500          -- ���ԑѕ�(����ԍ�) 14:00�`15:00
                  ,COUNT(ByTimeZoneSalesNO_1500_1600) ByTimeZoneSalesNO_1500_1600          -- ���ԑѕ�(����ԍ�) 15:00�`16:00
                  ,COUNT(ByTimeZoneSalesNO_1600_1700) ByTimeZoneSalesNO_1600_1700          -- ���ԑѕ�(����ԍ�) 16:00�`17:00
                  ,COUNT(ByTimeZoneSalesNO_1700_1800) ByTimeZoneSalesNO_1700_1800          -- ���ԑѕ�(����ԍ�) 17:00�`18:00
                  ,COUNT(ByTimeZoneSalesNO_1800_1900) ByTimeZoneSalesNO_1800_1900          -- ���ԑѕ�(����ԍ�) 18:00�`19:00
                  ,COUNT(ByTimeZoneSalesNO_1900_2000) ByTimeZoneSalesNO_1900_2000          -- ���ԑѕ�(����ԍ�) 19:00�`20:00
                  ,COUNT(ByTimeZoneSalesNO_2000_2100) ByTimeZoneSalesNO_2000_2100          -- ���ԑѕ�(����ԍ�) 20:00�`21:00
                  ,COUNT(ByTimeZoneSalesNO_2100_2200) ByTimeZoneSalesNO_2100_2200          -- ���ԑѕ�(����ԍ�) 21:00�`22:00
                  ,COUNT(ByTimeZoneSalesNO_2200_2300) ByTimeZoneSalesNO_2200_2300          -- ���ԑѕ�(����ԍ�) 22:00�`23:00
                  ,COUNT(ByTimeZoneSalesNO_2300_2400) ByTimeZoneSalesNO_2300_2400          -- ���ԑѕ�(����ԍ�) 23:00�`24:00
              FROM (SELECT history.DepositNO 
                          ,CONVERT(DATE, history.DepositDateTime) RegistDate  -- �o�^��
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '00:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '01:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_0000_0100  -- ���ԑѕ�(�ō�) 00:00�`01:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '01:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '02:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_0100_0200  -- ���ԑѕ�(�ō�) 01:00�`02:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '02:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '03:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_0200_0300  -- ���ԑѕ�(�ō�) 02:00�`03:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '03:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '04:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_0300_0400  -- ���ԑѕ�(�ō�) 03:00�`04:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '04:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '05:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_0400_0500  -- ���ԑѕ�(�ō�) 04:00�`05:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '05:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '06:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_0500_0600  -- ���ԑѕ�(�ō�) 05:00�`06:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '06:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '07:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_0600_0700  -- ���ԑѕ�(�ō�) 06:00�`07:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '07:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '08:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_0700_0800  -- ���ԑѕ�(�ō�) 07:00�`08:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '08:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '09:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_0800_0900  -- ���ԑѕ�(�ō�) 08:00�`09:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '09:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '10:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_0900_1000  -- ���ԑѕ�(�ō�) 09:00�`10:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '10:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '11:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_1000_1100  -- ���ԑѕ�(�ō�) 10:00�`11:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '11:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '12:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_1100_1200  -- ���ԑѕ�(�ō�) 11:00�`12:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '12:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '13:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_1200_1300  -- ���ԑѕ�(�ō�) 12:00�`13:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '13:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '14:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_1300_1400  -- ���ԑѕ�(�ō�) 13:00�`14:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '14:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '15:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_1400_1500  -- ���ԑѕ�(�ō�) 14:00�`15:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '15:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '16:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_1500_1600  -- ���ԑѕ�(�ō�) 15:00�`16:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '16:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '17:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_1600_1700  -- ���ԑѕ�(�ō�) 16:00�`17:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '17:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '18:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_1700_1800  -- ���ԑѕ�(�ō�) 17:00�`18:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '18:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '19:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_1800_1900  -- ���ԑѕ�(�ō�) 18:00�`19:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '19:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '20:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_1900_2000  -- ���ԑѕ�(�ō�) 19:00�`20:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '20:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '21:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_2000_2100  -- ���ԑѕ�(�ō�) 20:00�`21:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '21:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '22:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_2100_2200  -- ���ԑѕ�(�ō�) 21:00�`22:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '22:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '23:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_2200_2300  -- ���ԑѕ�(�ō�) 22:00�`23:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '23:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '24:00' THEN history.TotalGaku
                             ELSE 0
                           END AS ByTimeZoneTaxIncluded_2300_2400  -- ���ԑѕ�(�ō�) 23:00�`24:00
                           -- ----------------------------------------------------------------------------------------------------------------------------------------
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '00:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '01:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_0000_0100  -- ���ԑѕ�(����ԍ�) 00:00�`01:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '01:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '02:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_0100_0200  -- ���ԑѕ�(����ԍ�) 01:00�`02:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '02:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '03:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_0200_0300  -- ���ԑѕ�(����ԍ�) 02:00�`03:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '03:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '04:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_0300_0400  -- ���ԑѕ�(����ԍ�) 03:00�`04:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '04:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '05:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_0400_0500  -- ���ԑѕ�(����ԍ�) 04:00�`05:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '05:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '06:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_0500_0600  -- ���ԑѕ�(����ԍ�) 05:00�`06:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '06:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '07:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_0600_0700  -- ���ԑѕ�(����ԍ�) 06:00�`07:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '07:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '08:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_0700_0800  -- ���ԑѕ�(����ԍ�) 07:00�`08:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '08:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '09:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_0800_0900  -- ���ԑѕ�(����ԍ�) 08:00�`09:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '09:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '10:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_0900_1000  -- ���ԑѕ�(����ԍ�) 09:00�`10:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '10:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '11:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_1000_1100  -- ���ԑѕ�(����ԍ�) 10:00�`11:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '11:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '12:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_1100_1200  -- ���ԑѕ�(����ԍ�) 11:00�`12:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '12:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '13:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_1200_1300  -- ���ԑѕ�(����ԍ�) 12:00�`13:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '13:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '14:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_1300_1400  -- ���ԑѕ�(����ԍ�) 13:00�`14:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '14:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '15:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_1400_1500  -- ���ԑѕ�(����ԍ�) 14:00�`15:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '15:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '16:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_1500_1600  -- ���ԑѕ�(����ԍ�) 15:00�`16:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '16:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '17:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_1600_1700  -- ���ԑѕ�(����ԍ�) 16:00�`17:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '17:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '18:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_1700_1800  -- ���ԑѕ�(����ԍ�) 17:00�`18:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '18:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '19:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_1800_1900  -- ���ԑѕ�(����ԍ�) 18:00�`19:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '19:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '20:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_1900_2000  -- ���ԑѕ�(����ԍ�) 19:00�`20:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '20:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '21:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_2000_2100  -- ���ԑѕ�(����ԍ�) 20:00�`21:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '21:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '22:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_2100_2200  -- ���ԑѕ�(����ԍ�) 21:00�`22:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '22:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '23:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_2200_2300  -- ���ԑѕ�(����ԍ�) 22:00�`23:00
                          ,CASE
                             WHEN FORMAT(history.DepositDateTime, 'HH:mm') >= '23:00' AND FORMAT(history.DepositDateTime, 'HH:mm') < '24:00' THEN sales.SalesNO
                             ELSE NULL
                           END AS ByTimeZoneSalesNO_2300_2400  -- ���ԑѕ�(����ԍ�) 23:00�`24:00
                      FROM D_DepositHistory history
                      LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
                     WHERE history.DataKBN = 2
                       AND history.DepositKBN = 1
                       AND history.StoreCD = @StoreCD
                       AND CONVERT(varchar, history.DepositDateTime, 111) >= @DateFrom
                       AND CONVERT(varchar, history.DepositDateTime, 111) <= @DateTo
                       AND history.CancelKBN = 0
                       AND sales.DeleteDateTime IS NULL
                       AND sales.BillingType = 1
                   ) D
             GROUP BY D.RegistDate
           ) D17;

    -- �y���Z�����z���[�N�e�[�u���W�쐬
    SELECT * 
      INTO #Temp_D_DepositHistory8
      FROM (SELECT storeCalculation.CalculationDate RegistDate    -- �o�^��
                  ,7 DisplayOrder                                 -- ���ו\������
                  ,storeCalculation.[10000yenNum]                 -- �����c��10,000����
                  ,storeCalculation.[5000yenNum]                  -- �����c��5,000����
                  ,storeCalculation.[2000yenNum]                  -- �����c��2,000����
                  ,storeCalculation.[1000yenNum]                  -- �����c��1,000����
                  ,storeCalculation.[500yenNum]                   -- �����c��500����
                  ,storeCalculation.[100yenNum]                   -- �����c��100����
                  ,storeCalculation.[50yenNum]                    -- �����c��50����
                  ,storeCalculation.[10yenNum]                    -- �����c��10����
                  ,storeCalculation.[5yenNum]                     -- �����c��5����
                  ,storeCalculation.[1yenNum]                     -- �����c��1����
                  ,storeCalculation.[10000yenGaku]                -- �����c��10,000���z
                  ,storeCalculation.[5000yenGaku]                 -- �����c��5,000���z
                  ,storeCalculation.[2000yenGaku]                 -- �����c��2,000���z
                  ,storeCalculation.[1000yenGaku]                 -- �����c��1,000���z
                  ,storeCalculation.[500yenGaku]                  -- �����c��500���z
                  ,storeCalculation.[100yenGaku]                  -- �����c��100���z
                  ,storeCalculation.[50yenGaku]                   -- �����c��50���z
                  ,storeCalculation.[10yenGaku]                   -- �����c��10���z
                  ,storeCalculation.[5yenGaku]                    -- �����c��5���z
                  ,storeCalculation.[1yenGaku]                    -- �����c��1���z
                  ,storeCalculation.Etcyen                        -- ���̑����z
                  ,storeCalculation.Change                        -- �ޑK������
                  ,tempHistory9.TotalGaku                         -- �����c�� ��������(+)
                  ,tempHistory10.DepositGaku CashDeposit          -- �����c�� ��������(+)
                  ,tempHistory11.DepositGaku CashPayment          -- �����c�� �����x��(-) 
                  ,storeCalculation.Etcyen
                   + storeCalculation.Change
                   + tempHistory9.TotalGaku
                   + tempHistory10.DepositGaku
                   + tempHistory11.DepositGaku
                   AS CashBalance                                 -- �����c�� ���̑����z�`�����c�������x��(-)�܂ł̍��v
                  ,storeCalculation.[10000yenNum]
                   + storeCalculation.[5000yenNum]
                   + storeCalculation.[2000yenNum]
                   + storeCalculation.[1000yenNum]
                   + storeCalculation.[500yenNum]
                   + storeCalculation.[100yenNum]
                   + storeCalculation.[50yenNum]
                   + storeCalculation.[10yenNum]
                   + storeCalculation.[5yenNum]
                   + storeCalculation.[1yenNum]
                   + storeCalculation.[10000yenGaku]
                   + storeCalculation.[5000yenGaku]
                   + storeCalculation.[2000yenGaku]
                   + storeCalculation.[1000yenGaku]
                   + storeCalculation.[500yenGaku]
                   + storeCalculation.[100yenGaku]
                   + storeCalculation.[50yenGaku]
                   + storeCalculation.[10yenGaku]
                   + storeCalculation.[5yenGaku]
                   + storeCalculation.[1yenGaku]
                   AS ComputerTotal                               -- ���߭���v �����c�� 10,000�@���z�`�����c���@1�@���z�܂ł̍��v  -- 
                  ,ABS(
                     (storeCalculation.Etcyen
                      + storeCalculation.Change
                      + tempHistory9.TotalGaku
                      + tempHistory10.DepositGaku
                      + tempHistory11.DepositGaku)
                     -
                     (storeCalculation.[10000yenNum]
                      + storeCalculation.[5000yenNum]
                      + storeCalculation.[2000yenNum]
                      + storeCalculation.[1000yenNum]
                      + storeCalculation.[500yenNum]
                      + storeCalculation.[100yenNum]
                      + storeCalculation.[50yenNum]
                      + storeCalculation.[10yenNum]
                      + storeCalculation.[5yenNum]
                      + storeCalculation.[1yenNum]
                      + storeCalculation.[10000yenGaku]
                      + storeCalculation.[5000yenGaku]
                      + storeCalculation.[2000yenGaku]
                      + storeCalculation.[1000yenGaku]
                      + storeCalculation.[500yenGaku]
                      + storeCalculation.[100yenGaku]
                      + storeCalculation.[50yenGaku]
                      + storeCalculation.[10yenGaku]
                      + storeCalculation.[5yenGaku]
                      + storeCalculation.[1yenGaku])
                    ) AS CashShortage                             -- �����c�� �����ߕs��
                  ,tempHistory12.SalesNOCount                     -- ���� �`�[��
                  ,tempHistory12.CustomerCDCount                  -- ���� �q��(�l)
                  ,tempHistory12.SalesSUSum                       -- ���� ���㐔��
                  ,tempHistory12.TotalGakuSum                     -- ���� ������z
                  ,tempHistory13.ForeignTaxableAmount             -- ����� �O�őΏۊz
                  ,tempHistory13.TaxableAmount                    -- ����� ���őΏۊz
                  ,tempHistory13.TaxExemptionAmount               -- ����� ��ېőΏۊz
                  ,tempHistory13.TotalWithoutTax                  -- ����� �Ŕ����v
                  ,tempHistory13.Tax                              -- ����� ����
                  ,tempHistory13.OutsideTax                       -- ����� �O��
                  ,tempHistory13.ConsumptionTax                   -- ����� ����Ōv
                  ,tempHistory13.TaxIncludedTotal                 -- ����� �ō����v
				  ,tempHistory14.DenominationName1                -- ���ϕ� ����敪��1
				  ,tempHistory14.Kingaku1                         -- ���ϕ� ���z1
				  ,tempHistory14.DenominationName2                -- ���ϕ� ����敪��2
				  ,tempHistory14.Kingaku2                         -- ���ϕ� ���z2
				  ,tempHistory14.DenominationName3                -- ���ϕ� ����敪��3
				  ,tempHistory14.Kingaku3                         -- ���ϕ� ���z3
				  ,tempHistory14.DenominationName4                -- ���ϕ� ����敪��4
				  ,tempHistory14.Kingaku4                         -- ���ϕ� ���z4
				  ,tempHistory14.DenominationName5                -- ���ϕ� ����敪��5
				  ,tempHistory14.Kingaku5                         -- ���ϕ� ���z5
				  ,tempHistory14.DenominationName6                -- ���ϕ� ����敪��6
				  ,tempHistory14.Kingaku6                         -- ���ϕ� ���z6
				  ,tempHistory14.DenominationName7                -- ���ϕ� ����敪��7
				  ,tempHistory14.Kingaku7                         -- ���ϕ� ���z7
				  ,tempHistory14.DenominationName8                -- ���ϕ� ����敪��8
				  ,tempHistory14.Kingaku8                         -- ���ϕ� ���z8
				  ,tempHistory14.DenominationName9                -- ���ϕ� ����敪��9
				  ,tempHistory14.Kingaku9                         -- ���ϕ� ���z9
				  ,tempHistory14.DenominationName10               -- ���ϕ� ����敪��10
				  ,tempHistory14.Kingaku10                        -- ���ϕ� ���z10
                  ,tempHistory15.DepositTransfer                  -- �����x���v ���� �U��
                  ,tempHistory15.DepositCash                      -- �����x���v ���� ����
                  ,tempHistory15.DepositCheck                     -- �����x���v ���� ���؎�
                  ,tempHistory15.DepositBill                      -- �����x���v ���� ��`
                  ,tempHistory15.DepositOffset                    -- �����x���v ���� ���E
                  ,tempHistory15.DepositAdjustment                -- �����x���v ���� ����
                  ,tempHistory15.PaymentTransfer                  -- �����x���v �x�� �U��
                  ,tempHistory15.PaymentCash                      -- �����x���v �x�� ����
                  ,tempHistory15.PaymentCheck                     -- �����x���v �x�� ���؎�
                  ,tempHistory15.PaymentBill                      -- �����x���v �x�� ��`
                  ,tempHistory15.PaymentOffset                    -- �����x���v �x�� ���E
                  ,tempHistory15.PaymentAdjustment                -- �����x���v �x�� ����
                  ,tempHistory16.OtherAmountReturns               -- �����z �ԕi
                  ,tempHistory16.OtherAmountDiscount              -- �����z �l��
                  ,tempHistory16.OtherAmountCancel                -- �����z ���
                  ,tempHistory16.OtherAmountDelivery              -- �����z �z�B
                  ,tempHistory7.ExchangeCount                     -- ���։�
                  ,tempHistory17.ByTimeZoneTaxIncluded_0000_0100  -- ���ԑѕ�(�ō�) 00:00�`01:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0100_0200  -- ���ԑѕ�(�ō�) 01:00�`02:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0200_0300  -- ���ԑѕ�(�ō�) 02:00�`03:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0300_0400  -- ���ԑѕ�(�ō�) 03:00�`04:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0400_0500  -- ���ԑѕ�(�ō�) 04:00�`05:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0500_0600  -- ���ԑѕ�(�ō�) 05:00�`06:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0600_0700  -- ���ԑѕ�(�ō�) 06:00�`07:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0700_0800  -- ���ԑѕ�(�ō�) 07:00�`08:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0800_0900  -- ���ԑѕ�(�ō�) 08:00�`09:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_0900_1000  -- ���ԑѕ�(�ō�) 09:00�`10:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1000_1100  -- ���ԑѕ�(�ō�) 10:00�`11:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1100_1200  -- ���ԑѕ�(�ō�) 11:00�`12:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1200_1300  -- ���ԑѕ�(�ō�) 12:00�`13:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1300_1400  -- ���ԑѕ�(�ō�) 13:00�`14:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1400_1500  -- ���ԑѕ�(�ō�) 14:00�`15:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1500_1600  -- ���ԑѕ�(�ō�) 15:00�`16:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1600_1700  -- ���ԑѕ�(�ō�) 16:00�`17:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1700_1800  -- ���ԑѕ�(�ō�) 17:00�`18:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1800_1900  -- ���ԑѕ�(�ō�) 18:00�`19:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_1900_2000  -- ���ԑѕ�(�ō�) 19:00�`20:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_2000_2100  -- ���ԑѕ�(�ō�) 20:00�`21:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_2100_2200  -- ���ԑѕ�(�ō�) 21:00�`22:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_2200_2300  -- ���ԑѕ�(�ō�) 22:00�`23:00
                  ,tempHistory17.ByTimeZoneTaxIncluded_2300_2400  -- ���ԑѕ�(�ō�) 23:00�`24:00
                  ,tempHistory17.ByTimeZoneSalesNO_0000_0100      -- ���ԑѕʌ��� 00:00�`01:00
                  ,tempHistory17.ByTimeZoneSalesNO_0100_0200      -- ���ԑѕʌ��� 01:00�`02:00
                  ,tempHistory17.ByTimeZoneSalesNO_0200_0300      -- ���ԑѕʌ��� 02:00�`03:00
                  ,tempHistory17.ByTimeZoneSalesNO_0300_0400      -- ���ԑѕʌ��� 03:00�`04:00
                  ,tempHistory17.ByTimeZoneSalesNO_0400_0500      -- ���ԑѕʌ��� 04:00�`05:00
                  ,tempHistory17.ByTimeZoneSalesNO_0500_0600      -- ���ԑѕʌ��� 05:00�`06:00
                  ,tempHistory17.ByTimeZoneSalesNO_0600_0700      -- ���ԑѕʌ��� 06:00�`07:00
                  ,tempHistory17.ByTimeZoneSalesNO_0700_0800      -- ���ԑѕʌ��� 07:00�`08:00
                  ,tempHistory17.ByTimeZoneSalesNO_0800_0900      -- ���ԑѕʌ��� 08:00�`09:00
                  ,tempHistory17.ByTimeZoneSalesNO_0900_1000      -- ���ԑѕʌ��� 09:00�`10:00
                  ,tempHistory17.ByTimeZoneSalesNO_1000_1100      -- ���ԑѕʌ��� 10:00�`11:00
                  ,tempHistory17.ByTimeZoneSalesNO_1100_1200      -- ���ԑѕʌ��� 11:00�`12:00
                  ,tempHistory17.ByTimeZoneSalesNO_1200_1300      -- ���ԑѕʌ��� 12:00�`13:00
                  ,tempHistory17.ByTimeZoneSalesNO_1300_1400      -- ���ԑѕʌ��� 13:00�`14:00
                  ,tempHistory17.ByTimeZoneSalesNO_1400_1500      -- ���ԑѕʌ��� 14:00�`15:00
                  ,tempHistory17.ByTimeZoneSalesNO_1500_1600      -- ���ԑѕʌ��� 15:00�`16:00
                  ,tempHistory17.ByTimeZoneSalesNO_1600_1700      -- ���ԑѕʌ��� 16:00�`17:00
                  ,tempHistory17.ByTimeZoneSalesNO_1700_1800      -- ���ԑѕʌ��� 17:00�`18:00
                  ,tempHistory17.ByTimeZoneSalesNO_1800_1900      -- ���ԑѕʌ��� 18:00�`19:00
                  ,tempHistory17.ByTimeZoneSalesNO_1900_2000      -- ���ԑѕʌ��� 19:00�`20:00
                  ,tempHistory17.ByTimeZoneSalesNO_2000_2100      -- ���ԑѕʌ��� 20:00�`21:00
                  ,tempHistory17.ByTimeZoneSalesNO_2100_2200      -- ���ԑѕʌ��� 21:00�`22:00
                  ,tempHistory17.ByTimeZoneSalesNO_2200_2300      -- ���ԑѕʌ��� 22:00�`23:00
                  ,tempHistory17.ByTimeZoneSalesNO_2300_2400      -- ���ԑѕʌ��� 23:00�`24:00
				  ,tempHistory12.DiscountGaku                     -- �l���z
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


    -- �ŏI
    SELECT (SELECT Picture FROM M_Image WHERE ID = 2) Logo		-- ���S
	      ,calendar.CalendarDate								-- ���t
	      ,store.StoreName										-- �X�ܖ�
          ,store.Address1										-- �Z���P
          ,store.Address2										-- �Z���Q
          ,store.TelphoneNO										-- �d�b�ԍ�
          ,tempHistory1.IssueDate								-- ���s����
          ,tempHistory1.JanCD									-- JANCD
          ,tempHistory1.SKUShortName							-- ���i��
          ,tempHistory1.SalesUnitPrice							-- �P��
          ,tempHistory1.SalesSU									-- ����
          ,tempHistory1.SalesGaku								-- ���i
          ,tempHistory1.SalesTax								-- �Ŋz
          ,tempHistory1.SalesTaxRate							-- �ŗ�
          ,tempHistory1.TotalGaku								-- �̔����v�z
          --
          ,(SELECT SUM(SalesSU) FROM #Temp_D_DepositHistory1 t WHERE t.SalesNO = tempHistory1.SalesNO) SumSalesSU									-- ���v����
          ,(SELECT SUM(SalesGaku) FROM #Temp_D_DepositHistory1 t WHERE t.SalesNO = tempHistory1.SalesNO) Subtotal									-- ���v���z
		  ,(SELECT SUM(TotalGaku) FROM #Temp_D_DepositHistory1 t WHERE t.SalesNO = tempHistory1.SalesNO AND t.SalesTaxRate = 8) TargetAmount8		-- ����őΏۊz8%
		  ,(SELECT SUM(SalesTax) FROM #Temp_D_DepositHistory1 t WHERE t.SalesNO = tempHistory1.SalesNO AND t.SalesTaxRate = 8) ConsumptionTax8		-- ������œ�8%
		  ,(SELECT SUM(TotalGaku) FROM #Temp_D_DepositHistory1 t WHERE t.SalesNO = tempHistory1.SalesNO AND t.SalesTaxRate = 10) TargetAmount10		-- ����őΏۊz10%
		  ,(SELECT SUM(SalesTax) FROM #Temp_D_DepositHistory1 t WHERE t.SalesNO = tempHistory1.SalesNO AND t.SalesTaxRate = 10) ConsumptionTax10	-- ������œ�10%
		  ,(SELECT SUM(SalesGaku + SalesTax) FROM #Temp_D_DepositHistory1 t WHERE t.SalesNO = tempHistory1.SalesNO) Total							-- ���v
          --
          ,tempHistory2.PaymentName1							-- �x�����@��1
          ,tempHistory2.AmountPay1								-- �x�����@�z1
          ,tempHistory2.PaymentName2							-- �x�����@��2
          ,tempHistory2.AmountPay2								-- �x�����@�z2
          ,tempHistory2.PaymentName3							-- �x�����@��3
          ,tempHistory2.AmountPay3								-- �x�����@�z3
          ,tempHistory2.PaymentName4							-- �x�����@��4
          ,tempHistory2.AmountPay4								-- �x�����@�z4
          ,tempHistory2.PaymentName5							-- �x�����@��5
          ,tempHistory2.AmountPay5								-- �x�����@�z5
          ,tempHistory2.PaymentName6							-- �x�����@��6
          ,tempHistory2.AmountPay6								-- �x�����@�z6
          ,tempHistory2.PaymentName7							-- �x�����@��7
          ,tempHistory2.AmountPay7								-- �x�����@�z7
          ,tempHistory2.PaymentName8							-- �x�����@��8
          ,tempHistory2.AmountPay8								-- �x�����@�z8
          ,tempHistory2.PaymentName9							-- �x�����@��9
          ,tempHistory2.AmountPay9								-- �x�����@�z9
          ,tempHistory2.PaymentName10							-- �x�����@��10
          ,tempHistory2.AmountPay10								-- �x�����@�z10
          --
          ,tempHistory3.Refund									-- �ޑK
		  ,tempHistory3.DiscountGaku							-- �l���z
          --
          ,tempHistory1.StaffReceiptPrint						-- �S��CD
          ,tempHistory1.StoreReceiptPrint						-- �X��CD
          ,tempHistory1.SalesNO									-- ����ԍ�
          --
		  ,tempHistory4.RegistDate ChangePreparationRegistDate	-- �o�^��
          ,tempHistory4.ChangePreparationName1					-- �ޑK������1
          ,tempHistory4.ChangePreparationAmount1				-- �ޑK�����z1
          ,tempHistory4.ChangePreparationName2					-- �ޑK������2
          ,tempHistory4.ChangePreparationAmount2				-- �ޑK�����z2
          ,tempHistory4.ChangePreparationName3					-- �ޑK������3
          ,tempHistory4.ChangePreparationAmount3				-- �ޑK�����z3
          ,tempHistory4.ChangePreparationName4					-- �ޑK������4
          ,tempHistory4.ChangePreparationAmount4				-- �ޑK�����z4
          ,tempHistory4.ChangePreparationName5					-- �ޑK������5
          ,tempHistory4.ChangePreparationAmount5				-- �ޑK�����z5
          ,tempHistory4.ChangePreparationName6					-- �ޑK������6
          ,tempHistory4.ChangePreparationAmount6				-- �ޑK�����z6
          ,tempHistory4.ChangePreparationName7					-- �ޑK������7
          ,tempHistory4.ChangePreparationAmount7				-- �ޑK�����z7
          ,tempHistory4.ChangePreparationName8					-- �ޑK������8
          ,tempHistory4.ChangePreparationAmount8				-- �ޑK�����z8
          ,tempHistory4.ChangePreparationName9					-- �ޑK������9
          ,tempHistory4.ChangePreparationAmount9				-- �ޑK�����z9
          ,tempHistory4.ChangePreparationName10					-- �ޑK������10
          ,tempHistory4.ChangePreparationAmount10				-- �ޑK�����z10
          --
		  ,tempHistory5.RegistDate MiscDepositRegistDate		-- �o�^��
          ,tempHistory5.MiscDepositName1						-- �G������1
          ,tempHistory5.MiscDepositAmount1						-- �G�����z1
          ,tempHistory5.MiscDepositName2						-- �G������2
          ,tempHistory5.MiscDepositAmount2						-- �G�����z2
          ,tempHistory5.MiscDepositName3						-- �G������3
          ,tempHistory5.MiscDepositAmount3						-- �G�����z3
          ,tempHistory5.MiscDepositName4						-- �G������4
          ,tempHistory5.MiscDepositAmount4						-- �G�����z4
          ,tempHistory5.MiscDepositName5						-- �G������5
          ,tempHistory5.MiscDepositAmount5						-- �G�����z5
          ,tempHistory5.MiscDepositName6						-- �G������6
          ,tempHistory5.MiscDepositAmount6						-- �G�����z6
          ,tempHistory5.MiscDepositName7						-- �G������7
          ,tempHistory5.MiscDepositAmount7						-- �G�����z7
          ,tempHistory5.MiscDepositName8						-- �G������8
          ,tempHistory5.MiscDepositAmount8						-- �G�����z8
          ,tempHistory5.MiscDepositName9						-- �G������9
          ,tempHistory5.MiscDepositAmount9						-- �G�����z9
          ,tempHistory5.MiscDepositName10						-- �G������10
          ,tempHistory5.MiscDepositAmount10						-- �G�����z10
          --
		  ,tempHistory51.RegistDate DepositRegistDate			-- �o�^��
		  ,tempHistory51.CustomerCD								-- ������CD
		  ,tempHistory51.CustomerName							-- ��������
          ,tempHistory51.DepositName1							-- ������1
          ,tempHistory51.DepositAmount1							-- �����z1
          ,tempHistory51.DepositName2							-- ������2
          ,tempHistory51.DepositAmount2							-- �����z2
          ,tempHistory51.DepositName3							-- ������3
          ,tempHistory51.DepositAmount3							-- �����z3
          ,tempHistory51.DepositName4							-- ������4
          ,tempHistory51.DepositAmount4							-- �����z4
          ,tempHistory51.DepositName5							-- ������5
          ,tempHistory51.DepositAmount5							-- �����z5
          ,tempHistory51.DepositName6							-- ������6
          ,tempHistory51.DepositAmount6							-- �����z6
          ,tempHistory51.DepositName7							-- ������7
          ,tempHistory51.DepositAmount7							-- �����z7
          ,tempHistory51.DepositName8							-- ������8
          ,tempHistory51.DepositAmount8							-- �����z8
          ,tempHistory51.DepositName9							-- ������9
          ,tempHistory51.DepositAmount9							-- �����z9
          ,tempHistory51.DepositName10							-- ������10
          ,tempHistory51.DepositAmount10						-- �����z10
          --
		  ,tempHistory6.RegistDate MiscPaymentRegistDate		-- �o�^��
          ,tempHistory6.MiscPaymentName1						-- �G�x����1
          ,tempHistory6.MiscPaymentAmount1						-- �G�x���z1
          ,tempHistory6.MiscPaymentName2						-- �G�x����2
          ,tempHistory6.MiscPaymentAmount2						-- �G�x���z2
          ,tempHistory6.MiscPaymentName3						-- �G�x����3
          ,tempHistory6.MiscPaymentAmount3						-- �G�x���z3
          ,tempHistory6.MiscPaymentName4						-- �G�x����4
          ,tempHistory6.MiscPaymentAmount4						-- �G�x���z4
          ,tempHistory6.MiscPaymentName5						-- �G�x����5
          ,tempHistory6.MiscPaymentAmount5						-- �G�x���z5
          ,tempHistory6.MiscPaymentName6						-- �G�x����6
          ,tempHistory6.MiscPaymentAmount6						-- �G�x���z6
          ,tempHistory6.MiscPaymentName7						-- �G�x����7
          ,tempHistory6.MiscPaymentAmount7						-- �G�x���z7
          ,tempHistory6.MiscPaymentName8						-- �G�x����8
          ,tempHistory6.MiscPaymentAmount8						-- �G�x���z8
          ,tempHistory6.MiscPaymentName9						-- �G�x����9
          ,tempHistory6.MiscPaymentAmount9						-- �G�x���z9
          ,tempHistory6.MiscPaymentName10						-- �G�x����10
          ,tempHistory6.MiscPaymentAmount10						-- �G�x���z10
          --
		  ,tempHistory7.RegistDate ExchangeRegistDate			-- �o�^��
          ,tempHistory7.ExchangeName1							-- ���֖�1
          ,tempHistory7.ExchangeAmount1							-- ���֊z1
          ,tempHistory7.ExchangeDenomination1					-- ���֎���1
          ,tempHistory7.ExchangeCount1							-- ���֖���1
          ,tempHistory7.ExchangeName2							-- ���֖�2
          ,tempHistory7.ExchangeAmount2							-- ���֊z2
          ,tempHistory7.ExchangeDenomination2					-- ���֎���2
          ,tempHistory7.ExchangeCount2							-- ���֖���2
          ,tempHistory7.ExchangeName3							-- ���֖�3
          ,tempHistory7.ExchangeAmount3							-- ���֊z3
          ,tempHistory7.ExchangeDenomination3					-- ���֎���3
          ,tempHistory7.ExchangeCount3							-- ���֖���3
          ,tempHistory7.ExchangeName4							-- ���֖�4
          ,tempHistory7.ExchangeAmount4							-- ���֊z4
          ,tempHistory7.ExchangeDenomination4					-- ���֎���4
          ,tempHistory7.ExchangeCount4							-- ���֖���4
          ,tempHistory7.ExchangeName5							-- ���֖�5
          ,tempHistory7.ExchangeAmount5							-- ���֊z5
          ,tempHistory7.ExchangeDenomination5					-- ���֎���5
          ,tempHistory7.ExchangeCount5							-- ���֖���5
          ,tempHistory7.ExchangeName6							-- ���֖�6
          ,tempHistory7.ExchangeAmount6							-- ���֊z6
          ,tempHistory7.ExchangeDenomination6					-- ���֎���6
          ,tempHistory7.ExchangeCount6							-- ���֖���6
          ,tempHistory7.ExchangeName7							-- ���֖�7
          ,tempHistory7.ExchangeAmount7							-- ���֊z7
          ,tempHistory7.ExchangeDenomination7					-- ���֎���7
          ,tempHistory7.ExchangeCount7							-- ���֖���7
          ,tempHistory7.ExchangeName8							-- ���֖�8
          ,tempHistory7.ExchangeAmount8							-- ���֊z8
          ,tempHistory7.ExchangeDenomination8					-- ���֎���8
          ,tempHistory7.ExchangeCount8							-- ���֖���8
          ,tempHistory7.ExchangeName9							-- ���֖�9
          ,tempHistory7.ExchangeAmount9							-- ���֊z9
          ,tempHistory7.ExchangeDenomination9					-- ���֎���9
          ,tempHistory7.ExchangeCount9							-- ���֖���9
          ,tempHistory7.ExchangeName10							-- ���֖�10
          ,tempHistory7.ExchangeAmount10						-- ���֊z10
          ,tempHistory7.ExchangeDenomination10					-- ���֎���10
          ,tempHistory7.ExchangeCount10							-- ���֖���10
          --
		  ,tempHistory8.RegistDate CashBalanceRegistDate		-- �o�^��
          ,tempHistory8.[10000yenNum]                    		--�y���Z�����z�����c���@10,000�@����
          ,tempHistory8.[5000yenNum]                     		--�y���Z�����z�����c���@5,000�@����
          ,tempHistory8.[2000yenNum]                     		--�y���Z�����z�����c���@2,000�@����
          ,tempHistory8.[1000yenNum]                     		--�y���Z�����z�����c���@1,000�@����
          ,tempHistory8.[500yenNum]                      		--�y���Z�����z�����c���@500�@����
          ,tempHistory8.[100yenNum]                      		--�y���Z�����z�����c���@100�@����
          ,tempHistory8.[50yenNum]                      		--�y���Z�����z�����c���@50�@����
          ,tempHistory8.[10yenNum]                       		--�y���Z�����z�����c���@10�@����
          ,tempHistory8.[5yenNum]                        		--�y���Z�����z�����c���@5�@����
          ,tempHistory8.[1yenNum]                        		--�y���Z�����z�����c���@1�@����
          ,tempHistory8.[10000yenGaku]                   		--�y���Z�����z�����c���@10,000�@���z
          ,tempHistory8.[5000yenGaku]                    		--�y���Z�����z�����c���@5,000�@���z
          ,tempHistory8.[2000yenGaku]                    		--�y���Z�����z�����c���@2,000�@���z
          ,tempHistory8.[1000yenGaku]                    		--�y���Z�����z�����c���@1,000�@���z
          ,tempHistory8.[500yenGaku]                     		--�y���Z�����z�����c���@500�@���z
          ,tempHistory8.[100yenGaku]                     		--�y���Z�����z�����c���@100�@���z
          ,tempHistory8.[50yenGaku]                      		--�y���Z�����z�����c���@50�@���z
          ,tempHistory8.[10yenGaku]                      		--�y���Z�����z�����c���@10�@���z
          ,tempHistory8.[5yenGaku]                       		--�y���Z�����z�����c���@5�@���z
          ,tempHistory8.[1yenGaku]                       		--�y���Z�����z�����c���@1�@���z
          ,tempHistory8.Etcyen                           		--�y���Z�����z���̑����z
          ,tempHistory8.Change                           		--�y���Z�����z�ޑK������
          ,tempHistory8.TotalGaku                        		--�y���Z�����z�����c�� ��������(+)
          ,tempHistory8.CashDeposit                      		--�y���Z�����z�����c�� ��������(+)
          ,tempHistory8.CashPayment                      		--�y���Z�����z�����c�� �����x��(-)
          ,tempHistory8.CashBalance                      		--�y���Z�����z�����c�� ���̑����z�`�����c�������x��(-)�܂ł̍��v
          ,tempHistory8.ComputerTotal                    		--�y���Z�����z���߭���v �����c�� 10,000�@���z�`�����c���@1�@���z�܂ł̍��v
          ,tempHistory8.CashShortage                     		--�y���Z�����z�����c�� �����ߕs��
          ,tempHistory8.SalesNOCount                     		--�y���Z�����z�����@�`�[��
          ,tempHistory8.CustomerCDCount                  		--�y���Z�����z�����@�q��(�l)
          ,tempHistory8.SalesSUSum                       		--�y���Z�����z�����@���㐔��
          ,tempHistory8.TotalGakuSum                     		--�y���Z�����z�����@������z
          ,tempHistory8.ForeignTaxableAmount             		--�y���Z�����z����ʁ@�O�őΏۊz
          ,tempHistory8.TaxableAmount                    		--�y���Z�����z����ʁ@���őΏۊz
          ,tempHistory8.TaxExemptionAmount               		--�y���Z�����z����ʁ@��ېőΏۊz
          ,tempHistory8.TotalWithoutTax                  		--�y���Z�����z����ʁ@�Ŕ����v
          ,tempHistory8.Tax                              		--�y���Z�����z����ʁ@����
          ,tempHistory8.OutsideTax                       		--�y���Z�����z����ʁ@�O��
          ,tempHistory8.ConsumptionTax                   		--�y���Z�����z����ʁ@����Ōv
          ,tempHistory8.TaxIncludedTotal                 		--�y���Z�����z����ʁ@�ō����v
		  ,tempHistory8.DiscountGaku                     		--�y���Z�����z����ʁ@�l���z
		  ,tempHistory8.DenominationName1                		--�y���Z�����z���ϕ�  ����敪��1
		  ,tempHistory8.Kingaku1                         		--�y���Z�����z���ϕ�  ���z1
		  ,tempHistory8.DenominationName2                		--�y���Z�����z���ϕ�  ����敪��2
		  ,tempHistory8.Kingaku2                         		--�y���Z�����z���ϕ�  ���z2
		  ,tempHistory8.DenominationName3                		--�y���Z�����z���ϕ�  ����敪��3
		  ,tempHistory8.Kingaku3                         		--�y���Z�����z���ϕ�  ���z3
		  ,tempHistory8.DenominationName4                		--�y���Z�����z���ϕ�  ����敪��4
		  ,tempHistory8.Kingaku4                         		--�y���Z�����z���ϕ�  ���z4
		  ,tempHistory8.DenominationName5                		--�y���Z�����z���ϕ�  ����敪��5
		  ,tempHistory8.Kingaku5                         		--�y���Z�����z���ϕ�  ���z5
		  ,tempHistory8.DenominationName6                		--�y���Z�����z���ϕ�  ����敪��6
		  ,tempHistory8.Kingaku6                         		--�y���Z�����z���ϕ�  ���z6
		  ,tempHistory8.DenominationName7                		--�y���Z�����z���ϕ�  ����敪��7
		  ,tempHistory8.Kingaku7                         		--�y���Z�����z���ϕ�  ���z7
		  ,tempHistory8.DenominationName8                		--�y���Z�����z���ϕ�  ����敪��8
		  ,tempHistory8.Kingaku8                         		--�y���Z�����z���ϕ�  ���z8
		  ,tempHistory8.DenominationName9                		--�y���Z�����z���ϕ�  ����敪��9
		  ,tempHistory8.Kingaku9                         		--�y���Z�����z���ϕ�  ���z9
		  ,tempHistory8.DenominationName10               		--�y���Z�����z���ϕ�  ����敪��10
		  ,tempHistory8.Kingaku10                        		--�y���Z�����z���ϕ�  ���z10
          ,tempHistory8.DepositTransfer                  		--�y���Z�����z�����x���v ���� �U��
          ,tempHistory8.DepositCash                      		--�y���Z�����z�����x���v ���� ����
          ,tempHistory8.DepositCheck                     		--�y���Z�����z�����x���v ���� ���؎�
          ,tempHistory8.DepositBill                      		--�y���Z�����z�����x���v ���� ��`
          ,tempHistory8.DepositOffset                    		--�y���Z�����z�����x���v ���� ���E
          ,tempHistory8.DepositAdjustment                		--�y���Z�����z�����x���v ���� ����
          ,tempHistory8.PaymentTransfer                  		--�y���Z�����z�����x���v �x�� �U��
          ,tempHistory8.PaymentCash                      		--�y���Z�����z�����x���v �x�� ����
          ,tempHistory8.PaymentCheck                     		--�y���Z�����z�����x���v �x�� ���؎�
          ,tempHistory8.PaymentBill                      		--�y���Z�����z�����x���v �x�� ��`
          ,tempHistory8.PaymentOffset                    		--�y���Z�����z�����x���v �x�� ���E
          ,tempHistory8.PaymentAdjustment                		--�y���Z�����z�����x���v �x�� ����
          ,tempHistory8.OtherAmountReturns               		--�y���Z�����z�����z �ԕi
          ,tempHistory8.OtherAmountDiscount              		--�y���Z�����z�����z �l��
          ,tempHistory8.OtherAmountCancel                		--�y���Z�����z�����z ���
          ,tempHistory8.OtherAmountDelivery              		--�y���Z�����z�����z �z�B
          ,tempHistory8.ExchangeCount                    		--�y���Z�����z���։�
          ,tempHistory8.ByTimeZoneTaxIncluded_0000_0100  		--�y���Z�����z���ԑѕ�(�ō�) 00:00�`01:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0100_0200  		--�y���Z�����z���ԑѕ�(�ō�) 01:00�`02:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0200_0300  		--�y���Z�����z���ԑѕ�(�ō�) 02:00�`03:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0300_0400  		--�y���Z�����z���ԑѕ�(�ō�) 03:00�`04:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0400_0500  		--�y���Z�����z���ԑѕ�(�ō�) 04:00�`05:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0500_0600  		--�y���Z�����z���ԑѕ�(�ō�) 05:00�`06:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0600_0700  		--�y���Z�����z���ԑѕ�(�ō�) 06:00�`07:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0700_0800  		--�y���Z�����z���ԑѕ�(�ō�) 07:00�`08:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0800_0900  		--�y���Z�����z���ԑѕ�(�ō�) 08:00�`09:00
          ,tempHistory8.ByTimeZoneTaxIncluded_0900_1000  		--�y���Z�����z���ԑѕ�(�ō�) 09:00�`10:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1000_1100  		--�y���Z�����z���ԑѕ�(�ō�) 10:00�`11:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1100_1200  		--�y���Z�����z���ԑѕ�(�ō�) 11:00�`12:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1200_1300  		--�y���Z�����z���ԑѕ�(�ō�) 12:00�`13:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1300_1400  		--�y���Z�����z���ԑѕ�(�ō�) 13:00�`14:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1400_1500 		--�y���Z�����z���ԑѕ�(�ō�) 14:00�`15:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1500_1600  		--�y���Z�����z���ԑѕ�(�ō�) 15:00�`16:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1600_1700  		--�y���Z�����z���ԑѕ�(�ō�) 16:00�`17:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1700_1800  		--�y���Z�����z���ԑѕ�(�ō�) 17:00�`18:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1800_1900  		--�y���Z�����z���ԑѕ�(�ō�) 18:00�`19:00
          ,tempHistory8.ByTimeZoneTaxIncluded_1900_2000  		--�y���Z�����z���ԑѕ�(�ō�) 19:00�`20:00
          ,tempHistory8.ByTimeZoneTaxIncluded_2000_2100  		--�y���Z�����z���ԑѕ�(�ō�) 20:00�`21:00
          ,tempHistory8.ByTimeZoneTaxIncluded_2100_2200  		--�y���Z�����z���ԑѕ�(�ō�) 21:00�`22:00
          ,tempHistory8.ByTimeZoneTaxIncluded_2200_2300  		--�y���Z�����z���ԑѕ�(�ō�) 22:00�`23:00
          ,tempHistory8.ByTimeZoneTaxIncluded_2300_2400  		--�y���Z�����z���ԑѕ�(�ō�) 23:00�`24:00
          ,tempHistory8.ByTimeZoneSalesNO_0000_0100      		--�y���Z�����z���ԑѕʌ��� 00:00�`01:00
          ,tempHistory8.ByTimeZoneSalesNO_0100_0200      		--�y���Z�����z���ԑѕʌ��� 01:00�`02:00
          ,tempHistory8.ByTimeZoneSalesNO_0200_0300      		--�y���Z�����z���ԑѕʌ��� 02:00�`03:00
          ,tempHistory8.ByTimeZoneSalesNO_0300_0400      		--�y���Z�����z���ԑѕʌ��� 03:00�`04:00
          ,tempHistory8.ByTimeZoneSalesNO_0400_0500      		--�y���Z�����z���ԑѕʌ��� 04:00�`05:00
          ,tempHistory8.ByTimeZoneSalesNO_0500_0600      		--�y���Z�����z���ԑѕʌ��� 05:00�`06:00
          ,tempHistory8.ByTimeZoneSalesNO_0600_0700      		--�y���Z�����z���ԑѕʌ��� 06:00�`07:00
          ,tempHistory8.ByTimeZoneSalesNO_0700_0800      		--�y���Z�����z���ԑѕʌ��� 07:00�`08:00
          ,tempHistory8.ByTimeZoneSalesNO_0800_0900      		--�y���Z�����z���ԑѕʌ��� 08:00�`09:00
          ,tempHistory8.ByTimeZoneSalesNO_0900_1000      		--�y���Z�����z���ԑѕʌ��� 09:00�`10:00
          ,tempHistory8.ByTimeZoneSalesNO_1000_1100      		--�y���Z�����z���ԑѕʌ��� 10:00�`11:00
          ,tempHistory8.ByTimeZoneSalesNO_1100_1200      		--�y���Z�����z���ԑѕʌ��� 11:00�`12:00
          ,tempHistory8.ByTimeZoneSalesNO_1200_1300      		--�y���Z�����z���ԑѕʌ��� 12:00�`13:00
          ,tempHistory8.ByTimeZoneSalesNO_1300_1400      		--�y���Z�����z���ԑѕʌ��� 13:00�`14:00
          ,tempHistory8.ByTimeZoneSalesNO_1400_1500      		--�y���Z�����z���ԑѕʌ��� 14:00�`15:00
          ,tempHistory8.ByTimeZoneSalesNO_1500_1600      		--�y���Z�����z���ԑѕʌ��� 15:00�`16:00
          ,tempHistory8.ByTimeZoneSalesNO_1600_1700      		--�y���Z�����z���ԑѕʌ��� 16:00�`17:00
          ,tempHistory8.ByTimeZoneSalesNO_1700_1800      		--�y���Z�����z���ԑѕʌ��� 17:00�`18:00
          ,tempHistory8.ByTimeZoneSalesNO_1800_1900      		--�y���Z�����z���ԑѕʌ��� 18:00�`19:00
          ,tempHistory8.ByTimeZoneSalesNO_1900_2000      		--�y���Z�����z���ԑѕʌ��� 19:00�`20:00
          ,tempHistory8.ByTimeZoneSalesNO_2000_2100      		--�y���Z�����z���ԑѕʌ��� 20:00�`21:00
          ,tempHistory8.ByTimeZoneSalesNO_2100_2200      		--�y���Z�����z���ԑѕʌ��� 21:00�`22:00
          ,tempHistory8.ByTimeZoneSalesNO_2200_2300      		--�y���Z�����z���ԑѕʌ��� 22:00�`23:00
          ,tempHistory8.ByTimeZoneSalesNO_2300_2400      		--�y���Z�����z���ԑѕʌ��� 23:00�`24:00
      FROM M_Calendar calendar
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
                             AND store.StoreCD = @StoreCD
                             AND store.ChangeDate <= CONVERT(DATE, GETDATE())
      LEFT OUTER JOIN #Temp_D_DepositHistory1 tempHistory1 ON tempHistory1.StoreCD = store.StoreCD
                                                          AND tempHistory1.RegistDate = calendar.CalendarDate
      LEFT OUTER JOIN #Temp_D_DepositHistory2 tempHistory2 ON tempHistory2.Number = tempHistory1.Number
      LEFT OUTER JOIN #Temp_D_DepositHistory3 tempHistory3 ON tempHistory3.Number = tempHistory1.Number
      LEFT OUTER JOIN #Temp_D_DepositHistory4 tempHistory4 ON tempHistory4.RegistDate = calendar.CalendarDate
      LEFT OUTER JOIN #Temp_D_DepositHistory5 tempHistory5 ON tempHistory5.RegistDate = calendar.CalendarDate
      LEFT OUTER JOIN #Temp_D_DepositHistory51 tempHistory51 ON tempHistory51.RegistDate = calendar.CalendarDate
      LEFT OUTER JOIN #Temp_D_DepositHistory6 tempHistory6 ON tempHistory6.RegistDate = calendar.CalendarDate
      LEFT OUTER JOIN #Temp_D_DepositHistory7 tempHistory7 ON tempHistory7.RegistDate = calendar.CalendarDate
      LEFT OUTER JOIN #Temp_D_DepositHistory8 tempHistory8 ON tempHistory8.RegistDate = calendar.CalendarDate

     WHERE calendar.CalendarDate >= @DateFrom
       AND calendar.CalendarDate <= @DateTo
       AND store.DeleteFlg = 0
       AND store.StoreCD = @StoreCD
     ORDER BY tempHistory1.DetailOrder ASC
         ;
END


GO