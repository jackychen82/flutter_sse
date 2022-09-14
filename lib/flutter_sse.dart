library flutter_sse;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// [SSEClient]
class SSEClient {
  /// sse endpoint
  final String url;

  final http.Client _client = http.Client();

  final StreamController<String> _streamController = StreamController();

  Stream get stream => _streamController.stream;

  SSEClient({required this.url});

  /// subscribe to sse server
  void subscribe({Map<String, String>? header}) {
    var request = http.Request("GET", Uri.parse(url));

    header?.forEach((key, value) {
      request.headers[key] = value;
    });

    Future<http.StreamedResponse> response = _client.send(request);

    response.asStream().listen((resp) {
      resp.stream
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen(
        (data) {
          if (data.isNotEmpty) {
            _streamController.sink.add(data.replaceAll('data: ', ''));
          }
        },
        onError: (e) {
          _streamController.addError(e);
        },
      );
    }, onError: (e) {
      _streamController.addError(e);
    });
  }

  /// dispose
  void dispose() {
    _client.close();
    _streamController.close();
  }
}
