// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';

// import '../../../../../core/constants/agora_constants.dart';
// import '../../../../../core/services/agora_service.dart';

// class VideoCallScreen extends StatefulWidget {
//   final String appointment;
//   const VideoCallScreen({super.key, required this.appointment});

//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends State<VideoCallScreen> {
//   final AgoraService _agoraService = AgoraService();

//   int? _remoteUid;
//   bool _isJoined = false;
//   bool _isMuted = false;
//   bool _isCameraOff = false;

//   String? _callError;
//   bool _isLoading = true;

//   // TEMPORARY TEST TOKEN
//   // Don't commit this to GitHub.
//   static const String _token =
//       '007eJxTYGBK8d7UwpMie8H7mFbjdB5730qVM02LLBfKmYSdLvwsVKbAkJJomGhqaGhiYmKeamJhmZiUZGxmlGxpYWmWbJ6SambIKL8tqyGQkcFa6yADIxSC+CIMGW6ZESVBuc5heemBBblZjiVmXn4MDAAxmCEb';

//   // TEMPORARY TEST CHANNEL
//   // static const String _channelId = 'test_call_001';

//   String get _channelId => widget.appointment;

//   @override
//   void initState() {
//     super.initState();

//     debugPrint('🔥 Doctor VideoCallScreen opened');
//     debugPrint('📞 Appointment ID: ${widget.appointment}');
//     _startCall();
//   }

// //   Future<void> _startCall() async {
// //     try {
// //        setState(() {
// //       _isLoading = true;
// //       _callError = null;
// //     });

// //       // 1. Ask for camera and microphone permission
// //     final hasPermission=  await _agoraService.requestPermissions();

// //   if (!hasPermission) {
// //   if (!mounted) return;

// //   ScaffoldMessenger.of(context).showSnackBar(
// //     const SnackBar(
// //       content: Text(
// //         'Camera and microphone permissions are required for the call.',
// //       ),
// //     ),
// //   );

// //   return;
// // }
// //       // 2. Initialize Agora
// //       await _agoraService.initialize(
// //         AgoraConstants.appId,
// //       );

// //       // 3. Listen for other users joining/leaving
// //       _agoraService.registerEventHandlers(
// //         onUserJoined: (remoteUid) {
// //           setState(() {
// //             _remoteUid = remoteUid;
// //           });
// //         },
// //         onUserOffline: (remoteUid) {
// //           setState(() {
// //             _remoteUid = null;
// //           });
// //         },
// //       );

// //       // 4. Enable camera
// //       await _agoraService.enableVideo();

// //       // 5. Join Agora channel
// //       await _agoraService.joinChannel(
// //         token: _token,
// //         channelId: _channelId,
// //         uid: 0,
// //       );

// //       setState(() {
// //         _isJoined = true;
// //       });
// //     } catch (e) {
// //       debugPrint('Agora call error: $e');
// //     }
// //   }
//   Future<void> _startCall() async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _callError = null;
//       });

//       // 1. Request permissions
//       final hasPermission = await _agoraService.requestPermissions();

//       if (!hasPermission) {
//         throw Exception(
//           'Camera and microphone permissions are required.',
//         );
//       }

//       // 2. Initialize Agora
//       await _agoraService.initialize(
//         AgoraConstants.appId,
//       );

//       // 3. Register Agora events
//       _agoraService.registerEventHandlers(
//         onUserJoined: (remoteUid) {
//           if (!mounted) return;

//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (remoteUid) {
//           if (!mounted) return;

//           setState(() {
//             _remoteUid = null;
//           });
//         },
//       );

//       // 4. Enable video
//       await _agoraService.enableVideo();

//       // 5. Join channel
//       await _agoraService.joinChannel(
//         token: _token,
//         channelId: _channelId,
//         uid: 0,
//       );

//       if (!mounted) return;

//       setState(() {
//         _isJoined = true;
//         _isLoading = false;
//       });
//     } catch (e) {
//       debugPrint('❌ Agora call error: $e');

//       if (!mounted) return;

//       setState(() {
//         _isLoading = false;
//         _callError = 'Unable to start the call. Please try again.';
//       });
//     }
//   }

//   Future<void> _toggleMute() async {
//     await _agoraService.engine.muteLocalAudioStream(!_isMuted);

//     setState(() {
//       _isMuted = !_isMuted;
//     });
//   }

//   Future<void> _toggleCamera() async {
//     await _agoraService.engine.muteLocalVideoStream(!_isCameraOff);

//     setState(() {
//       _isCameraOff = !_isCameraOff;
//     });
//   }

//   @override
//   void dispose() {
//     _agoraService.engine.leaveChannel();
//     _agoraService.engine.release();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video Call'),
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : _callError != null
//               ? Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(
//                         Icons.error_outline,
//                         size: 48,
//                         color: Colors.red,
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         _callError!,
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: _startCall,
//                         child: const Text('Try Again'),
//                       ),
//                     ],
//                   ),
//                 )
//               : Stack(
//                   children: [
//                     // Remote user's video
//                     Positioned.fill(
//                       child: _remoteUid != null
//                           ? AgoraVideoView(
//                               controller: VideoViewController.remote(
//                                 rtcEngine: _agoraService.engine,
//                                 canvas: VideoCanvas(
//                                   uid: _remoteUid,
//                                 ),
//                                 connection: RtcConnection(
//                                   channelId: _channelId,
//                                 ),
//                               ),
//                             )
//                           : const Center(
//                               child: Text(
//                                 'Waiting for the other person...',
//                               ),
//                             ),
//                     ),

//                     // Local camera preview
//                     if (_isJoined)
//                       Positioned(
//                         top: 20,
//                         right: 20,
//                         width: 120,
//                         height: 170,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: _isCameraOff
//                               ? Container(
//                                   color: Colors.black,
//                                   child: Center(
//                                     child: Icon(
//                                       Icons.videocam_off,
//                                       size: 32,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 )
//                               : AgoraVideoView(
//                                   controller: VideoViewController(
//                                     rtcEngine: _agoraService.engine,
//                                     canvas: const VideoCanvas(uid: 0),
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     if (_isJoined)
//                       Positioned(
//                         bottom: 30,
//                         left: 0,
//                         right: 0,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             FloatingActionButton(
//                               heroTag: 'doctor_mute_button',
//                               onPressed: _toggleMute,
//                               child: Icon(
//                                 _isMuted ? Icons.mic_off : Icons.mic,
//                               ),
//                             ),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             FloatingActionButton(
//                               onPressed: _toggleCamera,
//                               child: Icon(_isCameraOff
//                                   ? Icons.videocam_off
//                                   : Icons.videocam),
//                             ),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             FloatingActionButton(
//                               backgroundColor: Colors.red,
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Icon(
//                                 Icons.call_end,
//                                 color: Colors.white,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//     );
//   }
// }

// // import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// // import 'package:dr_app/core/constants/agora_constants.dart';
// // import 'package:dr_app/core/services/agora_service.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';

// // class VideoCallScreen extends StatefulWidget {

// //   final String appointmentId;

// //   const VideoCallScreen({

// //     super.key,

// //     required this.appointmentId,

// //   });

// //   @override
// //   State<VideoCallScreen> createState()
// //   => _VideoCallScreenState();

// // }

// // class _VideoCallScreenState
// // extends State<VideoCallScreen>{

// // final AgoraService _agoraService =
// // AgoraService();

// // int? _remoteUid;

// // String? _doctorId;

// // bool _joined=false;

// // static const String _token =
// // 'YOUR_TOKEN_HERE';

// // String get _channelId =>
// // widget.appointmentId;

// // @override
// // void initState(){

// // super.initState();

// // _startCall();

// // }

// // Future<void> _startCall() async {

// // final doctor =
// // FirebaseAuth.instance.currentUser;

// // if(doctor==null){

// // return;

// // }

// // _doctorId=doctor.uid;

// // await _agoraService.requestPermissions();

// // await _agoraService.initialize(
// // AgoraConstants.appId
// // );

// // _agoraService.registerEventHandlers(

// // onUserJoined:(uid){

// // setState((){

// // _remoteUid=uid;

// // });

// // },

// // onUserOffline:(uid){

// // setState((){

// // _remoteUid=null;

// // });

// // },

// // );

// // await _agoraService.enableVideo();

// // await _agoraService.joinVideoChannel(

// // token:_token,

// // channelId:_channelId,

// // userId:_doctorId!,

// // );

// // setState((){

// // _joined=true;

// // });

// // }

// // @override
// // Widget build(BuildContext context){

// // return Scaffold(

// // appBar:AppBar(

// // title:
// // const Text("Doctor Video Call"),

// // ),

// // body:Stack(

// // children:[

// // Positioned.fill(

// // child:_remoteUid!=null

// // ?

// // AgoraVideoView(

// // controller:
// // VideoViewController.remote(

// // rtcEngine:
// // _agoraService.engine,

// // canvas:
// // VideoCanvas(
// // uid:_remoteUid,
// // ),

// // connection:
// // RtcConnection(

// // channelId:_channelId,

// // ),

// // ),

// // )

// // :

// // const Center(

// // child:
// // Text(
// // "Waiting for patient..."
// // ),

// // ),

// // ),

// // if(_joined)

// // Positioned(

// // top:20,

// // right:20,

// // width:120,

// // height:170,

// // child:

// // AgoraVideoView(

// // controller:
// // VideoViewController(

// // rtcEngine:
// // _agoraService.engine,

// // canvas:
// // VideoCanvas(

// // uid:
// // _agoraService
// // .getAgoraUid(
// // _doctorId!
// // ),

// // ),

// // ),

// // ),

// // ),

// // ],

// // ),

// // );

// // }

// // @override
// // void dispose(){

// // _agoraService.leaveChannel();

// // super.dispose();

// // }

// // }

import 'dart:async';
import 'dart:ui';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_app/core/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/agora_constants.dart';
import '../../../../../core/services/agora_service.dart';

class VideoCallScreen extends StatefulWidget {
  final String appointment;
  const VideoCallScreen({super.key, required this.appointment});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final AgoraService _agoraService = AgoraService();
  bool _remoteCameraOff = false;
  int? _remoteUid;
  bool _isJoined = false;
  bool _isMuted = false;
  bool _isCameraOff = false;
  String? _remoteProfileImage;

  String? _callError;
  bool _isLoading = true;

  Timer? _callTimer;
  int _callSeconds = 0;

  // TEMPORARY TEST TOKEN
  // Don't commit this to GitHub.
  static const String _token ='007eJxTYDi6UfbqtNd3l5YHSXFwfTu6Q4tBSHfD4tt31j7f+maC6HdRBYaURMNEU0NDExMT81QTC8vEpCRjM6NkSwtLs2TzlFQzwy/Kr7MaAhkZ1FQjWBkZIBDEF2HwDqxyMvPItagoLHHJjMxJi4rKNGZgAAD7riXV';

  // TEMPORARY TEST CHANNEL
  // static const String _channelId = 'test_call_001';

  String get _channelId => widget.appointment;

  @override
  void initState() {
    super.initState();

    debugPrint('🔥 Doctor VideoCallScreen opened');
    debugPrint('📞 Appointment ID: ${widget.appointment}');
    _startCall();
  }

  @override
  void dispose() {
    _stopTimer();
    _agoraService.engine.leaveChannel();
    _agoraService.engine.release();

    super.dispose();
  }

  Future<void> _startCall() async {
    try {
      final firebase = FirebaseAuth.instance.currentUser!.uid;

      final agoraUid = _agoraService.getAgoraUid(firebase);

      setState(() {
        _isLoading = true;
        _callError = null;
      });

      // 1. Request permissions
      final hasPermission = await _agoraService.requestPermissions();

      if (!hasPermission) {
        throw Exception(
          'Camera and microphone permissions are required.',
        );
      }

      // 2. Initialize Agora
      await _agoraService.initialize(
        AgoraConstants.appId,
      );

      // 3. Register Agora events
      _agoraService.registerEventHandlers(
        onUserJoined: (remoteUid) {
          if (!mounted) return;

          setState(() {
            _remoteUid = remoteUid;
            _remoteCameraOff = false;
          });
          _startTimer();
        },
        onUserOffline: (
          remoteUid,
        ) {
          if (!mounted) return;

          _stopTimer();

          setState(() {
            _remoteUid = null;
            _remoteCameraOff = false;
          });
        },
        onRemoteCameraChanged: (remoteUid, cameraOff) {
          if (remoteUid == _remoteUid) {
            setState(() {
              _remoteCameraOff = cameraOff;
            });
          }
        },
      );

      // 4. Enable video
      await _agoraService.enableVideo();

      // 5. Join channel
      await _agoraService.joinChannel(
        token: _token,
        channelId: _channelId,
        uid: agoraUid,
      );

      if (!mounted) return;

      setState(() {
        _isJoined = true;
        _isLoading = false;
      });

      await _fetchDoctorImage();
    } catch (e) {
      debugPrint('❌ Agora call error: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _callError = 'Unable to start the call. Please try again.';
      });
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

  void _stopTimer() {
    _callTimer?.cancel();
    _callTimer = null;
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _fetchDoctorImage() async {
    final doc = await FirebaseFirestore.instance
        .collection('appointments')
        .doc(widget.appointment)
        .get();

    if (!doc.exists) return;

    final data = doc.data();

    if (mounted) {
      setState(() {
        _remoteProfileImage = data?['doctorImage'];
      });
    }
  }

  Future<void> _toggleMute() async {
    await _agoraService.engine.muteLocalAudioStream(!_isMuted);

    setState(() {
      _isMuted = !_isMuted;
    });
  }

  Future<void> _toggleCamera() async {
    await _agoraService.engine.muteLocalVideoStream(!_isCameraOff);

    setState(() {
      _isCameraOff = !_isCameraOff;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: _isLoading
          ? _buildConnectingState()
          : _callError != null
              ? _buildErrorState()
              : _buildCallStack(),
    );
  }

  // ════════════════════════════════════════
  //  CONNECTING STATE
  // ════════════════════════════════════════
  Widget _buildConnectingState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryStart.withOpacity(0.95),
            const Color(0xFF0B1220),
          ],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 8,
              left: 4,
              child: _glassIconButton(
                icon: Icons.close_rounded,
                onTap: () => Navigator.maybePop(context),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.videocam_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 26),
                  const SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.6,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Connecting…',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text(
      'Video Consultation',
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    ),
    const SizedBox(height: 5),
    Text(
      _remoteUid != null
          ? 'Connected • ${_formatDuration(_callSeconds)}'
          : 'Waiting for participant',
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  ],
),

                      const SizedBox(height: 4),
                      Text(
                        _remoteUid != null
                            ? _formatDuration(_callSeconds)
                            : 'Waiting for participant',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════
  //  ERROR STATE
  // ════════════════════════════════════════
  Widget _buildErrorState() {
    return Container(
      color: const Color(0xFF0B1220),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 8,
              left: 4,
              child: _glassIconButton(
                icon: Icons.close_rounded,
                onTap: () => Navigator.maybePop(context),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 38,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Call failed to connect',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _callError!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 26),
                    GestureDetector(
                      onTap: _startCall,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryStart,
                              AppColors.primaryEnd,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryStart.withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.refresh_rounded,
                                color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Try Again',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════
  //  ACTIVE CALL
  // ════════════════════════════════════════
  Widget _buildCallStack() {
    return Stack(
      children: [
        // Remote user's video
        Positioned.fill(
          child: _remoteUid != null
              ? _remoteCameraOff
                  ? _buildRemoteCameraOff()
                  : AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: _agoraService.engine,
                        canvas: VideoCanvas(
                          uid: _remoteUid,
                        ),
                        connection: RtcConnection(
                          channelId: _channelId,
                        ),
                      ),
                    )
              : Container(
                  color: const Color(0xFF0B1220),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white54,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Waiting for the other person…',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),

        // Top gradient scrim + call status
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.55),
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              children: [
                _glassIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.maybePop(context),
                  size: 16,
                ),
                const SizedBox(width: 12),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3DDC84),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Video Consultation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Local camera preview
        if (_isJoined)
          Positioned(
            top: 100,
            right: 18,
            width: 110,
            height: 155,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: _isCameraOff
                    ? Container(
                        color: const Color(0xFF16202E),
                        child: const Center(
                          child: Icon(
                            Icons.videocam_off_rounded,
                            size: 26,
                            color: Colors.white54,
                          ),
                        ),
                      )
                    : AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _agoraService.engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      ),
              ),
            ),
          ),

        // Bottom glass control bar
        if (_isJoined)
          Positioned(
            bottom: 34,
            left: 0,
            right: 0,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.18),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _callControlButton(
                          icon: _isMuted
                              ? Icons.mic_off_rounded
                              : Icons.mic_rounded,
                          active: _isMuted,
                          onTap: _toggleMute,
                        ),
                        const SizedBox(width: 16),
                        _callControlButton(
                          icon: _isCameraOff
                              ? Icons.videocam_off_rounded
                              : Icons.videocam_rounded,
                          active: _isCameraOff,
                          onTap: _toggleCamera,
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF5C5C),
                                  Color(0xFFE53935),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.4),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.call_end_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ════════════════════════════════════════
  //  SHARED CONTROL WIDGETS
  // ════════════════════════════════════════
  Widget _callControlButton({
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white.withOpacity(0.18),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: active ? const Color(0xFF0B1220) : Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _glassIconButton({
    required IconData icon,
    required VoidCallback onTap,
    double size = 18,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }

  Widget _buildRemoteCameraOff() {
    return Container(
      color: Colors.black,
      child: Center(
        child: CircleAvatar(
          radius: 50,
          backgroundImage: _remoteProfileImage != null
              ? NetworkImage(_remoteProfileImage!)
              : null,
          child: _remoteProfileImage == null
              ? const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}
