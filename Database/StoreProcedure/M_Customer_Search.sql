 BEGIN TRY 
 Drop Procedure dbo.[M_Customer_Search]
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
CREATE PROCEDURE[dbo].[M_Customer_Search]
	-- Add the parameters for the stored procedure here
@RefDate as date,
--@KeyWordType as tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
    -- Insert statements for procedure here

ORDER BY fc.CustomerCD
--ORDER BY fc.CustomerCD

END
