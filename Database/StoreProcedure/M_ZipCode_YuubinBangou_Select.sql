 BEGIN TRY 
 Drop Procedure [dbo].[M_ZipCode_YuubinBangou_Select]
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
CREATE PROCEDURE [dbo].[M_ZipCode_YuubinBangou_Select]
	-- Add the parameters for the stored procedure here
	@Zip1From varchar(3) ,
	@Zip1To varchar(3) ,
	@Zip2From varchar(4) ,
	@Zip2To varchar(4) 
	--@mode int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
		SELECT  
		Top 1000
		zip.ZipCD1,
		zip.ZipCD2,
		zip.Address1,
		zip.Address2,
		carrier.CarrierName,
		zip.CarrierCD,
		zip.CarrierLeadDay
		FROM M_ZipCode zip
		LEFT JOIN F_Carrier(getdate()) carrier ON carrier.CarrierCD = zip.CarrierCD 
		WHERE zip.ZipCD1 + zip.ZipCD2 >= @Zip1From + @Zip2From
		AND zip.ZipCD1 + zip.ZipCD2 <= @Zip1To + @Zip2To 
		--WHERE (@Zip1From IS NULL OR ( ZipCD1 >= @Zip1From ))
		--AND (@Zip1To IS NULL OR( ZipCD1 <= @Zip1To ))
		--AND (@Zip2From IS NULL OR ( ZipCD2 >= @Zip2From ))
		--AND (@Zip2To IS NULL OR ( ZipCD2 <= @Zip2To ))
		Order By ZipCD1, ZipCD2 ASC
	
END

GO
