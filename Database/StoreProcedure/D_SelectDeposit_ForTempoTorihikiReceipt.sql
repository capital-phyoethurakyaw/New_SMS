SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--  ======================================================================
--       Program Call    店舗レジ 取引レシート出力　入金印刷情報取得
--       Program ID      TempoRegiTorihikiReceipt
--       Create date:    2020.02.24
--       Update date:    2020.06.13  ロジック変更
--    ======================================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'D_SelectDeposit_ForTempoTorihikiReceipt')
  DROP PROCEDURE [dbo].[D_SelectDeposit_ForTempoTorihikiReceipt]
GO


CREATE PROCEDURE [dbo].[D_SelectDeposit_ForTempoTorihikiReceipt]
(
    @StoreCD          varchar(4),
    @StaffCD          varchar(10)
)AS

--********************************************--
--                                            --
--                 処理開始                   --
--                                            --
--********************************************--

BEGIN
    SET NOCOUNT ON;

    SELECT D.Number
          ,D.RegistDate                                                                    -- 登録日
          ,MAX(D.CustomerCD) CustomerCD                                                    -- 入金元CD
          ,MAX(D.CustomerName) CustomerName                                                -- 入金元名
          ,MAX(CASE D.DepositNO WHEN  1 THEN D.DenominationName ELSE NULL END) Name1       -- 入金名1
          ,MAX(CASE D.DepositNO WHEN  1 THEN D.DepositGaku      ELSE NULL END) Amount1     -- 入金額1
          ,MAX(CASE D.DepositNO WHEN  2 THEN D.DenominationName ELSE NULL END) Name2       -- 入金名2
          ,MAX(CASE D.DepositNO WHEN  2 THEN D.DepositGaku      ELSE NULL END) Amount2     -- 入金額2
          ,MAX(CASE D.DepositNO WHEN  3 THEN D.DenominationName ELSE NULL END) Name3       -- 入金名3
          ,MAX(CASE D.DepositNO WHEN  3 THEN D.DepositGaku      ELSE NULL END) Amount3     -- 入金額3
          ,MAX(CASE D.DepositNO WHEN  4 THEN D.DenominationName ELSE NULL END) Name4       -- 入金名4
          ,MAX(CASE D.DepositNO WHEN  4 THEN D.DepositGaku      ELSE NULL END) Amount4     -- 入金額4
          ,MAX(CASE D.DepositNO WHEN  5 THEN D.DenominationName ELSE NULL END) Name5       -- 入金名5
          ,MAX(CASE D.DepositNO WHEN  5 THEN D.DepositGaku      ELSE NULL END) Amount5     -- 入金額5
          ,MAX(CASE D.DepositNO WHEN  6 THEN D.DenominationName ELSE NULL END) Name6       -- 入金名6
          ,MAX(CASE D.DepositNO WHEN  6 THEN D.DepositGaku      ELSE NULL END) Amount6     -- 入金額6
          ,MAX(CASE D.DepositNO WHEN  7 THEN D.DenominationName ELSE NULL END) Name7       -- 入金名7
          ,MAX(CASE D.DepositNO WHEN  7 THEN D.DepositGaku      ELSE NULL END) Amount7     -- 入金額7
          ,MAX(CASE D.DepositNO WHEN  8 THEN D.DenominationName ELSE NULL END) Name8       -- 入金名8
          ,MAX(CASE D.DepositNO WHEN  8 THEN D.DepositGaku      ELSE NULL END) Amount8     -- 入金額8
          ,MAX(CASE D.DepositNO WHEN  9 THEN D.DenominationName ELSE NULL END) Name9       -- 入金名9
          ,MAX(CASE D.DepositNO WHEN  9 THEN D.DepositGaku      ELSE NULL END) Amount9     -- 入金額9
          ,MAX(CASE D.DepositNO WHEN 10 THEN D.DenominationName ELSE NULL END) Name10      -- 入金名10
          ,MAX(CASE D.DepositNO WHEN 10 THEN D.DepositGaku      ELSE NULL END) Amount10    -- 入金額10
          ,D.StaffReceiptPrint                                                             -- 担当レシート表記
          ,D.StoreReceiptPrint                                                             -- 店舗レシート表記
      FROM (
            SELECT ROW_NUMBER() OVER(PARTITION BY history.DepositNO ORDER BY history.DepositDateTime DESC) as DepositNO
                  ,CONVERT(DATE, history.DepositDateTime) RegistDate
                  ,customer.CustomerCD
                  ,customer.CustomerName
                  ,denominationKbn.DenominationName
                  ,history.DepositGaku
                  ,history.Number
                  ,staff.ReceiptPrint StaffReceiptPrint
                  ,store.ReceiptPrint StoreReceiptPrint
              FROM D_DepositHistory history
              LEFT OUTER JOIN D_Sales sales ON sales.SalesNO = history.Number
              LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
              LEFT OUTER JOIN (
                               SELECT ROW_NUMBER() OVER(PARTITION BY CustomerCD ORDER BY ChangeDate DESC) AS RANK
                                     ,CustomerCD
                                     ,CustomerName
                                     ,ChangeDate
                                     ,DeleteFlg
                                 FROM M_Customer
                              ) customer ON customer.RANK = 1
                                        AND customer.CustomerCD = history.CustomerCD
                                        AND CONVERT(varchar, customer.ChangeDate, 111) <= CONVERT(varchar, history.DepositDateTime, 111)
              LEFT OUTER JOIN (
                               SELECT ROW_NUMBER() OVER(PARTITION BY StoreCD ORDER BY ChangeDate DESC) as RANK
                                     ,StoreCD
                                     ,ReceiptPrint
                                     ,DeleteFlg 
                                 FROM M_Store 
                              ) store ON store.RANK = 1
                                     AND store.StoreCD = history.StoreCD
                                     AND store.DeleteFlg <> 1
              LEFT OUTER JOIN (
                               SELECT ROW_NUMBER() OVER(PARTITION BY StaffCD ORDER BY ChangeDate DESC) AS RANK
                                     ,StaffCD
                                     ,StoreCD
                                     ,ReceiptPrint
                                     ,DeleteFlg
                                 FROM M_Staff
                              ) staff ON staff.RANK = 1
                                     AND staff.StoreCD = history.StoreCD
                                     AND staff.StaffCD = @StaffCD
                                     AND staff.DeleteFlg <> 1
             WHERE history.StoreCD = @StoreCD
               AND history.DataKBN = 3
               AND history.DepositKBN = 2
               AND history.CancelKBN = 0
               AND sales.DeleteDateTime IS NULL
               AND sales.BillingType = 1
               AND history.CustomerCD IS NOT NULL
               AND customer.DeleteFlg = 0
           ) D 
     GROUP BY D.Number
             ,D.RegistDate
             ,D.StaffReceiptPrint
             ,D.StoreReceiptPrint
        ;
END

GO

