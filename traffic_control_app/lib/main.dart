import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; 
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(TrafficControlApp());
}

class TrafficControlApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manual Traffic Control',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: TrafficControlHomePage(),
    );
  }
}

class TrafficControlHomePage extends StatefulWidget {
  @override
  _TrafficControlHomePageState createState() =>
      _TrafficControlHomePageState();
}

class _TrafficControlHomePageState extends State<TrafficControlHomePage>
    with SingleTickerProviderStateMixin {
  final List<String> directions = ['North', 'East', 'South', 'West'];
  int currentDirectionIndex = 0;
  int timeLeft = 45;
  Timer? timer;

  final AudioPlayer _audioPlayer = AudioPlayer(); 

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    startTimer();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  void startTimer() {
    timer?.cancel();
    timeLeft = 45;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
        if (timeLeft <= 0) {
          timer.cancel();
          handleBeepAndSwitch(); 
        }
      });
    });
  }

  Future<void> handleBeepAndSwitch() async {
    await _playBeep();                  
    await Future.delayed(Duration(seconds: 5)); 
    await _playBeep();                 
    switchToNextDirection();
    startTimer();                       
  }

Future<void> _playBeep() async {
  if (kIsWeb) return; 

  try {
    await _audioPlayer.play(AssetSource('beep.mp3'));
  } catch (e) {
    print('Sound error: $e');
  }
}

  void switchToNextDirection() {
    setState(() {
      currentDirectionIndex =
          (currentDirectionIndex + 1) % directions.length;
      timeLeft = 45;
    });
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String currentDirection = directions[currentDirectionIndex];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('🚦 Manual Traffic Control'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 10, spreadRadius: 5)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Current Direction',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(
                  currentDirection,
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                SizedBox(height: 20),
                Text('⏱ Time Left: ${timeLeft}s',
                    style: TextStyle(fontSize: 24)),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    switchToNextDirection();
                    _playBeep(); 
                    startTimer();
                  },
                  icon: Icon(Icons.skip_next),
                  label: Text('Start Traffic Control'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: const Color.fromARGB(255, 33, 32, 32),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
