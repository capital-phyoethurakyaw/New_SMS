 BEGIN TRY 
 Drop Procedure dbo.[ImportYahooJuuChuu]
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
CREATE PROCEDURE [dbo].[ImportYahooJuuChuu]
	-- Add the parameters for the stored procedure here
@JuChuuXml as xml
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	CREATE TABLE [dbo].[#tempJuChuu]
			(		

StoreCD		varchar(4) collate Japanese_CI_AS,					
APIKey					tinyint,		
InportSEQRows					int,		
YahooOrderId						varchar(50) collate Japanese_CI_AS,	
ParentOrderId							varchar(50) collate Japanese_CI_AS,
ChildOrderId1							varchar(50) collate Japanese_CI_AS,
ChildOrderId2							varchar(50) collate Japanese_CI_AS,
DeviceType							tinyint,
MobileCarrierName							tinyint,
IsSeen							tinyint,
IsSplit							tinyint,
CancelReason							int,
CancelReasonDetail							varchar(200) collate Japanese_CI_AS,
IsRoyalty							tinyint,
IsRoyaltyFix							tinyint,
IsSeller							 tinyint,
IsAffiliate							tinyint,
IsRatingB2s							tinyint,
NeedSnl					tinyint,		
OrderTime						datetime,	
LastUpdateTime							datetime,
Suspect							tinyint,
SuspectMessage							varchar(99) collate Japanese_CI_AS,
OrderStatus							tinyint,
StoreStatus							tinyint,
RoyaltyFixTime							datetime,
SendConfirmTime							datetime,
SendPayTime							datetime,
PrintSlipTime							datetime,
PrintDeliveryTime							datetime,
PrintBillTime							datetime,
BuyerComments							varchar(750) collate Japanese_CI_AS,
SellerComments							varchar(750) collate Japanese_CI_AS,
Notes							varchar(8000) collate Japanese_CI_AS,
OperationUser					varchar(60) collate Japanese_CI_AS,		
Referer							varchar(500) collate Japanese_CI_AS,
EntryPoint							varchar(1000) collate Japanese_CI_AS,
HistoryId							varchar(3) collate Japanese_CI_AS,
UsageId							varchar(10) collate Japanese_CI_AS,
UseCouponData							varchar(8000) collate Japanese_CI_AS,
TotalCouponDiscount							money,
ShippingCouponFlg							tinyint,
ShippingCouponDiscount							money,
CampaignPoints							varchar(100) collate Japanese_CI_AS,
IsMultiShip							tinyint,
MultiShipId							varchar(42) collate Japanese_CI_AS,
IsReadOnly							tinyint,
PayStatus							tinyint,
SettleStatus							tinyint,
PayType							tinyint,
PayKind							tinyint,
PayMethod							varchar(11) collate Japanese_CI_AS,
PayMethodName							varchar(150) collate Japanese_CI_AS,
SellerHandlingCharge			money,				
PayActionTime							datetime,
PayDate							date,
PayNotes							varchar(1000) collate Japanese_CI_AS,
SettleId							varchar(38) collate Japanese_CI_AS,
CardBrand							varchar(300) collate Japanese_CI_AS,
CardNumber							varchar(20) collate Japanese_CI_AS,
CardNumberLast4					int,
CardExpireYear						varchar(4) collate Japanese_CI_AS,	
CardExpireMonth							varchar(2) collate Japanese_CI_AS,
CardPayType							tinyint,
CardHolderName							varchar(100) collate Japanese_CI_AS,
CardPayCount							int,
CardBirthDay							varchar(8) collate Japanese_CI_AS,
UseYahooCard							tinyint,
UseWallet							tinyint,
NeedBillSlip							tinyint,
NeedDetailedSlip							tinyint,
NeedReceipt							tinyint,
AgeConfirmField							varchar(30) collate Japanese_CI_AS,
AgeConfirmValue							int,
AgeConfirmCheck							tinyint,
BillAddressFrom							varchar(4) collate Japanese_CI_AS,
BillFirstName							varchar(100) collate Japanese_CI_AS,
BillFirstNameKana							varchar(100) collate Japanese_CI_AS,
BillLastName							varchar(100) collate Japanese_CI_AS,
BillLastNameKana							varchar(100) collate Japanese_CI_AS,
BillZipCode							varchar(10) collate Japanese_CI_AS,
BillPrefecture							varchar(12) collate Japanese_CI_AS,
BillPrefectureKana							varchar(18) collate Japanese_CI_AS,
BillCity							varchar(100) collate Japanese_CI_AS,
BillCityKana							varchar(100) collate Japanese_CI_AS,
BillAddress1							varchar(100) collate Japanese_CI_AS,
BillAddress1Kana							varchar(100) collate Japanese_CI_AS,
BillAddress2							varchar(100) collate Japanese_CI_AS,
BillAddress2Kana							varchar(100) collate Japanese_CI_AS,
BillPhoneNumber							varchar(14) collate Japanese_CI_AS,
BillEmgPhoneNumber							varchar(14) collate Japanese_CI_AS,
BillMailAddress							varchar(100) collate Japanese_CI_AS,
BillSection1Field							varchar(100) collate Japanese_CI_AS,
BillSection1Value							varchar(100) collate Japanese_CI_AS,
BillSection2Field							varchar(100) collate Japanese_CI_AS,
BillSection2Value							varchar(100) collate Japanese_CI_AS,
PayNo							varchar(20) collate Japanese_CI_AS,
PayNoIssueDate							datetime,
ConfirmNumber							varchar(20) collate Japanese_CI_AS,
PaymentTerm							datetime,
IsApplePay							tinyint,
PayCharge							money,
ShipCharge							money,
GiftWrapCharge							money,
Discount							money,
Adjustments							money,
SettleAmount							money,
UsePoint							money,
TotalPrice							money,
SettlePayAmount				money,
TaxRatio							money,
IsGetPointFixAll					tinyint,		
TotalMallCouponDiscount		money,	
SellerId							varchar(128) collate Japanese_CI_AS,
IsLogin							tinyint,
FspLicenseCode			varchar(4) collate Japanese_CI_AS,
FspLicenseName			varchar(15) collate Japanese_CI_AS,
GuestAuthId					varchar(20) collate Japanese_CI_AS,
CombinedPayType		tinyint,	
CombinedPayKind		tinyint,
CombinedPayMethod	varchar(11) collate Japanese_CI_AS,
PayMethodAmount		money,
CombinedPayMethodName		varchar(150) collate Japanese_CI_AS,			
CombinedPayMethodAmount	money,
OrderId varchar(20) collate Japanese_CI_AS
)

declare @DocHandle int;

	exec sp_xml_preparedocument @DocHandle output, @JuChuuXml
	insert into #tempJuChuu
	select *  FROM OPENXML (@DocHandle, '/NewDataSet/test',2)
			with
			(		

StoreCD		varchar(4),					
APIKey					tinyint,		
InportSEQRows					int,		
YahooOrderId						varchar(50),	
ParentOrderId							varchar(50),
ChildOrderId1							varchar(50),
ChildOrderId2							varchar(50),
DeviceType							tinyint,
MobileCarrierName							tinyint,
IsSeen							tinyint,
IsSplit							tinyint,
CancelReason							int,
CancelReasonDetail							varchar(200),
IsRoyalty							tinyint,
IsRoyaltyFix							tinyint,
IsSeller							 tinyint,
IsAffiliate							tinyint,
IsRatingB2s							tinyint,
NeedSnl					tinyint,		
OrderTime						datetime,	
LastUpdateTime							datetime,
Suspect							tinyint,
SuspectMessage							varchar(99),
OrderStatus							tinyint,
StoreStatus							tinyint,
RoyaltyFixTime							datetime,
SendConfirmTime							datetime,
SendPayTime							datetime,
PrintSlipTime							datetime,
PrintDeliveryTime							datetime,
PrintBillTime							datetime,
BuyerComments							varchar(750),
SellerComments							varchar(750),
Notes							varchar(8000),
OperationUser					varchar(60),		
Referer							varchar(500),
EntryPoint							varchar(1000),
HistoryId							varchar(3),
UsageId							varchar(10),
UseCouponData							varchar(8000),
TotalCouponDiscount							money,
ShippingCouponFlg							tinyint,
ShippingCouponDiscount							money,
CampaignPoints							varchar(100),
IsMultiShip							tinyint,
MultiShipId							varchar(42),
IsReadOnly							tinyint,
PayStatus							tinyint,
SettleStatus							tinyint,
PayType							tinyint,
PayKind							tinyint,
PayMethod							varchar(11),
PayMethodName							varchar(150),
SellerHandlingCharge			money,				
PayActionTime							datetime,
PayDate							date,
PayNotes							varchar(1000),
SettleId							varchar(38),
CardBrand							varchar(300),
CardNumber							varchar(20),
CardNumberLast4					int,
CardExpireYear						varchar(4),	
CardExpireMonth							varchar(2),
CardPayType							tinyint,
CardHolderName							varchar(100),
CardPayCount							int,
CardBirthDay							varchar(8),
UseYahooCard							tinyint,
UseWallet							tinyint,
NeedBillSlip							tinyint,
NeedDetailedSlip							tinyint,
NeedReceipt							tinyint,
AgeConfirmField							varchar(30),
AgeConfirmValue							int,
AgeConfirmCheck							tinyint,
BillAddressFrom							varchar(4),
BillFirstName							varchar(100),
BillFirstNameKana							varchar(100),
BillLastName							varchar(100),
BillLastNameKana							varchar(100),
BillZipCode							varchar(10),
BillPrefecture							varchar(12),
BillPrefectureKana							varchar(18),
BillCity							varchar(100),
BillCityKana							varchar(100),
BillAddress1							varchar(100),
BillAddress1Kana							varchar(100),
BillAddress2							varchar(100),
BillAddress2Kana							varchar(100),
BillPhoneNumber							varchar(14),
BillEmgPhoneNumber							varchar(14),
BillMailAddress							varchar(100),
BillSection1Field							varchar(100),
BillSection1Value							varchar(100),
BillSection2Field							varchar(100),
BillSection2Value							varchar(100),
PayNo							varchar(20),
PayNoIssueDate							datetime,
ConfirmNumber							varchar(20),
PaymentTerm							datetime,
IsApplePay							tinyint,
PayCharge							money,
ShipCharge							money,
GiftWrapCharge							money,
Discount							money,
Adjustments							money,
SettleAmount							money,
UsePoint							money,
TotalPrice							money,
SettlePayAmount							money,
TaxRatio							money,
IsGetPointFixAll					tinyint,		
TotalMallCouponDiscount						money,	
SellerId							varchar(128),
IsLogin							tinyint,
FspLicenseCode							varchar(4),
FspLicenseName							varchar(15),
GuestAuthId							varchar(20),
CombinedPayType						tinyint,	
CombinedPayKind							tinyint,
CombinedPayMethod				varchar(11),
PayMethodAmount							money,
CombinedPayMethodName				varchar(150),			
CombinedPayMethodAmount						money	,
OrderId varchar(20)
)

select * into #temp1 from #tempJuchuu order by StoreCD 

	Declare @val as int,
	@valList as int,
	@DateTime as Datetime  ;
	set @val = (select Max(IsNull(InportSEQ,0))+1 from  D_YahooJuchuu);

	if (@val is null)
	Begin
	set @val=1;
	End
	set @DateTime = getdate();
	Update #temp1 set YahooorderID=OrderId 
	Alter table #temp1 	Drop Column [OrderId]


	insert into D_YahooJuchuu select @val,*,Null,getdate(),Null,getdate() from #temp1


	Drop table #temp1
	Drop  table #tempJuchuu
END
