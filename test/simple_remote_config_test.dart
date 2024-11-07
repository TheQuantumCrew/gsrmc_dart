import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:simple_remote_config/src/simple_remote_config.dart';
import 'package:simple_remote_config/src/simple_remote_config_exception.dart';
import 'package:test/test.dart';

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

    test(
        'initialize successfully loads config and return null when pass wrong type T',
        () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"key1": "value1", "key2": true}', 200);
      });
      final config = SimpleRemoteConfig(client: mockClient);

      await config.initilize(configUrl: 'http://example.com/config');

      expect(config.get<bool>('key1'), null);
      expect(config.get<String>('key2'), null);
    });

    test(
        'initialize successfully loads config and '
        'return null when value of provided key is not found', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"key1": "value1", "key2": true}', 200);
      });
      final config = SimpleRemoteConfig(client: mockClient);

      await config.initilize(configUrl: 'http://example.com/config');

      expect(config.get<String>('key3'), null);
    });

    test(
        'initialize successfully loads config and '
        'return defaultValue when value of provided key is not found',
        () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"key1": "value1", "key2": true}', 200);
      });
      final config = SimpleRemoteConfig(client: mockClient);

      await config.initilize(configUrl: 'http://example.com/config');

      expect(config.get<String>('key3', defaultValue: 'defaultValue of key3'),
          'defaultValue of key3');
    });

    test(
        'initialize successfully loads config, '
        'return provided default value when provided type is incorrect',
        () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"key1": "value1", "key2": true}', 200);
      });
      final config = SimpleRemoteConfig(client: mockClient);

      await config.initilize(configUrl: 'http://example.com/config');

      expect(config.get<bool>('key1', defaultValue: false), false);
    });

    test('initialize throws exception on non-200 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });
      final config = SimpleRemoteConfig(client: mockClient);

      expect(
        () async =>
            await config.initilize(configUrl: 'http://example.com/config'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'description',
            contains('Failed to load remote config'))),
      );
    });

    test(
        'initialize with invalid network JSON throws SimpleRemoteConfigException on FormatException',
        () async {
      final mockClient = MockClient((request) async {
        return http.Response('Invalid JSON', 200);
      });
      final config = SimpleRemoteConfig(client: mockClient);

      expect(
        () async =>
            await config.initilize(configUrl: 'http://example.com/config'),
        throwsA(isA<SimpleRemoteConfigException>()
            .having((e) => e.message, 'message', 'Invalid remote config')),
      );
    });

    test(
        'initialize with invalid config url throws SimpleRemoteConfigException on FormatException',
        () async {
      final mockClient = MockClient((request) async {
        return http.Response('Invalid JSON', 200);
      });
      final config = SimpleRemoteConfig(client: mockClient);

      expect(
        () async => await config.initilize(configUrl: 'example.com/config'),
        throwsA(isA<SimpleRemoteConfigException>()
            .having((e) => e.message, 'message', 'Invalid remote config')),
      );
    });
  });
}
