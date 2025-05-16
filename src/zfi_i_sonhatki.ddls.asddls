@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sổ nhật kí'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZFI_I_SONHATKI
  with parameters
    IncludeReversedDocuments : zde_boolean,
    @Environment.systemField:#SYSTEM_DATE
    FromDate                 : vdm_v_key_date,
    @Environment.systemField:#SYSTEM_DATE
    ToDate                   : vdm_v_key_date
  as select distinct from I_JournalEntry       as Journal
    inner join       I_JournalEntryItem        as Item         on  Item.AccountingDocument = Journal.AccountingDocument
                                                               and Item.CompanyCode        = Journal.CompanyCode
                                                               and Item.FiscalYear         = Journal.FiscalYear
    
    inner join       ZFI_I_TKDOIUNG_GLACCOUNT  as tkDoiUng      on tkDoiUng.AccountingDocument = Item.AccountingDocument
                                                               and tkDoiUng.SourceLedger       = Item.SourceLedger
                                                               and tkDoiUng.CompanyCode        = Item.CompanyCode
                                                               and tkDoiUng.FiscalYear         = Item.FiscalYear
                                                               and tkDoiUng.Ledger             = Item.Ledger
                                                               and tkDoiUng.LedgerGLLineItem   = Item.LedgerGLLineItem
    
    left outer join       I_OperationalAcctgDocItem as oaci    on  oaci.AccountingDocument     = Item.AccountingDocument
                                                               and oaci.AccountingDocumentItem = Item.AccountingDocumentItem
                                                               and oaci.CompanyCode            = Item.CompanyCode
                                                               and oaci.FiscalYear             = Item.FiscalYear
                                                                                                                              

    left outer join       I_PurchaseOrderItemAPI01  as po      on  po.PurchaseOrder     = Item.PurchasingDocument
                                                               and po.Material          = Item.Product
                                                               and po.PurchaseOrderItem = Item.PurchasingDocumentItem


                                                               
    left outer join       I_SalesOrderItem          as soi     on  soi.SalesOrder       = Item.SalesDocument
                                                               and soi.SalesOrderItem   = Item.SalesDocumentItem
                                                               and soi.Material         = Item.Product

    left outer join       I_ProductText             as ptxt    on  ptxt.Product  = Item.Product
                                                               and ptxt.Language = 'E'

    
    left outer join       ZFI_I_GET_HD              as hd      on  hd.AccountingDocument = Item.AccountingDocument
                                                               and hd.FiscalYear         = Item.FiscalYear
                                                               and hd.CompanyCode        = Item.CompanyCode
                                                               and hd.LedgerGLLineItem   = Item.LedgerGLLineItem

    left outer join       ZFI_I_GET_HD_WA           as hd_wa   on  hd_wa.AccountingDocument = Item.AccountingDocument
                                                               and hd_wa.CompanyCode        = Item.CompanyCode
                                                               and hd_wa.FiscalYear         = Item.FiscalYear
                                                               and hd_wa.LedgerGLLineItem   = Item.LedgerGLLineItem 


    left outer join       ZFI_GET_NAME_TYPE_D_K      as loai1  on  loai1.AccountingDocument       = Item.AccountingDocument
                                                               and loai1.CompanyCode              = Item.CompanyCode
                                                               and loai1.FiscalYear               = Item.FiscalYear
                                                               and loai1.AccountingDocumentItem   = Item.AccountingDocumentItem
                                                               and ( Item.FinancialAccountType = 'D' or Item.FinancialAccountType = 'K' )
                                                               
    left outer join       ZFI_GET_NAME_TYPE_A        as loai2  on  loai2.SourceLedger             = Item.SourceLedger
                                                               and loai2.CompanyCode              = Item.CompanyCode
                                                               and loai2.FiscalYear               = Item.FiscalYear
                                                               and loai2.AccountingDocument       = Item.AccountingDocument
                                                               and loai2.LedgerGLLineItem         = Item.LedgerGLLineItem
                                                               and loai2.Ledger                   = Item.Ledger
                                                               and loai2.FinancialAccountType     = Item.FinancialAccountType
                                                               

    left outer join    ZFI_GET_NAME_TYPE_S as loai3            on  loai3.SourceLedger             = Item.SourceLedger
                                                               and loai3.CompanyCode              = Item.CompanyCode
                                                               and loai3.FiscalYear               = Item.FiscalYear
                                                               and loai3.AccountingDocument       = Item.AccountingDocument
                                                               and loai3.LedgerGLLineItem         = Item.LedgerGLLineItem
                                                               and loai3.Ledger                   = Item.Ledger
                                                               
    left outer join    ZFI_GET_NAME_TYPE_S as loai3_DoiTuong   on  loai3_DoiTuong.SourceLedger             = tkDoiUng.SourceLedger
                                                               and loai3_DoiTuong.CompanyCode              = tkDoiUng.CompanyCode
                                                               and loai3_DoiTuong.FiscalYear               = tkDoiUng.FiscalYear
                                                               and loai3_DoiTuong.AccountingDocument       = tkDoiUng.AccountingDocument
                                                               and loai3_DoiTuong.LedgerGLLineItem         = tkDoiUng.LedgerGLLineItem_TKDoiUng
                                                               and loai3_DoiTuong.Ledger                   = tkDoiUng.Ledger
                                     


    left outer join       I_CompanyCode             as Com     on Com.CompanyCode = Journal.CompanyCode
    left outer join       I_Address_2               as Address on Address.AddressID = Com.AddressID
    
//    left outer join       I_CostCenterText         as CCText  on CCText.Language        = 'E'
//                                                             and CCText.ControllingArea = gl_item.ControllingArea
//                                                             and CCText.CostCenter      = gl_item.CostCenter 
    
    left outer join       I_ProfitCenterText       as PCText on PCText.Language        = 'E'
                                                            and PCText.ControllingArea = Item.ControllingArea
                                                            and PCText.ProfitCenter    = Item.ProfitCenter


{
  key Journal.CompanyCode,
  key Journal.AccountingDocument,
  key Journal.FiscalYear,
  @Consumption.filter.hidden: true
  key Item.LedgerGLLineItem,
      Item.GLAccount,     
                                                                                                                 
      tkDoiUng.TKDoiUng as tk_doi_ung,
      Journal.FiscalPeriod,
      @Consumption.filter.hidden: true
      concat_with_space(Address.OrganizationName1, Address.OrganizationName2, 1)                                                                                            as ten_cty,
      @Consumption.filter.hidden: true
      concat_with_space(concat_with_space(concat_with_space(Address.StreetName, Address.StreetPrefixName1, 1), Address.StreetPrefixName2, 1), Address.StreetSuffixName1, 1) as dia_chi,
      @Consumption.filter.hidden: true
      Com.VATRegistration,
      Journal.PostingDate,

      Journal.DocumentDate,
      

      case when Item.FinancialAccountType = 'D'
             or Item.FinancialAccountType = 'K'
                then case when loai1.name <> ''
                               then loai1.name
                          else ''
                     end
           when Item.FinancialAccountType = 'A'
             or Item.FinancialAccountType = 'M'
                then case when loai2.name <> ''
                               then loai2.name
                          else ''
                     end
           when Item.FinancialAccountType = 'S'
                then case when loai3.name <> ''
                               then loai3.name
                          when loai3_DoiTuong.name <> ''
                               then loai3_DoiTuong.name
                          else ''
                     end 
            else ''
        end   as ten_dt,
        
      case when Item.FinancialAccountType = 'D'
             or Item.FinancialAccountType = 'K'
                then case when loai1.ma <> ''
                               then loai1.ma
                          else ''
                     end
           when Item.FinancialAccountType = 'A'
             or Item.FinancialAccountType = 'M'
                then case when loai2.ma <> ''
                               then loai2.ma
                          else ''
                     end
           when Item.FinancialAccountType = 'S'
                then case when loai3.ma <> ''
                               then loai3.ma
                          when loai3_DoiTuong.ma <> ''
                               then loai3_DoiTuong.ma
                          else ''
                     end
           else ''
       end                          as cus_sup,

//      GetCus.name6                                                                                                                                                          as name_cus_segment,
//
//      GetCus.Customer                                                                                                                                                       as cus_segment,

      case
        when Item.DocumentItemText <> ''
            then Item.DocumentItemText
         when Item.DocumentItemText = ''
            then Journal.AccountingDocumentHeaderText
          else
               ' ' end                                                                                                                                                      as dien_giai


  ,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      @DefaultAggregation: #SUM
      cast( case
      //when Item.TransactionCurrency = Item.CompanyCodeCurrency then case
                when Item.DebitCreditCode = 'S' 
                    then cast( Item.AmountInCompanyCodeCurrency as abap.dec(23,2) )
                    else 0
      //end sd
               end as abap.curr(23,2)  )                                                                                                                                    as no_VND,

      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      @DefaultAggregation: #SUM
      cast( case
      // when Item.TransactionCurrency = Item.CompanyCodeCurrency then case
                when Item.DebitCreditCode = 'H'
                    then cast( Item.AmountInCompanyCodeCurrency * -1 as abap.dec(23,2) )
                    else 0
      //end
               end  as abap.curr(23,2) )                                                                                                                                    as co_VND,

      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      @DefaultAggregation: #SUM
      cast( case
       when Item.TransactionCurrency <> Item.CompanyCodeCurrency then case
                when Item.DebitCreditCode = 'S'
                    then cast( Item.AmountInTransactionCurrency as abap.dec(23,2) )
                else 0
       end
               end as abap.curr(23,2)  )                                                                                                                                    as no_NT,

      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      @DefaultAggregation: #SUM
      cast( case
      when Item.TransactionCurrency <> Item.CompanyCodeCurrency then case
                when Item.DebitCreditCode = 'H'
                   then cast( Item.AmountInTransactionCurrency * -1 as abap.dec(23,2) )
                else 0
      end
               end  as abap.curr(23,2) )                                                                                                                                    as co_NT,
      Item.TransactionCurrency,
      @Consumption.filter.hidden: true
      Item.CompanyCodeCurrency,
      @Consumption.filter.hidden: true
      oaci.IsNegativePosting,
//      case when Item.AccountingDocumentType = 'RE' or Item.AccountingDocumentType = 'WE'
//           then po.PurchaseOrderItemText
//      when Item.AccountingDocumentType = 'WL'
//           then odi.DeliveryDocumentItemText
//      when Item.AccountingDocumentType = 'RV'
//           then bdi.BillingDocumentItemText
//      when (Item.AccountingDocumentType <> 'RV' or Item.AccountingDocumentType <> 'WL' 
//          or (Item.AccountingDocumentType <> 'RE' or Item.AccountingDocumentType <> 'WE')) or Item.AccountingDocumentType = 'WA'
//           then ptxt.ProductName
//       end   as Product,
//
      case when oaci.AccountingDocumentType = 'RE' or oaci.AccountingDocumentType = 'WE'
           then case when po.PurchaseOrderItemText <> ''
                     then po.PurchaseOrderItemText
                     else ptxt.ProductName
                end
      when oaci.AccountingDocumentType = 'WL' or oaci.AccountingDocumentType = 'RV'
           then soi.SalesOrderItemText
      when (oaci.AccountingDocumentType <> 'RV' or oaci.AccountingDocumentType <> 'WL' 
          or (oaci.AccountingDocumentType <> 'RE' or oaci.AccountingDocumentType <> 'WE')) or oaci.AccountingDocumentType = 'WA'
           then ptxt.ProductName
       end   as Product,
       
       
      concat_with_space(concat_with_space(Item.CostCenter, '-', 1), Item._CostCenterTxt.CostCenterName, 1)                                                                                            as CostCenter,
      oaci.AssetContract,
      //Journal.AccountingDocumentCreationDate,
      @Consumption.filter.hidden: true
      cast(concat(Journal.AccountingDocumentCreationDate, Journal.CreationTime) as zfi_de_datetime)                                                                         as ngay_tao,
      //Journal.LastChangeDate,
      @Consumption.filter.hidden: true
      Journal.JournalEntryLastChangeDateTime,

      Journal.AccountingDocCreatedByUser,
      Item.ReferenceDocument,
      
//      case when Item.AccountingDocumentType = 'WA'
//        then hd_wa.DocumentRef
//      when Item.ReferenceDocument = hd.ReferenceDocument
//        then hd.DocumentReferenceID
//        else
//            Journal.DocumentReferenceID end                                                                                                                                 as DocumentReferenceID,
      Journal.DocumentReferenceID as DocumentReferenceID,
      Item.AccountingDocumentType,
      @Consumption.filter.hidden: true
      Journal.ReversalReferenceDocument,
      @Consumption.filter.hidden: true
      Item.FinancialAccountType,
      concat_with_space(concat_with_space(oaci.ProfitCenter, '-', 1), PCText.ProfitCenterName, 1) as vuviec

}
where
  (
    (
            $parameters.FromDate                 <= Item.PostingDate
      and   $parameters.ToDate                   >= Item.PostingDate
    )
    and(
            $parameters.IncludeReversedDocuments is not initial
      or(
            $parameters.IncludeReversedDocuments is initial
        and Journal.IsReversed                   is initial
        and Journal.IsReversal                   is initial
      )
    )
    //and (Item.FinancialAccountType = 'D' or Item.FinancialAccountType = 'K')
  )
  
