CLASS lsc_zr_mwis_sorder DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zr_mwis_sorder IMPLEMENTATION.

  METHOD save_modified.
    IF create-salesorder IS NOT INITIAL.
      RAISE ENTITY EVENT zr_mwis_sorder~SalesOrderCreated
        FROM VALUE #(
          FOR <new_sales_order> IN create-salesorder
          (
            orderuuid = <new_sales_order>-OrderUUID
            external_order_id = <new_sales_order>-ExternalOrderID
            origin = 'ZR_MWIS_SORDER'
          )
        ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zr_mwis_sorder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR SalesOrder
        RESULT result,
      SetDefaults FOR DETERMINE ON MODIFY
        IMPORTING keys FOR SalesOrder~SetDefaults.
ENDCLASS.

CLASS lhc_zr_mwis_sorder IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD SetDefaults.
    MODIFY ENTITIES OF zr_mwis_sorder IN LOCAL MODE
      ENTITY SalesOrder
        UPDATE FIELDS ( OrderDate Status )
        WITH VALUE #(
          FOR key IN keys
          (
            %tky      = key-%tky
            OrderDate = cl_abap_context_info=>get_system_date( )
            Status    = 'NEW'
          )
        ).
  ENDMETHOD.

ENDCLASS.
