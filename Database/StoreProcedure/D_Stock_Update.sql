 BEGIN TRY 
 Drop Procedure dbo.[D_Stock_Update]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[D_Stock_Update]
	-- Add the parameters for the stored procedure here
	@xml as xml,
	@Operator varchar(10),
	@InsertDateTime datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Insert 
	--Into D_Stock(RackNO ,UpdateOperator,UpdateDateTime)
	--Values (@RackNo ,@Operator ,@InsertDateTime)

	--UPDATE D_Stock
	--SET RackNO = @RackNo ,UpdateOperator = @Operator ,UpdateDateTime = @InsertDateTime
	--WHERE StockNO = @StockNo


	CREATE TABLE [dbo].[#tempStock]
			(
				[RackNo][varchar](11) collate Japanese_CI_AS,
				[StockNo][varchar](11) collate Japanese_CI_AS
			)

	declare @idoc  int

			exec sp_xml_preparedocument @idoc output, @xml
			insert into #tempStock
			SELECT *  FROM openxml(@idoc,'/NewDataSet/test',2)
			WITH
			(
				[RackNo][varchar](11) collate Japanese_CI_AS,
				[StockNo][varchar](11) collate Japanese_CI_AS
			)
			exec sp_xml_removedocument @idoc

	Update ds
	Set  RackNO =ts.RackNO,
	UpdateOperator = @Operator ,
	UpdateDateTime = @InsertDateTime
	From D_Stock as ds inner join #tempStock as ts on ds.StockNo=ts.StockNo



END

