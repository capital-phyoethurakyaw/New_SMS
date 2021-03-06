BEGIN TRY 
 Drop Procedure [dbo].[MastertorokuShiiretanka_Select]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




Create PROCEDURE [dbo].[MastertorokuShiiretanka_Select]
	-- Add the parameters for the stored procedure here
	@vendorcd as varchar(13),
	@storecd as varchar(4),
	@changedate as date,
	@display as int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	declare @date as date=getdate()
		
			if @display=0
		begin
		select 
					1 as 'TempKey',
					0 as 'CheckBox',
					fio.VendorCD,
					fio.StoreCD,
					fio.MakerItem,
					fi.BrandCD,
					 (
						Select BrandName   
						from M_Brand as mb
						where mb.BrandCD=fi.BrandCD
					 ) as BrandName,
					 fi.SportsCD,
					 (
						Select Char1   
						from M_Multiporpose as mp
						where mp.ID=202
						and mp.[Key]=fi.SportsCD
					 ) as Char1,
					 fi.SegmentCD,
					 (
						Select Char1   
						from M_Multiporpose as mp
						where mp.ID=203
						and mp.[Key]=fi.SegmentCD
					 ) as SegmentCDName,
					 fi.LastYearTerm,
					 fi.LastSeason,
					 fi.ItemCD,
					 (
						Select    mi.ItemName
						from F_Item(@date) as mi
						where mi.ITemCD=fi.ITemCD
						--and fi.ChangeDate <= fi.ChangeDate
					 ) as ItemName,
					CONVERT(VARCHAR(10),fio.ChangeDate  , 111) as ChangeDate,
					fi.PriceOutTax,
					fio.Rate,
					fio.PriceWithoutTax,
					fio.InsertOperator,
					fio.InsertDateTime,
					fio.UpdateOperator,
					fio.UpdateDateTime
			
	from F_ItemOrderPrice(@date)  as fio
	left outer join F_Item(@date) as fi on fi.MakerItem =fio.MakerITem  
	where fio.VendorCD=@vendorCD
	and		fio.StoreCD=@storecd
	--and fio.ChangeDate <= @changedate
	
	 order by fio.VendorCD,
				fio.StoreCD,
				fi.BrandCD,
				fi.SportsCD,
				fi.SegmentCD,
				fi.LastYearTerm,
				fi.LastSeason,
				fio.MakerItem,
				fi.ItemCD,
				fio.ChangeDate
			
		end

		if @display=1
		begin
			select 
					1 as 'TempKey',
					0 as 'CheckBox',
					mj.VendorCD,
					mj.StoreCD
					,
					mj.AdminNO,
					mj.SKUCD,
					msku.MakerItem,
					 msku.ItemCD,
					 (
						Select    mi.ItemName
						from F_Item(@date) as mi
						where mi.ITemCD=msku.ITemCD
						--and mi.ChangeDate <= msku.ChangeDate
					 ) as ItemName,
					msku.SizeName,
					msku. ColorName,
					msku.BrandCD,
					msku.SportsCD,
					msku.SegmentCD,
					msku.LastYearTerm,
					msku.LastSeason,
					CONVERT(VARCHAR(10),mj.ChangeDate, 111) as ChangeDate,
					msku.PriceOutTax,
					mj.Rate,
					mj.PriceWithoutTax,
					mj.InsertOperator,
					mj.InsertDateTime,
					mj.UpdateOperator,
					mj.UpdateDateTime
				from M_JANOrderPrice as mj
				left outer join F_SKU(@date)as msku on msku.AdminNO=mj.AdminNO
				WHERE	
							
							 	mj.VendorCD=@vendorcd
							and		mj.StoreCD=@storecd
							--and	(@brandcd is Null or	msku.BrandCD=@brandcd)
							--and	(@sportcd is Null or	msku.SportsCD=@sportcd)
							--and	(@segmentcd is Null or	msku.SegmentCD=@segmentcd)
							--and	(@lastyearterm is Null or	msku.LastYearTerm=@lastyearterm)
							--and	(@lastseason is Null or	msku.LastSeason =@lastseason)
							--and	(@makeritem is Null or	msku.MakerItem=@makeritem)
							--and	 (@changedate is null  Or msku.ChangeDate=@changedate)   
							
							--and
							--case when @display=0  
							--then msku.ChangeDate 
							--end
							--<=
							--case when @heardate is not null
							--then @heardate
							--end
							
							--or
							
							--case when @display=1
							--then ti.ChangeDate 
							--end
							--=
							--case when @heardate is not null
							--then @heardate
							--end

							order by mj.VendorCD,
									 mj.StoreCD,
									 msku.BrandCD,
									 msku.SportsCD,
									 msku.SegmentCD,
									 msku.LastYearTerm,
									 msku.LastSeason,
									 msku.MakerItem,
									 msku.ITemCD,
									 msku.ChangeDate

		end









				-- select 
				--		MakerItem,
				--		 ItemCD,
				--		 (
				--			Select    ItemName
				--			from F_Item(@date) as mi
				--			where mi.ITemCD=ts.ITemCD
				--			and mi.ChangeDate <= ts.ChangeDate
				--		 ) as ItemName,
				--		 SizeName,
				--		 ColorName,
				--		 SKUCD,

				--		 ChangeDate,
				--		 PriceOutTax,
				--		 Rate,
				--		 PriceWithoutTax,
				--		 Rate,
				--		 TempKey
				--from	#Tmp_sku as ts
				
				--WHERE	
				--			VendorCD=@vendorcd								
				--			and	ts.StoreCD=@storecd
				--			and	(@brandcd is Null or	ts.BrandCD=@brandcd)
				--			and	(@sportcd is Null or	ts.SportsCD=@sportcd)
				--			and	(@segmentcd is Null or	ts.SegmentCD=@segmentcd)
				--			and	(@lastyearterm is Null or	ts.LastYearTerm=@lastyearterm)
				--			and	(@lastseason is Null or	ts.LastSeason =@lastseason)
				--			and	(@makeritem is Null or	ts.MakerItem=@makeritem)
				--			and
				--			case when @display=0  
				--			then ts.ChangeDate 
				--			end
				--			<=
				--			case when @heardate is not null
				--			then @heardate
				--			end
							
				--			or
							
				--			case when @display=1
				--			then ts.ChangeDate 
				--			end
				--			=
				--			case when @heardate is not null
				--			then @heardate
				--			end 
				--			order by ts.VendorCD,
				--					 ts.BrandCD,
				--					 ts.SportsCD,
				--					 ts.SegmentCD,
				--					 ts.LastYearTerm,
				--					 ts.LastSeason,
				--					 ts.MakerItem,
				--					 ts.ITemCD,
				--					 ts.ChangeDate

				

				--insert into  #Tmp_item
				--	 values(6,0,@vendorcd,@storecd,@itemcd,@makerItem,@brandcd,@sportcd,@segmentcd
				--	 ,@lastyearterm,@lastseason,@changedate,@rate,@priceouttax,@priceoutwithouttax,
				--	 @insertoperator,getdate(),@insertoperator,getdate())
				--	 select * from #Tmp_item;
				--drop table #Tmp_item
				--drop table #Tmp_sku

END
