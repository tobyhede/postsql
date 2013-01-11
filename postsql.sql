
  -- CREATE TABLE "public"."things" (
  --   "id" int4 NOT NULL DEFAULT nextval('things_id_seq'::regclass),
  --   "created_at" timestamp(6) NOT NULL,
  --   "updated_at" timestamp(6) NOT NULL,
  --   "data" json NOT NULL,
  --   CONSTRAINT "things_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE
  -- );

 
  CREATE or REPLACE FUNCTION 
  json_string(data json, key text) RETURNS TEXT AS $$

    var ret = data;
    var keys = key.split('.')
    var len = keys.length;
    
    for (var i=0; i<len; ++i) {
      if (ret != undefined) ret = ret[keys[i]];
    }    
   
  
    if (ret != undefined) {
      ret = ret.toString();
    }

    return ret;

  $$ LANGUAGE plv8 IMMUTABLE STRICT;



  CREATE or REPLACE FUNCTION 
  json_int(data json, key text) RETURNS INT AS $$

    var ret = data;
    var keys = key.split('.')
    var len = keys.length;
    
    for (var i=0; i<len; ++i) {
      if (ret != undefined) ret = ret[keys[i]];
    }    
   
    ret = parseInt(ret);   
    if (isNaN(ret)) ret = null;

    return ret;

  $$ LANGUAGE plv8 IMMUTABLE STRICT;


  CREATE or REPLACE FUNCTION 
  json_int_array(data json, key text) RETURNS INT[] AS $$

    var ret = data;
    var keys = key.split('.')
    var len = keys.length;
    
    for (var i=0; i<len; ++i) {
      if (ret != undefined) ret = ret[keys[i]];
    }    
   
    if (! (ret instanceof Array)) {
      ret = [ret];
    }
    
    return ret;

  $$ LANGUAGE plv8 IMMUTABLE STRICT;




  CREATE or REPLACE FUNCTION 
  json_float(data json, key text) RETURNS DOUBLE PRECISION AS $$

    var ret = data;
    var keys = key.split('.')
    var len = keys.length;
    
    for (var i=0; i<len; ++i) {
      if (ret != undefined) ret = ret[keys[i]];
    }    
   
    ret = parseFloat(ret);   
    if (isNaN(ret)) ret = null;

    return ret;

  $$ LANGUAGE plv8 IMMUTABLE STRICT;



  CREATE or REPLACE FUNCTION 
  json_bool(data json, key text) RETURNS BOOLEAN AS $$

    var ret = data;
    var keys = key.split('.')
    var len = keys.length;
    
    for (var i=0; i<len; ++i) {
      if (ret != undefined) ret = ret[keys[i]];
    }    
   
    // if (ret != true || ret != false) ret = null;

    if (ret === true || ret === false) {    
      return ret;
    } 

    return null;

  $$ LANGUAGE plv8 IMMUTABLE STRICT;



  CREATE or REPLACE FUNCTION 
  json_date(data json, key text) RETURNS TIMESTAMP AS $$

    var ret = data;
    var keys = key.split('.')
    var len = keys.length;
    
    for (var i=0; i<len; ++i) {
      if (ret != undefined) ret = ret[keys[i]];
    }    

    //ret = Date.parse(ret)
    //if (isNaN(ret)) ret = null;
  
    ret = new Date(ret)
    if (isNaN(ret.getTime())) ret = null;

    return ret; 

  $$ LANGUAGE plv8 IMMUTABLE STRICT;




  CREATE or REPLACE FUNCTION 
  json_update(data json, value text) RETURNS BOOLEAN AS $$

    var data = data;
    var forUpdate = value;

    for (k in forUpdate) {
      if ( data.hasOwnProperty(k) ) {
        data[k] = forUpdate[k];
      }
    }    

    return true;

  $$ LANGUAGE plv8 STABLE STRICT;


  -- USAGE: UPDATE things SET data = json_add_to_set(data, 'object.list', '10');
  CREATE or REPLACE FUNCTION 
  json_push(data json, key text, value json) RETURNS JSON AS $$

    var data = data;
    var value = value;

    var keys = key.split('.')
    var len = keys.length;
      
    var last_field = data;
    var field = data;

    for (var i=0; i<len; ++i) {    
      last_field = field;    
      if (field) field = field[keys[i]];
    }    

    if (field) { 
      field.push(value)
    } else {      
      if (! (value instanceof Array)) {
        value = [value];
      }
      last_field[keys.pop()]= value;
    }

  return JSON.stringify(data);
   
  $$ LANGUAGE plv8 STABLE STRICT;

  



  -- USAGE: UPDATE things SET data = json_add_to_set(data, 'object.list', '10');
  CREATE or REPLACE FUNCTION 
  json_add_to_set(data json, key text, value json) RETURNS JSON AS $$

    var data = data;
    var value = value;

    var keys = key.split('.')
    var len = keys.length;
    
    var last_field = data;
    var field = data;

    for (var i=0; i<len; ++i) {
      last_field = field;    
      if (field) field = field[keys[i]];
    }    


    if (field && field.indexOf(value) == -1) {
      field.push(value)
    } else {
      if (! (value instanceof Array)) {
        value = [value];
      }
      last_field[keys.pop()]= value;
    }

  return JSON.stringify(data);
   
  $$ LANGUAGE plv8 STABLE STRICT;

  

  -- USAGE: UPDATE things SET data = json_add_to_set(data, 'object.list', '10');
  CREATE or REPLACE FUNCTION 
  json_pull(data json, key text, value json) RETURNS JSON AS $$

    var data = data;
    var value = value;

    var keys = key.split('.')
    var len = keys.length;
    
    var field = data;

    for (var i=0; i<len; ++i) {    
      if (field) field = field[keys[i]];
    }    

    if (field) {
      var idx = field.indexOf(value);
      
      if (idx != -1) {
        field.slice(idx);
      }      
    }


  return JSON.stringify(data);
   
  $$ LANGUAGE plv8 STABLE STRICT;





  CREATE or REPLACE FUNCTION 
  json_data(data json, fields text) RETURNS JSON AS $$

      var data = data;
  
      var _fields = fields.split(',');

      for (var key in data) {
        if (_fields.indexOf(key) == -1) delete data[key];        
      }
  
    return JSON.stringify(data);
   
  $$ LANGUAGE plv8 STABLE STRICT;


