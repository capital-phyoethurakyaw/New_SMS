IF OBJECT_ID ( 'M_ItemOrderPrice_SelectFromItem', 'P' ) IS NOT NULL
    Drop Procedure dbo.[M_ItemOrderPrice_SelectFromItem]
GO
IF OBJECT_ID ( 'M_ItemOrderPrice_SelectFromSKU', 'P' ) IS NOT NULL
    Drop Procedure dbo.[M_ItemOrderPrice_SelectFromSKU]
GO
IF OBJECT_ID ( 'M_ITEM_SelectForShiireTanka', 'P' ) IS NOT NULL
    Drop Procedure dbo.[M_ITEM_SelectForShiireTanka]
GO
IF OBJECT_ID ( 'M_SKU_SelectForShiireTanka', 'P' ) IS NOT NULL
    Drop Procedure dbo.[M_SKU_SelectForShiireTanka]
GO
IF OBJECT_ID ( 'PRC_MasterTouroku_HacchuuPrice', 'P' ) IS NOT NULL
    Drop Procedure dbo.[PRC_MasterTouroku_HacchuuPrice]
GO
IF EXISTS (select * from sys.table_types where name = 'T_ItmTanka')
    Drop TYPE dbo.[T_ItmTanka]
GO

IF EXISTS (select * from sys.table_types where name = 'T_SkuTanka')
    Drop TYPE dbo.[T_SkuTanka]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  ======================================================================
--       Program Call    仕入先別発注単価マスタ
--       Program ID      MasterTouroku_HacchuuPrice
--       Create date:    2020.05.11
--    ======================================================================


--****************************************--
--                                        --
--            データ抽出(ITEMより）       --
--                                        --
--****************************************--
CREATE PROCEDURE M_ItemOrderPrice_SelectFromItem
    (@VendorCD              varchar(13),
     @StoreCD               varchar(4),
     @DispKbn               tinyint,      -- 1:現状 2:履歴
     @BaseDate              varchar(10),
     @BrandCD               varchar(6),
     @SportsCD              varchar(6),
     @SegmentCD             varchar(6),
     @LastYearTerm          varchar(6),
     @LastSeason            varchar(6),
     @ChangeDate            varchar(10),
     @MakerItem             varchar(30)
    )AS
BEGIN

    SET NOCOUNT ON;

    IF @DispKbn = 1
    BEGIN
        WITH PRICE AS (
            SELECT VendorCD, StoreCD, MakerItem, MAX(ChangeDate) AS ChangeDate
              FROM M_ItemOrderPrice
             WHERE VendorCD = @VendorCD
               AND StoreCD = @StoreCD
               AND ChangeDate <= @BaseDate
             GROUP BY VendorCD, StoreCD, MakerItem
        )
        ,ITM AS (
                SELECT MakerItem, ChangeDate, ItemChangeDate, ItemCD
                FROM (
                        SELECT PR.MakerItem, PR.ChangeDate, IT.ChangeDate AS ItemChangeDate, IT.ItemCD
                              , ROW_NUMBER() OVER(PARTITION BY PR.MakerItem, PR.ChangeDate ORDER BY IT.ChangeDate DESC , IT.ItemCD) AS NUM
                          FROM PRICE PR
                          INNER JOIN M_ITEM IT ON PR.MakerItem = IT.MakerItem
                                              AND PR.ChangeDate >= IT.ChangeDate
                     ) SUB
                WHERE NUM = 1
        )
        SELECT 0 AS Chk
              ,MIP.VendorCD
              ,MIP.StoreCD
              ,MI.ITEMCD
              ,MI.ITemName
              ,MIP.MakerItem
              ,MI.BrandCD
              ,BR.BrandName
              ,MI.SportsCD
              ,SP.Char1 AS SportsName
              ,MI.SegmentCD
              ,SG.Char1 AS SegmentName
              ,MI.LastYearTerm
              ,MI.LastSeason
              ,CONVERT(varchar,MIP.ChangeDate,111) AS ChangeDate
              ,MIP.Rate
              ,MI.PriceOutTax
              ,MIP.PriceWithoutTax
              ,MIP.InsertOperator
              ,MIP.InsertDateTime
              ,MIP.UpdateOperator
              ,MIP.UpdateDateTime
              ,MIP.Rate AS OldRate
              ,'0' AS DelFlg
              ,ROW_NUMBER() OVER(ORDER BY MI.BrandCD,MI.SportsCD,MI.SegmentCD,MI.LastYearTerm,MI.LastSeason,MIP.MakerItem,MI.ITEMCD,MIP.ChangeDate) AS TempKey
        FROM PRICE
        INNER JOIN M_ItemOrderPrice MIP ON PRICE.VendorCD = MIP.VendorCD
                                       AND PRICE.StoreCD = MIP.StoreCD
                                       AND PRICE.MakerItem = MIP.MakerItem
                                       AND PRICE.ChangeDate = MIP.ChangeDate
        INNER JOIN ITM ON MIP.MakerItem = ITM.MakerItem
                      AND MIP.ChangeDate = ITM.ChangeDate
        INNER JOIN M_ITEM MI ON MI.MakerItem = ITM.MakerItem
                            AND MI.ITEMCD = ITM.ITEMCD
                            AND MI.ChangeDate = ITM.ItemChangeDate
        LEFT JOIN M_Brand BR ON MI.BrandCD = BR.BrandCD
        LEFT JOIN M_MultiPorpose SP ON MI.SportsCD = SP.[Key]
                                   AND '202' = SP.ID
        LEFT JOIN M_MultiPorpose SG ON MI.SegmentCD = SG.[Key]
                                   AND '203' = SG.ID
        WHERE ISNULL(MI.BrandCD,'') = (CASE WHEN @BrandCD <> '' THEN @BrandCD ELSE ISNULL(MI.BrandCD,'') END)
          AND ISNULL(MI.SportsCD,'') = (CASE WHEN @SportsCD <> '' THEN @SportsCD ELSE ISNULL(MI.SportsCD,'') END)
          AND ISNULL(MI.SegmentCD,'') = (CASE WHEN @SegmentCD <> '' THEN @SegmentCD ELSE ISNULL(MI.SegmentCD,'') END)
          AND ISNULL(MI.LastYearTerm,'') = (CASE WHEN @LastYearTerm <> '' THEN @LastYearTerm ELSE ISNULL(MI.LastYearTerm,'') END)
          AND ISNULL(MI.LastSeason,'') = (CASE WHEN @LastSeason <> '' THEN @LastSeason ELSE ISNULL(MI.LastSeason,'') END)
          AND MIP.ChangeDate = (CASE WHEN @ChangeDate <> '' THEN @ChangeDate ELSE MIP.ChangeDate END)
          AND ISNULL(MIP.MakerItem,'') = (CASE WHEN @MakerItem <> '' THEN @MakerItem ELSE ISNULL(MIP.MakerItem,'') END)          
        ORDER BY MI.BrandCD
                ,MI.SportsCD
                ,MI.SegmentCD
                ,MI.LastYearTerm
                ,MI.LastSeason
                ,MIP.MakerItem
                ,MI.ITEMCD
                ,MIP.ChangeDate
        ;
    
    END
    ELSE
    BEGIN
        
        WITH ITM AS (
                   SELECT MakerItem, ChangeDate, ItemChangeDate, ItemCD
                     FROM (
                        SELECT PR.MakerItem, PR.ChangeDate, IT.ChangeDate AS ItemChangeDate, IT.ItemCD
                             , ROW_NUMBER() OVER(PARTITION BY PR.MakerItem, PR.ChangeDate ORDER BY IT.ChangeDate DESC , IT.ItemCD) AS NUM
                        FROM M_ItemOrderPrice PR
                        INNER JOIN M_ITEM IT ON PR.MakerItem = IT.MakerItem
                                            AND PR.ChangeDate >= IT.ChangeDate
                        WHERE VendorCD = @VendorCD
                          AND StoreCD = @StoreCD
                          ) SUB 
                    WHERE NUM = 1
        )
        SELECT 0 AS Chk
              ,MIP.VendorCD
              ,MIP.StoreCD
              ,MI.ITEMCD
              ,MI.ITemName
              ,MIP.MakerItem
              ,MI.BrandCD
              ,BR.BrandName
              ,MI.SportsCD
              ,SP.Char1 AS SportsName
              ,MI.SegmentCD
              ,SG.Char1 AS SegmentName
              ,MI.LastYearTerm
              ,MI.LastSeason
              ,CONVERT(varchar,MIP.ChangeDate,111) AS ChangeDate
              ,MIP.Rate
              ,MI.PriceOutTax
              ,MIP.PriceWithoutTax
              ,MIP.InsertOperator
              ,MIP.InsertDateTime
              ,MIP.UpdateOperator
              ,MIP.UpdateDateTime
              ,MIP.Rate AS OldRate
              ,'0' AS DelFlg
              ,ROW_NUMBER() OVER(ORDER BY MI.BrandCD,MI.SportsCD,MI.SegmentCD,MI.LastYearTerm,MI.LastSeason,MIP.MakerItem,MI.ITEMCD,MIP.ChangeDate) AS TempKey
        FROM M_ItemOrderPrice MIP
        INNER JOIN ITM ON MIP.MakerItem = ITM.MakerItem
                      AND MIP.ChangeDate = ITM.ChangeDate
        INNER JOIN M_ITEM MI ON MI.MakerItem = ITM.MakerItem
                            AND MI.ItemCD = ITM.ItemCD
                            AND MI.ChangeDate = ITM.ItemChangeDate
        LEFT JOIN M_Brand BR ON MI.BrandCD = BR.BrandCD
        LEFT JOIN M_MultiPorpose SP ON MI.SportsCD = SP.[Key]
                                   AND '202' = SP.ID
        LEFT JOIN M_MultiPorpose SG ON MI.SegmentCD = SG.[Key]
                                   AND '203' = SG.ID
        WHERE MIP.VendorCD = @VendorCD
          AND MIP.StoreCD = @StoreCD
          AND ISNULL(MI.BrandCD,'') = (CASE WHEN @BrandCD <> '' THEN @BrandCD ELSE ISNULL(MI.BrandCD,'') END)
          AND ISNULL(MI.SportsCD,'') = (CASE WHEN @SportsCD <> '' THEN @SportsCD ELSE ISNULL(MI.SportsCD,'') END)
          AND ISNULL(MI.SegmentCD,'') = (CASE WHEN @SegmentCD <> '' THEN @SegmentCD ELSE ISNULL(MI.SegmentCD,'') END)
          AND ISNULL(MI.LastYearTerm,'') = (CASE WHEN @LastYearTerm <> '' THEN @LastYearTerm ELSE ISNULL(MI.LastYearTerm,'') END)
          AND ISNULL(MI.LastSeason,'') = (CASE WHEN @LastSeason <> '' THEN @LastSeason ELSE ISNULL(MI.LastSeason,'') END)
          AND MIP.ChangeDate = (CASE WHEN @ChangeDate <> '' THEN @ChangeDate ELSE MIP.ChangeDate END)
          AND ISNULL(MIP.MakerItem,'') = (CASE WHEN @MakerItem <> '' THEN @MakerItem ELSE ISNULL(MIP.MakerItem,'') END)          
        ORDER BY MI.BrandCD
                ,MI.SportsCD
                ,MI.SegmentCD
                ,MI.LastYearTerm
                ,MI.LastSeason
                ,MIP.MakerItem
                ,MI.ITEMCD
                ,MIP.ChangeDate
        ;
    END

END

GO

--****************************************--
--                                        --
--            データ抽出(SKUより）        --
--                                        --
--****************************************--
CREATE PROCEDURE M_ItemOrderPrice_SelectFromSKU
    (@VendorCD              varchar(13),
     @StoreCD               varchar(4),
     @DispKbn               tinyint,
     @BaseDate              varchar(10),
     @BrandCD               varchar(6),
     @SportsCD              varchar(6),
     @SegmentCD             varchar(6),
     @LastYearTerm          varchar(6),
     @LastSeason            varchar(6),
     @ChangeDate            varchar(10),
     @MakerItem             varchar(30)
    )AS
BEGIN

    SET NOCOUNT ON;
    
    IF @DispKbn = 1
    BEGIN
    	WITH PRICE AS (
            SELECT VendorCD, StoreCD, AdminNO, MAX(ChangeDate) AS ChangeDate
              FROM M_JANOrderPrice MJP
             WHERE VendorCD = @VendorCD
               AND StoreCD = @StoreCD
               AND ChangeDate <= @BaseDate
             GROUP BY VendorCD, StoreCD, AdminNO
        )
       ,SKU AS (
            SELECT PR.AdminNO, MAX(PR.ChangeDate) AS ChangeDate, MAX(MS.ChangeDate) AS SKUChangeDate
              FROM PRICE PR
             INNER JOIN M_SKU MS ON PR.AdminNO = MS.AdminNO
                                AND PR.ChangeDate >= MS.ChangeDate
             GROUP BY PR.AdminNO
        )        
        SELECT 0 AS Chk
              ,MJP.VendorCD
              ,MJP.StoreCD
              ,MS.ITEMCD
              ,( SELECT TOP 1 ITemName
                   FROM M_ITEM X 
                  WHERE X.ITEMCD = MS.ITEMCD
                    AND X.ChangeDate <= MJP.ChangeDate
                   ORDER BY X.ChangeDate DESC
                ) AS ITemName
              ,MJP.AdminNO
              ,MJP.SKUCD
              ,MS.SizeName
              ,MS.ColorName
              ,MS.MakerItem
              ,MS.BrandCD
              ,MS.SportsCD
              ,MS.SegmentCD
              ,MS.LastYearTerm
              ,MS.LastSeason
              ,CONVERT(varchar,MJP.ChangeDate,111) AS ChangeDate
              ,MJP.Rate
              ,( SELECT TOP 1 PriceOutTax
                   FROM M_ITEM X 
                  WHERE X.ITEMCD = MS.ITEMCD
                    AND X.ChangeDate <= MJP.ChangeDate
                   ORDER BY X.ChangeDate DESC
                ) AS PriceOutTax
              ,MJP.PriceWithoutTax
              ,MJP.InsertOperator
              ,MJP.InsertDateTime
              ,MJP.UpdateOperator
              ,MJP.UpdateDateTime
              ,MJP.Rate AS OldRate
              ,'0' AS DelFlg
              ,ROW_NUMBER() OVER(ORDER BY MS.BrandCD,MS.SportsCD,MS.SegmentCD,MS.LastYearTerm,MS.LastSeason,MS.MakerItem,MS.ITEMCD,MJP.AdminNO,MJP.ChangeDate) AS TempKey
        FROM PRICE
        INNER JOIN M_JANOrderPrice MJP ON PRICE.VendorCD = MJP.VendorCD
                                      AND PRICE.StoreCD = MJP.StoreCD
                                      AND PRICE.AdminNO = MJP.AdminNO
                                      AND PRICE.ChangeDate = MJP.ChangeDate
        INNER JOIN SKU ON MJP.AdminNO = SKU.AdminNO
                      AND MJP.ChangeDate = SKU.ChangeDate
        INNER JOIN M_SKU MS ON MS.AdminNO = SKU.AdminNO
                           AND MS.ChangeDate = SKU.SKUChangeDate
        WHERE ISNULL(MS.BrandCD,'') = (CASE WHEN @BrandCD <> '' THEN @BrandCD ELSE ISNULL(MS.BrandCD,'') END)
          AND ISNULL(MS.SportsCD,'') = (CASE WHEN @SportsCD <> '' THEN @SportsCD ELSE ISNULL(MS.SportsCD,'') END)
          AND ISNULL(MS.SegmentCD,'') = (CASE WHEN @SegmentCD <> '' THEN @SegmentCD ELSE ISNULL(MS.SegmentCD,'') END)
          AND ISNULL(MS.LastYearTerm,'') = (CASE WHEN @LastYearTerm <> '' THEN @LastYearTerm ELSE ISNULL(MS.LastYearTerm,'') END)
          AND ISNULL(MS.LastSeason,'') = (CASE WHEN @LastSeason <> '' THEN @LastSeason ELSE ISNULL(MS.LastSeason,'') END)
          AND MJP.ChangeDate = (CASE WHEN @ChangeDate <> '' THEN @ChangeDate ELSE MJP.ChangeDate END)
          AND ISNULL(MS.MakerItem,'') = (CASE WHEN @MakerItem <> '' THEN @MakerItem ELSE ISNULL(MS.MakerItem,'') END)
        ORDER BY MS.BrandCD
                ,MS.SportsCD
                ,MS.SegmentCD
                ,MS.LastYearTerm
                ,MS.LastSeason
                ,MS.MakerItem
                ,MS.ITEMCD
                ,MJP.AdminNO
                ,MJP.ChangeDate
        ;    
    END
    ELSE
    BEGIN
        WITH SKU AS (
            SELECT MJP.AdminNO, MJP.ChangeDate, MAX(MS.ChangeDate) AS SKUChangeDate
              FROM M_JANOrderPrice MJP
             INNER JOIN M_SKU MS ON MJP.AdminNO = MS.AdminNO
                                AND MJP.ChangeDate >= MS.ChangeDate
             WHERE VendorCD = @VendorCD
               AND StoreCD = @StoreCD
             GROUP BY MJP.AdminNO, MJP.ChangeDate
        )
        SELECT 0 AS Chk
              ,MJP.VendorCD
              ,MJP.StoreCD
              ,MS.ITEMCD
              ,( SELECT TOP 1 ITemName
                   FROM M_ITEM X 
                  WHERE X.ITEMCD = MS.ITEMCD
                    AND X.ChangeDate <= MJP.ChangeDate
                   ORDER BY X.ChangeDate DESC
                ) AS ITemName
              ,MJP.AdminNO
              ,MJP.SKUCD
              ,MS.SizeName
              ,MS.ColorName
              ,MS.MakerItem
              ,MS.BrandCD
              ,MS.SportsCD
              ,MS.SegmentCD
              ,MS.LastYearTerm
              ,MS.LastSeason
              ,CONVERT(varchar,MJP.ChangeDate,111) AS ChangeDate
              ,MJP.Rate
              ,( SELECT TOP 1 PriceOutTax
                   FROM M_ITEM X 
                  WHERE X.ITEMCD = MS.ITEMCD
                    AND X.ChangeDate <= MJP.ChangeDate
                   ORDER BY X.ChangeDate DESC
                ) AS PriceOutTax
              ,MJP.PriceWithoutTax
              ,MJP.InsertOperator
              ,MJP.InsertDateTime
              ,MJP.UpdateOperator
              ,MJP.UpdateDateTime
              ,MJP.Rate AS OldRate
              ,'0' AS DelFlg
              ,ROW_NUMBER() OVER(ORDER BY MS.BrandCD,MS.SportsCD,MS.SegmentCD,MS.LastYearTerm,MS.LastSeason,MS.MakerItem,MS.ITEMCD,MJP.AdminNO,MJP.ChangeDate) AS TempKey
        FROM M_JANOrderPrice MJP
        INNER JOIN SKU ON MJP.AdminNO = SKU.AdminNO
                      AND MJP.ChangeDate = SKU.ChangeDate
        INNER JOIN M_SKU MS ON MS.AdminNO = SKU.AdminNO
                           AND MS.ChangeDate = SKU.SKUChangeDate
        WHERE MJP.VendorCD = @VendorCD
          AND MJP.StoreCD = @StoreCD
          AND ISNULL(MS.BrandCD,'') = (CASE WHEN @BrandCD <> '' THEN @BrandCD ELSE ISNULL(MS.BrandCD,'') END)
          AND ISNULL(MS.SportsCD,'') = (CASE WHEN @SportsCD <> '' THEN @SportsCD ELSE ISNULL(MS.SportsCD,'') END)
          AND ISNULL(MS.SegmentCD,'') = (CASE WHEN @SegmentCD <> '' THEN @SegmentCD ELSE ISNULL(MS.SegmentCD,'') END)
          AND ISNULL(MS.LastYearTerm,'') = (CASE WHEN @LastYearTerm <> '' THEN @LastYearTerm ELSE ISNULL(MS.LastYearTerm,'') END)
          AND ISNULL(MS.LastSeason,'') = (CASE WHEN @LastSeason <> '' THEN @LastSeason ELSE ISNULL(MS.LastSeason,'') END)
          AND MJP.ChangeDate = (CASE WHEN @ChangeDate <> '' THEN @ChangeDate ELSE MJP.ChangeDate END)
          AND ISNULL(MS.MakerItem,'') = (CASE WHEN @MakerItem <> '' THEN @MakerItem ELSE ISNULL(MS.MakerItem,'') END)
        ORDER BY MS.BrandCD
                ,MS.SportsCD
                ,MS.SegmentCD
                ,MS.LastYearTerm
                ,MS.LastSeason
                ,MS.MakerItem
                ,MS.ITEMCD
                ,MJP.AdminNO
                ,MJP.ChangeDate
        ;
    END
    
END

GO

--****************************************--
--                                        --
--            ITEMマスタチェック          --
--                                        --
--****************************************--
CREATE PROCEDURE M_ITEM_SelectForShiireTanka(
    @ITemCD varchar(30),
    @ChangeDate varchar(10),
    @DeleteFlg varchar(1)
)AS
BEGIN
    SET NOCOUNT ON;

    SELECT Top 1 MI.ITemCD
          ,CONVERT(varchar,MI.ChangeDate,111) AS ChangeDate
          ,MI.ItemName
          ,MI.BrandCD
          ,BR.BrandName
          ,MI.MakerItem
          ,MI.SportsCD
          ,SP.Char1 AS SportsName
          ,MI.SegmentCD
          ,SG.Char1 AS SegmentName
          ,MI.PriceOutTax
          ,MI.LastYearTerm
          ,MI.LastSeason
          ,MI.DeleteFlg       
    FROM M_ITEM MI
    LEFT JOIN M_Brand BR ON MI.BrandCD = BR.BrandCD
    LEFT JOIN M_MultiPorpose SP ON MI.SportsCD = SP.[Key]
                               AND '202' = SP.ID
    LEFT JOIN M_MultiPorpose SG ON MI.SegmentCD = SG.[Key]
                               AND '203' = SG.ID
    WHERE MI.ITemCD = (CASE WHEN @ITemCD <> '' THEN @ITemCD ELSE MI.ITemCD END)
      AND MI.ChangeDate <= CONVERT(DATE, @ChangeDate)
      AND (@DeleteFlg IS NULL OR MI.DeleteFlg = @DeleteFlg)
    ORDER BY MI.ChangeDate DESC
    ;
END

GO

--****************************************--
--                                        --
--            SKUマスタチェック           --
--                                        --
--****************************************--
CREATE PROCEDURE M_SKU_SelectForShiireTanka(
    @MakerItem varchar(30),
    @AdminNO int,
    @ChangeDate varchar(10)
)AS
BEGIN
    SET NOCOUNT ON;

    SELECT MS.AdminNO
          ,MS.SKUCD
          ,MS.SizeName
          ,MS.ColorName
          ,MS.MakerItem
          ,MS.BrandCD
          ,MS.SportsCD
          ,MS.SegmentCD
          ,MS.LastYearTerm      
          ,MS.LastSeason  
          ,MS.ITemCD
          ,MI.ItemName
          ,MI.PriceOutTax
    FROM F_SKU(CONVERT(DATE, @ChangeDate)) MS
    LEFT JOIN F_ITEM(CONVERT(DATE, @ChangeDate)) MI ON MS.ITEMCD = MI.ITEMCD
    WHERE ISNULL(MS.MakerItem,'') = (CASE WHEN @MakerItem <> '' THEN @MakerItem ELSE ISNULL(MS.MakerItem,'') END)
      AND MS.AdminNO = (CASE WHEN @AdminNO <> 0 THEN @AdminNO ELSE MS.AdminNO END)
      AND MS.DeleteFlg = 0
      AND MI.DeleteFlg = 0
    ;
END

GO

CREATE TYPE T_ItmTanka AS TABLE
    (
    [Chk] [varchar](1) ,
    [VendorCD] [varchar](13),
    [StoreCD] [varchar](4),
    [ITEMCD] [varchar](30),
    [ITemName] [varchar](100),
    [MakerItem] [varchar](30),
    [BrandCD] [varchar](6),
    [BrandName] [varchar](30),
    [SportsCD] [varchar](6),
    [SportsName] [varchar](100),
    [SegmentCD] [varchar](6),
    [SegmentName] [varchar](100),
    [LastYearTerm] [varchar](6),
    [LastSeason] [varchar](6),
    [ChangeDate] [date],
    [Rate] [decimal](5, 2) ,
    [PriceOutTax] [money] ,
    [PriceWithoutTax] [money] ,
    [InsertOperator] [varchar](10),
    [InsertDateTime] [datetime],
    [UpdateOperator] [varchar](10),
    [UpdateDateTime] [datetime],
    [OldRate] [decimal](5, 2) ,
    [DelFlg] [varchar](1) ,
    [TempKey] [int]
    )
GO

CREATE TYPE T_SkuTanka AS TABLE
    (
    [Chk] [varchar](1) ,
    [VendorCD] [varchar](13),
    [StoreCD] [varchar](4),
    [ITEMCD] [varchar](30),
    [ITemName] [varchar](100),
    [AdminNO] [int],
    [SKUCD] [varchar](30),    
    [SizeName] [varchar](20),
    [ColorName] [varchar](20),
    [MakerItem] [varchar](30),
    [BrandCD] [varchar](6),
    [SportsCD] [varchar](6),
    [SegmentCD] [varchar](6),
    [LastYearTerm] [varchar](6),
    [LastSeason] [varchar](6),
    [ChangeDate] [date],
    [Rate] [decimal](5, 2) ,
    [PriceOutTax] [money] ,
    [PriceWithoutTax] [money] ,
    [InsertOperator] [varchar](10),
    [InsertDateTime] [datetime],
    [UpdateOperator] [varchar](10),
    [UpdateDateTime] [datetime],
    [OldRate] [decimal](5, 2) ,
    [DelFlg] [varchar](1) ,
    [TempKey] [int]
    )
GO

--****************************************--
--                                        --
--            登録処理                    --
--                                        --
--****************************************--
CREATE PROCEDURE [dbo].[PRC_MasterTouroku_HacchuuPrice]
    (@VendorCD    varchar(13),
    @OldITMTable  T_ItmTanka READONLY,
    @OldSKUTable  T_SkuTanka READONLY,
    @ITMTable     T_ItmTanka READONLY,
    @SKUTable     T_SkuTanka READONLY,
    @Operator     varchar(10),
    @PC  varchar(30),
    
    @OutVendorCD varchar(13) OUTPUT
)AS

BEGIN
    DECLARE @W_ERR  tinyint;
    DECLARE @SYSDATETIME datetime;
    DECLARE @OperateModeNm varchar(10);
    DECLARE @KeyItem varchar(100);
    
    SET @W_ERR = 0;
    SET @SYSDATETIME = SYSDATETIME();

    -- 【テーブル転送仕様C】M_ItemOrderPrice ITEM発注単価マスタ 
    -- 削除
    DELETE IP
    FROM   M_ItemOrderPrice IP
    INNER JOIN @OldITMTable WK ON IP.VendorCD = WK.VendorCD
                              AND IP.StoreCD = WK.StoreCD
                              AND IP.MakerItem = WK.MakerItem
                              AND IP.ChangeDate = WK.ChangeDate
    ;
    
    -- 追加
    INSERT INTO [M_ItemOrderPrice]
           ([VendorCD]
           ,[StoreCD]
           ,[MakerItem]
           ,[ChangeDate]
           ,[Rate]
           ,[PriceWithoutTax]
           ,[DeleteFlg]
           ,[UsedFlg]
           ,[InsertOperator]
           ,[InsertDateTime]
           ,[UpdateOperator]
           ,[UpdateDateTime])
     SELECT
            VendorCD
           ,StoreCD
           ,MakerItem
           ,ChangeDate
           ,Rate
           ,PriceWithoutTax
           ,0
           ,0
           ,InsertOperator
           ,InsertDateTime
           ,UpdateOperator
           ,UpdateDateTime
    FROM @ITMTable
    ;

    -- 【テーブル転送仕様D】 M_JANOrderPrice JAN発注単価マスタ
    -- 削除
    DELETE JP
    FROM   M_JANOrderPrice JP 
    INNER JOIN @OldSKUTable WK ON JP.VendorCD = WK.VendorCD
                              AND JP.StoreCD = WK.StoreCD
                              AND JP.AdminNO = WK.AdminNO
                              AND JP.ChangeDate = WK.ChangeDate
    ;
    
    -- 追加
    INSERT INTO [dbo].[M_JANOrderPrice]
           ([VendorCD]
           ,[StoreCD]
           ,[AdminNO]
           ,[ChangeDate]
           ,[SKUCD]
           ,[Rate]
           ,[PriceWithoutTax]
           ,[DeleteFlg]
           ,[UsedFlg]
           ,[InsertOperator]
           ,[InsertDateTime]
           ,[UpdateOperator]
           ,[UpdateDateTime])
     SELECT
            VendorCD
           ,StoreCD
           ,AdminNO
           ,ChangeDate
           ,SKUCD
           ,Rate
           ,PriceWithoutTax
           ,0
           ,0
           ,InsertOperator
           ,InsertDateTime
           ,UpdateOperator
           ,UpdateDateTime
    FROM @SKUTable
    ;
    
    --処理履歴データへ更新
    SET @KeyItem = @VendorCD;
            
    EXEC L_Log_Insert_SP
        @SYSDATETIME,
        @Operator,
        'MasterTouroku_HacchuuPrice',
        @PC,
        @OperateModeNm,
        @KeyItem;
 
--<<OWARI>>
  return @W_ERR;

END


