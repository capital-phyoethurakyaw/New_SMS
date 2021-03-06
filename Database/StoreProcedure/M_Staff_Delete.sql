 BEGIN TRY 
 Drop Procedure [dbo].[M_Staff_Delete]
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
CREATE PROCEDURE [dbo].[M_Staff_Delete]
	-- Add the parameters for the stored procedure here
	@StaffCD varchar(10),
	@ChangeDate date,
	@Operator varchar(10),
	@Program as varchar(30),
	@PC as varchar(30),
	@OperateMode as varchar(10),
	@KeyItem as varchar(100)
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Delete M_Staff 
	Where StaffCD = @StaffCD
	AND ChangeDate = @ChangeDate 

	exec dbo.L_Log_Insert @Operator,@Program,@PC,@OperateMode,@KeyItem
END

GO
