@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy Mã và Tên Đối Tượng'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_GET_NAME_TYPE_A
  as select distinct from I_GLAccountLineItem as gl_item
          left outer join I_FixedAsset  as Asset       on Asset.MasterFixedAsset       = gl_item.MasterFixedAsset
                                                      and gl_item.FinancialAccountType = 'A'
          
          left outer join I_ProductText as ProductText on ProductText.Product  = gl_item.Product
                                                      and ProductText.Language = $session.system_language
                                                      and gl_item.FinancialAccountType = 'M'
    
                                                                       
{
  key gl_item.SourceLedger,
  key gl_item.CompanyCode,
  key gl_item.FiscalYear,
  key gl_item.AccountingDocument,
  key gl_item.LedgerGLLineItem,
  key gl_item.Ledger,
  key gl_item.FinancialAccountType,
  
  case when gl_item.FinancialAccountType = 'A'
          then Asset.MasterFixedAsset
       when gl_item.FinancialAccountType = 'M'
          then ProductText.Product
       else '' 
  end as ma,
  
  case when gl_item.FinancialAccountType = 'A'
          then Asset.FixedAssetDescription
       when gl_item.FinancialAccountType = 'M'
          then ProductText.ProductName
       else '' 
  end as name
      
}
where
     gl_item.FinancialAccountType = 'A'
  or gl_item.FinancialAccountType = 'M'
