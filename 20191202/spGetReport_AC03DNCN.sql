GO
/****** Object:  StoredProcedure [dbo].[spGetReport_AC03DNCN]    Script Date: 12/2/2019 4:06:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author	  :	Nusantara Secom InfoTech
-- Create date: 2019
-- Description:	spGetReport_AC03DNCN
-- =============================================
ALTER PROCEDURE [dbo].[spGetReport_AC03DNCN]
	-- Add the parameters for the stored procedure here
	@InvoiceNo varchar(10),
	@ModUserId varchar(8),  
    @ModPrgId varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE ACT_DNCN SET PrintedCount = ISNULL(PrintedCount,0) + 1, ModUserID = @ModUserId, ModPCID = HOST_NAME(), ModPrgID=@ModPrgId, ModTimestamp=GETDATE() WHERE InvoiceNo = @InvoiceNo;

    -- Insert statements for procedure here
	SELECT a.InvoiceNo,
			FPNo,
			InvoiceDate
			,a.CustomerCode
			,a.CustomerName
			,SupplierrCode
			,SupplierrName
			,a.CustomerSection
			,a.Address1
			,a.Address2
			,a.Address3
			,a.Address4
			,a.City
			,a.Province
			,a.PostalCode
			,a.Contact
			,BankAcct
			,BankName
			,BankAddress
			,InvoiceAmount
			,VAT
			,TotalAmount,
			look.Dummy1,
			PrintedCount,
			a.CurrencyCode,
			b.InvDesc as Description,
			b.InvAmount as Amount
			,c.IncludeTaxFlag,d.DecimalPointAmount,a.INVDNCNFlag
			FROM ACT_DNCN a
			JOIN MST_Lookup_Detail look ON look.TableID='MST_Approver' AND look.Dummy2='INVOICE' AND look.Name='APPROVED BY'
			JOIN ACT_DNCN_Detail b on a.InvoiceNo=b.InvoiceNo 
			LEFT JOIN MST_Customer c ON a.CustomerCode=c.CustomerCode
			LEFT JOIN MST_Currency d ON a.CurrencyCode=d.CurrencyCode
			WHERE b.Status='Y' and a.InvoiceNo =@InvoiceNo
END
