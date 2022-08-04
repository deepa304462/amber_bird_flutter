import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:path_provider/path_provider.dart';

enum APIVersion { V1, V2 }

enum RESTMethod { POST, PUT, DELETE, DOWNLOAD, GET, SEARCH, AUTH }

class ClientService {
  ClientService._();

  static String urlV2 =
      "https://api.to.diago-app.com/"; // DO NOT CHANGE, USE setUrl method from main.dart only.
  // static String urlV2 =
  //     "http://localhost:8080/"; // DO NOT CHANGE, USE setUrl method from main.dart only.
  // static String urlV2 =
  //     "http://192.168.43.155/"; // DO NOT CHANGE, USE setUrl method from main.dart only.

  static String url = "https://old.diago-app.com/";

  static Dio dio = new Dio();
  static DefaultCacheManager cacheManager = DefaultCacheManager();
  static String token = '';

  static setUrl({String? newUrl, required APIVersion ver}) {
    if (ver == APIVersion.V1) {
      url = newUrl!;
    } else if (ver == APIVersion.V2) {
      urlV2 = newUrl!;
    }
  }

  /***
   * pName is paramenter name, pValue is parament value,
   * path is servlet path
   */

  static Future<Response> getCustom({required String path}) async {
    return await dio.get(path);
  }

  static Future<Response> get(
      {required String path,
      String? id,
      APIVersion ver = APIVersion.V1}) async {
    return await _call(
        path: path, id: id, apiVersion: ver, method: RESTMethod.GET);
  }

  static Future<Response> delete(
      {required String path,
      required String id,
      APIVersion ver = APIVersion.V1}) async {
    return await _call(
        path: path, id: id, apiVersion: ver, method: RESTMethod.DELETE);
  }

  static Future<Response> post(
      {required String path,
      required Map<String, dynamic> payload,
      APIVersion ver = APIVersion.V1}) async {
    return await _call(
        path: path, payload: payload, apiVersion: ver, method: RESTMethod.POST);
  }

  static Future<Response> auth(
      {required String path,
      required Map<String, dynamic> payload,
      APIVersion ver = APIVersion.V1}) async {
    return await _call(
        path: path, payload: payload, apiVersion: ver, method: RESTMethod.AUTH);
  }

  static Future<Response> searchQuery(
      {required String path,
      required Map<String, dynamic> query,
      required String lang,
      APIVersion ver = APIVersion.V1}) async {
    return await _call(
        path: path,
        payload: query,
        apiVersion: ver,
        lang: lang,
        method: RESTMethod.SEARCH);
  }

  static _call(
      {required String path,
      Map<String, dynamic>? payload,
      String? id,
      APIVersion? apiVersion,
      String? lang,
      required RESTMethod method,
      int retry = 3}) async {
    var response;
    Map<String, dynamic> header = Map();
    if (apiVersion == APIVersion.V2 && method != RESTMethod.AUTH) {
      header['Authorization'] = 'Bearer ' + token;
    }
    header['diago-tag'] = 'fEC3wfDtpr/Gm43hdzFVifLj3IqlLAoXa2W/yyi5Ros=';
    try {
      switch (method) {
        case RESTMethod.GET:
          response = await dio.get(
              (apiVersion == APIVersion.V1 ? url : urlV2) + path + '/$id',
              options: Options(headers: header));
          return response;
        case RESTMethod.POST:
        case RESTMethod.AUTH:
          response = await dio.post(
              (apiVersion == APIVersion.V1 ? url : urlV2) + path,
              data: payload,
              options: Options(headers: header));
          return response;
        case RESTMethod.SEARCH:
          Map<String, dynamic> queryMap = Map<String, dynamic>();
          queryMap['query'] = jsonEncode(payload);
          if (lang!.isNotEmpty) {
            queryMap['ln'] = lang;
          }
          response = await dio.get(
              (apiVersion == APIVersion.V1 ? url : urlV2) + path,
              queryParameters: queryMap,
              options: Options(headers: header));
          return response;
        case RESTMethod.PUT:
          response = await dio.put(
              (apiVersion == APIVersion.V1 ? url : urlV2) + path + '/$id',
              data: payload,
              options: Options(headers: header));
          return response;
        case RESTMethod.DELETE:
          response = await dio.delete(
              (apiVersion == APIVersion.V1 ? url : urlV2) + path + '/$id',
              options: Options(headers: header));
          return response;
        case RESTMethod.DOWNLOAD:
          throw Exception('no supported');
          break;
      }
    } catch (e) {
      DioError error = e as DioError;
      if (error.response?.statusCode == 429 && retry > 0) {
        return await _call(
            path: path,
            payload: payload,
            method: method,
            apiVersion: apiVersion,
            lang: lang,
            retry: --retry);
      } else {
        throw e;
      }
      throw e;
    }
  }

  static Future<Response> Put(
      {required String path,
      required String id,
      required Map<String, dynamic> payload,
      APIVersion ver = APIVersion.V1}) async {
    return await _call(
        payload: payload,
        id: id,
        path: path,
        apiVersion: ver,
        method: RESTMethod.PUT);
  }

  static Future<Response> postFile(
      {required File file,
      required String filePath,
      required Map<String, dynamic> payload,
      APIVersion ver = APIVersion.V1}) async {
    FormData formData = new FormData.fromMap({
      'data': jsonEncode(payload),
      "files": await MultipartFile.fromFile(file.path,
          filename: file.path
              .substring(file.path.lastIndexOf("/") + 1, file.path.length)),
    });

    try {
      //404
      return await dio.post((ver == APIVersion.V1 ? url : urlV2) + 'file',
          data: formData, options: Options(contentType: 'multipart/form-data'));
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.error.toString().isNotEmpty) {
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.message);
      }
    }
    return Future.value(null);
  }

  static Future<File> downloadFileFromUrl(
      {required String path,
      required String id,
      APIVersion ver = APIVersion.V1}) async {
    File file = await cacheManager.getSingleFile(id);
    // ignore: unnecessary_null_comparison
    if (file == null) {
      var request =
          await dio.get((ver == APIVersion.V1 ? url : urlV2) + path + '/$id',
              options: Options(
                responseType: ResponseType.bytes,
                followRedirects: false,
              ));
      var response = await request.data;
      String dir = (await getApplicationDocumentsDirectory()).path;

      file = File('$dir/$id' + '.png');
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response);
      await raf.close();
      await cacheManager.putFile(id, file.readAsBytesSync());
    }

    return file;
  }
}

String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;

Dio _dio = Dio();

Future getReverseGeocodingGivenLatLngUsingMapbox(LatLng latLng) async {
  String query = '${latLng.longitude},${latLng.latitude}';
  String url = '$baseUrl/$query.json?access_token=$accessToken';
  url = Uri.parse(url).toString();
  print(url);
  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    return responseData.data;
  } catch (e) {
    // final errorMessage = DioExceptions.fromDioError(e as DioError).toString();
    print(e);
  }
}
