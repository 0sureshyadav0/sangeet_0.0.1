import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:provider/provider.dart';
import 'package:sangeet/providers/music_provider.dart';

class MusicAppHome extends StatefulWidget {
  final String title;
  final String artist;
  final String path;
  final String duration;
  final int index;
  const MusicAppHome({
    super.key,
    required this.title,
    required this.artist,
    required this.path,
    required this.duration,
    required this.index,
  });

  @override
  State<MusicAppHome> createState() => _MusicAppHomeState();
}

class _MusicAppHomeState extends State<MusicAppHome>
    with TickerProviderStateMixin {
  double turns = 200;
  double percentage = 0;
  int rotation = 0;
  double sliderValue = 0.0;
  Timer? _timer;
  final channel = const MethodChannel("flutter_channel");

  @override
  void initState() {
    super.initState();
    sliderProgress();
    Provider.of<MusicProvider>(context, listen: false)
        .playMusic(widget.path, widget.duration);
    getCurrentPlayingTime();
  }

  void rotateMusicNote() {
    setState(() {
      turns += 20;
    });
  }

  int playingTime = 0;
  Duration durationTime = const Duration(milliseconds: 0);
  void getCurrentPlayingTime() async {
    final duration = Duration(milliseconds: int.parse(widget.duration));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        playingTime = await channel.invokeMethod("getCurrentPlayingTime");
        if (_timer != null) {
          setState(() {
            durationTime = Duration(milliseconds: playingTime);
            int currentPosition = durationTime.inMilliseconds;
            percentage = ((currentPosition.toDouble()) /
                    (duration.inMilliseconds.toDouble())) *
                100;
          });
          if (duration.inSeconds == durationTime.inSeconds) {
            Provider.of<MusicProvider>(context, listen: false).setIsPlaying();
            timer
                .cancel(); // it will stop the timer and don't call setIsPlaying method
          }
        }
      } on PlatformException catch (e) {
        Get.snackbar("Error", "${e.message}");
      }
    });
  }

  void sliderProgress() {
    int fullDuration = int.parse(widget.duration);
    final musicDuration = Duration(milliseconds: fullDuration);
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        try {
          final currentPosition =
              await channel.invokeMethod<int>("getCurrentPlayingTime");
          final currentDuration = Duration(milliseconds: currentPosition!);
          if (currentDuration.inSeconds == musicDuration.inSeconds &&
              _timer != null) {
            setState(() {
              sliderValue = 0.0;
              percentage = 0.0;
            });
          } else if (_timer != null) {
            setState(() {
              sliderValue = (currentPosition / fullDuration).clamp(0.0, 1.0);
            });
          }
        } catch (e) {
          Get.snackbar("Error", "$e");
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int time = int.parse(widget.duration);
    Duration timeDuration = Duration(milliseconds: time);
    int hours = timeDuration.inHours.toInt();
    int minutes = (timeDuration.inMinutes % 60).toInt();
    int seconds = (timeDuration.inSeconds % 60).toInt();
    return Scaffold(
      body: Stack(
        children: [
          // Background image

          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                opacity: 0.7,
                image: AssetImage(
                    "./assets/images/background.jpeg"), // Add your image to assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: const Text(
              "Sangeet",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${durationTime.inHours.toString().padLeft(2, '0')}:${durationTime.inMinutes.toString().padLeft(2, '0')}:${(durationTime.inSeconds % 60).toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 3, 253, 11),
                              fontFamily: "Schyler",
                              fontSize: 30.0,
                            ),
                          ),
                          Text(
                            "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 3, 250, 11),
                              fontFamily: "Schyler",
                              fontSize: 30.0,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      // Album Art Placeholder
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                          // border: Border.all(
                          //   color: Colors.red,
                          //   width: 5,
                          // ),
                        ),
                        child: TweenAnimationBuilder(
                          onEnd: rotateMusicNote,
                          tween: Tween<double>(
                              begin: 0,
                              end:
                                  int.parse(widget.duration).toDouble() / 1000),
                          duration: Duration(
                              milliseconds: int.parse(widget.duration)),
                          builder: (context, double value, child) {
                            return Transform.rotate(
                              angle: value,
                              child: const Icon(
                                Icons.music_note,
                                size: 80,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Song Title
                      MarqueeText(
                        speed: 25.0,
                        text: TextSpan(
                          text: widget.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Artist Name
                      Text(
                        widget.artist,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),

                      const Spacer(),
                      Slider(
                        value: sliderValue,
                        min: 0.0,
                        label: "hello",
                        activeColor: const Color.fromARGB(255, 3, 248, 11),
                        inactiveColor: Colors.grey,
                        max: 1.0,
                        onChanged: (value) {
                          setState(() {
                            sliderValue = value.toDouble();
                            Provider.of<MusicProvider>(context, listen: false)
                                .seekTo(
                                    (value * timeDuration.inMilliseconds)
                                        .toInt(),
                                    timeDuration.inMilliseconds);
                          });
                        },
                      ),
                      // Play/Pause Controls
                      Consumer<MusicProvider>(builder: (BuildContext context,
                          MusicProvider provider, Widget? child) {
                        List<dynamic> musicFiles = provider.getmusicFiles;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MusicAppHome(
                                      artist: widget.index == 0
                                          ? musicFiles[musicFiles.length - 1]
                                              ['artist']
                                          : musicFiles[widget.index - 1]
                                              ['artist'],
                                      title: widget.index == 0
                                          ? musicFiles[musicFiles.length - 1]
                                              ['title']
                                          : musicFiles[widget.index - 1]
                                              ['title'],
                                      path: widget.index == 0
                                          ? musicFiles[musicFiles.length - 1]
                                              ['path']
                                          : musicFiles[widget.index - 1]
                                              ['path'],
                                      duration: widget.index == 0
                                          ? musicFiles[musicFiles.length - 1]
                                              ['duration']
                                          : musicFiles[widget.index - 1]
                                              ['duration'],
                                      index: widget.index == 0
                                          ? musicFiles.length - 1
                                          : widget.index - 1,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.skip_previous,
                                  size: 40, color: Colors.white),
                            ),
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  provider.togglePlayer(widget.path);
                                },
                                icon: provider.isPlaying
                                    ? const Icon(Icons.pause,
                                        size: 40, color: Colors.white)
                                    : const Icon(Icons.play_arrow,
                                        size: 40, color: Colors.white),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MusicAppHome(
                                      artist:
                                          widget.index == musicFiles.length - 1
                                              ? musicFiles[0]['artist']
                                              : musicFiles[widget.index + 1]
                                                  ['artist'],
                                      title:
                                          widget.index == musicFiles.length - 1
                                              ? musicFiles[0]['title']
                                              : musicFiles[widget.index + 1]
                                                  ['title'],
                                      path:
                                          widget.index == musicFiles.length - 1
                                              ? musicFiles[0]['path']
                                              : musicFiles[widget.index + 1]
                                                  ['path'],
                                      duration:
                                          widget.index == musicFiles.length - 1
                                              ? musicFiles[0]['duration']
                                              : musicFiles[widget.index + 1]
                                                  ['duration'],
                                      index:
                                          widget.index == musicFiles.length - 1
                                              ? 0
                                              : widget.index + 1,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.skip_next,
                                  size: 40, color: Colors.white),
                            ),
                          ],
                        );
                      }),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 3.4,
            left: MediaQuery.of(context).size.width / 3.2,
            child: Center(
              child: CircleWithPartialBorder(percentage: percentage),
            ),
          ),
        ],
      ),
    );
  }
}

class CircleWithPartialBorder extends StatelessWidget {
  final double
      percentage; // Percentage of the circle to apply the border to (0-100)

  const CircleWithPartialBorder({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(151, 151), // Size of the box
      painter: PartialBorderPainter(percentage: percentage),
    );
  }
}

class PartialBorderPainter extends CustomPainter {
  final double percentage;
  PartialBorderPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint glowPaint = Paint()
      ..color = const Color.fromARGB(255, 1, 248, 9) // Neon color
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal, 10); // Apply a blur for the neon effect

    final Paint borderPaint = Paint()
      ..color =
          const Color.fromARGB(255, 2, 250, 10).withAlpha((1 * 255).toInt())
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke; // Regular stroke

    double startAngle = -((22 / 7) / 2); // Start at the top of the circle
    double sweepAngle = 2 *
        (22 / 7) *
        (percentage / 100); // Calculate sweep angle based on percentage

    // Draw the neon glow effect (larger arc with blur)
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2),
      startAngle,
      sweepAngle,
      false,
      glowPaint, // Apply the glow effect here
    );

    // Draw the regular border on top (normal, non-glowing arc)
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2),
      startAngle,
      sweepAngle,
      false,
      borderPaint, // Apply the normal border here
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Repaint every time the percentage changes
  }
}
