import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb; // To check if it's web
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart'; // For Web support

class Signaling {
  late WebSocketChannel
      _channel; // Change IOWebSocketChannel to WebSocketChannel for cross-platform
  Function(RTCSessionDescription)? onOffer;
  Function(RTCSessionDescription)? onAnswer;
  Function(RTCIceCandidate)? onCandidate;

  void connect(String serverUrl) {
    if (kIsWeb) {
      // Use WebSocketChannel for Web
      _channel = WebSocketChannel.connect(Uri.parse(serverUrl));
    } else {
      // Use IOWebSocketChannel for native platforms
      _channel = IOWebSocketChannel.connect(serverUrl);
    }

    _channel.stream.listen((message) {
      var data = json.decode(message);
      switch (data['type']) {
        case 'offer':
          onOffer?.call(RTCSessionDescription(data['sdp'], 'offer'));
          break;
        case 'answer':
          onAnswer?.call(RTCSessionDescription(data['sdp'], 'answer'));
          break;
        case 'candidate':
          onCandidate?.call(RTCIceCandidate(
              data['candidate'], data['sdpMid'], data['sdpMLineIndex']));
          break;
      }
    });
  }

  void sendOffer(RTCSessionDescription description) {
    _channel.sink.add(json.encode({
      'type': 'offer',
      'sdp': description.sdp,
    }));
  }

  void sendAnswer(RTCSessionDescription description) {
    _channel.sink.add(json.encode({
      'type': 'answer',
      'sdp': description.sdp,
    }));
  }

  void sendCandidate(RTCIceCandidate candidate) {
    _channel.sink.add(json.encode({
      'type': 'candidate',
      'candidate': candidate.candidate,
      'sdpMid': candidate.sdpMid,
      'sdpMLineIndex': candidate.sdpMLineIndex,
    }));
  }

  void dispose() {
    _channel.sink.close();
  }
}
