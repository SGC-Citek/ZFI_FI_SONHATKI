@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy Mã và Tên Đối Tượng FinancialAccountType S'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_GET_NAME_TYPE_S 
    as select from I_GLAccountLineItem as gl_item
       left outer join ZFI_GET_NAME_TYPE_D_K as D_K
                    on D_K.CompanyCode        = gl_item.CompanyCode
                   and D_K.AccountingDocument = gl_item.AccountingDocument
                   and D_K.FiscalYear         = gl_item.FiscalYear
                   and D_K.AccountingDocumentItem = gl_item.AccountingDocumentItem
       left outer join I_ProductText    as ProductText on ProductText.Product    = gl_item.Product
                                                      and ProductText.Language   = $session.system_language
       left outer join I_FixedAsset     as Asset       on Asset.MasterFixedAsset = gl_item.MasterFixedAsset
       left outer join I_CostCenterText as CCText      on CCText.Language        = $session.system_language
                                                      and CCText.ControllingArea = gl_item.ControllingArea
                                                      and CCText.CostCenter      = gl_item.CostCenter
                   
{
   key  gl_item.SourceLedger       ,
   key  gl_item.CompanyCode        ,
   key  gl_item.FiscalYear         ,
   key  gl_item.AccountingDocument ,
   key  gl_item.LedgerGLLineItem   ,
   key  gl_item.Ledger             ,
   
   gl_item.Product,
   gl_item.MasterFixedAsset,
   gl_item.CostCenter,
   gl_item.Supplier,
   gl_item.Customer,
   gl_item.AccountingDocumentItem,
   
   case when gl_item.Product is not initial
             then gl_item.Product
        when gl_item.MasterFixedAsset is not initial
             then gl_item.MasterFixedAsset
        when gl_item.CostCenter is not initial
             then gl_item.CostCenter
        when gl_item.Supplier is not initial
          or gl_item.Customer is not initial
             then D_K.ma
        else ''
   end as ma,
   
      case when gl_item.Product is not initial
             then ProductText.ProductName
        when gl_item.MasterFixedAsset is not initial
             then Asset.FixedAssetDescription
        when gl_item.CostCenter is not initial
             then CCText.CostCenterName
        when gl_item.Supplier is not initial
          or gl_item.Customer is not initial
             then D_K.name
        else ''
   end as name
       
}
