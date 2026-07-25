@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZMWIS_SORDER'
@EndUserText.label: 'Sales Order'
define root view entity ZR_MWIS_SORDER
  as select from zmwis_sorder as SalesOrder
{
  key order_uuid as OrderUUID,
  external_order_id as ExternalOrderID,
  customer_name as CustomerName,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  gross_amount as GrossAmount,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  currency_code as CurrencyCode,
  order_date as OrderDate,
  status as Status,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_changed_by as LocalChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_changed_at as LocalChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
}
