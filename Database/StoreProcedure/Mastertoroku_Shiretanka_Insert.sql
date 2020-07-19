BEGIN TRY 
 Drop Procedure [dbo].[Mastertoroku_Shiretanka_Insert]
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
Create PROCEDURE [dbo].[Mastertoroku_Shiretanka_Insert]
	
	@tbsku as Xml,
	@tbitem as Xml,
	@vendorcd as varchar(13),
	@storecd as varchar(4)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @date as datetime=getdate()



	DECLARE @DocHandle int	
	EXEC sp_xml_preparedocument @DocHandle OUTPUT, @tbitem

	 SELECT *
	  Into #tmpit
	  FROM OPENXML (@DocHandle, '/NewDataSet/test',3)
	WITH(
	--VendorCD VARCHAR(13),
	--StoreCD VARCHAR(4),
	MakerItem VARCHAR(30),
	ChangeDate date,
	Rate decimal,
	PriceWithoutTax money
	)

	EXEC sp_xml_removedocument @DocHandle; 


	

	 Delete
	   from M_ItemOrderPrice
	 where VendorCD=@vendorCD
	 and StoreCD=@storeCD
	 ----and MakerITem In (Select MakerItem from #tmpitem)
	 --and ChangeDate IN (
	 --Select ChangeDate from  #tmpit
	 --)
	 
	Insert 
	Into M_ItemOrderPrice
	(
	Vendorcd,
	StoreCD,
	MakerItem,
	ChangeDate,
	Rate,
	PriceWithoutTax,
	DeleteFlg,
	UsedFlg,
	InsertOperator,
	InsertDateTime,
	UpdateOperator,
	UpdateDateTime

	)
	Select
	@vendorcd,
	@storecd,
	MakerItem,
	ChangeDate,
	Rate,
	PriceWithoutTax,
	0,
	0,
	'0001',
	getdate(),
	'pc',
	getdate()
	
	From #tmpit
	

	DECLARE @Docsku int	
	EXEC sp_xml_preparedocument @Docsku OUTPUT, @tbsku
	 SELECT * 
	 into #tmpsk
	 FROM OPENXML (@Docsku, '/NewDataSet/test',3)
	WITH(
	--VendorCD VARCHAR(13),
	--StoreCD VARCHAR(4),
	AdminNO int,
	SKUCD varchar(40),
	CheckBox  Varchar,
	SizeName Varchar(20),
	ColorName Varchar(20),
	ItemCD Varchar(30),
	MakerItem VARCHAR(30),
	Rate decimal,
	ChangeDate date,
	PriceOutTax money,
	PriceWithoutTax money
	)
	EXEC sp_xml_removedocument @Docsku; 


	
	Delete   from  M_JanOrderPrice
	 where VendorCD=@vendorCD 
	 and StoreCD=@storecd 
	------and AdminNO= (Select AdminNO from #tmpsku) 
	--and ChangeDate In  (Select ChangeDate from #tmpsk)
	

	Insert 
	Into M_JanOrderPrice
	(
	Vendorcd,
	StoreCD,
	AdminNO,
	ChangeDate,
	SKUCD,
	Rate,
	PriceWithoutTax,
	Remarks,
	DeleteFlg,
	UsedFlg,
	InsertOperator,
	InsertDateTime,
	UpdateOperator,
	UpdateDateTime
	)
	Select
	@vendorcd,
	@storecd,
	'0',
	'2020-07-01',
	NUll,
	0.00,
	1000.00,
	NUll,
	0,
	0,
	'0001',
	getdate(),
	'pc',
	getdate()


	From #tmpsk


drop Table #tmpsk
drop Table #tmpi


END


