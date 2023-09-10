import 'dart:convert';
import 'dart:io';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

enum _APIVersion { V1, V2 }

enum Environment { dev, prod }

enum RESTMethod { POST, PUT, DELETE, DOWNLOAD, GET, SEARCH, AUTH }

enum dealName {
  FLASH,
  SALES,
  WEEKLY_DEAL,
  SUPER_DEAL,
  ONLY_COIN_DEAL,
  EXCLUSIVE_DEAL,
  MEMBER_DEAL,
  PRIME_MEMBER_DEAL,
  CUSTOM_RULE_DEAL
}

enum memberShipType { Paid, Platinum, Gold, Silver, No_Membership }

enum multiProductName { COMBO, BUNDLE, COLLECTION, STORIES }

class ClientService {
  ClientService._();

  static String urlV2 =
      "https://api.to.diago-app.com/"; // DO NOT CHANGE, USE setUrl method from main.dart only.
  // static String urlV2 =
  //     "://localhost:8080/"; // DO NOT CHANGE, USE setUrl method from main.dart only.
  // static String urlV2 =
  //     "://192.168.43.155/"; // DO NOT CHANGE, USE setUrl method from main.dart only.

  static String url = "https://prod.sbazar.app/";
  static String solrUrl = "https://search.sbazar.app/";

  static String cdnUrl = "https://cdn2.sbazar.app/";
  static String downloadUrl = "https://prod.sbazar.app/fileStorage/download/";
  static Dio dio = Dio();
  static DefaultCacheManager cacheManager = DefaultCacheManager();
  static String token = '';

  static setUrl({String? newUrl, required _APIVersion ver}) {
    if (ver == _APIVersion.V1) {
      url = newUrl!;
    } else if (ver == _APIVersion.V2) {
      urlV2 = newUrl!;
    }
  }

  static setEnv({required Environment env}) {
    if (env == Environment.dev) {
      url = "https://prod.sbazar.app/";
      downloadUrl = "https://prod.sbazar.app/fileStorage/download/";
      solrUrl = "https://search.sbazar.app/";
    } else if (env == Environment.prod) {
      url = "https://prod-api.sbazar.app/";
      solrUrl = "https://search-prod.sbazar.app";
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
      // ignore: library_private_types_in_public_api
      _APIVersion ver = _APIVersion.V1}) async {
    return await _call(
        path: path, id: id, apiVersion: ver, method: RESTMethod.GET);
  }

  static Future<Response> delete(
      {required String path,
      required String id,
      _APIVersion ver = _APIVersion.V1}) async {
    return await _call(
        path: path, id: id, apiVersion: ver, method: RESTMethod.DELETE);
  }

  static Future<Response> post(
      {required String path,
      required Map<String, dynamic> payload,
      String payloadAsString = '',
      _APIVersion ver = _APIVersion.V1}) async {
    if (payloadAsString != '') {
      return await _call(
          path: path,
          id: payloadAsString,
          apiVersion: ver,
          method: RESTMethod.POST);
    } else {
      return await _call(
          path: path,
          payload: payload,
          apiVersion: ver,
          method: RESTMethod.POST);
    }
  }

  static Future<Response> auth(
      {required String path,
      required Map<String, dynamic> payload,
      _APIVersion ver = _APIVersion.V1}) async {
    return await _call(
        path: path, payload: payload, apiVersion: ver, method: RESTMethod.AUTH);
  }

  static Future<Response> searchQuery(
      {required String path,
      required Map<String, dynamic> query,
      required String lang,
      _APIVersion ver = _APIVersion.V1}) async {
    return await _call(
        path: path,
        payload: query,
        apiVersion: ver,
        lang: lang,
        method: RESTMethod.SEARCH);
  }

  static _getTitleForm(String queryData) {
    queryData = queryData.toLowerCase();
    final whitespaceRE = RegExp(r"\s+");
    queryData = queryData.replaceAll(whitespaceRE, " ").trim();
    List<String> queryBreakDown = queryData.split(' ');
    return CodeHelp.titleCase(queryBreakDown[0]);
  }

  static _whileCardQueryFormat(String queryData) {
    queryData = queryData.toLowerCase();
    final whitespaceRE = RegExp(r"\s+");
    queryData = queryData.replaceAll(whitespaceRE, " ").trim();
    List<String> queryBreakDown = queryData.split(' ');
    return '*${queryBreakDown.join('**')}*';
  }

  static Future<Response> solrSearch(
      {required String path,
      required String queryData,
      _APIVersion ver = _APIVersion.V1}) async {
    var response;
    Map<String, dynamic> header = Map();
    // var method = RESTMethod.GET;
    header['diago-tag'] = 'fEC3wfDtpr/Gm43hdzFVifLj3IqlLAoXa2W/yyi5Ros=';
    try {
      //https://search.sbazar.app/product/select?indent=true&q.op=OR&q=name:*Shan*&fq=indexData:*shan**masala*
      //
      var rng = Random();
      // for (var i = 0; i < 10; i++) {
      // print(rng.nextInt(100));
      // }
      response = await dio.get(
          '${solrUrl}${path}/select?indent=true&q.op=OR&q=indexData:${_whileCardQueryFormat(queryData)}&sort=random_${rng.nextInt(100)}+desc',
          options: Options(headers: header));
      return response;
    } catch (e) {
      print(url + path);
      DioError error = e as DioError;
      if (error.response?.statusCode == 401) {
        return error.response!;
      } else {
        throw e;
      }
    }
  }

  static _call(
      {required String path,
      Map<String, dynamic>? payload,
      String? id,
      _APIVersion? apiVersion,
      String? lang,
      required RESTMethod method,
      int retry = 3}) async {
    var response;
    Map<String, dynamic> header = Map();
    if (method != RESTMethod.AUTH && token.isNotEmpty) {
      header['Authorization'] = 'Bearer $token';
    }
    header['diago-tag'] = 'fEC3wfDtpr/Gm43hdzFVifLj3IqlLAoXa2W/yyi5Ros=';
    // log(jsonEncode(payload));
    try {
      switch (method) {
        case RESTMethod.GET:
          if (id != null && id != '') {
            response = await dio.get(
                '${apiVersion == _APIVersion.V1 ? url : urlV2}$path/$id',
                options: Options(headers: header));
          } else {
            response = await dio.get(
                '${apiVersion == _APIVersion.V1 ? url : urlV2}$path',
                options: Options(headers: header));
          }

          return response;
        case RESTMethod.POST:
        case RESTMethod.AUTH:
          if (id != null && id != '') {
            response = await dio.post(
                (apiVersion == _APIVersion.V1 ? url : urlV2) + path,
                data: id,
                options: Options(headers: header));
          } else {
            response = await dio.post(
                (apiVersion == _APIVersion.V1 ? url : urlV2) + path,
                data: payload,
                options: Options(headers: header));
          }

          return response;
        case RESTMethod.SEARCH:
          Map<String, dynamic> queryMap = Map<String, dynamic>();
          queryMap['query'] = jsonEncode(payload);
          if (lang!.isNotEmpty) {
            queryMap['locale'] = lang;
          }
          response = await dio.get(
              (apiVersion == _APIVersion.V1 ? url : urlV2) + path,
              queryParameters: queryMap,
              options: Options(headers: header));
          return response;
        case RESTMethod.PUT:
          response = await dio.put(
              '${apiVersion == _APIVersion.V1 ? url : urlV2}$path/$id',
              data: payload,
              options: Options(headers: header));
          return response;
        case RESTMethod.DELETE:
          response = await dio.delete(
              '${apiVersion == _APIVersion.V1 ? url : urlV2}$path/$id',
              options: Options(headers: header));
          return response;
        case RESTMethod.DOWNLOAD:
          throw Exception('no supported');
      }
    } catch (e) {
      print(url + path);
      DioError error = e as DioError;
      if (error.response?.statusCode == 429 && retry > 0) {
        return await _call(
            path: path,
            payload: payload,
            method: method,
            apiVersion: apiVersion,
            lang: lang,
            retry: --retry);
      } else if (error.response?.statusCode == 401) {
        return error.response;
      } else {
        return error.response;
        // throw e;
      }
    }
  }

  static Future<Response> Put(
      {required String path,
      required String id,
      required Map<String, dynamic> payload,
      _APIVersion ver = _APIVersion.V1}) async {
    return await _call(
        payload: payload,
        id: id,
        path: path,
        apiVersion: ver,
        method: RESTMethod.PUT);
  }

  static Future<Response> postFile(
      {required String path,
      required File file,
      required Map<String, dynamic> payload,
      _APIVersion ver = _APIVersion.V1}) async {
    String fileName = file.path.substring(file.path.lastIndexOf("/") + 1,
        file.path.length); //file.path.split('/').last;
    FormData formData = await FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path,
          filename: fileName, contentType: MediaType("image", "jpeg")),
      'payload': jsonEncode(payload)
    });
    try {
      //404
      return await dio.post('${url}$path/upload',
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
      _APIVersion ver = _APIVersion.V1}) async {
    File file = await cacheManager.getSingleFile(id);
    // ignore: unnecessary_null_comparison
    if (file == null) {
      var request =
          await dio.get('${ver == _APIVersion.V1 ? url : urlV2}$path/$id',
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

String baseUrl = 's://api.mapbox.com/geocoding/v5/mapbox.places';
String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;

Dio _dio = Dio();
