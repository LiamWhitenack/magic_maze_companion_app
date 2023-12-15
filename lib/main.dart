// ignore_for_file: unused_element

// ignore: unused_import
import 'dart:async';
// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'sand_timer.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static ThemeData theme = ThemeData(
    // This is the theme of your application.
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: TimerScreen(theme: theme),
    );
    return materialApp;
  }
}

class TimerScreen extends StatefulWidget {
  final ThemeData theme;

  // ignore: prefer_const_constructors_in_immutables
  TimerScreen({required this.theme, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with TickerProviderStateMixin {
  late AnimationController timerController;
  late AnimationController sandTimerController;
  late AnimationController rotationController;
  late Animation<double> animation;
  late Animation<double> rotateAnimation;
  static const alarmAudioPath = "assets/sounds/alarm_small.mp3";
  final alarmPlayer = AudioPlayer();
  static const flipAudioPath = "assets/sounds/flip_small.mp3";
  final flipPlayer = AudioPlayer();
  static const musicAudioPath = "assets/sounds/music_small.mp3";
  final musicPlayer = AudioPlayer();
  static const warningAudioPath = "assets/sounds/warning_small.mp3";
  final warningPlayer = AudioPlayer();

  bool timerRunning = false;
  bool flip = false;
  void startTimer() async {
    sandTimerController.forward();
    timerController.forward();
    if (!rotationController.isCompleted) {
      rotationController.forward();
    }
    musicPlayer.play();
    timerRunning = true;

    setState(() {});
  }

  void pauseTimer() async {
    timerController.stop();
    sandTimerController.stop();
    rotationController.stop();
    timerRunning = false;
    musicPlayer.pause();
    setState(() {});
  }

  void flipTimer() async {
    if (rotationController.isCompleted) {
      musicPlayer.pause();
      timerController.value = 1.0 - timerController.value;
      rotationController.reverse();
      sandTimerController.stop();
      timerController.stop();
      flip = true;
      await flipPlayer.play();
      await flipPlayer.stop();
      // await flipPlayer.seek(Duration.zero);
      musicPlayer.play();
    }
  }

  @override
  void initState() {
    super.initState();

    alarmPlayer.setAsset(alarmAudioPath);
    flipPlayer.setAsset(flipAudioPath);
    musicPlayer.setAsset(musicAudioPath);
    warningPlayer.setAsset(warningAudioPath);
    timerController = AnimationController(vsync: this, duration: const Duration(minutes: 3));
    sandTimerController = AnimationController(vsync: this, duration: const Duration(minutes: 3))
      ..addListener(() {
        setState(() {});
      });
    rotationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))
      ..addListener(() {
        setState(() {});
      });
    animation = Tween<double>(begin: 0.0, end: 0.1).animate(CurvedAnimation(
      parent: sandTimerController,
      curve: const Interval(
        0.01,
        1.0,
        curve: Curves.linear,
      ),
    ));
    rotateAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(CurvedAnimation(
      parent: rotationController,
      curve: const Interval(
        0.0,
        1.0,
        curve: Curves.ease,
      ),
    ));

    rotationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        if (!flip) {
          return;
        }
        sandTimerController.value = 1.0 - sandTimerController.value;
        rotationController.value = 1.0;

        musicPlayer.stop();
        startTimer();
        flip = false;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    timerController.dispose();
    sandTimerController.dispose();
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutesRemaining = ((1 - timerController.value) * 3).toInt();
    int secondsRemaining = (((1 - timerController.value) * 180) % 60).toInt();
    String secondsRemainingString = secondsRemaining.toString();
    if (secondsRemaining < 10) {
      secondsRemainingString = "0$secondsRemainingString";
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$minutesRemaining:$secondsRemainingString",
              style:
                  TextStyle(color: (timerController.value > 0.833) ? Colors.red : Colors.purple[300], fontSize: 54.0),
            ),
            GestureDetector(
              onDoubleTap: () {
                flipTimer();
              },
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [Colors.purple[400]!, Colors.purple[300]!]),
                ),
                child: Transform.rotate(
                  angle: (rotateAnimation.value * math.pi) / 180,
                  child: CustomPaint(
                    size: const Size(0, 400),
                    painter: SandClock(value: animation.value),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => timerRunning ? pauseTimer() : startTimer(),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.purple[300], // Set the background color
                  ),
                  child: SizedBox(
                    width: 60,
                    height: 40,
                    child: Center(
                        child: Text(
                      timerRunning ? "Pause" : "Start",
                      style: const TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class TimerContainerPainter extends CustomPainter {
//   final fillPaint = Paint()..color = Colors.purple[200]!;

//   @override
//   void paint(Canvas canvas, Size size) {
//     // This [Rect] will fill the whole canvas we got
//     double radius = 150;
//     var count = 15;

//     // Background for our texture
//     canvas.drawCircle(Offset.zero, radius, fillPaint);

//     canvas.drawPoints(
//       PointMode.points,
//       randomOffsets(radius, count),
//       dotPaint,
//     );
//   }

//   static final rnd = Random();
//   static List<Offset> randomOffsets(double radius, int count) {
//     List<Offset> offsets = [];
//     for (var i = 0; i < count; i++) {
//       double angle = Random().nextDouble() * 2 * pi;
//       double randomRadius = Random().nextDouble() * radius;

//       // Convert polar coordinates to Cartesian coordinates
//       double x = randomRadius * cos(angle);
//       double y = randomRadius * sin(angle);
//       offsets.add(Offset(x, y));
//     }
//     return offsets;
//   }

//   final dotPaint = Paint()..color = Colors.white24;

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
