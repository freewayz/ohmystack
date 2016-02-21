library api;

import 'dart:io';
import 'dart:async';
import 'package:rpc/rpc.dart';


//let use this  response for testing that dart is working properly 
class KodingResponse{
    String message;
    KodingResponse();
}

class StackResponse{
    //for stack response we are returning a map value, which represent a json
    Map result;
    StackResponse();
}




@ApiClass(version : '1.0')
class OhMyStackAPI{
    
    @ApiMethod(path:"koding")
    KodingResponse testKodingVm(){
        return new KodingResponse()..message = "OhMyStackAPI is working on koding VM";
    }
    
    
    @ApiMethod(path:"koding")
    KodingResponse testKodingUser(String whoami){
        return new KodingResponse()..message = "Hello Geek ${whoami} this is koding hackthon";
        
    }
}

