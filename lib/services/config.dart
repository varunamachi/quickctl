import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

typedef Decoder<T> = T Function(dynamic json);

class Config {
  static final Config _instance = Config._internal();

  Config._internal();

  factory Config() => Config._instance;

  Map<String, dynamic> cache = {};

  Future<dynamic> _getJson(String key) async {
    final sp = await SharedPreferences.getInstance();
    final data = sp.getString(key);
    if (data == null) {
      return null;
    }
    final mp = json.decode(data);
    return mp;
  }

  Future<bool> _setJson(String key, dynamic value) async {
    final sp = await SharedPreferences.getInstance();
    final str = json.encode(value);
    return await sp.setString(key, str);
  }

  Future<T?> getVal<T>(String key, Decoder<T> decoder) async {
    if (cache.containsKey(key)) {
      return cache[key] as T;
    }
    final jsonData = await _getJson(key);
    if (jsonData == null) {
      return null;
    }

    final val = decoder(jsonData);
    if (val == null) {
      return null;
    }
    cache[key] = val;
    return val;
  }

  Future<List<T>> getList<T>(String key, Decoder<T> decoder) async {
    if (cache.containsKey(key)) {
      return cache[key] as List<T>;
    }

    final jsonData = await _getJson(key);
    if (jsonData is! List) {
      return [];
    }
    final list = List<T>.from(jsonData.map((model) => decoder(model)));
    cache[key] = list;
    return list;
  }

  Future<bool> setVal<T>(String key, T val, {bool persist = true}) async {
    if (val == null) {
      return false;
    }
    if (persist) {
      if (!await _setJson(key, val)) {
        return false;
      }
    }
    cache[key] = val;
    return true;
  }

  Future<bool> remove<T>(String key) async {
    cache.remove(key);
    final sp = await SharedPreferences.getInstance();
    return await sp.remove(key);
  }

  Future<bool> clear() async {
    var result = false;
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.clear();
    } on Exception catch (e) {
      throw Exception("Could not clear storage: ${e.toString()}");
    }
    return result;
  }

  // Future<GlobalConfig> globalConfig() async {
  //   final config = await getVal("globalConfig",
  //       (o) => GlobalConfig.fromJson(o as Map<String, dynamic>));
  //   return config ?? GlobalConfig.defaults();
  // }

  // Future<bool> setGloablConfig(GlobalConfig config) async {
  //   return await setVal<GlobalConfig>("globalConfig", config);
  // }
}
