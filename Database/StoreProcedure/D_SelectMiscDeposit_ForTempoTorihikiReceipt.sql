SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--  ======================================================================
--       Program Call    XάW ζψV[goΝ@GόΰσόξρζΎ
--       Program ID      TempoRegiTorihikiReceipt
--       Create date:    2020.02.24
--       Update date:    2020.06.13  WbNΟX
--                  :    2020.07.11  ψπDepositNOΙΟX
--    ======================================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'D_SelectMiscDeposit_ForTempoTorihikiReceipt')
  DROP PROCEDURE [dbo].[D_SelectMiscDeposit_ForTempoTorihikiReceipt]
GO


CREATE PROCEDURE [dbo].[D_SelectMiscDeposit_ForTempoTorihikiReceipt]
(
    @DepositNO        int,
    @StaffCD          varchar(10)
)AS

--********************************************--
--                                            --
--                 Jn                   --
--                                            --
--********************************************--

BEGIN
    SET NOCOUNT ON;

    SELECT D.RegistDate                                                                          -- o^ϊ
          ,MAX(CASE D.RANK WHEN  1 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate1       -- Gόΰϊ1
          ,MAX(CASE D.RANK WHEN  1 THEN D.DenominationName ELSE NULL END) MiscDepositName1       -- GόΰΌ1
          ,MAX(CASE D.RANK WHEN  1 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount1     -- Gόΰz1
          ,MAX(CASE D.RANK WHEN  2 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate2       -- Gόΰϊ2
          ,MAX(CASE D.RANK WHEN  2 THEN D.DenominationName ELSE NULL END) MiscDepositName2       -- GόΰΌ2
          ,MAX(CASE D.RANK WHEN  2 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount2     -- Gόΰz2
          ,MAX(CASE D.RANK WHEN  3 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate3       -- Gόΰϊ3
          ,MAX(CASE D.RANK WHEN  3 THEN D.DenominationName ELSE NULL END) MiscDepositName3       -- GόΰΌ3
          ,MAX(CASE D.RANK WHEN  3 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount3     -- Gόΰz3
          ,MAX(CASE D.RANK WHEN  4 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate4       -- Gόΰϊ4
          ,MAX(CASE D.RANK WHEN  4 THEN D.DenominationName ELSE NULL END) MiscDepositName4       -- GόΰΌ4
          ,MAX(CASE D.RANK WHEN  4 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount4     -- Gόΰz4
          ,MAX(CASE D.RANK WHEN  5 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate5       -- Gόΰϊ5
          ,MAX(CASE D.RANK WHEN  5 THEN D.DenominationName ELSE NULL END) MiscDepositName5       -- GόΰΌ5
          ,MAX(CASE D.RANK WHEN  5 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount5     -- Gόΰz5
          ,MAX(CASE D.RANK WHEN  6 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate6       -- Gόΰϊ6
          ,MAX(CASE D.RANK WHEN  6 THEN D.DenominationName ELSE NULL END) MiscDepositName6       -- GόΰΌ6
          ,MAX(CASE D.RANK WHEN  6 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount6     -- Gόΰz6
          ,MAX(CASE D.RANK WHEN  7 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate7       -- Gόΰϊ7
          ,MAX(CASE D.RANK WHEN  7 THEN D.DenominationName ELSE NULL END) MiscDepositName7       -- GόΰΌ7
          ,MAX(CASE D.RANK WHEN  7 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount7     -- Gόΰz7
          ,MAX(CASE D.RANK WHEN  8 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate8       -- Gόΰϊ8
          ,MAX(CASE D.RANK WHEN  8 THEN D.DenominationName ELSE NULL END) MiscDepositName8       -- GόΰΌ8
          ,MAX(CASE D.RANK WHEN  8 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount8     -- Gόΰz8
          ,MAX(CASE D.RANK WHEN  9 THEN D.DepositDateTime  ELSE NULL END) MiscDepositDate9       -- Gόΰϊ9
          ,MAX(CASE D.RANK WHEN  9 THEN D.DenominationName ELSE NULL END) MiscDepositName9       -- GόΰΌ9
          ,MAX(CASE D.RANK WHEN  9 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount9     -- Gόΰz9
          ,MAX(CASE D.RANK WHEN  10 THEN D.DepositDateTime ELSE NULL END) MiscDepositDate10      -- Gόΰϊ10
          ,MAX(CASE D.RANK WHEN 10 THEN D.DenominationName ELSE NULL END) MiscDepositName10      -- GόΰΌ10
          ,MAX(CASE D.RANK WHEN 10 THEN D.DepositGaku      ELSE NULL END) MiscDepositAmount10    -- Gόΰz10
          ,D.StaffReceiptPrint                                                                   -- SV[g\L
          ,D.StoreReceiptPrint                                                                   -- XάV[g\L
      FROM (
            SELECT H.RegistDate
                  ,H.DepositDateTime
                  ,H.DenominationName
                  ,H.DepositGaku
                  ,ROW_NUMBER() OVER(PARTITION BY H.Number ORDER BY H.DepositDateTime ASC) as RANK
                  ,H.StaffReceiptPrint
                  ,H.StoreReceiptPrint
              FROM (
                    SELECT CONVERT(Date, history.DepositDateTime) RegistDate
                          ,FORMAT(history.DepositDateTime,  'yyyy/MM/dd HH:mm') DepositDateTime
                          ,denominationKbn.DenominationName
                          ,history.DepositGaku
                          ,history.Number
                          ,ROW_NUMBER() OVER(PARTITION BY history.Number ORDER BY history.DepositDateTime DESC) as RANK
                          ,staff.ReceiptPrint StaffReceiptPrint
                          ,store.ReceiptPrint StoreReceiptPrint
                      FROM D_DepositHistory history
                      LEFT OUTER JOIN M_DenominationKBN denominationKbn ON denominationKbn.DenominationCD = history.DenominationCD
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
                     WHERE history.DataKBN = 3
                       AND history.DepositKBN = 2
                       AND history.DepositNO = @DepositNO
                       AND history.CancelKBN = 0
                       AND history.CustomerCD IS NULL
                   ) H
             WHERE H.RANK BETWEEN 1 AND 10
           ) D 
     GROUP BY D.RegistDate
             ,D.StaffReceiptPrint
             ,D.StoreReceiptPrint
           ;
END

GO

