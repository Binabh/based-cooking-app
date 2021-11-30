import 'dart:io';

import 'package:based_cooking/constants/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class BaseRepository {
  var options = BaseOptions(
    connectTimeout: 20000,
    receiveTimeout: 20000,
  );
  late Dio dio;
  BaseRepository() {
    dio = Dio(options);
    dio.interceptors.add(DioCacheManager(CacheConfig(baseUrl: "")).interceptor);
  }
  Future<Response> getDataFromServer(String url,
      {Map<String, dynamic>? params, bool forceRefresh = false}) async {
    Response? result;
    try {
      result = await dio.get(
        ApiEndpoint.apiBaseUrl + url,
        queryParameters: params,
        options: buildCacheOptions(const Duration(days: 1),
            forceRefresh: forceRefresh),
      );
      return result;
    } on DioError catch (e) {
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
    } on DioError catch (e) {
      return false;
    }
  }
}
