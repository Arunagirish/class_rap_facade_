CLASS zsales_hi DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zsales_hi IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

  data: lt_kna1 TYPE I_Customer.

    MODIFY ENTITIES OF i_salesordertp
     ENTITY salesorder
     CREATE
        FIELDS ( salesordertype
         salesorganization
         distributionchannel
         organizationdivision
         soldtoparty )
     WITH VALUE #( ( %cid = 'H001'
     %data = VALUE #( salesordertype = 'TA'
     salesorganization = '1001'
     distributionchannel = '01'
     organizationdivision = '03'
     soldtoparty = '0001000010' ) )

     ( %cid = 'H002'
     %data = VALUE #( salesordertype = 'TA'
     salesorganization = '1002'
     distributionchannel = '01'
     organizationdivision = '03'
     soldtoparty = '0001000010' ) ) )
    CREATE BY \_item
     FIELDS ( product
     requestedquantity plant )
     WITH VALUE #( ( %cid_ref = 'H001'
     salesorder = space
     %target = VALUE #( ( %cid = 'I001'
     product = 'FG0210000017R716'
     requestedquantity = '2.000'
     plant = '1002' ) ) )

     ( %cid_ref = 'H002'
     salesorder = space
     %target = VALUE #( ( %cid = 'I002'
     product = 'FG0210000017R716'
     requestedquantity = '2.000'
     plant = '1002' ) ) ) )
     MAPPED DATA(ls_mapped)
     FAILED DATA(ls_failed)
     REPORTED DATA(ls_reported).

    DATA: ls_so_temp_key      TYPE STRUCTURE FOR KEY OF i_salesordertp,
          ls_so_item_temp_key TYPE STRUCTURE FOR KEY OF i_salesorderitemtp.

    COMMIT ENTITIES BEGIN
     RESPONSE OF i_salesordertp
     FAILED DATA(ls_save_failed)
     REPORTED DATA(ls_save_reported).

    CONVERT KEY OF i_salesordertp FROM ls_so_temp_key TO DATA(ls_so_final_key).
    MOVE-CORRESPONDING ls_mapped-salesorderitem[ 1 ] TO ls_so_item_temp_key.
    CONVERT KEY OF i_salesorderitemtp FROM ls_so_item_temp_key TO DATA(ls_so_item_final_key).


    COMMIT ENTITIES END.

    out->write(  ls_so_item_final_key ).
    out->write( 'sales order created' ).

  ENDMETHOD.
ENDCLASS.

