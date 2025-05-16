@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy Mã và Tên Đối Tượng FinancialAccountType D hoặc K'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_GET_NAME_TYPE_D_K
  as select distinct from I_OperationalAcctgDocItem as oadi
  //    left outer join       I_BusinessPartner         as bp              on bp.BusinessPartner        =  oadi.AlternativePayeePayer
  //                                                                       and oadi.AlternativePayeePayer <> ''

    left outer join       I_Supplier                as supplier        on  supplier.Supplier                = oadi.Supplier
                                                                       and (
                                                                          supplier.IsOneTimeAccount         is null
                                                                          or supplier.IsOneTimeAccount      is initial
                                                                        )
                                                                       and oadi.AddressAndBankIsSetManually is initial
                                                                       and oadi.AlternativePayeePayer       is initial

    left outer join       I_Customer                as customer        on  customer.Customer                = oadi.Customer
                                                                       and (
                                                                          customer.IsOneTimeAccount         is null
                                                                          or customer.IsOneTimeAccount      is initial
                                                                        )
                                                                       and oadi.AddressAndBankIsSetManually is initial
                                                                       and oadi.AlternativePayeePayer       is initial

    left outer join       I_OneTimeAccountSupplier  as OneTimesupplier on  OneTimesupplier.CompanyCode            = oadi.CompanyCode
                                                                       and OneTimesupplier.AccountingDocument     = oadi.AccountingDocument
                                                                       and OneTimesupplier.FiscalYear             = oadi.FiscalYear
                                                                       and OneTimesupplier.AccountingDocumentItem = oadi.AccountingDocumentItem
                                                                       and oadi.FinancialAccountType              = 'K'
                                                                       and (
                                                                          supplier.IsOneTimeAccount               is not initial
                                                                          or oadi.AddressAndBankIsSetManually     is not initial
                                                                        )

    left outer join       I_OneTimeAccountCustomer  as OneTimecustomer on  OneTimecustomer.CompanyCode            = oadi.CompanyCode
                                                                       and OneTimecustomer.AccountingDocument     = oadi.AccountingDocument
                                                                       and OneTimecustomer.FiscalYear             = oadi.FiscalYear
                                                                       and OneTimecustomer.AccountingDocumentItem = oadi.AccountingDocumentItem
                                                                       and oadi.FinancialAccountType              = 'D'
                                                                       and (
                                                                          customer.IsOneTimeAccount               is not initial
                                                                          or oadi.AddressAndBankIsSetManually     is not initial
                                                                        )
{
  key oadi.CompanyCode,
  key oadi.AccountingDocument,
  key oadi.FiscalYear,
  key oadi.AccountingDocumentItem,
//  key oadi.FinancialAccountType,

      //      case when oadi.AlternativePayeePayer <> ''
      //                then oadi.AlternativePayeePayer
      case when oadi.Customer is not initial
                 then oadi.Customer
            when oadi.Supplier is not initial
                 then oadi.Supplier
            else ''
       end as ma,

      //      case when oadi.AlternativePayeePayer <> '' //Ưu Tiên 1
      //                then case when concat_with_space(bp.OrganizationBPName2,concat_with_space(bp.OrganizationBPName3,bp.OrganizationBPName4,1),1) = ''
      //                               then bp.OrganizationBPName1
      //                          else concat_with_space(bp.OrganizationBPName2,concat_with_space(bp.OrganizationBPName3,bp.OrganizationBPName4,1),1)
      //                     end
      case   when supplier.Supplier is not initial  //Ưu Tiên 2
              then case when supplier.BusinessPartnerName2 <> ''
                             or supplier.BusinessPartnerName3 <> ''
                             or supplier.BusinessPartnerName4 <> ''
                       then concat_with_space(supplier.BusinessPartnerName2,concat_with_space(supplier.BusinessPartnerName3,supplier.BusinessPartnerName4,1),1)
                       else supplier.BusinessPartnerName1
                   end
         when customer.Customer is not initial //Ưu Tiên 2
              then case when customer.BusinessPartnerName2 <> ''
                             or customer.BusinessPartnerName3 <> ''
                             or customer.BusinessPartnerName4 <> ''
                       then concat_with_space(customer.BusinessPartnerName2,concat_with_space(customer.BusinessPartnerName3,customer.BusinessPartnerName4,1),1)
                       else customer.BusinessPartnerName1
                   end
         when OneTimesupplier.Supplier is not initial //Ưu Tiên 3
              then case when OneTimesupplier.BusinessPartnerName2 <> ''
                             or OneTimesupplier.BusinessPartnerName3 <> ''
                             or OneTimesupplier.BusinessPartnerName4 <> ''
                       then concat_with_space(OneTimesupplier.BusinessPartnerName2,concat_with_space(OneTimesupplier.BusinessPartnerName3,OneTimesupplier.BusinessPartnerName4,1),1)
                       else OneTimesupplier.BusinessPartnerName1
                   end
         when OneTimecustomer.Customer is not initial //Ưu Tiên 3
              then case when OneTimecustomer.BusinessPartnerName2 <> ''
                             or OneTimecustomer.BusinessPartnerName3 <> ''
                             or OneTimecustomer.BusinessPartnerName4 <> ''
                       then concat_with_space(OneTimecustomer.BusinessPartnerName2,concat_with_space(OneTimecustomer.BusinessPartnerName3,OneTimecustomer.BusinessPartnerName4,1),1)
                       else OneTimecustomer.BusinessPartnerName1
                   end
         else '' //Ưu Tiên 4
      end  as name

}
//where
//     oadi.FinancialAccountType = 'K'
//  or oadi.FinancialAccountType = 'D'
