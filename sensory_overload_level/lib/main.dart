//aeyrium sensor dart package
//https://pub.dev/documentation/aeyrium_sensor/latest/
//check mark sensor dart package
//https://pub.dev/packages/checkmark

//add x animation for not level

import 'package:flutter/material.dart';
import 'package:checkmark/checkmark.dart';
import 'package:aeyrium_sensor/aeyrium_sensor.dart';

// build icon data
const IconData cancel_outlined = IconData(0xef28, fontFamily: 'MaterialIcons');

void main() {
  runApp(
    MaterialApp(
      home: MyApp(), // becomes the route named '/'
      routes: <String, WidgetBuilder>{
        '/a': (BuildContext context) => HorizontalPage(),
        '/b': (BuildContext context) => VerticalPage(),
        '/c': (BuildContext context) => MyHomePage(title: 'Leveler'),
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leveler',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.orange,
            ), //button color
            foregroundColor: MaterialStateProperty.all<Color>(
              Colors.white,
            ),
          ),
        ),
      ),
      home: const MyHomePage(title: 'The Leveler'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application.

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // onPressed move to these states/pages
    void _openHoizontal() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HorizontalPage(),
        ),
      );
    }

    void _openVertical() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VerticalPage(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // create buttons that would navigate to the both levelers
            SizedBox(
              width: 300, // <-- Your width
              height: 100,
              child: ElevatedButton(
                onPressed: _openHoizontal,
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 30)),
                child: const Text('Horizontal Level'),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 300, // <-- Your width
              height: 100,
              child: ElevatedButton(
                onPressed: _openHoizontal,
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 30)),
                child: const Text('Vertical Level'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalPage extends StatefulWidget {
  const HorizontalPage({super.key});

  @override
  _HorizontalPageState createState() => _HorizontalPageState();
}

class _HorizontalPageState extends State<HorizontalPage> {
  bool checkedH = false;
  late double pitchH;
  late double rollH;

  // return X icon for when not level
  Icon openXHorizontal() {
    if (checkedH == false) {
      return const Icon(
        cancel_outlined,
        color: Colors.red,
        size: 300,
      );
    } else {
      return const Icon(cancel_outlined, color: Colors.white);
    }
  }

  @override
  void initState() {
    AeyriumSensor.sensorEvents.listen(
      (SensorEvent event) {
        if (mounted) {
          setState(
            () {
              pitchH = event.pitch;
              rollH = event.roll;
            },
          );
        }
        // check if level horizontally
        if (pitchH < -1.47 && pitchH > -1.53) {
          checkedH = true;
        } else {
          checkedH = false;
          openXHorizontal();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horizontal'),
      ),
      body: Column(
        children: [
          Text(pitchH.toString()),
          Text(rollH.toString()),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 200,
              width: 200,
              child: CheckMark(
                active: checkedH,
                curve: Curves.decelerate,
                duration: const Duration(milliseconds: 500),
              ),
            ),
          ),
          const SizedBox(height: 100, width: 50),
          openXHorizontal(),
        ],
      ),
    );
  }
}

class VerticalPage extends StatefulWidget {
  const VerticalPage({super.key});

  @override
  _VerticalPageState createState() => _VerticalPageState();
}

class _VerticalPageState extends State<VerticalPage> {
  late double pitchV;
  late double rollV;
  bool checkedV = false;

  // return X icon for when not level
  Icon openXVertical() {
    if (checkedV == false) {
      return const Icon(
        cancel_outlined,
        color: Colors.red,
        size: 300,
      );
    } else {
      return const Icon(cancel_outlined, color: Colors.white);
    }
  }

  @override
  void initState() {
    AeyriumSensor.sensorEvents.listen(
      (SensorEvent event) {
        if (mounted) {
          setState(
            () {
              pitchV = event.pitch;
              rollV = event.roll;
            },
          );
          // check if level vertically
          if (pitchV <= 0.03 && pitchV >= -0.03) {
            checkedV = true;
          } else {
            checkedV = false;
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vertical'),
      ),
      body: Column(
        children: [
          Text(pitchV.toString()),
          Text(rollV.toString()),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 200,
              width: 200,
              child: CheckMark(
                active: checkedV,
                curve: Curves.decelerate,
                duration: const Duration(milliseconds: 500),
              ),
            ),
          ),
          const SizedBox(height: 100, width: 50),
          openXVertical(),
        ],
      ),
    );
  }
}
