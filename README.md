# Simple Remote Config

[![pub package](https://img.shields.io/pub/v/simple_remote_config.svg)](https://pub.dev/packages/simple_remote_config)
![cov](https://TheQuantumCrew.github.io/simple_remote_config/badges/coverage.svg)](https://github.com/TheQuantumCrew/simple_remote_config/actions)

A simple plugin for helping you to change your application's behaviors, settings,.. without updating the application via network JSON.

## Features

- Fetch Remote Config via network JSON.
- Cache in-memory configs
- Provide get data via key and default value when data isn't found.

You can get started by looking at the [example](example/lib/example.dart).

## Install

### Dart

```sh
dart pub add simple_remote_config
```

### Flutter

```sh
flutter pub add simple_remote_config
```

## First step

### Android

Don't forget to add network permission in the Android manifest (`AndroidManifest.xml`)

```xml
<manifest xmlns:android...>
 ...
 <uses-permission android:name="android.permission.INTERNET" />
 <application ...
</manifest>
```

### macOS

macOS apps must allow network access in the relevant \*.entitlements files.

```xml
<key>com.apple.security.network.client</key>
<true/>
```

## How to use

### Initialization

Create your `SimpleRemoteConfig` instance.

```dart
import 'package:simple_remote_config/simple_remote_config.dart';

final remoteConfig = SimpleRemoteConfig();
```

`SimpleRemoteConfig` has a param `Client` from `http` package so you can pass your custom `Client` object when create `SimpleRemoteConfig` instance.

```dart
import 'package:simple_remote_config/simple_remote_config.dart';
import 'package:http/http.dart' as http;

final client = http.Client();

final remoteConfig = SimpleRemoteConfig(client: client);
```

### Fetch remote config data

`SimpleRemoteConfig` provides `initilize` function and you must pass an url to start fetching remote config data from network.

_Remember: Url must return JSON format._

```dart
import 'package:simple_remote_config/simple_remote_config.dart';

final remoteConfig = SimpleRemoteConfig();

const configUrl = "https://dungngminh.github.io/remote_config/test.json";

await remoteConfig.initilize(configUrl: configUrl);
```

### Get data from remote

`SimpleRemoteConfig` fetchs data in JSON format, data is returned in key-value format, you can `key` to get `value` via `get` function and type `T` you need (`dynamic` by default). `SimpleRemoteConfig` will return `value` from `key` that you pass and correct type `T`.

Example JSON format:

```json
{
    "key1": true, // boolean
    "key2": 10, // int
    "key3": "value from key 3" // string
}
```

And `get` data:

```dart
final valueKey1 = remoteConfig.get<bool>('key1');
print(valueKey1); // true

final valueKey2 = remoteConfig.get<int>('key2');
print(valueKey2); // 10

final valueKey3 = remoteConfig.get<String>('key3');
print(valueKey3); // value from key 3
```

If provided `key` is not found or provided `T` is incorrect, `get` will return `null`.

```dart
final valueKey1 = remoteConfig.get<String>('key1');
print(valueKey1); // null
```

You can pass `defaultValue` when `get` returns `null`.

```dart
final valueKey1 = remoteConfig.get<String>('key1', defaultValue: 'this is default value');
print(valueKey1); // this is default value
```

## Happy coding

That's all for now! Want a feature? Found a bug? Create an [issue](https://github.com/TheQuantumCrew/simple_remote_config/issues/new)!
