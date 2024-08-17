import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class NetworkClient {
  // instantiate a object of type Network client accross all class instances
  // call upon the private constructor to build it
  static NetworkClient? _instance;
  late final PersistCookieJar _cookieJar;
  late final Dio _dio;

  Dio get dio => _dio;
  PersistCookieJar get cookieJar => _cookieJar;

  // return the instance of the object
  NetworkClient._internal();

  static Future<NetworkClient> getInstance() async {
    if (_instance == null) {
      _instance = NetworkClient._internal();
      await _instance!._setup();
    }
    return _instance!;
  }

  Future<void> _setup() async {
    _cookieJar = await _cookieJarSetup();
    _dio = _dioSetup(_cookieJar);
  }

  static Future<PersistCookieJar> _cookieJarSetup() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;

    PersistCookieJar cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage('$appDocPath/.cookies/'));

    return cookieJar;
  }

  static Dio _dioSetup(PersistCookieJar cookieJar) {
    Dio dio = Dio(BaseOptions(
        validateStatus: (status) => status != null && status < 600,
        headers: {'Content-Type': 'application/json'}));
    dio.interceptors.add(CookieManager(cookieJar));
    return dio;
  }
}
