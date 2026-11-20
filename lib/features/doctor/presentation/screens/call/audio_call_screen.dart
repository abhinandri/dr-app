import 'dart:async';

import 'package:dr_app/core/constants/agora_constants.dart';
import 'package:dr_app/core/services/agora_service.dart';
import 'package:flutter/material.dart';

class AudioCallScreen extends StatefulWidget {
  final String appointmentId;

  const AudioCallScreen({
    super.key,
    required this.appointmentId,
  });

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  Timer? _callTimer;
  int _callSeconds = 0;

  final AgoraService _agoraService = AgoraService();
  bool _isJoined = false;
  bool _isMuted = false;
  int? _remoteUid;

  @override
  void initState() {
    super.initState();
    _startCall();
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    super.dispose();
  }

  String get _channelId => widget.appointmentId;

  static const String _token =
      '007eJxTYDi6UfbqtNd3l5YHSXFwfTu6Q4tBSHfD4tt31j7f+maC6HdRBYaURMNEU0NDExMT81QTC8vEpCRjM6NkSwtLs2TzlFQzwy/Kr7MaAhkZ1FQjWBkZIBDEF2HwDqxyMvPItagoLHHJjMxJi4rKNGZgAAD7riXV';

  Future<void> _startCall() async {
    try {
      final permission = await _agoraService.requestMicrophonePermission();

      if (!permission) return;

      await _agoraService.initialize(
        AgoraConstants.appId,
      );

      _agoraService.registerEventHandlers(
        onUserJoined: (remoteUid) {
          setState(() {
            _remoteUid = remoteUid;
          });
          _startTimer();
        },
        onUserOffline: (uid) {
          _callTimer?.cancel;
          setState(() {
            _remoteUid = null;
          });
        },
        onRemoteCameraChanged: (uid, state) {
          // Audio call doesn't use remote camera
        },
      );

      await _agoraService.joinAudioChannel(
        token: _token,
        channelId: _channelId,
        uid: 0,
      );

      setState(() {
        _isJoined = true;
      });
    } catch (e) {
      debugPrint(
        "Audio error: $e",
      );
    }
  }

  void _startTimer() {
    _callTimer?.cancel();

    _callSeconds = 0;

    _callTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;

        setState(() {
          _callSeconds++;
        });
      },
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Audio Call"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 55,
            child: Icon(
              Icons.person,
              size: 60,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _remoteUid != null ? "Connected" : "Calling...",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isJoined ? _formatDuration(_callSeconds) : '00:00',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Appointment ID:\n${widget.appointmentId}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: "mute",
                onPressed: () async {
                  _isMuted = !_isMuted;

                  await _agoraService.muteMicrophone(_isMuted);

                  setState(() {});
                },
                child: Icon(
                  _isMuted ? Icons.mic_off : Icons.mic,
                ),
              ),
              const SizedBox(width: 30),
              FloatingActionButton(
                heroTag: "end",
                backgroundColor: Colors.red,
                onPressed: () async {
                  await _agoraService.engine.leaveChannel();

                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.call_end,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
