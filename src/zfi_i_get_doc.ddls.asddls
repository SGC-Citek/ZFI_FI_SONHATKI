@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Get document'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_GET_DOC as select distinct from I_JournalEntryItem as Item
{
    key Item.AccountingDocument,
    key Item.CompanyCode,
    key Item.FiscalYear,
    key Item.LedgerGLLineItem,
    Item.GLAccount,
    Item.OffsettingAccount,
    Item.DebitCreditCode,
    Item.FinancialAccountType          
}where (Item.DebitCreditCode = 'H' or Item.DebitCreditCode = 'S') and (Item.FinancialAccountType <> 'D' or Item.FinancialAccountType <> 'K')
