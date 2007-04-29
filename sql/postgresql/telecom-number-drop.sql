--drop functions
drop function 
drop function 


--drop permissions
delete from acs_permissions where object_id in (select _id from telecom_number);

--drop objects
create function inline_0 ()
returns integer as '
declare
        object_rec              record;
begin
        for object_rec in select object_id from acs_objects where object_type=''telecom_number''
        loop
                perform acs_object__delete( object_rec.object_id );
        end loop;

        return 0;
end;' language 'plpgsql';

select inline_0();
drop function inline_0();

--drop table
drop table telecom_numbers;
drop table phone_types;
drop view telecom_number_vw;

--drop attributes
select acs_attribute__drop_attribute (
           'note',
           'TITLE'
        );

select acs_attribute__drop_attribute (
           'note',
           'BODY'
        );


--drop type
select acs_object_type__drop_type(
           'telecom_number',
           't'
        );


