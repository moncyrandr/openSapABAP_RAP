CLASS zgm_cl_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zgm_cl_eml IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA lt_travels_tab TYPE TABLE FOR READ RESULT zgm_i_travel.

    " Step 1 READ
    READ ENTITIES OF zgm_i_travel
        ENTITY Travel
    FROM VALUE #( ( TravelUUID = 'FAC80100E688ED3418003B66951B83F9' ) )
    RESULT lt_travels_tab. " data(travels1) - dichiarazione in linea.
    out->write( lt_travels_tab ).

    " Step 2 READ with fields
    READ ENTITIES OF zgm_i_travel
        ENTITY Travel
        FIELDS ( AgencyID CustomerID TravelID BookingFee CreatedAt )
        WITH VALUE #( ( TravelUUID = 'FAC80100E688ED3418003B66951B83F9' ) )
    RESULT LT_travels_tab.
    out->write( LT_travels_tab ).

    " Step 3 READ with fields and FAILED/MESSAGE
    DATA lt_failed TYPE RESPONSE FOR FAILED zgm_i_travel.
    DATA lt_mess TYPE RESPONSE FOR REPORTED zgm_i_travel.
    READ ENTITIES OF zgm_i_travel
        ENTITY Travel
        FIELDS ( AgencyID CustomerID TravelID BookingFee CreatedAt )
        WITH VALUE #( ( TravelUUID = '1231232132313' ) )
    RESULT lt_travels_tab
    REPORTED lt_mess " valorizzata non sempre
    FAILED lt_failed.
    out->write( lt_travels_tab ).

    " Step 4 READ with fields
    READ ENTITIES OF zgm_i_travel
        ENTITY Travel ALL FIELDS
        WITH VALUE #( ( TravelUUID = 'FAC80100E688ED3418003B66951B83F9' ) )
    RESULT LT_travels_tab.
    out->write( LT_travels_tab ).

    " Step 5 READ by association
    READ ENTITIES OF zgm_i_travel
        ENTITY Travel BY \_Booking ALL FIELDS
        WITH VALUE #( ( TravelUUID = 'FAC80100E688ED3418003B66951B83F9' ) )
    RESULT DATA(LT_bookings_tab).
    out->write( LT_bookings_tab ).

    " Step 6 MODIFY update
    MODIFY ENTITIES OF zgm_i_travel
        ENTITY Travel
        UPDATE
        SET FIELDS WITH VALUE
            #(
                (    TravelUUID     = 'FAC80100E688ED3418003B66951B83F9'
                     Description    = 'Manual Update'
                     TravelStatus   = 'F'
                )
             ).

    " Step 7a INSERT update
    MODIFY ENTITIES OF zgm_i_travel
        ENTITY Travel
        UPDATE
        SET FIELDS WITH VALUE
            #(
                (    TravelUUID     = 'FAC80100E688ED3418003B66951B83F9'
                     Description    = 'Manual Update'
                     TravelStatus   = 'F'
                )
             ).
    " Step 7b commit
    COMMIT ENTITIES
    RESPONSE OF zgm_c_travel
    FAILED      DATA(lt_failed_upd)
    REPORTED    DATA(lt_mess_upd).

    " step 8 - MODIFY Create
    MODIFY ENTITIES OF zgm_i_travel
      ENTITY travel
        CREATE
          SET FIELDS WITH VALUE
            #( ( %cid        = 'MyContentID_1'
                 AgencyID    = '70012'
                 CustomerID  = '14'
                 BeginDate   = cl_abap_context_info=>get_system_date( )
                 EndDate     = cl_abap_context_info=>get_system_date( ) + 10
                 Description = 'Manual Insert' ) )

     MAPPED DATA(mapped)
     FAILED DATA(failed)
     REPORTED DATA(reported).

    out->write( mapped-travel ).

    COMMIT ENTITIES
      RESPONSE OF zgm_i_travel
      FAILED     DATA(failed_commit)
      REPORTED   DATA(reported_commit).

    out->write( 'Create done' ).

*    " step 8 - MODIFY Delete
*    MODIFY ENTITIES OF zgm_i_travel
*      ENTITY travel
*        DELETE FROM
*          VALUE
*            #( ( TravelUUID  = 'FAC80100E688ED3418003B66951B83F9' ) )
*
*     FAILED DATA(failed_ins)
*     REPORTED DATA(reported_ins).
*
*    COMMIT ENTITIES
*      RESPONSE OF zgm_i_travel
*      FAILED     DATA(failed_commit_del)
*      REPORTED   DATA(reported_commit_del).
*
*    out->write( 'Delete done' ).


  ENDMETHOD.

ENDCLASS.
