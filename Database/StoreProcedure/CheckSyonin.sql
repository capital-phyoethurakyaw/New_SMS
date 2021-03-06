 BEGIN TRY 
 Drop Procedure dbo.[CheckSyonin]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CheckSyonin]
    (@OrderNO varchar(11),
    @Operator  varchar(10)
    )AS
    
--********************************************--
--                                            --
--                 処理開始                   --
--                                            --
--********************************************--

BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    DECLARE @ERRNO varchar(4);
    DECLARE @CNT int;
    
    SET @ERRNO = '';
    
    
    SELECT @CNT = COUNT(W.OrderNO)
    FROM
        (
        SELECT A.OrderNO
        	,MAX(A.UpdateOperator) AS UpdateOperator
            ,MAX(A.StoreCD) AS StoreCD
            ,MAX(B.ChangeDate) AS ChangeDate
        FROM D_Order A
        LEFT OUTER JOIN M_Store AS B 
        ON A.StoreCD = B.StoreCD
        AND B.ChangeDate <= A.OrderDate
        
        WHERE A.OrderNO = @OrderNO
        AND A.ApprovalStageFLG <= 9
        AND A.ApprovalStageFLG > 1
        AND A.DeleteDateTime IS NULL
        AND B.DeleteFlg = 0
        GROUP BY A.OrderNO
    )AS W
    LEFT OUTER JOIN M_Store AS B 
    ON W.StoreCD = B.StoreCD
    AND W.ChangeDate = B.ChangeDate
    
    WHERE ((W.UpdateOperator IN (B.ApprovalStaffCD21, B.ApprovalStaffCD22)
        AND @Operator IN (B.ApprovalStaffCD11, B.ApprovalStaffCD12)
        )
        OR
        (W.UpdateOperator IN (B.ApprovalStaffCD31, B.ApprovalStaffCD32)
        AND @Operator IN (B.ApprovalStaffCD11, B.ApprovalStaffCD12, B.ApprovalStaffCD21, B.ApprovalStaffCD22)
        ))
    ;

    IF @CNT > 0 
    BEGIN
        SET @ERRNO = 'E233';
        SELECT @ERRNO AS errno;
        RETURN;
    END;

    SELECT @ERRNO AS errno;
END


