PostSQL
====================================

Functions for transforming PostgreSQL and PL/v8 into a totally awesome JSON document store  


Requirements
------------------------------------

 * PostgreSQL 9.2 beta 
 * PL/V8 http://code.google.com/p/plv8js/wiki/PLV8


PG 9.2 gives you a JSON datatype, which will validate JSON automatically.

Any version of PG that supports PL/V8 can be used but the functions will need to be adapted to use TEXT instead of JSON types. Validations will also obviously need to be handled manually.



Background
------------------------------------

Initial work inspired by a demo by Andrew Dunstan
http://people.planetpostgresql.org/andrew/index.php?/archives/249-Using-PLV8-to-index-JSON.html

And this by @leinweber captures the grand vision 
http://ssql-pgaustin.herokuapp.com/#1






Details
-------------------------------------

  JSON Types need to be mapped into corresponding PG types 
  
  Number     => INT or DOUBLE PRECISION
  String     => TEXT
  Date       => TIMESTAMP
  Boolean    => BOOLEAN
  Array      => ARRAY of appropriate PG Type 
  Object     => 
  null       => NULL

   USING the following functions:
   
   Each function takes a JSON column and a field to access as string 
   Nested fields can be access as well eg "person.name"
  
     json_string
   
     json_int
  
     json_float
  
     json_bool
         literal js true will convert to PG true, other values are falsey
  
     json_datetime
         currently will convert any numeric value into a timestamp
  
     json_int_array (with others to come)
         will wrap an integer into an array as required
     
     json_push(column, field, json_value)
         Appends value to an array
         or if field is not present sets field to the array json_value
         UPDATE things SET data = json_add_to_set(data, 'array', '10');
         Will error if field is not an array.
  
     json_add_to_set(column, field, json_value)
         Appends value to an array only if its not in the array already
         or if field is not present sets field to the array json_value
         UPDATE things SET data = json_add_to_set(data, 'object.array', '10');
         Will error if field is not an array.
  

  SAMPLE DATA
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
   
  
  Using the correctly typed accessor allows PG's normal operators to JUST WORK. 
  
     SELECT id, json_string(data,'name') FROM things WHERE json_string(data,'name') LIKE 'G%';
     SELECT id, json_int(data,'count') FROM things WHERE json_int(data,'count') = 10;
  
     Including ARRAY operators and FUNCTIONS:
     SELECT id, (json_int_array(data,'object.list') FROM things WHERE 10 = ALL (json_int_array(data,'object.list'))
  
   Creating an index makes performance on-par with regular PG columnn data
  
     CREATE INDEX name_in_json ON things (json_string(data,'name'));

