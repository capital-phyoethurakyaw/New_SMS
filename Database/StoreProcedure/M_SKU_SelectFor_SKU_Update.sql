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
  
	DECLARE @DocHandle int	
	EXEC sp_xml_preparedocument @DocHandle OUTPUT, @datatb
	--INSERT INTO #tmp
	 SELECT * 
	 into #tmpitem
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
		from #tmpitem as tm
		inner join F_SKU(@date) as ts
		on tm.ItemCD=ts.ItemCD
		and DeleteFlg=0
		where tm.CheckBox='1'
  drop Table #tmpitem
END
