@EndUserText.label: 'Parameters for SalesOrderCreated Event'
define abstract entity ZA_MWIS_SOC_Event
{
    origin : abp_root_entity_name;
    external_order_id: abap.char(20);
}
