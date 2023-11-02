import 'dart:developer';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor implements InterceptorContract {
  Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));

  // @override
  // Future<BaseRequest> interceptRequest({required BaseRequest data}) async {
  //   logger.v("Requisição para: ${data.baseUrl}\n${data.headers}");
  //   return data;
  // }

  // @override
  // Future<ResponseData> interceptResponse({required ResponseData data}) async {
  //   if (data.statusCode ~/ 100 == 2) {
  //     logger.i(
  //         "Resposta de ${data.url}\n${data.headers}\n${data.statusCode}\n ${data.body}");
  //   } else {
  //     logger.e(
  //         "Resposta de ${data.url}\n${data.headers}\n${data.statusCode}\n ${data.body}");
  //   }
  //   return data;
  // }
  
  @override
  Future<bool> shouldInterceptRequest() async {
    return true;
  }
  
  @override
  Future<bool> shouldInterceptResponse() async {
    return true;
  }
  
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
     log("Requisição para: ${request.url}\n${request.headers}");
     return request;
  }
  
  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    if (response.statusCode ~/ 100 == 2) {
      log(
          "Resposta ${response.headers}\n${response.statusCode}");
    } else {
      log(
          "Resposta ${response.headers}\n${response.statusCode}");
    }
    return response;
  }
}
