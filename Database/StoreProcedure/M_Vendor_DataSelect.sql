 BEGIN TRY 
 Drop Procedure dbo.[M_Vendor_DataSelect]
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
CREATE PROCEDURE [dbo].[M_Vendor_DataSelect]
	-- Add the parameters for the stored procedure here
	@VendorCD as varchar(13), 
	@ChangeDate as date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select * 
	From F_Vendor(cast(@ChangeDate as varchar(10))) mv
	Where mv.VendorCD = @VendorCD
	and mv.DeleteFlg = '0'
	and mv.VendorFlg = '1'
END
