 BEGIN TRY 
 Drop Procedure dbo.[GetJuchuuNO]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE GetJuchuuNO
    (@JuchuuProcessNO varchar(11)
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

    
    SELECT H.JuchuuNO FROM D_Juchuu AS H 
    WHERE H.JuchuuProcessNO = @JuchuuProcessNO
    AND H.DeleteDateTime IS NULL
    ORDER BY H.JuchuuNO
    ;

END

