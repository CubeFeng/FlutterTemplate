import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class RealNameLivingbodyExampleView extends StatefulWidget {
  @override
  _RealNameLivingbodyExamplePageState createState() => _RealNameLivingbodyExamplePageState();
}

class _RealNameLivingbodyExamplePageState extends State<RealNameLivingbodyExampleView> {
  late VideoPlayerController _controller;
  final Completer<bool> _controllerInitFuture = Completer();
  final StreamController<Duration> _currentDuration = StreamController();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/data/example.mp4');
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      initVideoPlayer();
    });
  }

  Future initVideoPlayer() async {
    _controller.addListener(() async {
      final Duration res = await _controller.position ?? Duration.zero;
      if (res >= _controller.value.duration) {
        await _controller.seekTo(const Duration(seconds: 0));
        await _controller.pause();
      }

      if (_controller.value.isPlaying || !_controller.value.isPlaying) {
        if (!_currentDuration.isClosed) {
          _currentDuration.sink.add(res);
        }
      }
    });
    _controller.initialize().whenComplete(() => _controllerInitFuture.complete(true));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _controllerInitFuture.future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: Stack(
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  _NavigatorBar(),
                ],
              ),
              bottomNavigationBar: PreferredSize(
                  preferredSize: const Size.fromHeight(100),
                  child: StreamBuilder<Duration>(
                      stream: _currentDuration.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return _VideoPlayerControl(
                            position: snapshot.data ?? Duration.zero,
                            totalDuration: _controller.value.duration,
                            isPlaying: _controller.value.isPlaying,
                            onPress: () {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                            },
                          );
                        } else {
                          return const SizedBox();
                        }
                      })),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    _currentDuration.close();
    super.dispose();
  }
}

class _VideoPlayerControl extends StatelessWidget {
  final Duration position;
  final Duration totalDuration;
  final bool isPlaying;
  final VoidCallback? onPress;
  const _VideoPlayerControl(
      {this.position = Duration.zero, this.totalDuration = Duration.zero, this.isPlaying = false, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.black,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: InkWell(
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: const Color(0xFF333333),
                size: 25,
              ),
              onTap: onPress,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 10),
            child: Text(
              DateUtil.formatDateMs(position.inMilliseconds, format: 'mm:ss'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Flexible(
              child: SliderTheme(
            //自定义风格
            data: SliderTheme.of(context).copyWith(
              //进度条滑块左边颜色
              inactiveTrackColor: Colors.white38,
              // activeTrackColor: Colors.black26,
              thumbColor: Colors.white,
              trackHeight: 3,
              overlayShape: const RoundSliderOverlayShape(
                //可继承SliderComponentShape自定义形状
                overlayRadius: 0, //滑块外圈大小
              ),
              thumbShape: const RoundSliderThumbShape(
                //可继承SliderComponentShape自定义形状
                disabledThumbRadius: 7, //禁用是滑块大小
                enabledThumbRadius: 7, //滑块大小
              ),
            ),
            child: Slider(
              value: position.inSeconds / totalDuration.inSeconds,
              divisions: 100,
              // onChangeStart: _onChangeStart,
              // onChangeEnd: _onChangeEnd,
              // onChanged: _onChanged,
              min: 0,
              max: 1,
              onChanged: (double value) {},
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 10),
            child: Text(
              DateUtil.formatDateMs(totalDuration.inMilliseconds, format: 'mm:ss'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigatorBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 12),
          child: InkWell(
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black38,
              ),
              child: Icon(
                Icons.close_rounded,
                color: const Color(0xFF333333),
              ),
            ),
            onTap: () => Navigator.pop(context),
          )),
    );
  }
}
