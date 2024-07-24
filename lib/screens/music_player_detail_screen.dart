import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animations/screens/painter/progress_bar.dart';
import 'package:flutter_animations/screens/painter/volume_painter.dart';
import 'package:lottie/lottie.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  const MusicPlayerDetailScreen({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<MusicPlayerDetailScreen> createState() =>
      _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen>
    with TickerProviderStateMixin {
  final Duration totalDuration = const Duration(minutes: 1);

  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: totalDuration,
  )..repeat();

  late final AnimationController _marquee = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  )..repeat();

  late final AnimationController _playPauseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final AnimationController _lottieController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    lowerBound: 0.0,
    upperBound: 0.5,
    value: 0.5,
  );

  late final Animation<Offset> _marqueeTween = Tween(
    begin: const Offset(0.1, 0),
    end: const Offset(-2.0, 0),
  ).animate(_marquee);

  String _getTimeFormatFromDuration(Duration duration) {
    if (duration.inHours > 0) {
      return "${duration.inHours.toString().padLeft(2, "0")}:${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}";
    } else {
      return "${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}";
    }
  }

  void _onPlayPauseTap() {
    if (_playPauseController.isCompleted) {
      _playPauseController.reverse();
      _lottieController.forward();
    } else {
      _playPauseController.forward();
      _lottieController.reverse();
    }
  }

  bool _dragging = false;

  void _toggleDragging() {
    setState(() {
      _dragging = !_dragging;
    });
  }

  final ValueNotifier<double> _volume = ValueNotifier(0.5);

  void _onVolumeDragUpdate(DragUpdateDetails details, double maxWidth) {
    _volume.value += details.delta.dx / maxWidth;
    _volume.value = _volume.value.clamp(0.0, 1.0);
  }

  void _openMenu() {}

  @override
  void dispose() {
    _progressController.dispose();
    _marquee.dispose();
    _playPauseController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: const Text("Interstellar"),
        actions: [
          IconButton(
            onPressed: _openMenu,
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.center,
            child: Hero(
              tag: "${widget.index}",
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    )
                  ],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/covers/${widget.index}.jpg"),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(size.width - 80, 5),
                painter: ProgressBar(
                  progress: _progressController.value,
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              final elapsedTime =
                  (_progressController.duration ?? Duration.zero) *
                      _progressController.value;
              final remainTime =
                  (_progressController.duration ?? Duration.zero) *
                      (1 - _progressController.value);
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getTimeFormatFromDuration(elapsedTime),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "-${_getTimeFormatFromDuration(remainTime)}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text(
            "Interstellar",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          SlideTransition(
            position: _marqueeTween,
            child: const Text(
              "A Flim By Christopher Nolan - Original Motion Picture Soundtrack",
              style: TextStyle(
                fontSize: 18,
              ),
              maxLines: 1,
              overflow: TextOverflow.visible,
              softWrap: false,
            ),
          ),
          // const SizedBox(height: 30),
          GestureDetector(
            onTap: _onPlayPauseTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedIcon(
                  icon: AnimatedIcons.pause_play,
                  progress: _playPauseController,
                  size: 60,
                ),
                Lottie.asset(
                  width: 70,
                  height: 70,
                  // onLoaded: (composition) {
                  //   _playPauseController.duration = composition.duration;
                  // },
                  "assets/animations/play-lottie.json",
                  controller: _lottieController,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onHorizontalDragUpdate: (details) =>
                _onVolumeDragUpdate(details, size.width - 80),
            onHorizontalDragStart: (_) => _toggleDragging(),
            onHorizontalDragEnd: (_) => _toggleDragging(),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 500),
              curve: Curves.bounceOut,
              scale: _dragging ? 1.1 : 1.0,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ValueListenableBuilder(
                    valueListenable: _volume,
                    builder: (context, value, child) {
                      return CustomPaint(
                        size: Size(size.width - 80, 50),
                        painter: VolumePainter(volume: value),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
