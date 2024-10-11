import 'package:flutter_webrtc/flutter_webrtc.dart';

class PeerConnection {
  late RTCPeerConnection _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  Function(MediaStream)? onRemoteStream;

  Future<void> init() async {
    // Create RTC configuration
    Map<String, dynamic> config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };

    // Initialize peer connection
    _peerConnection = await createPeerConnection(config);

    // Handle local and remote stream
    _peerConnection.onAddStream = (MediaStream stream) {
      onRemoteStream?.call(stream);
      _remoteStream = stream;
    };

    _peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      // Send candidate to remote peer through signaling server
      // signaling.sendCandidate(candidate);
    };

    // Get the user audio stream
    _localStream = await navigator.mediaDevices
        .getUserMedia({'audio': true, 'video': false});
    _peerConnection.addStream(_localStream!);
  }

  Future<void> createOffer() async {
    RTCSessionDescription description = await _peerConnection.createOffer();
    await _peerConnection.setLocalDescription(description);
    // Send offer to remote peer
    // signaling.sendOffer(description);
  }

  Future<void> createAnswer() async {
    RTCSessionDescription description = await _peerConnection.createAnswer();
    await _peerConnection.setLocalDescription(description);
    // Send answer to remote peer
    // signaling.sendAnswer(description);
  }

  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    await _peerConnection.setRemoteDescription(description);
  }

  Future<void> addCandidate(RTCIceCandidate candidate) async {
    await _peerConnection.addCandidate(candidate);
  }

  void dispose() {
    _peerConnection.close();
    _localStream?.dispose();
    _remoteStream?.dispose();
  }
}
