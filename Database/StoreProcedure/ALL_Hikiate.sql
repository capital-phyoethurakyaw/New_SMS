BEGIN TRY 
 Drop Procedure dbo.[ALL_Hikiate]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  ======================================================================
--       Program Call    一括引当処理
--       Program ID      ALL_Hikiate
--       Create date:    2020.05.05
--    ======================================================================
                   
CREATE PROCEDURE [ALL_Hikiate]
    (@Operator  varchar(10),
    @PC         varchar(30),    
    @PStoreCD    varchar(4),
    @PAdminNO    int
)AS

--********************************************--
--                                            --
--                 処理開始                   --
--                                            --
--********************************************--

BEGIN

    DECLARE @W_ERR  tinyint;
    DECLARE @SYSDATETIME datetime;
    DECLARE @SYSDATE date;
    DECLARE @SYSDATE_VAR varchar(10);
    
    SET @W_ERR = 0;
    SET @SYSDATETIME = SYSDATETIME();
    SET @SYSDATE = CONVERT(date,@SYSDATETIME);
    SET @SYSDATE_VAR = CONVERT(varchar,@SYSDATE,111);
    
    DECLARE @StoreKBN tinyint;
    DECLARE @JuchuuNO varchar(11);
    DECLARE @JuchuuRows int;
    DECLARE @AdminNo int;
    DECLARE @SoukoCD varchar(6);
    DECLARE @HikiateSuu int;
    DECLARE @StoreCD varchar(4);
    
    DECLARE @KeySeq int;
    DECLARE @ReserveNO varchar(11);
    DECLARE @Number varchar(11);
    DECLARE @NumberRows int;

    
    --商品引当用
    DECLARE @return_value int,
            @Result tinyint,
            @Error tinyint,
            @LastDay varchar(10),
            @OutKariHikiateNo varchar(11);


    -- 対象店舗テーブル
    DECLARE @TBStore TABLE(
       StoreCD VARCHAR(4)
    );

    -- 対象店舗の取得
    SET @StoreKBN = (SELECT top 1 M.StoreKBN FROM M_Store M
                      WHERE M.StoreCD = @PStoreCD
                        AND M.DeleteFlg = 0
                        AND M.ChangeDate < = @SYSDATE
                      ORDER BY M.ChangeDate desc
                    );
                    
    IF @StoreKBN = 3    --3　:店舗外商
    BEGIN
        INSERT INTO @TBStore SELECT ST.StoreCD
                             FROM ( SELECT M.StoreCD, M.StoreKBN
                                         , ROW_NUMBER() OVER(PARTITION BY StoreCD ORDER BY M.ChangeDate DESC) AS ROW_NO
                                      FROM M_Store M
                                     WHERE M.DeleteFlg = 0
                                       AND M.ChangeDate < = @SYSDATE
                                   ) ST
                            WHERE ST.ROW_NO = 1
                              AND ST.StoreKBN = 2
                            ;
    END
    ELSE   
    BEGIN
        INSERT INTO @TBStore Values (@PStoreCD);
    END
    
    --カーソル定義
    DECLARE CUR_AAA CURSOR FOR
        SELECT DM.JuchuuNO
              ,DM.JuchuuRows
              ,DM.AdminNo
              ,DM.SoukoCD
              ,DM.JuchuuSuu - DM.HikiateSu
              ,DH.StoreCD
          FROM D_JuchuuDetails DM
         INNER JOIN D_Juchuu DH ON DM.JuchuuNO = DH.JuchuuNO
         WHERE DM.DeleteDateTime IS NULL
           AND DH.DeleteDateTime IS NULL
           AND DM.JuchuuSuu > DM.HikiateSu
           AND DM.SalesDate IS NULL
           AND ISNULL(DH.ReturnFLG,0) = 0
           AND ISNULL(DM.DirectFLG,0) = 0
           AND ISNULL(DM.HikiateFLG,0) = 0
           AND ISNULL(DM.UpdateCancelKBN,0) <> 9
           AND DH.StoreCD IN ( SELECT StoreCD FROM @TBStore)
           AND (DM.AdminNo = @PAdminNo OR @PAdminNo = 0)
         ORDER BY DH.JuchuuDate

    --カーソルオープン
    OPEN CUR_AAA;

    --最初の1行目を取得して変数へ値をセット
    FETCH NEXT FROM CUR_AAA
    INTO  @JuchuuNO, @JuchuuRows, @AdminNo, @SoukoCD, @HikiateSuu, @StoreCD
    ;
    
    --データの行数分ループ処理を実行する
    WHILE @@FETCH_STATUS = 0
    BEGIN
    -- ========= ループ内の実際の処理 ここから===

        --Function_商品引当.
        EXEC Fnc_Reserve_SP
            @AdminNO,
            @SYSDATE_VAR,
            @StoreCD,
            @SoukoCD,
            @HikiateSuu,
            1,  --@DenType
            @JuchuuNO, 
            @JuchuuRows,
            NULL,
            @Result OUTPUT,
            @Error OUTPUT,
            @LastDay OUTPUT,
            @OutKariHikiateNo OUTPUT
            ;
            
        IF @OutKariHikiateNo = ''
        BEGIN
            SET @Error = 1;
            RETURN;
        END
        
        --テーブル転送仕様Ａ
        --D_TemporaryReserveに該当のレコードは複数。
        --各レコードで処理必要。
        DECLARE CUR_Tem CURSOR FOR
            SELECT A.KeySeq
            FROM D_TemporaryReserve A
            LEFT OUTER JOIN D_Stock B ON B.StockNO = A.StockNO
            WHERE A.TemporaryNO = @OutKariHikiateNo
            ORDER BY A.KeySeq
            ;
            
        --カーソルオープン
        OPEN CUR_Tem;

        --最初の1行目を取得して変数へ値をセット
        FETCH NEXT FROM CUR_Tem
        INTO  @KeySeq;
        
        --データの行数分ループ処理を実行する
        WHILE @@FETCH_STATUS = 0
        BEGIN
        -- ========= ループ内の実際の処理 ここから===                
            --伝票番号採番
            EXEC Fnc_GetNumber
                12,             --in伝票種別 6
                @SYSDATE,       --in基準日
                @StoreCD,       --in店舗CD
                @Operator,
                @ReserveNO OUTPUT
                ;
            
            IF ISNULL(@ReserveNO,'') = ''
            BEGIN
                SET @W_ERR = 1;
                RETURN @W_ERR;
            END
            
            INSERT INTO [D_Reserve]
               ([ReserveNO]
               ,[ReserveKBN]
               ,[Number]
               ,[NumberRows]
               ,[StockNO]
               ,[SoukoCD]
               ,[JanCD]
               ,[SKUCD]
               ,[AdminNO]
               ,[ReserveSu]
               ,[ShippingPossibleDate]
               ,[ShippingPlanDate]
               ,[ShippingPossibleSU]
               ,[ShippingOrderNO]
               ,[ShippingOrderRows]
               ,[PickingListDateTime]               
               ,[CompletedPickingNO]
               ,[CompletedPickingRow]
               ,[CompletedPickingDate]
               ,[ShippingSu]
               ,[ReturnKBN]
               ,[OriginalReserveNO]
               ,[InsertOperator]
               ,[InsertDateTime]
               ,[UpdateOperator]
               ,[UpdateDateTime]
               ,[DeleteOperator]
               ,[DeleteDateTime])
             SELECT
                @ReserveNO
               ,tbl.ReserveKBN
               ,tbl.Number
               ,tbl.NumberRows
               ,tbl.StockNO
               ,DS.SoukoCD
               ,DS.JanCD
               ,DS.SKUCD
               ,DS.AdminNO
               ,tbl.ReserveSu
               ,CASE WHEN DS.ArrivalYetFLG = 0 THEN @SYSDATE ELSE NULL END    --ShippingPossibleDate
               ,NULL
               ,CASE WHEN DS.ArrivalYetFLG = 0 THEN tbl.ReserveSu ELSE 0 END   --ShippingPossibleSU
               ,NULL    --ShippingOrderNO
               ,0       --ShippingOrderRows
               ,NULL    --PickingListDateTime
               ,NULL    --CompletedPickingNO
               ,0       --CompletedPickingRow
               ,NULL    --CompletedPickingDate
               ,0       --ShippingSu
               ,0       --ReturnKBN
               ,NULL    --OriginalReserveNO
               ,@Operator  
               ,@SYSDATETIME
               ,@Operator  
               ,@SYSDATETIME
               ,NULL    --DeleteOperator
               ,NULL    --DeleteDateTime
           FROM D_TemporaryReserve tbl
           LEFT JOIN D_Stock DS ON tbl.StockNO = DS.StockNO
          WHERE tbl.TemporaryNO = @OutKariHikiateNo
          ;        
                       
          -- ========= ループ内の実際の処理 ここまで===

            --次の行のデータを取得して変数へ値をセット
            FETCH NEXT FROM CUR_Tem
            INTO  @KeySeq;

        END
        
        --カーソルを閉じる
        CLOSE CUR_Tem;
        DEALLOCATE CUR_Tem;
        
        --テーブル転送仕様B    
        UPDATE D_Stock SET
               ReserveSu = DS.ReserveSu + DT.ReserveSu
              ,AllowableSu = DS.AllowableSu - DT.ReserveSu
              ,AnotherStoreAllowableSu = DS.AnotherStoreAllowableSu - DT.ReserveSu
              ,UpdateOperator =  @Operator  
              ,UpdateDateTime =  @SYSDATETIME
        FROM D_TemporaryReserve AS DT
        INNER JOIN D_Stock DS ON DT.StockNO = DS.StockNO
                             AND DS.DeleteDateTime IS NULL
        WHERE DT.TemporaryNO = @OutKariHikiateNo
        ;

        --カーソル定義
        DECLARE CUR_Tem2 CURSOR FOR
            SELECT tbl.Number
                  ,tbl.NumberRows
                  ,MAX(DJM.HikiateSu) + SUM(tbl.ReserveSu) AS ReserveSu
                  ,MAX(DJM.JuchuuSuu) AS JuchuuSuu
              FROM D_TemporaryReserve AS tbl
             INNER JOIN D_JuchuuDetails DJM ON tbl.Number = DJM.JuchuuNO
                                           AND tbl.NumberRows = DJM.JuchuuRows
             WHERE tbl.TemporaryNO = @OutKariHikiateNo
             GROUP BY tbl.Number
                     ,tbl.NumberRows
            ;

        DECLARE @ReserveSu int;
        DECLARE @JuchuuSuu int;
        
        --カーソルオープン
        OPEN CUR_Tem2;

        --最初の1行目を取得して変数へ値をセット
        FETCH NEXT FROM CUR_Tem2
        INTO @Number, @NumberRows, @ReserveSu, @JuchuuSuu;
        
        --データの行数分ループ処理を実行する
        WHILE @@FETCH_STATUS = 0
        BEGIN
        
            -- 受注明細テーブル（テーブル転送仕様C）
            UPDATE D_JuchuuDetails SET
                   HikiateSu = @ReserveSu
                  ,HikiateFlg = (CASE WHEN @ReserveSu = 0 THEN 3 WHEN @ReserveSu >= @JuchuuSuu THEN 1 ELSE 2 END)
                  ,UpdateOperator  =  @Operator  
                  ,UpdateDateTime  =  @SYSDATETIME
            WHERE JuchuuNO = @Number
              AND JuchuuRows = @NumberRows
            ;
            
            -- 配送予定明細テーブル（テーブル転送仕様D）
            UPDATE D_DeliveryPlanDetails SET
               HikiateFlg = (CASE WHEN @ReserveSu >= @JuchuuSuu THEN 1 ELSE 0 END)
              ,UpdateOperator  =  @Operator  
              ,UpdateDateTime  =  @SYSDATETIME
            WHERE Number = @Number
              AND NumberRows = @NumberRows
            ;
            
            --次の行のデータを取得して変数へ値をセット
            FETCH NEXT FROM CUR_Tem2
            INTO @Number, @NumberRows, @ReserveSu, @JuchuuSuu;

        END     --LOOPの終わり
        
        --カーソルを閉じる
        CLOSE CUR_Tem2;
        DEALLOCATE CUR_Tem2;

      -- ========= ループ内の実際の処理 ここまで===

        --次の行のデータを取得して変数へ値をセット
        FETCH NEXT FROM CUR_AAA
        INTO  @JuchuuNO, @JuchuuRows, @AdminNo, @SoukoCD, @HikiateSuu, @StoreCD;
    END
    
    --カーソルを閉じる
    CLOSE CUR_AAA;
    DEALLOCATE CUR_AAA;                     
            
    
--<<OWARI>>
  return @W_ERR;

END


