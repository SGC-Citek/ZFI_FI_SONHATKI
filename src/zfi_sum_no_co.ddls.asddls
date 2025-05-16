@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tổng nợ và có (VND)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_SUM_NO_CO 
    as select from I_JournalEntry            as Journal  
    left outer join I_OperationalAcctgDocItem as Item    on  Item.AccountingDocument = Journal.AccountingDocument
                                                         and Item.CompanyCode        = Journal.CompanyCode
                                                         and Item.FiscalYear         = Journal.FiscalYear
{               
  Item.Customer,
  Item.CompanyCodeCurrency                                                                                                                                              as loai_tien,
      @Semantics: { amount : {currencyCode: 'loai_tien'} }
      sum(cast( case
            when Item.CompanyCodeCurrency = 'VND' then case 
                when Item.DebitCreditCode = 'S' and Item.IsNegativePosting = ''
                    then cast( Item.AmountInCompanyCodeCurrency as abap.dec(23,2) )
                when Item.DebitCreditCode = 'H'  and Item.IsNegativePosting = 'X'
                    then cast( Item.AmountInCompanyCodeCurrency as abap.dec(23,2) )
                else 0
               end   end as abap.curr(23,2)  ) )     as tong_no_VND,
       
       @Semantics: { amount : {currencyCode: 'loai_tien'} }
      sum(cast( case
              when Item.CompanyCodeCurrency = 'VND' then case
                when Item.DebitCreditCode = 'H' and Item.IsNegativePosting = '' 
                    then cast( Item.AmountInCompanyCodeCurrency as abap.dec(23,2) )
                when Item.DebitCreditCode = 'S'  and Item.IsNegativePosting = 'X'
                    then cast( Item.AmountInCompanyCodeCurrency as abap.dec(23,2) )
                else 0
               end  end  as abap.curr(23,2) ) )     as tong_co_VND
}
group by
    Item.Customer,
    Item.CompanyCodeCurrency
