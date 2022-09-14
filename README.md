Flutter Server-Sent Events client

## Getting started

Import

```dart
import 'package:flutter_sse/flutter_sse.dart';
```

## Usage

Example

```dart
final SSEClient client = SSEClient(url: "your sse endpoint");

client.subscribe();
client.stream.listen((event) {
  /// ...
});
```
