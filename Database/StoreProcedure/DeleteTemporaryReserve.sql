DROP  PROCEDURE [dbo].[DeleteTemporaryReserve]
GO


--  ======================================================================
--       Program Call    受注入力
--       Program ID      TempoJuchuuNyuuryoku
--       Create date:    2019.6.19
--    ======================================================================
CREATE PROCEDURE DeleteTemporaryReserve
    (@JuchuuNO   varchar(11)	--Tennicの場合はJuchuuProcessNOが格納されている
)AS

--********************************************--
--                                            --
--                 処理開始                   --
--                                            --
--********************************************--

BEGIN

    DECLARE @Tennic tinyint;
	
    SET @Tennic = (SeLECT M.Tennic FROM M_Control AS M WHERE M.MainKey = 1);
    
    --【TemporaryReserve】
    IF @Tennic = 1
    BEGIN
        DELETE FROM D_TemporaryReserve
        WHERE [Number] IN (SELECT H.JuchuuNO FROM D_Juchuu AS H 
                                            WHERE H.JuchuuProcessNO = @JuchuuNO)
        ;
    END
    ELSE
    BEGIN
        DELETE FROM D_TemporaryReserve
        WHERE [Number] = @JuchuuNO
        ;
    END
END

GO
