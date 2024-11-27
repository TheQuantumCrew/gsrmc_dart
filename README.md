# Simple Remote Config

[![pub package](https://img.shields.io/pub/v/simple_remote_config.svg)](https://pub.dev/packages/simple_remote_config)

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

`SimpleRemoteConfig` fetchs data in JSON format, data is returned in key-value format, you can `key` to get `value` via
get functions, currently `SimpleRemoteConfig` supports `String`, `int`, `double`, `bool`, `Map`.

````dart

Example JSON format:

```json
{
    "key1": true, // boolean
    "key2": 10, // int
    "key3": "value from key 3", // string,
    "key4": {
        "key4_1": "value from key 4_1",
        "key4_2": 20
    }, // map
    "key5": 10.5 // double
}
````

And get data:

```dart
final valueKey1 = remoteConfig.getBool('key1');
print(valueKey1); // true

final valueKey2 = remoteConfig.getInt('key2');
print(valueKey2); // 10

final valueKey3 = remoteConfig.getString('key3');
print(valueKey3); // value from key 3

final valueKey4 = remoteConfig.getMap('key4');
print(valueKey4); // {key4_1: value from key 4_1, key4_2: 20}

final valueKey5 = remoteConfig.getDouble('key5');
print(valueKey5); // 10.5
```

If provided `key` is not found or provided `T` is incorrect, get functions will return `null`.

```dart
final valueKey7 = remoteConfig.getString('key7');
print(valueKey7); // null
```

You can pass `defaultValue` when get functions returns `null`.

```dart
final valueKey7 = remoteConfig.getString('key7', defaultValue: 'this is default value');
print(valueKey7); // this is default value
```

## Get all data from remote

`SimpleRemoteConfig` provides `getAll` function to get all data from remote.

```dart
final allData = remoteConfig.getAll();
print(allData); /// {key1: true, key2: 10, key3: value from key 3, key4: {key4_1: value from key 4_1, key4_2: 20}, key5: 10.5}

```

## Happy coding

That's all for now! Want a feature? Found a bug? Create an [issue](https://github.com/TheQuantumCrew/simple_remote_config/issues/new)!
