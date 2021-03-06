 BEGIN TRY 
 Drop Procedure dbo.[M_Location_InsertUpdate]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[M_Location_InsertUpdate] 
	-- Add the parameters for the stored procedure here
	@xml as xml,
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

	Declare @InsertDateTime datetime=getdate()

	Exec dbo.D_Stock_Update @xml,@Operator,@InsertDateTime

	--Exec dbo.L_StockHistory_Insert @StockNo,@SoukoCD,@RackNo,@JanCD,@SKUCD,@StockSu,
	--@Operator,@InsertDateTime

	Exec dbo.L_StockHistory_Insert @Operator,@InsertDateTime

	Exec dbo.L_Log_Insert @Operator,@Program,@PC,@OperateMode,@KeyItem
    
	
END

