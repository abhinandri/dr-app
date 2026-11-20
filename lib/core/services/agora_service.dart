import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraService {
  late final RtcEngine _engine;

  RtcEngine get engine => _engine;

  int getAgoraUid(String firebaseUid) {
  final uid = firebaseUid.hashCode & 0x7FFFFFFF;
  return uid == 0 ? 1 : uid;
}

  Future<void> muteMicrophone(bool mute) async {
  await _engine.muteLocalAudioStream(mute);
}

  Future<void> initialize(String appId) async {
    _engine = createAgoraRtcEngine();

    await _engine.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
  }
  
  Future<bool> requestMicrophonePermission() async {
  final status = await Permission.microphone.request();

  return status.isGranted;
}

  Future<bool> requestPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

return statuses[Permission.camera]?.isGranted == true &&
      statuses[Permission.microphone]?.isGranted == true;
  }
  

  Future<void> enableVideo() async {
    await _engine.enableVideo();
    await _engine.startPreview();
  }



  void registerEventHandlers({
  required void Function(int remoteUid) onUserJoined,
  required void Function(int remoteUid) onUserOffline,
  required void Function(int remoteUid, bool cameraOff) onRemoteCameraChanged,

}) {
  debugPrint('🔵 Registering Agora event handlers...');

  _engine.registerEventHandler(
    RtcEngineEventHandler(
      
      onJoinChannelSuccess: (connection, elapsed) {
        debugPrint('==============================');
        debugPrint('✅ AGORA JOIN SUCCESS');
        debugPrint('📡 Channel: ${connection.channelId}');
        debugPrint('👤 Local UID: ${connection.localUid}');
        debugPrint('⏱️ Elapsed: $elapsed ms');
        debugPrint('==============================');
      },
          onConnectionStateChanged: (connection, state, reason) {
      debugPrint('==============================');
      debugPrint('🔄 AGORA CONNECTION STATE');
      debugPrint('📡 Channel: ${connection.channelId}');
      debugPrint('🔗 State: $state');
      debugPrint('❓ Reason: $reason');
      debugPrint('==============================');
    },

    onError: (err, msg) {
      debugPrint('==============================');
      debugPrint('❌ AGORA ERROR');
      debugPrint('🔢 Error: $err');
      debugPrint('📝 Message: $msg');
      debugPrint('==============================');
    },

      onUserJoined: (connection, remoteUid, elapsed) {
        debugPrint('==============================');
        debugPrint('👤👤 REMOTE USER JOINED');
        debugPrint('📡 Channel: ${connection.channelId}');
        debugPrint('👤 Remote UID: $remoteUid');
        debugPrint('⏱️ Elapsed: $elapsed ms');
        debugPrint('==============================');

        onUserJoined(remoteUid);
      },

      onUserOffline: (connection, remoteUid, reason) {
        debugPrint('❌ REMOTE USER LEFT');
        debugPrint('👤 Remote UID: $remoteUid');
        debugPrint('📡 Channel: ${connection.channelId}');
        debugPrint('Reason: $reason');

        onUserOffline(remoteUid);
      },

      onRemoteVideoStateChanged: (
  connection,
  remoteUid,
  state,
  reason,
  elapsed,
) {
  debugPrint('📹 REMOTE VIDEO STATE CHANGED');
  debugPrint('👤 Remote UID: $remoteUid');
  debugPrint('📹 State: $state');
  debugPrint('❓ Reason: $reason');

  final cameraOff =
      state == RemoteVideoState.remoteVideoStateStopped ||
      state == RemoteVideoState.remoteVideoStateFrozen;

  onRemoteCameraChanged(remoteUid, cameraOff);
},
    ),
  );

  debugPrint('🟢 Agora event handlers registered');
}

  Future<void> joinChannel({
    required String token,
    required String channelId,
    required int uid,
  }) async {
    debugPrint('🚀 JOINING AGORA');
    debugPrint('📡 Channel: $channelId');
    debugPrint('👤 Requested UID: $uid');

    await _engine.joinChannel(
      token: token,
      channelId: channelId,
      uid: uid,
      options: const ChannelMediaOptions(),
    );
    debugPrint('✅ joinChannel() call completed');
  }

  Future<void> joinAudioChannel({
  required String token,
  required String channelId,
  required int uid,
}) async {
  debugPrint('🚀 JOINING AGORA AUDIO');
  debugPrint('📡 Channel: $channelId');
  debugPrint('👤 Requested UID: $uid');

  await _engine.joinChannel(
    token: token,
    channelId: channelId,
    uid: uid,
    options: const ChannelMediaOptions(
      publishMicrophoneTrack: true,
      publishCameraTrack: false,
      autoSubscribeAudio: true,
      autoSubscribeVideo: false,
    ),
  );

  debugPrint('✅ Audio joinChannel() call completed');
}
}