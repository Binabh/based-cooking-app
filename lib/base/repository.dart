import 'dart:io';

import 'package:basedcooking/constants/api_endpoints.dart';
import 'package:dio/dio.dart';

class BaseRepository {
  var options = BaseOptions(
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  );
  late Dio dio;
  BaseRepository() {
    dio = Dio(options);
  }
  Future<Response> getDataFromServer(String url,
      {Map<String, dynamic>? params, bool forceRefresh = false}) async {
    Response? result;
    try {
      result = await dio.get(
        ApiEndpoint.apiBaseUrl + url,
        queryParameters: params,
      );
      return result;
    } on DioException catch (e) {
      print(e.message);
    }
    return result!;
  }

  Future<bool> getFileFromServer(String url,
      {Map<String, dynamic>? params, required String savePath}) async {
    try {
      Response result = await dio.get(
        ApiEndpoint.rawBaseUrl + url,
        queryParameters: params,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(result.data);
      await raf.close();
      return true;
    } on DioException catch (e) {
      print(e.toString());
      return false;
    }
  }
}
