-- just drop the table might not remove the BLOBs
-- delete from carare.data_upload;

drop schema if exists mint2 cascade;
create schema mint2;

SET search_path TO mint2,public;
-- generally foreign key constraints are going to be managed in the
-- application. So the ON DELETE case in the constraint should actually
-- never have to be executed...

-- generally sequences start with 1000
-- data below is meant to be test data

-- terms with no parents are considered list names

create sequence seq_users_id start with 1002;
create table users (
	users_id int  primary key,
 	login text unique,
	job_role text,
    first_name text,
    last_name text,
  	email text,
	work_telephone text,
  	md5_password text,
	organization_id int,
	password_expires date,
	account_created date,
	active_account boolean,
	rights int
);

-- Super user has 31 lower bits set. I didnt want to touch the sign bit, scared of complications --
insert into users( users_id, first_name, last_name, email, login, md5_password, active_account, rights , account_created ) values
 ( 1000, 'CARARE', 'Admin', 'stabenau@image.ntua.gr', 'admin', md5( 'admin' || 'm1st1k0' ), true, ~(1<<31), '20012-01-01' );

create sequence seq_organization_id start with 1001;
create table organization (
	organization_id int primary key,
	original_name text,
	english_name text,
	short_name text,
	address text,
	description text,
	country text,
	url_pattern text,
	publish_allowed boolean not null default FALSE,
    primary_contact_user_id int references users on delete set null,
	-- one of content provider, aggregator, national contact, reviewer --
	-- doesn't do much --
	-- museum, library, archive .. --
	org_type text,
	json_folders text,
	parental_organization_id int references organization 
);


create sequence seq_blob_wrap_id start with 1000;
create table blob_wrap (
	blob_wrap_id bigint primary key,
	length int,
	data_id oid
);


-- circular user and organization foreign key
ALTER TABLE users ADD FOREIGN KEY (organization_id) REFERENCES organization on delete set null;

insert into organization(organization_id, english_name,  parental_organization_id , country ) values
 ( 1, 'NTUA', null, 'Greece' );
update users set organization_id = 1 where users_id in ( 1000, 1001 );

create sequence seq_mapping_id start with 1000;
create table mapping (
	mapping_id int primary key,
	creation_date timestamp, 
	last_modified timestamp,
	name text,
	organization_id int references organization,
	target_schema_id int,
	shared boolean not null,
	finished boolean not null,
	json text,
	xsl text
);

create sequence seq_activity_id start with 1000;
create table activity(
	activity_id int primary key,
	created timestamp,
	
	-- java serialized activity object
	-- is recreated, when cleanup is needed
	serial bytea,
	
	class_name text,
	description text
);


create sequence seq_dataset_id start with 1000;
create table dataset (
	dataset_id int primary key,
	
	-- subtype discriminator for object mapping
	-- upload, merge, transformation, publication
	subtype text,
	
	-- name that should be given to the user (editable)
	name text,
	
	-- optional blob data (zip or tgz format)
	blob_wrap_id int references blob_wrap,
	loading_status text,
	
	-- optional schema for this dataset
	xml_schema_id int,
	schema_status text,
	
	
	-- xpath for item root ( optional if schema_id is given )
	-- might not be set at all
	item_root_path_id int,
	
	-- xpath for a suitable item label
	item_label_path_id int,
		
	-- optional path to a native item_id
	item_native_id_path_id int,
	
	-- root holder for this dataset
	root_holder_id int,
	
	
	-- itemizer status
	-- (NOT_APPLICABLE, RUNNING, FAILED, OK, DELETING )
	itemizer_status text,
	
	-- available after itemization
	item_count int,
	
	-- if there is a schema and this was validated.
	valid_item_count int,
	-- node index status
	-- ( NOT_APPLICABLE, RUNNING, FAILED, OK, COMPRESSED, EDITED )
	node_index_status text,
	
	-- node index name
	-- if not xml_node_$dataset_id
	node_index_name text,
	
	-- initial size of the node index table
	node_index_size bigint,
	
	-- stats status 
	-- for small datasets we can directly query node table
	-- ( AVAILABLE, BUILDING, DIRECT )
	statistic_status text,	
	
	created timestamp,
	last_modified timestamp,
	
	-- user that made this dataset
	creator_id int references users,
	
	-- organization this belongs to
	organization_id int references organization,
	
	-- deletion flag
	-- deletions are done delayed, so that recovery is possible
	deleted boolean,
	deleted_date timestamp,
	
	-- The publication status is essentially a flag
	-- if its OK, its published, other statuses are running, failed, not applicable
	publication_status text,
	
	-- when the last publication happened
	publish_date timestamp,
	
	published_item_count int NOT NULL DEFAULT 0
	
);

create sequence seq_dataset_log_id start with 1000; 
create table dataset_log (
	dataset_log_id int primary key,
	dataset_id int references dataset on delete cascade,
	entry_time timestamp,
	message text,
	
	-- boring stuff  for the admins should go into here
	detail text,
	
	-- the user whoose action created this log
	-- null if not applicable
	users_id int references users
);

create index idx_dataset_log_dataset_id on dataset_log( dataset_id );


-- store all the xpaths and count them per data upload --
create sequence seq_xpath_summary_id start with 1000;
create table xpath_summary (
	xpath_summary_id int primary key,
	dataset_id int references dataset on delete cascade,
	
	-- the path without the namespaces
	xpath text,
	count bigint,
	
	-- all the names connected with '/' makes the xpath
	name text,
	
	-- with the uri and all the parent nodes you can build the
	-- proper path with namespace prefixes
	uri text,
	uri_prefix text,
	-- these 2 are guesses based on the parsed xml
	optional boolean,
	multiple boolean,
	
	description text,
	distinct_count bigint,
	unique_value boolean not null,
	avg_length float not null,
	parent_summary_id bigint references xpath_summary on delete set null
);

create index idx_xpath_summary_parent_id on xpath_summary( parent_summary_id );
create index idx_xpath_summary_dataset_xpath on xpath_summary( dataset_id, xpath );


-- subtype from dataset
create table data_upload (
	dataset_id int references dataset on delete cascade,

	-- only for zips its bigger than 1 --
	no_of_files int not null default -1,

	-- for OAI reps here goes the URL --
    source_url text,

	-- http uploads should provide this --
	-- on upload is copied into name. 
	-- name is editable, original_filename is not
	original_filename text,

	-- one of the suppported  ZIP-XML, ZIP-CSV, XML, CSV
	-- we store in the db TGZ as standard for easier iteration and better compression than zip
	-- on big xml filesets 
	structural_format text,
	
	-- upload method ( HTTP, URL, FTP, SERVER, OAI )
	upload_method text,
	
	-- oai token
	resumption_token text,
		
	-- in which folders is this dataset, JSONArray encoded
	json_folders text,

	-- some csv info
	csv_has_header boolean,
	
	csv_esc character,
	csv_delimiter character
);


-- track a transformation and record the result in the database
create table transformation (
	dataset_id int references dataset on delete cascade,
	-- where this transformation is derived from 
	parent_dataset_id int references dataset,	
	report text,
	mapping_id int references mapping,
	crosswalk_id int,
	json_mapping text,
	-- a blob for invalid items
	invalid_id int references blob_wrap
);



-- need to get rid of the oid storage --

CREATE OR REPLACE FUNCTION on_upload_delete() RETURNS trigger
AS $on_upload_delete$
BEGIN
PERFORM lo_unlink( old.data_id );
RETURN null;
END;
$on_upload_delete$
LANGUAGE plpgsql
IMMUTABLE
RETURNS NULL ON NULL INPUT;

CREATE TRIGGER upload_delete_trigger
AFTER DELETE
ON blob_wrap
FOR EACH ROW EXECUTE PROCEDURE on_upload_delete();


-- xml nodes need to be droped quickly before the xml_object goes
-- or the database will need years for this operation

CREATE OR REPLACE FUNCTION dataset_delete() RETURNS trigger
AS $$
BEGIN
	BEGIN
		EXECUTE 'drop table if exists xml_node_' || old.dataset_id ;
		IF old.node_index_name<>null THEN
		  EXECUTE 'delete from ' || old.node_index_name || ' where dataset_id = ' || old.dataset_id;
		END IF;  
	EXCEPTION WHEN undefined_table then
  		RETURN old;
  	END;
RETURN old;
END;
$$
LANGUAGE plpgsql
VOLATILE
RETURNS NULL ON NULL INPUT;



CREATE TRIGGER dataset_delete_trigger 
BEFORE DELETE
ON dataset
FOR EACH ROW EXECUTE PROCEDURE dataset_delete();


create sequence seq_locks_id start with 1000;
create table locks (
	locks_id bigint primary key,
	object_id bigint,
	object_type text,
	aquired timestamp,
	user_login text,
	http_session_id text,
	name text,
	unique (object_type, object_id )
);




create sequence seq_xml_node_id start with 1000 increment by 1000;
create table xml_node_master (
	xml_node_id bigint,
-- should have foreign key here, but then we need to put parent nodes
-- before child nodes, but then we cant have checksum from children
	parent_node_id bigint,
	
	-- No foreign key here, delays deletes endlessly
	dataset_id int,
	
	-- shortcut to the xpath for this text
	xpath_summary_id int,
	
	-- one of text, element, attribute
	node_type smallint,
	content text,

	-- how many subnodes from here
	size bigint,
	checksum text
);


-- is read on app start
-- updated in imports
create table global_namespaces (
	uri text,
	prefix text
);



create sequence seq_xml_schema_id start with 1000;
create table xml_schema(
	xml_schema_id int primary key,
	name text,
	xsd text,
	item_level_path text,
	item_label_path text,
	item_id_path text,
	json_config text,
	json_template text,
	json_original text,
	documentation text,
	schematron_rules text,
	schematron_xsl text,
	created timestamp,
	last_modified timestamp
);

ALTER TABLE mapping ADD FOREIGN KEY (target_schema_id) references xml_schema on delete set null;
ALTER TABLE dataset ADD FOREIGN KEY (xml_schema_id) references xml_schema on delete set null;
 
create sequence seq_crosswalk_id start with 1000;
create table crosswalk(
    crosswalk_id int primary key,
    source_schema_id int references xml_schema,
    target_schema_id int references xml_schema,
    xsl text,
    json_mapping_template text,
    created timestamp
);

ALTER TABLE transformation ADD FOREIGN KEY (crosswalk_id) references crosswalk;

create sequence seq_meta_id start with 1000;
create table meta (
  meta_id int primary key,
  meta_key text,
  meta_value text
);

-- track schema version. Each published schema needs that
-- for each change to a published schema we need patch files that
-- upgrade the database without loosing the data (as much as that is possible) 

insert into meta( meta_id, meta_key, meta_value ) values( 1, 'schema.version', '2' );

create sequence seq_item_id start with 1000;
create table item (
	item_id bigint primary key not null,
	-- the gzipped xml for this item
	-- preferrable without <xml> header
	-- either this or the tree_id need to be present
	gzip_xml bytea,
	
	dataset_id int references dataset on delete cascade,
	-- maybe some externally meaningful id --
	-- should be consistent over different xml_objects --
	persistent_id text,
	
	-- optional, there might be no more tree
	xml_node_id bigint,
	
	-- you can track if this is a derived item, if info is available --
	source_item_id bigint,
	
	-- per item change time tracking --
	last_modified timestamp,
	
	-- optional label for display purpose
	label text,
	
	-- is this item validated (has the schema of the dataset)
	valid boolean not null
);

create index idx_item_dataset_id on item( dataset_id, item_id);
create index idx_item_source_item on item( source_item_id );

-- no foreign ref on xpath_summary
-- xpath_summaries are not disappearing by themselves, only wiht datasets and there is already a cascade in place

create sequence seq_xpath_stats_values_id start with 1000;
create table xpath_stats_values (
	xpath_stats_values_id bigint primary key not null,
	dataset_id int references dataset on delete cascade,
	xpath_summary_id int,
	start bigint,
	count int,
	gzipped_values bytea
);
create index idx_xpath_stats_values_summary on xpath_stats_values( xpath_summary_id, start );
create index idx_xpath_stats_values_dataset on xpath_stats_values( dataset_id );

create sequence seq_value_edit_id start with 1000;
create table value_edit (
	value_edit_id bigint primary key not null,
	dataset_id int references dataset,
	xpath_holder_id int,
	match_string text,
	replace_string text,
	created timestamp
);




