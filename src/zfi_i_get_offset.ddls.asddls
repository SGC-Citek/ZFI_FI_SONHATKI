@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy offsetting account'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_GET_OFFSET as select  from  I_JournalEntryItem   as JournalItem 
//                inner join ZFI_I_GET_DOC as doc on doc.AccountingDocument = JournalItem.AccountingDocument
//                           and doc.CompanyCode = JournalItem.CompanyCode
//                           and doc.FiscalYear   = JournalItem.FiscalYear
//                           and doc.LedgerGLLineItem = JournalItem.LedgerGLLineItem
                                                             //and (doc.Customer = JournalItem.OffsettingAccount or doc.Supplier = JournalItem.OffsettingAccount)
                                                
{
    key JournalItem.AccountingDocument,
    key JournalItem.CompanyCode,
    key JournalItem.FiscalYear,
    key JournalItem.LedgerGLLineItem,
   JournalItem.GLAccount,
    JournalItem.Customer,
    JournalItem.Supplier
//    case when  JournalItem.OffsettingAccount = doc.Account
//        then doc.GLAccount //end as tk_doi_ung
//    else
//         JournalItem.OffsettingAccount end as tk_doi_ung
}

