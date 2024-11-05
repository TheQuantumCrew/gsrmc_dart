import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:simple_remote_config/src/simple_remote_config_exception.dart';

/// A [SimpleRemoteConfig] class that fetches a JSON config from a URL and
/// provides a way to access the config values.
class SimpleRemoteConfig {
  SimpleRemoteConfig({Client? client}) : _client = client ?? Client();

  final Client _client;

  /// In-memory cache for the config values.
  final _inMemoryCachedConfig = <String, dynamic>{};

  /// Fetches the config from the given URL and stores it in the in-memory cache.
  ///
  /// *Parameters:*
  ///
  /// [configUrl] - The URL to fetch the config from.
  ///
  ///
  /// *Exceptions:*
  ///
  /// Throws a [SimpleRemoteConfigException] if the request fails, no connection, invalid json config format, etc...
  Future<void> initilize({required String configUrl}) {
    return _initilize(configUrl: configUrl);
  }

  Future<void> _initilize({required String configUrl}) async {
    try {
      final response = await _client.get(Uri.parse(configUrl));
      if (response.statusCode == 200) {
        final json = response.body;
        final config = jsonDecode(json) as Map<String, dynamic>;
        config.forEach((key, value) {
          _inMemoryCachedConfig[key] = value;
        });
      } else {
        throw Exception('Failed to load remote config');
      }
    } catch (e) {
      throw SimpleRemoteConfigException(
          message: switch (e) {
        SocketException() => 'No internet connection',
        FormatException() => 'Invalid remote config format',
        _ => 'Error when handling: $e',
      });
    }
  }

  /// Returns the value of the given key from the in-memory cache.
  ///
  /// *Parameters:*
  ///
  /// [key] - The key to get the value for.
  ///
  /// [defaultValue] - The default value to return if the key is not found in the cache.
  ///
  /// Returns:
  ///
  /// The value of the given key from the in-memory cache, or the default value if the key is not found.
  ///
  /// Example:
  ///
  /// ```dart
  /// final config = SimpleRemoteConfig();
  /// await config.initilize(configUrl: 'http://example.com/config'); // { "key1": "value1", "key2": true}
  ///
  /// final value = config.get<String>('key1');
  /// print(value); // value1
  ///
  /// final value2 = config.get<bool>('key2');
  /// print(value2); // true
  ///
  /// final value3 = config.get<String>('key3');
  /// print(value3); // null
  ///
  /// final value4 = config.get<String>('key3, defaultValue: 'default');
  /// print(value4); // default
  /// ```
  T? get<T>(String key, {T? defaultValue}) {
    final value = _get<T>(key);
    return value ?? defaultValue;
  }

  T? _get<T>(String key) {
    return _inMemoryCachedConfig[key] as T?;
  }
}
