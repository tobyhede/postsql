PostSQL
====================================

Functions for transforming PostgreSQL and PL/v8 into a totally awesome JSON document store  


Requirements
------------------------------------

 * PostgreSQL 9.2 beta 
 * PL/V8 http://code.google.com/p/plv8js/wiki/PLV8


PG 9.2 gives you a JSON datatype, which will validate JSON automatically.

Any version of PG that supports PL/V8 can be used but the functions will need to be adapted to use TEXT instead of JSON types. Validation of JSON will also obviously need to be handled manually. 



Background
------------------------------------

Initial work inspired by a demo by Andrew Dunstan
http://people.planetpostgresql.org/andrew/index.php?/archives/249-Using-PLV8-to-index-JSON.html

And this by @leinweber captures the grand vision 
http://ssql-pgaustin.herokuapp.com/#1


Details
-------------------------------------

In order to be used in WHERE and ORDER BY correctly JSON field, the various JSON Types need to be mapped into corresponding PG types. Using the correctly typed accessor allows PG's normal operators to JUST WORK. 
  
    Number     => INT or DOUBLE PRECISION
    String     => TEXT
    Date       => TIMESTAMP
    Boolean    => BOOLEAN
    Array      => ARRAY of appropriate PG Type 
    Object     => ?
    null       => NULL
 
Functions expect a column of pg JSON type.     

All functions will accept a JSON field as a string in dot notation, allowing access to fields of arbtirary depth eg "person.name".



### Scalar Functions
  

#### json_string(column, field) returns TEXT

    SELECT id, json_string(data,'person.name') FROM things WHERE json_string(data,'person.name') = 'Zaphod';
    SELECT id, json_string(data,'name') FROM things WHERE json_string(data,'name') LIKE 'G%';
 
#### json_int(column, field) returns INT

JS values that are NaN are returned as NULL

    SELECT id, json_int(data,'person.id') FROM things WHERE json_int(data,'person.id') = 10;
    SELECT id, json_int(data,'count') FROM things WHERE json_int(data,'count') <= 99;
 
#### json_float(column, field) returns DOUBLE PRECISION
  
JS values that are NaN are returned as NULL

    SELECT id, json_int(data,'person.id') FROM things WHERE json_int(data,'person.id') = 10.01;
    SELECT id, json_int(data,'count') FROM things WHERE json_int(data,'count') <= 99.9999;


#### json_bool(column, field) returns BOOLEAN

Literal JS *true* and *false* are boolean, all other values are NULL. 

    SELECT id, json_bool(data,'boolean') FROM things WHERE json_bool(data,'boolean') = false 

  
#### json_date(column, field) returns TIMESTAMP

Any JS numeric value will be converted to a JS date, all other values are NULL. 
  
    SELECT id, json_date(data,'date') FROM things WHERE json_date(data,'date') <= NOW();


### Array Functions

Array functions return typed Arrays that can be used with any of the PG Array operators. Currently we only have the ability to handle arrays of ints but others are coming.

#### json_int_array(column, field)
         
Will wrap an integer into an array as required

     SELECT id, (json_int_array(data,'object.list') FROM things WHERE 10 = ALL (json_int_array(data,'object.list'))
     
     SELECT id, (json_int_array(data,'object.list') FROM things WHERE 10 = ANY (json_int_array(data,'object.list'))


### Advanced Functions
     
#### json_push(column, field, json_value)

Appends json_value to an array or if the field is not present, will set the field to be an array containing json_value. Will throw an error if the field is not an array. *json_value* is a string representing a valid JSON representation.

         UPDATE things SET data = json_add_to_set(data, 'array', '10');
         Will error if field is not an array.
  
  
#### json_add_to_set(column, field, json_value)

Appends json_value to an array if it is not in the array already or if the field is not present, will set the field to be an array containing json_value. Will throw an error if the field is not an array. *json_value* is a string representing a valid JSON representation.
         
         UPDATE things SET data = json_add_to_set(data, 'object.array', '10');

  
##### Indexes and/or Indices
  
An index can be created using any of the Scalar and Array Functions. 
Creating an index makes performance on-par with regular PG columnn data
  
    CREATE INDEX name_in_json ON things (json_string(data,'name'));
     
  
#### Sample Data

All the above have been tested with randomly generated data in the form:

    {
	    "uuid":"ba596c94-9e50-11e1-a50e-70cd60fffe0e",
	    "integer":10,
	    "string":"Blick",      
	    "date":"2012-05-11T15:42:15+10:00",
	    "boolean":true,
	    "numeric":99.9,
	    "object":{
	      "string":"Ullrich",
	      "array":[3428,7389,5166,5823,3566,6086,3087,7690,6374,4531,6019,9722,8793,6732,5264,9618,5843,6714,5160,4065,2102,4972,2778,6110,4357,4385,1296,7981,607,3104,4992,8207,7517,1932,8097,2626,5196,425,8803,4778,7814,5337,9467,200,3542,4001,5930,4646,7304,4033,4838,7539,648,7016,6377,7957,7411,4023,7105,3676,9195,2337,8259,9166,9972,4740,7705,5368,5815,2592,5569,4842,6577,3805,1473,8585,9371,8732,9491,3819,7517,3437,6342,3397,8603,5324,676,7922,813,9850,8032,9324,733,5436,2971,9878,1648,6248,2109,1422]
	    }
    }
   
 
  


