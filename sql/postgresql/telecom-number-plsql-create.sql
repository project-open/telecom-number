-- packages/telecom_number/sql/postgresql/telecom_number-plsql.sql
--
-- @author Jon Griffin
-- @creation-date 27 February 2003
-- @cvs-id $Id$

create function inline_0 () 
returns integer as '  
begin 
    PERFORM acs_object_type__create_type (  
      ''telecom_number'', -- object_type  
      ''Telecom Number'', -- pretty_name 
      ''Telecom Number'',  -- pretty_plural 
      ''acs_object'',   -- supertype 
      ''telecom_numbers'',  -- table_name 
      ''number_id'', -- id_column 
      ''telecom_number'', -- package_name 
      ''f'', -- abstract_p 
      null, -- type_extension_table 
      null -- name_method 
  ); 
 
  return 0;  
end;' language 'plpgsql'; 

select inline_0 (); 

drop function inline_0 ();

------ start of oacs new proc
create or replace function telecom_number__new ( varchar,varchar,varchar,integer,varchar,
varchar,integer,integer,integer,bool,varchar,integer,varchar,integer )
returns integer as ' 
declare 
    p_area_city_code       alias for $1; -- comment
    p_best_contact_time    alias for $2; -- comment
    p_extension            alias for $3; -- comment
    p_itu_id               alias for $4; -- comment
    p_location             alias for $5; -- comment
    p_national_number      alias for $6; -- comment
    p_number_id            alias for $7; -- comment
    p_party_id             alias for $8; -- comment
    p_phone_type_id        alias for $9; -- comment
    p_sms_enabled_p        alias for $10; -- comment
    p_subscriber_number    alias for $11; -- comment
    p_creation_user        alias for $12; -- comment
    p_creation_ip          alias for $13; -- comment
    p_context_id           alias for $14; -- comment

    -- local vars
    v_number_id telecom_numbers.number_id%TYPE; 
begin 
  v_number_id := acs_object__new (  
    null,  
    ''telecom_number'',
    now(), 
    p_creation_user, 
    p_creation_ip, 
    p_context_id 
  );   
   

  insert into telecom_numbers (
    area_city_code,
    best_contact_time,
    extension,
    itu_id,
    location,
    national_number,
    number_id,
    party_id,
    phone_type_id,
    sms_enabled_p,
    subscriber_number 
  )  
  values ( 
    p_area_city_code,
    p_best_contact_time,
    p_extension,
    p_itu_id,
    p_location,
    p_national_number,
    v_number_id,
    p_party_id,
    p_phone_type_id,
    p_sms_enabled_p,
    p_subscriber_number 
  ); 

  PERFORM acs_permission__grant_permission (
     v_number_id,
     p_creation_user,
     ''admin''
  );

   raise NOTICE ''Adding telecom_number - %'',v_number_id;
  return v_number_id;

end;' language 'plpgsql';

------ end new proc

create or replace function telecom_number__del (integer) 
returns integer as ' 
declare 
 p_number_id    alias for $1; 
 v_return integer := 0;  
begin 

   delete from acs_permissions 
     where object_id = p_number_id; 

   delete from telecom_numbers 
     where number_id = p_number_id;

   raise NOTICE ''Deleting telecom_number - %'',p_number_id;

   PERFORM acs_object__delete(p_number_id);
   return v_return;

end;' language 'plpgsql';

