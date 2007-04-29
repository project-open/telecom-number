-- @cvs-id: $Id$

create table phone_types (
    phone_type_id                  integer
                                   constraint phone_types_id_pk
                                     primary key,
    description                    varchar (40)
                                   constraint phone_types_desc_nn
                                     not null
);

-- insert some data

-- telecom_numbers 
-- This table is used to store telephone numbers
-- I have deviated from HR-XML slightly to make the 
-- table map more directly to dml

create table telecom_numbers
(
    number_id           integer
                        constraint telecom_number_id_pk
                            primary key
                        constraint telecom_number_id_fk
                            references acs_objects (object_id),
    party_id            integer
                        constraint telecom_party_id_fk
                            references parties (party_id),    
    itu_id              integer
                        constraint telecom_number_itu_code_fk
                            references itu_codes(itu_id),
    -- trunk number
    national_number     varchar(20),
    -- area code npa
    area_city_code      varchar(30),
    -- local number nxx
    subscriber_number   varchar(100)
                        constraint telecom_number_sub_num_nn
                            not null,
    extension           varchar(100),
    sms_enabled_p       boolean,
    -- 24x7,weekdays
    best_contact_time   varchar (200),
    -- home, office, etc
    location            varchar (200),
    -- mobile, pager, fax
    phone_type_id       integer
                        constraint telecom_numbers_phontyp_id_fk
                            references phone_types(phone_type_id)
);

create index telecom_numbers_itu_ix on telecom_numbers (itu_id);
create index telecom_numbers_party_ix on telecom_numbers (party_id);

-- view
create view telecom_number_vw as 
   select
   n.*,
   area_city_code || ' ' || subscriber_number as pretty_number,
   description as phone_type
   from phone_types t,telecom_numbers n
   where t.phone_type_id = n.phone_type_id;


-- plsql
\i telecom-number-plsql-create.sql
