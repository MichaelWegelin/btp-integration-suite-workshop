@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZMWIS_SORDER'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_MWIS_SORDER
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_MWIS_SORDER
  association [1..1] to ZR_MWIS_SORDER as _BaseEntity on $projection.ORDERUUID = _BaseEntity.ORDERUUID
{
  key OrderUUID,
  ExternalOrderID,
  CustomerName,
  @Semantics: {
    Amount.Currencycode: 'CurrencyCode'
  }
  GrossAmount,
  @Consumption: {
    Valuehelpdefinition: [ {
      Entity.Element: 'Currency', 
      Entity.Name: 'I_CurrencyStdVH', 
      Useforvalidation: true
    } ]
  }
  CurrencyCode,
  OrderDate,
  Status,
  @Semantics: {
    User.Createdby: true
  }
  LocalCreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  LocalCreatedAt,
  @Semantics: {
    User.Localinstancelastchangedby: true
  }
  LocalChangedBy,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LocalChangedAt,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LastChangedAt,
  _BaseEntity
}
