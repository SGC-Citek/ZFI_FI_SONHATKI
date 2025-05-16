@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'lấy mã đối tượng tương ứng với gl account'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_GET_CUS_BY_GL as select distinct from I_JournalEntryItem as item
{
    key item.AccountingDocument,
    key item.FiscalYear,
    key item.CompanyCode,
    key item.LedgerGLLineItem,
    key item.GLAccount,
    item.Customer,
    item._Customer.BPCustomerFullName as name6
}where item.Customer <> ''
