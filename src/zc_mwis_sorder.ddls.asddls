@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Sales Order'
@ObjectModel.sapObjectNodeType.name: 'ZMWIS_SORDER'
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_MWIS_SORDER
  provider contract transactional_query
  as projection on ZR_MWIS_SORDER
  association [1..1] to ZR_MWIS_SORDER as _BaseEntity on 
    $projection.OrderUUID = _BaseEntity.OrderUUID
{
  key OrderUUID,
      ExternalOrderID,
      CustomerName,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      GrossAmount,
      @Consumption: {
        valueHelpDefinition: [ {
          entity.element: 'Currency',
          entity.name: 'I_CurrencyStdVH',
          useForValidation: true
        } ]
      }
      CurrencyCode,
      OrderDate,
      Status,
      @Semantics.user.createdBy: true
      LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      LocalChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      _BaseEntity
}

