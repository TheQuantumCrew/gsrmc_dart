import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:simple_remote_config/src/simple_remote_config.dart';
import 'package:simple_remote_config/src/simple_remote_config_exception.dart';
import 'package:test/test.dart';

void main() {
  group('SimpleRemoteConfig', () {
    group('initialize successfully', () {
      test('should return correct value when correct method is used', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
              '{"key1": "value1", "key2": true, "key3": 1.0, "key4": 100, "key5": { "key6": "value5" }}',
              200);
        });
        final config = SimpleRemoteConfig(client: mockClient);

        await config.initilize(configUrl: 'http://example.com/config');

        expect(config.getString('key1'), 'value1');
        expect(config.getBool('key2'), true);
        expect(config.getDouble('key3'), 1.0);
        expect(config.getInt('key4'), 100);
        expect(config.getMap('key5'), {'key6': 'value5'});
      });

      test('should return null when use wrong method to get value', () async {
        final mockClient = MockClient((request) async {
          return http.Response(
              '{"key1": "value1", "key2": true, "key3": 1.0, "key4": 100, "key5": { "key6": "value5" }}',
              200);
        });
        final config = SimpleRemoteConfig(client: mockClient);

        await config.initilize(configUrl: 'http://example.com/config');

        expect(config.getBool('key1'), null);
        expect(config.getString('key2'), null);
        expect(config.getString('key3'), null);
        expect(config.getDouble('key4'), null);
        expect(config.getInt('key5'), null);
      });

      test('should return null when value of provided key is not found',
          () async {
        final mockClient = MockClient((request) async {
          return http.Response(
              '{"key1": "value1", "key2": true, "key3": 1.0, "key4": 100, "key5": { "key6": "value5" }}',
              200);
        });
        final config = SimpleRemoteConfig(client: mockClient);

        await config.initilize(configUrl: 'http://example.com/config');

        expect(config.getBool('key7'), null);
        expect(config.getString('key7'), null);
        expect(config.getDouble('key7'), null);
        expect(config.getInt('key7'), null);
        expect(config.getMap('key7'), null);
      });

      test('should return defaultValue when value of provided key is not found',
          () async {
        final mockClient = MockClient((request) async {
          return http.Response(
              '{"key1": "value1", "key2": true, "key3": 1.0, "key4": 100, "key5": { "key6": "value5" }}',
              200);
        });
        final config = SimpleRemoteConfig(client: mockClient);

        await config.initilize(configUrl: 'http://example.com/config');

        expect(config.getBool('key7', defaultValue: false), false);
        expect(config.getString('key7', defaultValue: 'key 7 value'),
            'key 7 value');
        expect(config.getDouble('key7', defaultValue: 0.0), 0.0);
        expect(config.getInt('key7', defaultValue: 1), 1);
        expect(config.getMap('key7', defaultValue: {}), {});
      });

      test('should return defaultValue when wrong type method is used',
          () async {
        final mockClient = MockClient((request) async {
          return http.Response(
              '{"key1": "value1", "key2": true, "key3": 1.0, "key4": 100, "key5": { "key6": "value5" }}',
              200);
        });
        final config = SimpleRemoteConfig(client: mockClient);

        await config.initilize(configUrl: 'http://example.com/config');

        expect(config.getBool('key1', defaultValue: false), false);
        expect(config.getDouble('key1', defaultValue: 0.0), 0.0);
        expect(config.getInt('key1', defaultValue: 1), 1);
        expect(config.getMap('key1', defaultValue: {}), {});
      });

      test(
          'should return provided default value when wrong type method is incorrect',
          () async {
        final mockClient = MockClient((request) async {
          return http.Response(
              '{"key1": "value1", "key2": true, "key3": 1.0, "key4": 100, "key5": { "key6": "value5" }}',
              200);
        });
        final config = SimpleRemoteConfig(client: mockClient);

        await config.initilize(configUrl: 'http://example.com/config');

        expect(config.getBool('key1', defaultValue: false), false);
        expect(config.getDouble('key1', defaultValue: 0.0), 0.0);
        expect(config.getInt('key1', defaultValue: 1), 1);
        expect(config.getMap('key1', defaultValue: {}), {});
      });
    });

    group('initialize failed', () {
      test('should throw exception on non-200 response', () async {
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
          'should throw SimpleRemoteConfigException on FormatException when response is invalid network JSON',
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
          'should throw SimpleRemoteConfigException on FormatException when invalid config url is provided',
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
  });
}
