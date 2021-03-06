
/****** Object:  StoredProcedure [dbo].[M_Souko_BindForTanaoroshi]    Script Date: 6/11/2019 2:21:19 PM ******/
DROP PROCEDURE [dbo].[M_Souko_BindForTanaoroshi]
GO

/****** Object:  StoredProcedure [dbo].[M_Souko_BindForTanaoroshi]    Script Date: 6/11/2019 2:21:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[M_Souko_BindForTanaoroshi]
    -- Add the parameters for the stored procedure here
    @StoreCD as varchar(4),
    @ChangeDate as varchar(10)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT FS.SoukoCD,FS.SoukoName 
    FROM F_Souko(@ChangeDate) AS FS 
    WHERE FS.StoreCD = @StoreCD
    AND FS.DeleteFlg = 0
    ORDER BY FS.SoukoCD
END

GO


