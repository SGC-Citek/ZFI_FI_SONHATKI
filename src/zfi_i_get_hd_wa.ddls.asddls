@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'lấy hóa đơn cho ctu WA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_GET_HD_WA as select from I_JournalEntryItem as Item
    left outer join I_BillingDocument as bil on bil.DocumentReferenceID <> Item.DocumentItemText
{
    key Item.AccountingDocument,
    key Item.FiscalYear,
    key Item.CompanyCode,
    key Item.LedgerGLLineItem,
    Item.DocumentItemText as DocumentRef
}where Item.AccountingDocumentType = 'WA'
