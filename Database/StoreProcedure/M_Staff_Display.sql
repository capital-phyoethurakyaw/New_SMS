 BEGIN TRY 
 Drop Procedure [dbo].[M_Staff_Display]
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
CREATE PROCEDURE [dbo].[M_Staff_Display]
	-- Add the parameters for the stored procedure here
	@StaffCD varchar(10),
	@ChangeDate date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		staff.StaffName,
		staff.StaffKana,
		staff.StoreCD,
		store.StoreName,
		staff.BMNCD,
		MP.Char1,
		staff.MenuCD,
		menu.MenuName,
		staff.StoreMenuCD,
		menu.MenuName,
		staff.AuthorizationsCD,
		autho.AuthorizationsName,
		staff.StoreAuthorizationsCD,
		sautho.StoreAuthorizationsName,
		staff.PositionCD,
		MTP.Char1,
		staff.[Password],
		Convert(varchar(10),staff.JoinDate,111) AS JoinDate,
		Convert(varchar(10),staff.LeaveDate,111) As LeaveDate,
		staff.ReceiptPrint,
		staff.Remarks,
		staff.DeleteFlg
	FROM M_Staff staff LEFT JOIN
	F_Store(@ChangeDate) store ON store.StoreCD = staff.StoreCD LEFT JOIN
	M_Menu menu ON menu.MenuID = staff.MenuCD LEFT JOIN
	F_Authorizations(@ChangeDate) autho ON autho.AuthorizationsCD = staff.AuthorizationsCD LEFT JOIN
	F_StoreAuthorizations(@ChangeDate) sautho ON sautho.StoreAuthorizationsCD = staff.StoreAuthorizationsCD LEFT JOIN
	M_MultiPorpose MP ON staff.BMNCD = MP.[Key] AND MP.ID = '209' LEFT JOIN
	M_MultiPorpose MTP ON staff.PositionCD = MTP.[Key] AND MTP.ID= '214'

WHERE staff.ChangeDate =@ChangeDate
AND staff.StaffCD = @StaffCD

END



GO
