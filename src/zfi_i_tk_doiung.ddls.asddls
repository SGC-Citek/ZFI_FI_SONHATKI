@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tài khoản đối ứng'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_TK_DOIUNG 
 as select from I_JournalEntryItem as JEI_TKDOIUNG
    left outer  join I_JournalEntryItem    as JEI    on JEI.SourceLedger                = JEI_TKDOIUNG.SourceLedger
                                          			and JEI.CompanyCode                 = JEI_TKDOIUNG.CompanyCode
                                          			and JEI.FiscalYear                  = JEI_TKDOIUNG.FiscalYear
                                          			and JEI.AccountingDocument          = JEI_TKDOIUNG.AccountingDocument
                                          			and JEI.LedgerGLLineItem            = JEI_TKDOIUNG.OffsettingAccount
                                          			and JEI.Ledger                      = JEI_TKDOIUNG.Ledger
    left outer  join I_CostCenterText as _CostCenterTxt            on JEI_TKDOIUNG.ControllingArea = _CostCenterTxt.ControllingArea
                                                                  and JEI_TKDOIUNG.CostCenter      = _CostCenterTxt.CostCenter
                                                                  and _CostCenterTxt.Language      = 'E'
    left outer  join I_ProfitCenterText as _ProfitCenterText      on  JEI_TKDOIUNG.ControllingArea    = _ProfitCenterText.ControllingArea
                                                                  and JEI_TKDOIUNG.ProfitCenter       = _ProfitCenterText.ProfitCenter
                                                                  and _ProfitCenterText.Language      = 'E'
{
    key JEI_TKDOIUNG.SourceLedger,
    key JEI_TKDOIUNG.CompanyCode,
    key JEI_TKDOIUNG.FiscalYear,
    key JEI_TKDOIUNG.AccountingDocument,
    key JEI_TKDOIUNG.LedgerGLLineItem,
    key JEI_TKDOIUNG.Ledger,
    JEI_TKDOIUNG.GLAccount,
    JEI_TKDOIUNG.OffsettingAccount,
    JEI_TKDOIUNG.TransactionCurrency,
    JEI_TKDOIUNG.CompanyCodeCurrency,
    JEI_TKDOIUNG.DebitCreditCode,
    JEI_TKDOIUNG.AccountingDocumentType,
    JEI_TKDOIUNG.ReferenceDocument,
    JEI_TKDOIUNG.FinancialAccountType,
    JEI_TKDOIUNG.DocumentItemText,
    JEI_TKDOIUNG.AccountingDocumentItem,
    JEI_TKDOIUNG.PurchasingDocument,
    JEI_TKDOIUNG.PurchasingDocumentItem,
    JEI_TKDOIUNG.Product,
    JEI_TKDOIUNG.SalesDocument,
    JEI_TKDOIUNG.SalesDocumentItem,
    JEI_TKDOIUNG.CostCenter,
    JEI_TKDOIUNG.PostingDate,
    JEI_TKDOIUNG.ControllingArea,
    JEI_TKDOIUNG.ProfitCenter,
    
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    JEI_TKDOIUNG.AmountInTransactionCurrency,
    
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    JEI_TKDOIUNG.AmountInCompanyCodeCurrency,
    
//    JEI.LedgerGLLineItem as Loai,
    
    _CostCenterTxt.CostCenterName,
    _ProfitCenterText.ProfitCenterName
    
}
where JEI.LedgerGLLineItem  is null
