USE [SMSLocal]
GO
/****** Object:  StoredProcedure [dbo].[M_SKU_SelectFor_SKU_Update]    Script Date: 2020/06/29 10:57:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Alter PROCEDURE [dbo].[M_SKU_SelectFor_SKU_Update]
	-- Add the parameters for the stored procedure here
	@datatb as Xml
	AS
BEGIN
	
	SET NOCOUNT ON;
	Declare @date as date=getdate()
  
	if @type =1  -- for copy
   begin
	DECLARE @DocHandle int	
	EXEC sp_xml_preparedocument @DocHandle OUTPUT, @skutb
	--INSERT INTO #tmp
	 SELECT * 
	 into #tmpitem1
	 FROM OPENXML (@DocHandle, '/NewDataSet/test',3)
	WITH(
	--VendorCD VARCHAR(13),
	--StoreCD VARCHAR(4),
	CheckBox  Varchar,

	ItemCD Varchar(30),
	MakerItem VARCHAR(30),
	ChangeDate date,
	PriceOutTax money,
	PriceWithoutTax money
	)
	EXEC sp_xml_removedocument @DocHandle; 
		Select 
			tm.ItemCD
			,
			ts.AdminNO,
			ts.SKUCD,
			ts.SizeName,
			ts.ColorName,
			ts.MakerItem,
			ts.BrandCD,
			ts.SportsCD,
			ts.SegmentCD,
			ts.LastYearTerm,
			ts.LastSeason,
			tm.PriceOutTax,
			ts.ChangeDate,
			ts.Rate,
			tm.PriceWithoutTax,
			tm.CheckBox
		from #tmpitem1 as tm
		inner join F_SKU(@date1) as ts
		on tm.ItemCD=ts.ItemCD
		and DeleteFlg=0
		where tm.CheckBox=1
  drop Table #tmpitem1
  end  

   if @type =2  
   --for update
   begin
	
	DECLARE @Docitem int	
	EXEC sp_xml_preparedocument @Docitem OUTPUT, @itemtb
	--INSERT INTO #tmp
	 SELECT * 
	 into #tmitem
	 FROM OPENXML (@Docitem, '/NewDataSet/test',3)
	WITH(
	--VendorCD VARCHAR(13),
	--StoreCD VARCHAR(4),
	CheckBox  Varchar,
	LastYearTerm varchar(6),
	LastSeason varchar(6),
	BrandCD varchar(6),
	SportsCD varchar(6),
	SegmentCD varchar(6),
	ItemCD Varchar(30),
	MakerItem VARCHAR(30),
	Rate decimal,
	ChangeDate date,
	PriceOutTax money,
	PriceWithoutTax money
	)
	EXEC sp_xml_removedocument @Docitem; 



	DECLARE @Docsku int	
	EXEC sp_xml_preparedocument @Docsku OUTPUT, @skutb
	--INSERT INTO #tmp
	 SELECT * 
	 into #tmsku
	 FROM OPENXML (@Docsku, '/NewDataSet/test',3)
	WITH(
	--VendorCD VARCHAR(13),
	--StoreCD VARCHAR(4),
	AdminNo int,
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
		
		Select  
			tm.ItemCD,
			ts.AdminNO
			,
			ts.SKUCD,
			ts.SizeName,
			ts.ColorName,
			ts.MakerItem,
			tm.BrandCD,
			tm.SportsCD
			,
			tm.SegmentCD,
			tm.LastYearTerm
			,
			tm.LastSeason,
			tm.PriceOutTax,
			ts.ChangeDate,
			tm.Rate,
			tm.PriceWithoutTax,
			tm.CheckBox
		from #tmitem as tm
		inner join #tmsku as ts
		on tm.ItemCD=ts.ItemCD
		and ts.ChangeDate <= '2020-07-01'
		where tm.CheckBox=1
  drop Table #tmpitem
   drop Table #tmsku
  end


END
