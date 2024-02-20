import 'dart:developer';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:memo_webapi/helpers/globals.dart';

class LoggingInterceptor implements InterceptorContract {

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
     log("Requisição para: ${request.url}\n${request.headers}\n${request.method}");
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
    if (response.statusCode == 401 && response.statusCode == 403) {
      user = null;
      accessToken = null;
    }
    return response;
  }
}
