 BEGIN TRY 
 Drop Procedure dbo.[D_Purchase_SelectData]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--  ======================================================================
--       Program Call    仕入入力
--       Program ID      ShiireNyuuryoku
--       Create date:    2019.11.24
--    ======================================================================
CREATE PROCEDURE D_Purchase_SelectData
    (@OperateMode    tinyint,                 -- 処理区分（1:新規 2:修正 3:削除）
    @PurchaseNO varchar(11)
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

--        IF @OperateMode = 2   --修正時
--        BEGIN
            SELECT DH.PurchaseNO
                  ,DH.StoreCD
                  ,CONVERT(varchar,DH.PurchaseDate,111) AS PurchaseDate
                  ,DH.CancelFlg
                  ,DH.ProcessKBN
                  ,DH.ReturnsFlg
                  ,DH.VendorCD
                  ,(SELECT top 1 A.VendorName
                  FROM M_Vendor A 
                  WHERE A.VendorCD = DH.VendorCD AND A.DeleteFlg = 0 AND A.ChangeDate <= DH.PurchaseDate
                  AND A.VendorFlg = 1
                  ORDER BY A.ChangeDate desc) AS VendorName 
                  ,DH.CalledVendorCD
                  ,(SELECT top 1 A.VendorName
                  FROM M_Vendor A 
                  WHERE A.VendorCD = DH.CalledVendorCD AND A.DeleteFlg = 0 AND A.ChangeDate <= DH.PurchaseDate
                  ORDER BY A.ChangeDate desc) AS CalledVendorName 
                  ,DH.CalculationGaku
                  ,DH.AdjustmentGaku
                  ,DH.PurchaseGaku
                  ,DH.PurchaseTax
                  ,DH.TotalPurchaseGaku
                  ,DH.CommentOutStore
                  ,DH.CommentInStore
                  ,DH.ExpectedDateFrom
                  ,DH.ExpectedDateTo
                  ,DH.InputDate
                  ,DH.StaffCD
                  ,CONVERT(varchar,DH.PaymentPlanDate,111) AS PaymentPlanDate
                  ,DH.PayPlanNO
                  ,DH.OutputDateTime
                  ,DH.StockAccountFlg
                  ,DH.InsertOperator
                  ,CONVERT(varchar,DH.InsertDateTime) AS InsertDateTime
                  ,DH.UpdateOperator
                  ,CONVERT(varchar,DH.UpdateDateTime) AS UpdateDateTime
                  ,DH.DeleteOperator
                  ,CONVERT(varchar,DH.DeleteDateTime) AS DeleteDateTime
                  
                  ,DM.PurchaseRows
                  ,DM.DisplayRows
                  ,DM.ArrivalNO
                  ,DM.SKUCD
                  ,DM.AdminNO
                  ,DM.JanCD
                  ,(SELECT top 1 (CASE A.VariousFLG WHEN 1 THEN DM.MakerItem ELSE A.MakerItem END) AS MakerItem
                  FROM M_SKU A 
                  WHERE A.AdminNO = DM.AdminNO AND A.ChangeDate <= DH.PurchaseDate 
                    AND A.DeleteFlg = 0
                  ORDER BY A.ChangeDate desc) AS MakerItem
                  ,(SELECT top 1 (CASE A.VariousFLG WHEN 1 THEN DM.ItemName ELSE A.SKUName END) AS SKUName 
                  FROM M_SKU A 
                  WHERE A.AdminNO = DM.AdminNO AND A.ChangeDate <= DH.PurchaseDate 
                    AND A.DeleteFlg = 0
                  ORDER BY A.ChangeDate desc) AS ItemName
                  ,(SELECT top 1 (CASE A.VariousFLG WHEN 1 THEN DM.ColorName ELSE A.ColorName END) AS ColorName 
                  FROM M_SKU A 
                  WHERE A.AdminNO = DM.AdminNO AND A.ChangeDate <= DH.PurchaseDate 
                    AND A.DeleteFlg = 0
                  ORDER BY A.ChangeDate desc) AS ColorName
                  ,(SELECT top 1 (CASE A.VariousFLG WHEN 1 THEN DM.SizeName ELSE A.SizeName END) AS SizeName 
                  FROM M_SKU A 
                  WHERE A.AdminNO = DM.AdminNO AND A.ChangeDate <= DH.PurchaseDate 
                    AND A.DeleteFlg = 0
                  ORDER BY A.ChangeDate desc) AS SizeName
                  
                  ,DM.Remark
                  ,DM.PurchaseSu
                  ,DM.TaniCD
                  ,DM.TaniName
                  ,DM.PurchaserUnitPrice
                  ,DM.CalculationGaku AS D_CalculationGaku
                  ,DM.AdjustmentGaku As D_AdjustmentGaku
                  ,DM.PurchaseGaku AS D_PurchaseGaku
                  ,DM.PurchaseTax AS D_PurchaseTax
                  ,DM.TaxRitsu
                  ,DM.TotalPurchaseGaku AS D_TotalPurchaseGaku
                  ,DM.CurrencyCD
                  ,DM.CommentOutStore AS D_CommentOutStore
                  ,DM.CommentInStore AS D_CommentInStore
                  ,DM.ReturnNO
                  ,DM.ReturnRows
                  ,DM.OrderUnitPrice
                  ,DM.OrderNO
                  ,DM.OrderRows
                  ,DM.DifferenceFlg
                  ,DM.DeliveryNo
                  
                  --出荷済みFLG (Hidden)
                  ,(SELECT top 1 1 
                    FROM D_Warehousing AS DW
                    INNER JOIN D_Stock AS DS
                    ON DS.StockNO = DW.StockNO
                    AND DS.DeleteDateTime IS NULL
                    INNER JOIN D_Reserve AS DR
                    ON DR.StockNO = DS.StockNO
                    AND DR.DeleteDateTime IS NULL
                    INNER JOIN D_PickingDetails AS DP
                    ON DP.ReserveNO = DR.ReserveNO
                    AND DP.DeleteDateTime IS NULL
                    INNER JOIN D_InstructionDetails AS DI
                    ON DI.ReserveNO = DP.ReserveNO
                    AND DI.DeleteDateTime IS NULL
                    INNER JOIN D_ShippingDetails AS DSM
                    ON DSM.InstructionNO = DI.InstructionNO
                    AND DSM.InstructionRows = DI.InstructionRows
                    AND DSM.DeleteDateTime IS NULL
                    WHERE DW.Number = DM.PurchaseNO
                    AND DW.NumberRow = DM.PurchaseRows
                    AND DW.WarehousingKBN = 30		--2020/01/27 chg
                    AND DW.DeleteDateTime IS NULL
                    AND DW.DeleteFlg = 0
                    ) AS SyukkazumiFlg
                    
                  --出荷指示済みFLG (Hidden)
                  ,(SELECT top 1 1 
                    FROM D_Warehousing AS DW
                    INNER JOIN D_Stock AS DS
                    ON DS.StockNO = DW.StockNO
                    AND DS.DeleteDateTime IS NULL
                    INNER JOIN D_Reserve AS DR
                    ON DR.StockNO = DS.StockNO
                    AND DR.DeleteDateTime IS NULL
                    INNER JOIN D_PickingDetails AS DP
                    ON DP.ReserveNO = DR.ReserveNO
                    AND DP.DeleteDateTime IS NULL
                    INNER JOIN D_InstructionDetails AS DI
                    ON DI.ReserveNO = DP.ReserveNO
                    AND DI.DeleteDateTime IS NULL
                    WHERE DW.Number = DM.PurchaseNO
                    AND DW.NumberRow = DM.PurchaseRows
                    AND DW.WarehousingKBN = 30		--2020/01/27 chg
                    AND DW.DeleteDateTime IS NULL
                    AND DW.DeleteFlg = 0
                    ) AS SyukkaSijizumiFlg
                    
                  --ピッキング済みFLG (Hidden)
                  ,(SELECT top 1 1 
                    FROM D_Warehousing AS DW
                    INNER JOIN D_Stock AS DS
                    ON DS.StockNO = DW.StockNO
                    AND DS.DeleteDateTime IS NULL
                    INNER JOIN D_Reserve AS DR
                    ON DR.StockNO = DS.StockNO
                    AND DR.DeleteDateTime IS NULL
                    INNER JOIN D_PickingDetails AS DP
                    ON DP.ReserveNO = DR.ReserveNO
                    AND DP.DeleteDateTime IS NULL
                    WHERE DW.Number = DM.PurchaseNO
                    AND DW.NumberRow = DM.PurchaseRows
                    AND DW.WarehousingKBN = 30		--2020/01/27 chg
                    AND DW.DeleteDateTime IS NULL
                    ) AS PickingzumiFlg
                    
                  --引当済みFLG (Hidden)
                  ,(SELECT top 1 1 
                    FROM D_Warehousing AS DW
                    INNER JOIN D_Stock AS DS
                    ON DS.StockNO = DW.StockNO
                    AND DS.DeleteDateTime IS NULL
                    INNER JOIN D_Reserve AS DR
                    ON DR.StockNO = DS.StockNO
                    AND DR.DeleteDateTime IS NULL
                    WHERE DW.Number = DM.PurchaseNO
                    AND DW.NumberRow = DM.PurchaseRows
                    AND DW.WarehousingKBN = 30		--2020/01/27 chg
                    AND DW.DeleteDateTime IS NULL
                    AND DW.DeleteFlg = 0
                    ) AS HikiatezumiFlg
                    
                  --入出庫番号 (Hidden)
                  ,(SELECT top 1 DW.WarehousingNO
                    FROM D_Warehousing AS DW
                    WHERE DW.Number = DM.PurchaseNO
                    AND DW.NumberRow = DM.PurchaseRows
                    AND DW.WarehousingKBN = 30		--2020/01/27 chg
                    AND DW.DeleteDateTime IS NULL
                    AND DW.DeleteFlg = 0
                    ORDER BY DW.WarehousingNO desc
                    ) AS WarehousingNO
                    
                  --在庫番号 (Hidden)
                  ,(SELECT top 1 DW.StockNO
                    FROM D_Warehousing AS DW
                    WHERE DW.Number = DM.PurchaseNO
                    AND DW.NumberRow = DM.PurchaseRows
                    AND DW.WarehousingKBN = 30		--2020/01/27 chg
                    AND DW.DeleteDateTime IS NULL
                    AND DW.DeleteFlg = 0
                    ORDER BY DW.WarehousingNO desc
                    ) AS StockNO
                    
                    
                  --引当番号 (Hidden)
                  ,(SELECT top 1 DR.ReserveNO 
                    FROM D_Warehousing AS DW
                    INNER JOIN D_Reserve AS DR
                    ON DR.StockNO = DW.StockNO
                    AND DR.DeleteDateTime IS NULL
                    WHERE DW.Number = DM.PurchaseNO
                    AND DW.NumberRow = DM.PurchaseRows
                    AND DW.WarehousingKBN = 30		--2020/01/27 chg
                    AND DW.DeleteDateTime IS NULL	
                    ) AS ReserveNO
                    
              FROM D_Purchase DH
              LEFT OUTER JOIN D_PurchaseDetails AS DM 
              ON DH.PurchaseNO = DM.PurchaseNO 
              AND DM.DeleteDateTime IS NULL
              WHERE DH.PurchaseNO = @PurchaseNO 
              AND DH.ProcessKBN = 2		--★
--              AND DH.DeleteDateTime IS Null
                ORDER BY DH.PurchaseNO, DM.DisplayRows
                ;
--        END

END

