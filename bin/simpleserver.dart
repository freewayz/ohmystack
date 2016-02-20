import 'dart:io';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';
import 'package:logging_handlers/server_logging_handlers.dart';
import 'package:oh_my_stack/ohmystackapi.dart';


const String _apiRoot = "/api";
const String _apiPrefix = "/api";


final  ApiServer _apiServer = new ApiServer(apiPrefix : _apiPrefix, prettyPrint: true);

main() async{
   
   Logger.root.level = Level.ALL;
   Logger.root.onRecord.listen(new SyncFileLoggingHandler('stack_api.log'));
   
   if(stdout.hasTerminal){
       Logger.root.onRecord.listen(new LogPrintHandler());
       
   }
   
   //let register the api to the api server
    _apiServer.addApi(new OhMyStackAPI());
    _apiServer.enableDiscoveryApi();
    
    HttpServer server  = await HttpServer.bind(InternetAddress.ANY_IP_V4, 8080);
    server.listen(_apiServer.httpRequestHandler);
    //to confirm where the server is ruuning
    print("Server is running on http://${server.address.host}:${server.port}");
}