BEGIN TRY 
 Drop Procedure [dbo].[M_ShiireKakeritsu_Select]
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
CREATE PROCEDURE [dbo].[M_ShiireKakeritsu_Select]
@VendorCD as varchar(13),
@StoreCD as varchar(4)
AS
BEGIN
	select 
	       '0' as Column1,
	        mo.VendorCD,
			mo.StoreCD,
			mo.BrandCD,
			 (
			   Select BrandName   
			   from M_Brand as mb
				where mb.BrandCD=mo.BrandCD
			) as BrandName,
			mo.SportsCD,
			(
			 Select Char1   
			from M_Multiporpose as mp
			where mp.ID=202
			and mp.[Key]=mo.SportsCD
			) as SportsName,
			mo.SegmentCD,
			(
			Select Char1   
			from M_Multiporpose as mp
			where mp.ID=203
			and mp.[Key]=mo.SegmentCD
			) as SegmentCDName,
			mo.LastYearTerm,
			mo.LastSeason,
			mo.ChangeDate,
			mo.Rate
			from M_OrderRate mo
	        where mo.VendorCD=@VendorCD
	        and mo.StoreCD=@StoreCD
	        Order by mo.VendorCD,mo.StoreCD,mo.ChangeDate,mo.BrandCD,mo.SportsCD,mo.SegmentCD,mo.LastYearTerm,mo.LastSeason 
END
