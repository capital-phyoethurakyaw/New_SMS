 BEGIN TRY 
 Drop Procedure dbo.[M_Souko_IsExists]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[M_Souko_IsExists]
	-- Add the parameters for the stored procedure here
	@SoukoCD varchar(13),
	@ChangeDate date,
	@DeleteFlg tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select ms.SoukoName, ms.StoreCD from
	F_Souko(cast(@ChangeDate as varchar(10))) ms
	where ms.SoukoCD = @SoukoCD
END

