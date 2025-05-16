@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS lấy product'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_GET_PRODUCT
  as select distinct from I_JournalEntry as journal
    left outer join       I_JournalEntryItem       as Item on Item.AccountingDocument = journal.AccountingDocument
                                                           and Item.FiscalYear        = journal.FiscalYear
                                                           and Item.CompanyCode       = journal.CompanyCode
    left outer join       I_PurchaseOrderItemAPI01 as po   on  po.PurchaseOrder = Item.PurchasingDocument
                                                           and po.Material      = Item.Product


    left outer join      I_OutboundDeliveryItem   as odi  on  odi.OutboundDelivery = journal.DocumentReferenceID
                                                           and odi.Material         = Item.Product

    left outer join       I_BillingDocumentItem    as bdi  on  bdi.BillingDocument = Item.ReferenceDocument
                                                           and bdi.Product        = Item.Product
                                                           //and bdi.BillingDocumentItem = Item.LedgerGLLineItem

    left outer join      I_ProductText            as ptxt on  ptxt.Product  = Item.Product
                                                           and ptxt.Language = 'E'
{
  key journal.AccountingDocument,
  key journal.CompanyCode,
  key journal.FiscalYear,
  key Item.AccountingDocumentItem,
  Item.AccountingDocumentType,
  Item.Product as pro,
      case when Item.AccountingDocumentType = 'RE' or Item.AccountingDocumentType = 'WE'
            then po.PurchaseOrderItemText
       when Item.AccountingDocumentType = 'WL' 
            then odi.DeliveryDocumentItemText
       when Item.AccountingDocumentType = 'RV'
            then bdi.BillingDocumentItemText
       when (Item.AccountingDocumentType <> 'RV' or Item.AccountingDocumentType <> 'WL' or (Item.AccountingDocumentType <> 'RE' or Item.AccountingDocumentType <> 'WE')) or Item.AccountingDocumentType = 'WA'
            then ptxt.ProductName
        end as Product
}
