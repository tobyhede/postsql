



// var json =  '{"uuid":"ba596c94-9e50-11e1-a50e-70cd60fffe0e","integer":10,"string":"Blick","date":"2012-05-11T15:42:15+10:00","boolean":true,"numeric":99.9,"object":{"string":"Ullrich","array":[3428,7389,5166,5823,3566,6086,3087,7690,6374,4531,6019,9722,8793,6732,5264,9618,5843,6714,5160,4065,2102,4972,2778,6110,4357,4385,1296,7981,607,3104,4992,8207,7517,1932,8097,2626,5196,425,8803,4778,7814,5337,9467,200,3542,4001,5930,4646,7304,4033,4838,7539,648,7016,6377,7957,7411,4023,7105,3676,9195,2337,8259,9166,9972,4740,7705,5368,5815,2592,5569,4842,6577,3805,1473,8585,9371,8732,9491,3819,7517,3437,6342,3397,8603,5324,676,7922,813,9850,8032,9324,733,5436,2971,9878,1648,6248,2109,1422]}}';


function test(ret) {
  
  var ret = ret.boolean;
  // console.log(ret);
  // console.log(ret == true);
  if (ret === true || ret === false) {    
    console.log("bool:"+ret);
  } else {
    console.log("null!");  
  }

  // if (ret != true || ret != false) {    
  //   console.log("null!");  
  // } else {    
  //   console.log("bool:"+ret);
  // }
}

test(JSON.parse('{"boolean":true}'));
test(JSON.parse('{"boolean":false}'));
test(JSON.parse('{"boolean":1}'));
test(JSON.parse('{"boolean":0}'));
test(JSON.parse('{"boolean":"true"}'));
test(JSON.parse('{"boolean":"false"}'));
test(JSON.parse('{"boolean":"100"}'));
  
  // var data ='{"count":[99], "date":"2012-05-08T15:42:15+10:00", "object": {"test":[10]}}';
  // var value = '99';
  // // var value = '99';
  // // var key = "object.vtha"
  // var key = "date"


  // var data = JSON.parse(data); 
  // var value = JSON.parse(value); 

  // var keys = key.split('.')
  // var len = keys.length;
  
  // var ret = data;

  //   // var ret = JSON.parse(data); 

  //   for (var i=0; i<len; ++i) {
  //     if (ret != null) ret = ret[keys[i]];
  //   }    

  //   //ret = Date.parse(ret)
  //   //if (isNaN(ret)) ret = null;
  
  //   ret = new Date(ret)
  //   if (isNaN(ret.getTime())) ret = null;

  //   console.log(ret);


    
    // for (var i=0; i<len; ++i) {    
    //   if (field) field = field[keys[i]];
    // }    

    // if (field) {
    //   var idx = field.indexOf(value);
    //   console.log(idx);
    //   if (idx != -1) {
    //     field = field.slice(idx,1);
    //     console.log(field);
    //   }      
    // }


    // for (var i=0; i<len; ++i) {    
    //   last_field = field;    
    //   if (field) field = field[keys[i]];
    // }    

    // if (field) { 
    //   field.push(value)
    // } else {      
    //   if (! (value instanceof Array)) {
    //     value = [value];
    //   }
    //   last_field[keys.pop()]= value;
    // }

  // for (var i=0; i<len; ++i) {
  //   last_field = field;    
  //   if (field) field = field[keys[i]];
  // }    

  // // if (field == null) field = last_field;

  // console.log(last_field)
  // console.log(field)



  //   field.push(value)  

  // if (field && field.indexOf(value) == -1) {
  //   field.push(value)
  // } else {
  //   if (! (value instanceof Array)) {
  //     value = [value];
  //   }

  //   last_field[keys.pop()]= value;
  // }

  // console.log(data)
