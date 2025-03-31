import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
//import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:village_project/firebase_config_keys.dart';
import 'package:village_project/utils/colors.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key, required this.token});
  final String token;
  @override
  State<StatefulWidget> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  String channel = "715382";
  int? _remoteUid; // Stores remote user ID
  bool _localUserJoined =
      false; // Indicates if local user has joined the channel
  late RtcEngine _engine; // Stores Agora RTC Engine instance
  @override
  void initState() {
    super.initState();
    _startVideoCalling();
  }

  // Initializes Agora SDK
  Future<void> _startVideoCalling() async {
    await _requestPermissions();
    await _initializeAgoraVideoSDK();
    await _setupLocalVideo();
    _setupEventHandlers();
    await _joinChannel();
  }

  // Requests microphone and camera permissions
  Future<void> _requestPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }

  // Set up the Agora RTC engine instance
  Future<void> _initializeAgoraVideoSDK() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: FirebaseConfigKeys.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
  }

  // Enables and starts local video preview
  Future<void> _setupLocalVideo() async {
    await _engine.enableVideo();
    await _engine.startPreview();
  }

  // Register an event handler for Agora RTC
  void _setupEventHandlers() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (error, message) {
          debugPrint("error: ${error.toString()}");
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");
          setState(() => _localUserJoined = true);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("Remote user $remoteUid joined");
          setState(() => _remoteUid = remoteUid);
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("Remote user $remoteUid left");
          setState(() => _remoteUid = null);
        },
      ),
    );
  }

  // Join a channel
  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: widget.token,
      channelId: channel,
      options: const ChannelMediaOptions(
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
      uid: 0,
    );
  }

  @override
  void dispose() {
    _cleanupAgoraEngine();
    super.dispose();
  }

  // Leaves the channel and releases resources
  Future<void> _cleanupAgoraEngine() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text('Agora Video Calling')),
      body: Stack(
        children: [
          Center(child: _remoteVideo()),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? _localVideo()
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              onPressed: () async {
                await _cleanupAgoraEngine();
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.call,
                color: white,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width * 0.1),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Displays remote video view
  Widget _localVideo() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(
          uid: 0,
          renderMode: RenderModeType.renderModeHidden,
        ),
      ),
    );
  }

  // Displays remote video view
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Waiting for remote user to join...',
        textAlign: TextAlign.center,
      );
    }
  }
}
