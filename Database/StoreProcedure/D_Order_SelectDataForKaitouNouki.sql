 BEGIN TRY 
 Drop Procedure dbo.[D_Order_SelectDataForKaitouNouki]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [D_Order_SelectDataForKaitouNouki]    */
Create PROCEDURE [dbo].[D_Order_SelectDataForKaitouNouki](
    -- Add the parameters for the stored procedure here
    @ArrivalPlanDateFrom  varchar(10),
    @ArrivalPlanDateTo  varchar(10),
    @ArrivalPlanMonthFrom  int,
    @ArrivalPlanMonthTo  int,
    @OrderDateFrom  varchar(10),
    @OrderDateTo  varchar(10),
    @OrderNOFrom  varchar(11),
    @OrderNOTo  varchar(11),
    @EDIDate  varchar(10),
    
    @ChkMikakutei tinyint,
    @ArrivalPlan int,
    @ChkKanbai tinyint,
    @ChkFuyo tinyint,
    
    @OrderCD  varchar(13),
    @StoreCD  varchar(4)

)AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    
    DECLARE @SYSDATETIME datetime;
    SET @SYSDATETIME = SYSDATETIME();
    
    IF OBJECT_ID( N'[dbo]..[#TableForKaitouNouki]', N'U' ) IS NOT NULL
      BEGIN
        DROP TABLE [#TableForKaitouNouki];
      END
      
    -- Insert statements for procedure here
    SELECT DH.OrderNO
          ,DM.OrderRows
          ,CONVERT(varchar,DH.OrderDate,111) AS OrderDate
          ,DM.JuchuuNO
          ,DM.JuchuuRows
          ,ROW_NUMBER() OVER(PARTITION BY DH.OrderNO,DM.OrderRows ORDER BY DA.ArrivalPlanNO) ROWNUM
          ,ISNULL(DA.ArrivalPlanNO,' ') AS ArrivalPlanNO
          
          ,DH.DestinationSoukoCD
          ,DM.ColorName
          ,DM.SizeName
          
          ,(CASE DH.DestinationKBN WHEN 1 THEN N'〇' ElSE '' END) AS DestinationKBN
          
          ,DH.OrderCD          
          ,(SELECT top 1 A.VendorName
          FROM M_Vendor A 
          WHERE A.VendorCD = DH.OrderCD AND A.DeleteFlg = 0 AND A.ChangeDate <= DH.OrderDate
		  AND A.VendorFlg = 1
          ORDER BY A.ChangeDate desc) AS VendorName 
                                   
          ,(SELECT top 1 A.StoreName 
              FROM M_Store A 
              WHERE A.StoreCD = DH.StoreCD AND A.ChangeDate <= DH.OrderDate
              AND A.DeleteFlg = 0
              ORDER BY A.ChangeDate desc) AS StoreName
          
          ,(SELECT top 1 (CASE A.VariousFLG WHEN 1 THEN DM.ItemName ELSE A.SKUName END) AS SKUName 
              FROM M_SKU A 
              WHERE A.AdminNO = DM.AdminNO 
              AND A.ChangeDate <= DH.OrderDate 
              AND A.DeleteFlg = 0
              ORDER BY A.ChangeDate desc) AS SKUName
            ,(SELECT top 1 M.ITemCD 
            FROM M_SKU AS M 
            WHERE M.ChangeDate <= DH.OrderDate
             AND M.AdminNO = DM.AdminNO
              AND M.DeleteFlg = 0
             ORDER BY M.ChangeDate desc) AS ITemCD
            ,(SELECT top 1 M.AdminNO 
            FROM M_SKU AS M 
            WHERE M.ChangeDate <= DH.OrderDate
             AND M.AdminNO = DM.AdminNO
              AND M.DeleteFlg = 0
             ORDER BY M.ChangeDate desc) AS AdminNO
            ,(SELECT top 1 M.SKUCD 
            FROM M_SKU AS M 
            WHERE M.ChangeDate <= DH.OrderDate
             AND M.AdminNO = DM.AdminNO
              AND M.DeleteFlg = 0
             ORDER BY M.ChangeDate desc) AS SKUCD
            ,(SELECT top 1 M.JANCD 
            FROM M_SKU AS M 
            WHERE M.ChangeDate <= DH.OrderDate
             AND M.AdminNO = DM.AdminNO
              AND M.DeleteFlg = 0
             ORDER BY M.ChangeDate desc) AS JANCD
            ,DM.MakerItem
            ,(SELECT top 1 M.OrderAttentionNote 
            FROM M_SKU AS M 
            WHERE M.ChangeDate <= DH.OrderDate
             AND M.AdminNO = DM.AdminNO
              AND M.DeleteFlg = 0
             ORDER BY M.ChangeDate desc) AS OrderAttentionNote
             
          ,DM.CommentOutStore
          ,DM.CommentInStore

          ,DM.OrderSu
          ,DM.OrderUnitPrice
          ,DM.OrderHontaiGaku
          
          ,DS.StockNO
          ,ISNULL(DS.InstructionSu,0) AS InstructionSu
          ,DR.ReserveNO
          ,CONVERT(varchar,DA.ArrivalPlanDate,111) AS ArrivalPlanDate
          ,DA.ArrivalPlanMonth      --ù\ÆÞîÄ
          ,DA.ArrivalPlanCD       --ù\ÆÞÅ¾ïÁ 
          ,DA.ArrivalPlanSu
                          
          ,(SELECT top 1 M.Num2 
            FROM M_MultiPorpose AS M 
            WHERE M.ID = 206
            AND M.[Key] = DA.ArrivalPlanCD
            ) AS Num2 
              
          ,1 AS DelFlg
          ,0 AS UpdateFlg
          ,CONVERT(date, NULL) AS CalcuArrivalPlanDate
    
    INTO #TableForKaitouNouki
    from D_Order AS DH
    INNER JOIN D_OrderDetails AS DM 
        ON DM.OrderNO = DH.OrderNO 
        AND DM.DeleteDateTime IS NULL
    /*
    INNER JOIN (SELECT  DM.OrderNO
            , CONVERT(varchar, MAX(DA.ArrivalPlanDate), 111) AS ArrivalPlanDate
            FROM D_OrderDetails AS DM 
            
            LEFT OUTER JOIN D_ArrivalPlan AS DA
            ON  DA.DeleteDateTime IS NULL
            AND DM.OrderNO = DA.Number AND DM.OrderRows = DA.NumberRows
            AND DA.ArrivalPlanKBN = 1
            
            WHERE DM.DeleteDateTime IS NULL
            
            --üÜùvâ`âFâbâN
            --ëµû╩é┼ö═ê═ÄwÆÞé│éÛé¢ô³ëÎù\ÆÞô·é╔ìçÆvéÀéÚé®é­ö╗Æfü®ç@
            --ìçÆvéÁé¢ÅÛìçüAìçÆvéÁé╚éóô·éÓè▄é▀é─üAé╗é╠ö¡ÆìöÈìåé╠ô³ëÎù\ÆÞÅ¯ò±é═æSé─üiì┼æÕéRüjÆèÅoüAò\ÄªéÀéÚü®üE
            AND ISNULL(DA.ArrivalPlanDate,'') >= (CASE WHEN @ArrivalPlanDateFrom <> '' THEN CONVERT(DATE, @ArrivalPlanDateFrom) ELSE ISNULL(DA.ArrivalPlanDate,'') END)
            AND ISNULL(DA.ArrivalPlanDate,'') <= (CASE WHEN @ArrivalPlanDateTo <> '' THEN CONVERT(DATE, @ArrivalPlanDateTo) ELSE ISNULL(DA.ArrivalPlanDate,'') END)
            
            AND ((ISNULL(DA.ArrivalPlanMonth,0) >= (CASE WHEN @ArrivalPlanMonthFrom <> 0 THEN @ArrivalPlanMonthFrom ELSE ISNULL(DA.ArrivalPlanMonth,0) END)
                    AND ISNULL(DA.ArrivalPlanMonth,0) <= (CASE WHEN @ArrivalPlanMonthTo <> 0 THEN @ArrivalPlanMonthTo ELSE ISNULL(DA.ArrivalPlanMonth,0) END))
                OR (CONVERT(VARCHAR, ISNULL(DA.ArrivalPlanDate,''), 112) / 100 >= (CASE WHEN @ArrivalPlanMonthFrom <> 0 THEN @ArrivalPlanMonthFrom ELSE CONVERT(VARCHAR, ISNULL(DA.ArrivalPlanDate,''), 112) / 100 END)
                    AND CONVERT(VARCHAR, ISNULL(DA.ArrivalPlanDate,''), 112) / 100 <= (CASE WHEN @ArrivalPlanMonthTo <> 0 THEN @ArrivalPlanMonthTo ELSE CONVERT(VARCHAR, ISNULL(DA.ArrivalPlanDate,''), 112) / 100 END))
                )
                    
            GROUP BY DM.OrderNO
            ) AS DMA ON DM.OrderNO = DMA.OrderNO
            */
    LEFT OUTER JOIN D_ArrivalPlan AS DA
        ON DA.DeleteDateTime IS NULL
        AND DM.OrderNO = DA.Number AND DM.OrderRows = DA.NumberRows
        AND DA.ArrivalPlanKBN = 1
            
    LEFT OUTER JOIN D_EDI AS DE
        ON DE.EDIImportNO = DA.EDIImportNO
        AND DE.DeleteDateTime IS NULL
        
    LEFT OUTER JOIN D_Stock AS DS
        ON DA.ArrivalPlanNO = DS.ArrivalPlanNO 
        AND DS.DeleteDateTime IS NULL

    LEFT OUTER JOIN D_Reserve AS DR
        ON DR.StockNO = DS.StockNO 
        AND DR.DeleteDateTime IS NULL

    LEFT OUTER JOIN  M_MultiPorpose AS M
        ON M.ID = 206
        AND M.[Key] = DA.ArrivalPlanCD
        
    WHERE DH.StoreCD = @StoreCD
        AND DH.OrderCD = (CASE WHEN @OrderCD <> '' THEN @OrderCD ELSE DH.OrderCD END)
        --AND DH.DestinationKBN = 2   --Æ╝æùé┼û│éó		2020.03.31 del
        --AND DH.OrderWayKBN = 2  --Netö¡Æìé┼é╚éó		2020.03.31 del
        AND DH.ReturnFLG = 0    --âLâââôâZâïé┼é╚éó
        AND DH.ApprovalStageFLG >= 1 --ïpë║ê╚èO
        
        AND DH.OrderNO >= (CASE WHEN @OrderNOFrom <> '' THEN @OrderNOFrom ELSE DH.OrderNO END)
        AND DH.OrderNO <= (CASE WHEN @OrderNOTo <> '' THEN @OrderNOTo ELSE DH.OrderNO END)
      
        AND DH.OrderDate >= (CASE WHEN @OrderDateFrom <> '' THEN CONVERT(DATE, @OrderDateFrom) ELSE DH.OrderDate END)
        AND DH.OrderDate <= (CASE WHEN @OrderDateTo <> '' THEN CONVERT(DATE, @OrderDateTo) ELSE DH.OrderDate END)
        AND ISNULL(CONVERT(DATE,DE.ImportDateTime),'') = (CASE WHEN @EDIDate <> '' THEN CONVERT(DATE, @EDIDate) ELSE ISNULL(CONVERT(DATE,DE.ImportDateTime),'') END)

        AND DH.DeleteDateTime IS NULL

    ORDER BY DH.OrderNO
    ;
    
    ALTER TABLE [#TableForKaitouNouki] ALTER COLUMN [OrderNO] VARCHAR(11) NOT NULL;
    ALTER TABLE [#TableForKaitouNouki] ALTER COLUMN [OrderRows] int NOT NULL;
    ALTER TABLE [#TableForKaitouNouki] ALTER COLUMN [ArrivalPlanNO] VARCHAR(11) NOT NULL;
    ALTER TABLE [#TableForKaitouNouki] ALTER COLUMN [ROWNUM] int NOT NULL;
    
    ALTER TABLE [#TableForKaitouNouki] ADD PRIMARY KEY CLUSTERED ([OrderNO], [OrderRows], [ArrivalPlanNO], [ROWNUM])
    WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
    ;

    IF ((ISNULL(@OrderDateFrom,'') <> '' OR ISNULL(@OrderDateTo,'') <> '') AND (@ChkMikakutei = 1 OR @ChkFuyo = 1 OR @ChkKanbai = 1))
    BEGIN
        UPDATE #TableForKaitouNouki
        SET DelFlg = 1
        ;

        --ô·òtûóèmÆÞò¬ONé╠ÅÛìç
        IF @ChkMikakutei = 1
        BEGIN
            --ô³ëÎù\ÆÞâfü[â^é¬æÂì¦éÁé╚éó
            UPDATE #TableForKaitouNouki
            SET DelFlg = 0
            WHERE NOT EXISTS(
                SELECT DA.ArrivalPlanDate
                FROM D_ArrivalPlan AS DA
                WHERE DA.Number = #TableForKaitouNouki.OrderNO
                AND DA.NumberRows = #TableForKaitouNouki.OrderRows
                AND DA.ArrivalPlanKBN = 1
                AND DA.DeleteDateTime IS NULL
            );

            --ù\ÆÞô·é╚éÁé┼ô³ëÎù\ÆÞâfü[â^é¬æÂì¦éÀéÚ
            UPDATE #TableForKaitouNouki
            SET DelFlg = 0
            WHERE EXISTS(
                SELECT DA.ArrivalPlanDate
                FROM D_ArrivalPlan AS DA
                WHERE DA.Number = #TableForKaitouNouki.OrderNO
                AND DA.NumberRows = #TableForKaitouNouki.OrderRows
                AND DA.ArrivalPlanKBN = 1
                AND DA.ArrivalPlanCD IS NULL
                AND DA.ArrivalPlanDate IS NULL
                AND DA.ArrivalPlanMonth IS NULL
                AND DA.DeleteDateTime IS NULL
            );
            
            --Å{üAù\û±üAûóÆÞüAèmöFÆåé┼ô³ëÎù\ÆÞâfü[â^é¬æÂì¦éÀéÚ
            UPDATE #TableForKaitouNouki
            SET DelFlg = 0
            WHERE EXISTS(
                SELECT DA.ArrivalPlanDate
                FROM D_ArrivalPlan AS DA
                INNER JOIN M_MultiPorpose AS M
                ON M.ID = 206
                AND M.[Key] = DA.ArrivalPlanCD
                AND M.Num2 IN (1,2,4,6)
                WHERE DA.Number = #TableForKaitouNouki.OrderNO
                AND DA.NumberRows = #TableForKaitouNouki.OrderRows
                AND DA.ArrivalPlanKBN = 1
                AND DA.DeleteDateTime IS NULL
            );
            
        END
		                    
        --òsùvò¬ONé╠ÅÛìç
        IF @ChkFuyo = 1
        BEGIN
            UPDATE #TableForKaitouNouki
            SET DelFlg = 0
            WHERE EXISTS(
                SELECT DA.ArrivalPlanDate
                FROM D_ArrivalPlan AS DA
                INNER JOIN M_MultiPorpose AS M
                ON M.ID = 206
                AND M.[Key] = DA.ArrivalPlanCD
                AND M.Num2 = 5
                WHERE DA.Number = #TableForKaitouNouki.OrderNO
                AND DA.NumberRows = #TableForKaitouNouki.OrderRows
                AND DA.ArrivalPlanKBN = 1
                AND DA.DeleteDateTime IS NULL
            );
        END
        
        --è«öäò¬ONé╠ÅÛìç
        IF @ChkKanbai = 1
        BEGIN
            UPDATE #TableForKaitouNouki
            SET DelFlg = 0
            WHERE EXISTS(
                SELECT DA.ArrivalPlanDate
                FROM D_ArrivalPlan AS DA
                INNER JOIN M_MultiPorpose AS M
                ON M.ID = 206
                AND M.[Key] = DA.ArrivalPlanCD
                AND M.Num2 = 3
                WHERE DA.Number = #TableForKaitouNouki.OrderNO
                AND DA.NumberRows = #TableForKaitouNouki.OrderRows
                AND DA.ArrivalPlanKBN = 1
                AND DA.DeleteDateTime IS NULL
            );
        END
        
        DELETE FROM #TableForKaitouNouki
        WHERE DelFlg = 1
        ;
    END  

    --ô³ëÎù\ÆÞïµò¬
    IF  @ArrivalPlan <> 0
    BEGIN
        UPDATE #TableForKaitouNouki
        SET DelFlg = 1
        ;
        
        UPDATE #TableForKaitouNouki
        SET DelFlg = 0
        WHERE EXISTS(
            SELECT DA.ArrivalPlanDate
            FROM D_ArrivalPlan AS DA
            INNER JOIN M_MultiPorpose AS M
            ON M.ID = 206
            AND M.[Key] = DA.ArrivalPlanCD
            AND M.Num2 = (SELECT A.Num2 FROM M_MultiPorpose AS A WHERE A.ID = 206 AND A.[Key] = @ArrivalPlan) 
            WHERE DA.Number = #TableForKaitouNouki.OrderNO
            AND DA.NumberRows = #TableForKaitouNouki.OrderRows
            AND DA.ArrivalPlanKBN = 1
            AND DA.DeleteDateTime IS NULL
        );

        DELETE FROM #TableForKaitouNouki
        WHERE DelFlg = 1
        ;
	END
	
    --ëµû╩é┼ö═ê═ÄwÆÞé│éÛé¢ô³ëÎù\ÆÞô·é╔ìçÆvéÀéÚé®é­ö╗Æfü®ç@
    --ìçÆvéÁé¢ÅÛìçüAìçÆvéÁé╚éóô·éÓè▄é▀é─üAé╗é╠ö¡ÆìöÈìåé╠ô³ëÎù\ÆÞÅ¯ò±é═æSé─üiì┼æÕéRüjÆèÅoüAò\ÄªéÀéÚü®üE
    IF ISNULL(@ArrivalPlanDateFrom,'') <> '' OR ISNULL(@ArrivalPlanDateTo,'') <> '' OR @ArrivalPlanMonthFrom > 0 OR @ArrivalPlanMonthTo > 0
    BEGIN
        UPDATE #TableForKaitouNouki
        SET DelFlg = 1
        ;
        
        IF ISNULL(@ArrivalPlanDateFrom,'') <> '' OR ISNULL(@ArrivalPlanDateTo,'') <> '' 
        BEGIN
            UPDATE #TableForKaitouNouki
            SET DelFlg = 0
            WHERE EXISTS(
                SELECT DA.ArrivalPlanDate
                FROM D_ArrivalPlan AS DA
                WHERE DA.Number = #TableForKaitouNouki.OrderNO
                AND DA.NumberRows = #TableForKaitouNouki.OrderRows
                AND DA.ArrivalPlanKBN = 1
                AND DA.ArrivalPlanDate >= (CASE WHEN @ArrivalPlanDateFrom <> '' THEN CONVERT(DATE, @ArrivalPlanDateFrom) ELSE DA.ArrivalPlanDate END)
                AND DA.ArrivalPlanDate <= (CASE WHEN @ArrivalPlanDateTo <> '' THEN CONVERT(DATE, @ArrivalPlanDateTo) ELSE DA.ArrivalPlanDate END)
            AND DA.DeleteDateTime IS NULL
            );
        END
        
        IF @ArrivalPlanMonthFrom > 0 OR @ArrivalPlanMonthTo > 0
        BEGIN
            UPDATE #TableForKaitouNouki
            SET DelFlg = 0
            WHERE EXISTS(
                SELECT DA.ArrivalPlanDate
                FROM D_ArrivalPlan AS DA
                WHERE DA.Number = #TableForKaitouNouki.OrderNO
                AND DA.NumberRows = #TableForKaitouNouki.OrderRows
                AND DA.ArrivalPlanKBN = 1
                AND ((DA.ArrivalPlanMonth >= (CASE WHEN @ArrivalPlanMonthFrom <> 0 THEN @ArrivalPlanMonthFrom ELSE DA.ArrivalPlanMonth END)
                        AND DA.ArrivalPlanMonth <= (CASE WHEN @ArrivalPlanMonthTo <> 0 THEN @ArrivalPlanMonthTo ELSE DA.ArrivalPlanMonth END))
                    OR (CONVERT(VARCHAR, ISNULL(DA.ArrivalPlanDate,''), 112) / 100 >= (CASE WHEN @ArrivalPlanMonthFrom <> 0 THEN @ArrivalPlanMonthFrom ELSE CONVERT(VARCHAR, ISNULL(DA.ArrivalPlanDate,''), 112) / 100 END)
                        AND CONVERT(VARCHAR, ISNULL(DA.ArrivalPlanDate,''), 112) / 100 <= (CASE WHEN @ArrivalPlanMonthTo <> 0 THEN @ArrivalPlanMonthTo ELSE CONVERT(VARCHAR, ISNULL(DA.ArrivalPlanDate,''), 112) / 100 END))
                    )
            AND DA.DeleteDateTime IS NULL
            );
        END
        
        DELETE FROM #TableForKaitouNouki
        WHERE DelFlg = 1
        ;
    END
    
    
    SELECT *
        ,COUNT(DH.OrderNO) OVER(PARTITION BY DH.OrderNO, DH.OrderRows) AS CNT
    FROM #TableForKaitouNouki AS DH
    WHERE DH.ROWNUM <= 3	--üiì┼æÕéRüj
    ORDER BY DH.OrderDate, DH.OrderNO, DH.OrderRows
    ;
    
END

