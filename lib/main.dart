import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<double> _accelerometerValues = [0, 0, 0];
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black38),
              ),
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 220),
                    left: getLeft(
                        (MediaQuery.of(context).size.width - 80) / 2 -
                            _accelerometerValues[0] * 50,
                        MediaQuery.of(context).size.width - 80),
                    top: getTop(
                        (MediaQuery.of(context).size.width - 80) / 2 +
                            _accelerometerValues[1] * 50,
                        MediaQuery.of(context).size.width - 80),
                    child: Container(
                      height: 80,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                    'Accelerometer: ${_accelerometerValues[0].toStringAsFixed(1)},${_accelerometerValues[1].toStringAsFixed(1)},${_accelerometerValues[2].toStringAsFixed(1)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double getLeft(double location, double limit) {
    if (location < 0) {
      return 0.0;
    } else if (location > limit) {
      return limit;
    } else {
      return location;
    }
  }

  double getTop(double location, double limit) {
    if (location < 0) {
      return 0.0;
    } else if (location > limit) {
      return limit;
    } else {
      return location;
    }
  }
}
