import 'package:simple_remote_config/src/simple_remote_config.dart';
import 'package:simple_remote_config/src/simple_remote_config_exception.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:io';

void main() {
  group('SimpleRemoteConfig', () {
    test('initialize successfully loads config', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"key1": "value1", "key2": true}', 200);
      });
      final config = SimpleRemoteConfig(client: mockClient);

      await config.initilize(configUrl: 'http://example.com/config');

      expect(config.get<String>('key1'), 'value1');
      expect(config.get<bool>('key2'), true);
    });

    test('initialize throws exception on non-200 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });
      final config = SimpleRemoteConfig(client: mockClient);

      expect(
        () async => await config.initilize(configUrl: 'http://example.com/config'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'description', contains('Failed to load remote config'))),
      );
    });

    test('initialize throws SimpleRemoteConfigException on SocketException', () async {
      final mockClient = MockClient((request) async {
        throw SocketException('No internet connection');
      });
      final config = SimpleRemoteConfig(client: mockClient);

      expect(
        () async => await config.initilize(configUrl: 'http://example.com/config'),
        throwsA(isA<SimpleRemoteConfigException>().having((e) => e.message, 'message', 'No internet connection')),
      );
    });

    test('initialize throws SimpleRemoteConfigException on FormatException', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Invalid JSON', 200);
      });
      final config = SimpleRemoteConfig(client: mockClient);

      expect(
        () async => await config.initilize(configUrl: 'http://example.com/config'),
        throwsA(isA<SimpleRemoteConfigException>().having((e) => e.message, 'message', 'Invalid remote config format')),
      );
    });
  });
}
