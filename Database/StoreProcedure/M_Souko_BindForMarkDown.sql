BEGIN TRY 
 Drop Procedure dbo.[M_Souko_BindForMarkDown]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
Create PROCEDURE [dbo].[M_Souko_BindForMarkDown] 
    @StoreAuthorizationsCD as varchar(4)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT FS.SoukoCD, FS.SoukoName
      FROM F_Souko(getdate()) as FS
     WHERE FS.DeleteFlg=0
       AND EXISTS ( SELECT MS.StoreCD
                      FROM M_StoreAuthorizations MS
                     WHERE MS.StoreAuthorizationsCD = @StoreAuthorizationsCD
                       AND MS.ChangeDate <= GETDATE()
                       AND FS.StoreCD = MS.StoreCD
                   )
    ORDER BY FS.SoukoCD
     ;
END
