BEGIN TRY 
 Drop PROCEDURE dbo.[D_MoveRequest_SelectDataForIdouIrai]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

BEGIN TRY 
 Drop PROCEDURE dbo.[PRC_ZaikoIdouIraiNyuuryoku]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--  ======================================================================
--       Program Call    在庫移動依頼入力
--       Program ID      ZaikoIdouIraiNyuuryoku
--       Create date:    2019.12.11
--    ======================================================================
CREATE PROCEDURE D_MoveRequest_SelectDataForIdouIrai
    (@RequestNO varchar(11)
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
    SELECT DH.RequestNO
          ,DH.StoreCD
          ,CONVERT(varchar,DH.RequestDate,111) AS RequestDate
          ,DH.MovePurposeKBN
          ,DH.FromStoreCD
          ,DH.FromSoukoCD
          ,DH.ToStoreCD
          ,DH.ToSoukoCD
          ,DH.StaffCD
          ,DH.AnswerDateTime
          ,DH.AnswerStaffCD
          ,DH.InsertOperator
          ,CONVERT(varchar,DH.InsertDateTime) AS InsertDateTime
          ,DH.UpdateOperator
          ,CONVERT(varchar,DH.UpdateDateTime) AS UpdateDateTime
          ,DH.DeleteOperator
          ,CONVERT(varchar,DH.DeleteDateTime) AS DeleteDateTime
                  
          ,DM.RequestRows
          ,DM.SKUCD
          ,DM.AdminNO
          ,DM.JanCD
          ,(SELECT top 1 M.SKUName 
            FROM M_SKU AS M 
            WHERE M.ChangeDate <= DH.RequestDate
             AND M.AdminNO = DM.AdminNO
              AND M.DeleteFlg = 0
             ORDER BY M.ChangeDate desc) AS SKUName
          ,(SELECT top 1 M.ColorName 
            FROM M_SKU AS M 
            WHERE M.ChangeDate <= DH.RequestDate
             AND M.AdminNO = DM.AdminNO
              AND M.DeleteFlg = 0
             ORDER BY M.ChangeDate desc) AS ColorName
          ,(SELECT top 1 M.SizeName 
            FROM M_SKU AS M 
            WHERE M.ChangeDate <= DH.RequestDate
             AND M.AdminNO = DM.AdminNO
              AND M.DeleteFlg = 0
             ORDER BY M.ChangeDate desc) AS SizeName
          
          ,DM.RequestSu
          ,CONVERT(varchar,DM.ExpectedDate,111) AS ExpectedDate
          ,DM.CommentInStore

      FROM D_MoveRequest DH
      LEFT OUTER JOIN D_MoveRequestDetailes AS DM 
      ON DH.RequestNO = DM.RequestNO 
      AND DM.DeleteDateTime IS NULL                     
      
      WHERE DH.RequestNO = @RequestNO           
      AND DH.DeleteDateTime IS Null
      ORDER BY DM.RequestRows
      ;
      
END

GO

CREATE TYPE T_IdoIrai AS TABLE
    (
    [RequestRows] [int],

    [SKUCD] [varchar](30) ,
    [AdminNO] [int] ,
    [JanCD] [varchar](13) ,
    [RequestSu] [int] ,
    [OldRequestSu] [int] ,

    [ExpectedDate] date,
    [CommentInStore] varchar(80),
    [UpdateFlg][tinyint]
    )
GO

CREATE PROCEDURE PRC_ZaikoIdouIraiNyuuryoku
   (@OperateMode    int,                 -- 処理区分（1:新規 2:修正 3:削除）
    @RequestNO   varchar(11),
    @StoreCD   varchar(4),
    @MovePurposeKBN tinyint,
--    @MovePurposeType tinyint,
    @RequestDate  varchar(10),
    @FromStoreCD varchar(4),
    @FromSoukoCD varchar(6),
    @ToStoreCD varchar(4),
    @ToSoukoCD varchar(6),
    @StaffCD   varchar(10),

    @Table  T_IdoIrai READONLY,
    @Operator  varchar(10),
    @PC  varchar(30),
    @OutRequestNO varchar(11) OUTPUT
)AS

--********************************************--
--                                            --
--                 処理開始                   --
--                                            --
--********************************************--

BEGIN
    DECLARE @W_ERR  tinyint;
    DECLARE @SYSDATETIME datetime;
    DECLARE @OperateModeNm varchar(10);
    DECLARE @KeyItem varchar(100);
    DECLARE @Program varchar(100); 
    
    SET @W_ERR = 0;
    SET @SYSDATETIME = SYSDATETIME();
    SET @Program = 'ZaikoIdouIraiNyuuryoku';    
    
    DECLARE @KBN_TENPOKAN tinyint;
    SET @KBN_TENPOKAN = 1;

    DECLARE CUR_Store CURSOR FOR
        SELECT top 1 A.MailAddress1, A.MailAddress2, A.MailAddress3
        FROM M_Store AS A
        WHERE A.StoreCD = @ToStoreCD 
        AND A.DeleteFlg = 0 
        AND A.ChangeDate <= @RequestDate
        ORDER BY A.ChangeDate desc
        ;
    
	DECLARE @MailAddress1 varchar(100);
    DECLARE @MailAddress2 varchar(100);
    DECLARE @MailAddress3 varchar(100);
    DECLARE @Rows int;
    DECLARE @MailCounter int;

    DECLARE @MailFlg tinyint;
    SET @MailFlg = (SELECT M.MailFlg FROM M_MovePurpose AS M WHERE M.MovePurposeKBN = 1);

    --新規--
    IF @OperateMode = 1
    BEGIN
        SET @OperateModeNm = '新規';

        --伝票番号採番
        EXEC Fnc_GetNumber
            24,             --in伝票種別 24
            @RequestDate, --in基準日
            @StoreCD,       --in店舗CD
            @Operator,
            @RequestNO OUTPUT
            ;
        
        IF ISNULL(@RequestNO,'') = ''
        BEGIN
            SET @W_ERR = 1;
            RETURN @W_ERR;
        END
        
        --【D_MoveRequest】移動依頼　Table転送仕様Ａ
        INSERT INTO [D_MoveRequest]
           ([RequestNO]
           ,[StoreCD]
           ,[RequestDate]
           ,[MovePurposeKBN]
           ,[FromStoreCD]
           ,[FromSoukoCD]
           ,[ToStoreCD]
           ,[ToSoukoCD]
           ,[RequestInputDateTime]
           ,[StaffCD]
           ,[AnswerDateTime]
           ,[AnswerStaffCD]
           ,[InsertOperator]
           ,[InsertDateTime]
           ,[UpdateOperator]
           ,[UpdateDateTime]
           ,[DeleteOperator]
           ,[DeleteDateTime])
     	VALUES
           (@RequestNO
           ,@StoreCD
           ,convert(date,@RequestDate)
           ,@MovePurposeKBN
           ,@FromStoreCD
           ,@FromSoukoCD
           ,@ToStoreCD
           ,@ToSoukoCD
           ,SYSDATETIME()	--RequestInputDateTime
           ,@StaffCD
           ,NULL	--AnswerDateTime
           ,NULL	--AnswerStaffCD

           ,@Operator  
           ,@SYSDATETIME
           ,@Operator  
           ,@SYSDATETIME
           ,NULL                  
           ,NULL
           );               
	END
	
	IF @OperateMode <= 2	--新規・修正　追加行のための更新
	BEGIN
        --【D_MoveRequestDetailes】移動依頼明細　Table転送仕様Ｂ
        INSERT INTO [D_MoveRequestDetailes]
                   ([RequestNO]
                   ,[RequestRows]
                   ,[SKUCD]
                   ,[AdminNO]
                   ,[JanCD]
                   ,[RequestSu]
                   ,[ExpectedDate]
                   ,[CommentInStore]
                   ,[AnswerKBN]

                   ,[InsertOperator]
                   ,[InsertDateTime]
                   ,[UpdateOperator]
                   ,[UpdateDateTime])
             SELECT @RequestNO                         
                   ,tbl.RequestRows                       
                   ,tbl.SKUCD
                   ,tbl.AdminNO
                   ,tbl.JanCD
                   ,tbl.RequestSu
                   ,tbl.ExpectedDate
                   ,tbl.CommentInStore
                   ,0	--AnswerKBN
                   
                   ,@Operator  
                   ,@SYSDATETIME
                   ,@Operator  
                   ,@SYSDATETIME

              FROM @Table tbl
              WHERE tbl.UpdateFlg = 0
              ;
	END
	
    --新規--
    IF @OperateMode = 1
    BEGIN
        --MailFlg = 1の場合
        IF @MailFlg = 1
        BEGIN
            --【D_Mail】メール連絡内容　Table転送仕様Ｃ
            INSERT INTO [D_Mail]
               ([MailCounter]
               ,[MailType]
               ,[MailKBN]
               ,[Number]
               ,[MailNORows]
               ,[MailDateTime]
               ,[StaffCD]
               ,[ContactKBN]
               ,[MailPatternCD]
               ,[MailSubject]
               ,[MailPriority]
               ,[ReMailFlg]
               ,[UnitKBN]
               ,[SendedDateTime]
               ,[SenderKBN]
               ,[SenderCD]
               ,[SenderAddress]
               ,[MailContent]
               ,[InsertOperator]
               ,[InsertDateTime]
               ,[UpdateOperator]
               ,[UpdateDateTime])
            VALUES(
                ISNULL((SELECT MAX(A.MailCounter) FROM D_Mail AS A),0) +1 
               ,9   --MailType
               ,51  --MailKBN
               ,@RequestNO  --Number
               ,1   --MailNORows
               ,@SYSDATETIME    --MailDateTime
               ,@StaffCD
               ,1   --ContactKBN
               ,(SELECT top 1 A.MoveMailPatternCD FROM M_Store AS A
                  WHERE A.StoreCD = @ToStoreCD AND A.DeleteFlg = 0 
                  AND A.ChangeDate <= @RequestDate
                  ORDER BY A.ChangeDate desc)  
               ,(SELECT top 1 B.MailSubject 
                    FROM M_Store AS A
                    INNER JOIN M_MailPattern AS B
                    ON B.MailPatternCD = A.MoveMailPatternCD
                  WHERE A.StoreCD = @ToStoreCD AND A.DeleteFlg = 0 
                  AND A.ChangeDate <= @RequestDate
                  ORDER BY A.ChangeDate desc)   --MailSubject
               ,(SELECT top 1 B.MailPriority 
                    FROM M_Store AS A
                    INNER JOIN M_MailPattern AS B
                    ON B.MailPatternCD = A.MoveMailPatternCD
                  WHERE A.StoreCD = @ToStoreCD AND A.DeleteFlg = 0 
                  AND A.ChangeDate <= @RequestDate
                  ORDER BY A.ChangeDate desc)   --MailPriority
               ,0   --ReMailFlg
               ,2   --UnitKBN
               ,NULL    --SendedDateTime
               ,1   --SenderKBN
               ,(SELECT A.SenderCD FROM M_MailServer A WHERE A.SenderKBN = 1)   --SenderCD
               ,(SELECT A.SenderAddress FROM M_MailServer A WHERE A.SenderKBN = 1)  --SenderAddress
               ,(SELECT top 1 B.MailText 
                    FROM M_Store AS A
                    INNER JOIN M_MailPattern AS B
                    ON B.MailPatternCD = A.MoveMailPatternCD
                  WHERE A.StoreCD = @ToStoreCD AND A.DeleteFlg = 0 
                  AND A.ChangeDate <= @RequestDate
                  ORDER BY A.ChangeDate desc)   --MailContent

               ,@Operator  
               ,@SYSDATETIME
               ,@Operator  
               ,@SYSDATETIME
               );

            --【D_MailAddress】メール連絡宛先　Table転送仕様Ｄ
            SET @MailCounter = (SELECT MAX(A.MailCounter) FROM D_Mail AS A WHERE A.[Number] = @RequestNO);
            SET @Rows = 1;
            
            --明細数分Insert★
            --カーソルオープン
            OPEN CUR_Store;

            --最初の1行目を取得して変数へ値をセット
            FETCH NEXT FROM CUR_Store
            INTO @MailAddress1, @MailAddress2, @MailAddress3;
            
            --データの行数分ループ処理を実行する
            WHILE @@FETCH_STATUS = 0
            BEGIN
                -- ========= ループ内の実際の処理 ここから===
                IF ISNULL(@MailAddress1,'') <> ''
                BEGIN
                    EXEC INSERT_UPDATE_D_MailAddress
                         1  --@KBN ,
                         ,@MailAddress1
                         ,@Rows
                         ,@MailCounter
                        ;
                    
                    SET @Rows = @Rows + 1;
                END
                IF ISNULL(@MailAddress2,'') <> ''
                BEGIN
                    EXEC INSERT_UPDATE_D_MailAddress
                         1  --@KBN ,
                         ,@MailAddress2
                         ,@Rows
                         ,@MailCounter 
                        ;
                    
                    SET @Rows = @Rows + 1;
                END
                IF ISNULL(@MailAddress3,'') <> ''
                BEGIN
                    EXEC INSERT_UPDATE_D_MailAddress
                         1  --@KBN ,
                         ,@MailAddress3
                         ,@Rows
                         ,@MailCounter
                        ;
                END
                --次の行のデータを取得して変数へ値をセット
                FETCH NEXT FROM CUR_Store
                INTO @MailAddress1, @MailAddress2, @MailAddress3;
            END            --LOOPの終わり
            
            --カーソルを閉じる
            CLOSE CUR_Store;
            DEALLOCATE CUR_Store;
		END
    END
    
    --変更--
    ELSE IF @OperateMode = 2
    BEGIN
        SET @OperateModeNm = '変更';
        
        --【D_MoveRequest】在庫移動依頼　Table転送仕様Ａ
        UPDATE [D_MoveRequest]
           SET [StoreCD] = @StoreCD                         
              ,[RequestDate] = convert(date,@RequestDate)
              ,[MovePurposeKBN] = @MovePurposeKBN
              ,[FromStoreCD] = @FromStoreCD
              ,[FromSoukoCD] = @FromSoukoCD
              ,[ToStoreCD] = @ToStoreCD
              ,[ToSoukoCD] = @ToSoukoCD
              ,[StaffCD]         = @StaffCD  
              ,[UpdateOperator]     =  @Operator  
              ,[UpdateDateTime]     =  @SYSDATETIME
         WHERE RequestNO = @RequestNO
           ;

        --【D_MoveRequestDetailes】在庫移動依頼明細　Table転送仕様Ｂ�@
        UPDATE [D_MoveRequestDetailes]
           SET  [SKUCD]          = tbl.SKUCD
               ,[AdminNO]        = tbl.AdminNO
               ,[JanCD]          = tbl.JanCD
               ,[RequestSu]      = tbl.RequestSu
               ,[ExpectedDate]   = tbl.ExpectedDate
               ,[CommentInStore]   = tbl.CommentInStore    
               ,[UpdateOperator]   =  @Operator  
               ,[UpdateDateTime]   =  @SYSDATETIME
        FROM D_MoveRequestDetailes
        INNER JOIN @Table tbl
         ON @RequestNO = D_MoveRequestDetailes.RequestNO
         AND tbl.RequestRows = D_MoveRequestDetailes.RequestRows
         AND tbl.UpdateFlg = 1
         ;

        --削除行
        --【D_MoveRequestDetailes】在庫移動依頼明細　Table転送仕様Ｂ�@
        UPDATE [D_MoveRequestDetailes]
            SET [DeleteOperator]     =  @Operator  
               ,[DeleteDateTime]     =  @SYSDATETIME
        FROM D_MoveRequestDetailes
        INNER JOIN @Table tbl
         ON @RequestNO = D_MoveRequestDetailes.RequestNO
         AND tbl.RequestRows = D_MoveRequestDetailes.RequestRows
         AND tbl.UpdateFlg = 2
         ;
        
        --MailFlg = 1の場合
        IF @MailFlg = 1
        BEGIN
            --【D_Mail】メール連絡内容　Table転送仕様Ｃ
            UPDATE [D_Mail]
            SET [MailType] = 9
               ,[MailKBN] = 51
               ,[Number] = @RequestNO
              -- ,[MailNORows] = (SELECT MAX(A.MailNORows) FROM D_Mail AS A WHERE A.[Number] = @RequestNO) + 1
               ,[MailDateTime] = @SYSDATETIME
               ,[StaffCD] = @StaffCD
               ,[ContactKBN] = 1
               ,[MailPatternCD] = (SELECT top 1 A.MoveMailPatternCD FROM M_Store AS A
                                  WHERE A.StoreCD = @ToStoreCD AND A.DeleteFlg = 0 
                                  AND A.ChangeDate <= @RequestDate
                                  ORDER BY A.ChangeDate desc) 
               ,[MailSubject] = (SELECT top 1 B.MailSubject 
                                FROM M_Store AS A
                                INNER JOIN M_MailPattern AS B
                                ON B.MailPatternCD = A.MoveMailPatternCD
                              WHERE A.StoreCD = @ToStoreCD AND A.DeleteFlg = 0 
                              AND A.ChangeDate <= @RequestDate
                              ORDER BY A.ChangeDate desc)
               ,[MailPriority] = (SELECT top 1 B.MailPriority 
                                FROM M_Store AS A
                                INNER JOIN M_MailPattern AS B
                                ON B.MailPatternCD = A.MoveMailPatternCD
                              WHERE A.StoreCD = @ToStoreCD AND A.DeleteFlg = 0 
                              AND A.ChangeDate <= @RequestDate
                              ORDER BY A.ChangeDate desc)
               ,[ReMailFlg] = 1
               ,[UnitKBN] = 2
               ,[SendedDateTime] = NULL
               ,[SenderKBN] = 1
               ,[SenderCD] = (SELECT A.SenderCD FROM M_MailServer A WHERE A.SenderKBN = 1)
               ,[SenderAddress] = (SELECT A.SenderAddress FROM M_MailServer A WHERE A.SenderKBN = 1)
               ,[MailContent] = (SELECT top 1 B.MailText 
                                FROM M_Store AS A
                                INNER JOIN M_MailPattern AS B
                                ON B.MailPatternCD = A.MoveMailPatternCD
                              WHERE A.StoreCD = @ToStoreCD AND A.DeleteFlg = 0 
                              AND A.ChangeDate <= @RequestDate
                              ORDER BY A.ChangeDate desc)
               ,[UpdateOperator]   =  @Operator  
               ,[UpdateDateTime]   =  @SYSDATETIME
            WHERE [Number] = @RequestNO
            AND MailCounter = (SELECT MAX(A.MailCounter) FROM D_Mail AS A WHERE A.[Number] = @RequestNO)
           -- AND MailNORows = (SELECT MAX(A.MailNORows) FROM D_Mail AS A WHERE A.[Number] = @RequestNO)
            ;

            --【D_MailAddress】メール連絡宛先　Table転送仕様Ｄ
            SET @MailCounter = (SELECT MAX(A.MailCounter) FROM D_Mail AS A WHERE A.[Number] = @RequestNO);
            
            SET @Rows = 1;
            
            --明細数分Insert★
            --カーソルオープン
            OPEN CUR_Store;

            --最初の1行目を取得して変数へ値をセット
            FETCH NEXT FROM CUR_Store
            INTO @MailAddress1, @MailAddress2, @MailAddress3;
            
            --データの行数分ループ処理を実行する
            WHILE @@FETCH_STATUS = 0
            BEGIN
                -- ========= ループ内の実際の処理 ここから===
                IF ISNULL(@MailAddress1,'') <> ''
                BEGIN
                    EXEC INSERT_UPDATE_D_MailAddress
                         2  --@KBN ,
                         ,@MailAddress1
                         ,@Rows
                         ,@MailCounter
                        ;
                    
                    SET @Rows = @Rows + 1;
                END
                IF ISNULL(@MailAddress2,'') <> ''
                BEGIN
                    EXEC INSERT_UPDATE_D_MailAddress
                         2  --@KBN ,
                         ,@MailAddress2
                         ,@Rows
                         ,@MailCounter 
                        ;
                    
                    SET @Rows = @Rows + 1;
                END
                IF ISNULL(@MailAddress3,'') <> ''
                BEGIN
                    EXEC INSERT_UPDATE_D_MailAddress
                         2  --@KBN ,
                         ,@MailAddress3
                         ,@Rows
                         ,@MailCounter
                        ;
                END
                --次の行のデータを取得して変数へ値をセット
                FETCH NEXT FROM CUR_Store
                INTO @MailAddress1, @MailAddress2, @MailAddress3;
            END            --LOOPの終わり
            
            --カーソルを閉じる
            CLOSE CUR_Store;
            DEALLOCATE CUR_Store;
		END
    END    
  
    ELSE IF @OperateMode = 3 --削除--
    BEGIN
        SET @OperateModeNm = '削除';

        --【D_MoveRequest】移動　テーブル転送仕様A�A
        UPDATE [D_MoveRequest]
            SET [UpdateOperator]     =  @Operator  
               ,[UpdateDateTime]     =  @SYSDATETIME
               ,[DeleteOperator]     =  @Operator  
               ,[DeleteDateTime]     =  @SYSDATETIME
         WHERE [RequestNO] = @RequestNO
         ;
             
        --【D_MoveRequestDetailes】移動明細　Table転送仕様Ｂ�A
        UPDATE [D_MoveRequestDetailes]
            SET [DeleteOperator]     =  @Operator  
               ,[DeleteDateTime]     =  @SYSDATETIME
         WHERE [RequestNO] = @RequestNO
         AND [DeleteDateTime] IS NULL
         ;
    END
    
    --処理履歴データへ更新
    SET @KeyItem = @RequestNO;
        
    EXEC L_Log_Insert_SP
        @SYSDATETIME,
        @Operator,
        @Program,
        @PC,
        @OperateModeNm,
        @KeyItem;

    SET @OutRequestNO = @RequestNO;
    
--<<OWARI>>
  return @W_ERR;

END

GO

BEGIN TRY 
 Drop PROCEDURE dbo.[INSERT_UPDATE_D_MailAddress]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [INSERT_UPDATE_D_MailAddress]
(
    @KBN tinyint,
    @MailAddress  varchar(100),
    @Rows int,
    @MailCounter  int
)AS
--********************************************--
--                                            --
--                 処理開始                   --
--                                            --
--********************************************--

BEGIN

    IF @KBN = 1
    BEGIN
        --【D_MailAddress】メール連絡宛先　Table転送仕様Ｄ
        INSERT INTO [D_MailAddress]
           ([MailCounter]
           ,[AddressRows]
           ,[AddressKBN]
           ,[Address])
        VALUES(
            @MailCounter
           ,@Rows   --AddressRows
           ,1   --AddressKBN
           ,@MailAddress  --Address
           );
    END
    
    ELSE IF @KBN = 2
    BEGIN
        UPDATE [D_MailAddress]
        SET [AddressKBN] = 1
           ,[Address] = @MailAddress
        WHERE MailCounter = @MailCounter
        AND AddressRows = @Rows
        ;  
    END

END


GO