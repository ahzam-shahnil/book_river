import 'package:Book_River/HomeScreen.dart';
import 'constants.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: null,
        body: LoadScreen(),
      ),
    );
  }
}

class LoadScreen extends StatefulWidget {
  @override
  _LoadScreenState createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 4);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: Center(
            child: ColorizeAnimatedTextKit(
              speed: Duration(seconds: 2),
              text: [
                "Book River",
              ],
              textStyle: TextStyle(
                fontSize: 40.0,
              ),
              colors: [
                Colors.blue,
                Colors.purple,
                Colors.red,
              ],
              textAlign: TextAlign.start,
              alignment: AlignmentDirectional.topStart,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          child: new FlareActor(
            "images/loader.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "Untitled",
            color: Colors.blue,
            artboard: "Artboard",
          ),
        ),
        Container(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Developed by",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                  text: " Ahzam Shahnil ❤",
                  style: kCreditTextStyle,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
