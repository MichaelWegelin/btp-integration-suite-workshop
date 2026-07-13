CLASS LHC_ZR_MWIS_SORDER DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR SalesOrder
        RESULT result,
      SetDefaults FOR DETERMINE ON MODIFY
            IMPORTING keys FOR SalesOrder~SetDefaults.
ENDCLASS.

CLASS LHC_ZR_MWIS_SORDER IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
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
