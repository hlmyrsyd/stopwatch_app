import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(

      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  // LOGIC
  int milliseconds = 0, seconds = 0, minutes = 0, hours = 0;
  String digitMilliseconds = "00", digitSeconds = "00", digitMinutes = "00";
  Timer? timer;
  bool started = false;
  List laps = [];

  //Create stop timer func

  void stop(){
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  //Create the reset function

  void reset(){
    timer!.cancel();
    setState(() {
      milliseconds = 0;
      seconds = 0;
      minutes = 0;

      digitMilliseconds = "00";
      digitSeconds = "00";
      digitMinutes = "00";

      started = false;
      laps.clear();
    });
  }
  
  void addLaps(){
    String lap = "$digitMinutes:$digitSeconds.$digitMilliseconds";
    setState(() {
      laps.add(lap);
    });
  }

  //Create the start timer function

  void start(){
    started = true;
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      int localMilliseconds = milliseconds + 10;
      int localSeconds = seconds;
      int localMinutes = minutes;

      if (localMilliseconds >= 1000) {
        localSeconds++;
        localMilliseconds = 0;
      }
      if (localSeconds >= 60) {
        localMinutes++;
        localSeconds = 0;
      }
      setState(() {
        milliseconds = localMilliseconds;
        seconds = localSeconds;
        minutes = localMinutes;
        digitMilliseconds = (milliseconds ~/ 10).toString().padLeft(2, '0');
        // ? "$milliseconds" : (milliseconds >= 10) ? "0$milliseconds" : "0$milliseconds";
        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2757),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Go Sprint App",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Center(
                child: Text(
                  "$digitMinutes:$digitSeconds.$digitMilliseconds",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 80.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                height: 240.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF323F68),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                // add list builder
                child: ListView.builder(
                  itemCount: laps.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Lap ${index+1}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            "${laps[index]}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ]
                      ),
                    );
                  }                  ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      RawMaterialButton(
                        onPressed: () {
                          (!started) ? start() : stop();
                        },
                        fillColor: Colors.blue,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(80.0),
                        child: Text(
                          (!started) ? "START" : "PAUSE",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40.0
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RawMaterialButton(
                          onPressed: () {
                            reset();
                          },
                          shape: const StadiumBorder(
                            side: BorderSide(color: Colors.blue),
                          ),
                          child: const Text(
                            "Reset",
                            style: TextStyle(color: Colors.white),
                          ),
                        ), 
                      ),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: RawMaterialButton(
                          onPressed: () {
                            addLaps();
                          },
                          shape: const StadiumBorder(
                            side: BorderSide(color: Colors.blue),
                          ),
                          child: const Text(
                            "Add Lap",
                            style: TextStyle(color: Colors.white),
                          ),
                        ), 
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}