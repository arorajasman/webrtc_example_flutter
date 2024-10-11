import 'package:flutter/material.dart';
import 'package:webrtc_example_flutter/services/webrtc/peer_connection.dart';
import 'package:webrtc_example_flutter/services/webrtc/signaling.dart';

class AudioCallPage extends StatefulWidget {
  const AudioCallPage({super.key});

  @override
  _AudioCallPageState createState() => _AudioCallPageState();
}

class _AudioCallPageState extends State<AudioCallPage> {
  final PeerConnection _peerConnection = PeerConnection();
  final Signaling _signaling = Signaling();

  @override
  void initState() {
    super.initState();
    _signaling.connect('wss://your-signaling-server.com');
    _peerConnection.init();

    _signaling.onOffer = (offer) async {
      await _peerConnection.setRemoteDescription(offer);
      await _peerConnection.createAnswer();
    };

    _signaling.onAnswer = (answer) async {
      await _peerConnection.setRemoteDescription(answer);
    };

    _signaling.onCandidate = (candidate) {
      _peerConnection.addCandidate(candidate);
    };

    _peerConnection.onRemoteStream = (stream) {
      // Handle remote stream (play audio, etc.)
    };
  }

  @override
  void dispose() {
    _peerConnection.dispose();
    _signaling.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Call')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _peerConnection.createOffer();
            },
            child: Text('Start Call'),
          ),
          ElevatedButton(
            onPressed: () {
              // Accept call
            },
            child: Text('Accept Call'),
          ),
          ElevatedButton(
            onPressed: () {
              // End call
            },
            child: Text('End Call'),
          ),
        ],
      ),
    );
  }
}
