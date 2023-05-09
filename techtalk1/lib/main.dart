// Material design framework
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

// The main app widget, called first
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This is the build tree for the app, this widget contains the app container
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University of Idaho History',
      // The theme data for the app, inherited by all children
      theme: ThemeData(
          primarySwatch:
              const Color.fromRGBO(241, 179, 0, 1.0).asMaterialColor),
      // This is the main screen for the app
      home: const MyHomePage(title: 'Historical Photos 2'),
    );
  }
}

// A stateful widget that represents our main screen, can be moved to other files.
class MyHomePage extends StatefulWidget {
  // The widget's constructor, called when the widget is created
  const MyHomePage({super.key, required this.title});

  // The title is passed in from the constructor
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// The state for our stateful widget
class _MyHomePageState extends State<MyHomePage> {
  // The datasource, from the library digital collections
  var dataUrl =
      "https://www.lib.uidaho.edu/digital/uihistorical/data/metadata.json";

  // The state widget's entry point, called first
  @override
  void initState() {
    super.initState();
    // Get the data from the datasource
  }

  // Our UI build tree, called when the state needs refreshed
  @override
  Widget build(BuildContext context) {
    // The scaffold is the main container for the screen
    return Scaffold(
        // The app bar is the top bar
        appBar: AppBar(
          // The title is passed in from the constructor
          title: Text(widget.title),
        ),
        body: Container(
            child: ListView(
                children: [bodyWidgets(), bodyWidgets(), bodyWidgets()])));
  }

  // The body of the app, contains the main content
  bodyWidgets() {
    return Column(children: [
      SizedBox(
        height: 300,
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(color: Color.fromARGB(255, 196, 119, 113))),
      ),
      const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          "Title",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
        child: Text(
          "Description",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black26, fontSize: 20),
        ),
      ),
    ]);
  }
}

extension ToMaterialColor on Color {
  MaterialColor get asMaterialColor {
    Map<int, Color> shades = [
      50,
      100,
      200,
      300,
      400,
      500,
      600,
      700,
      800,
      900
    ].asMap().map(
        (key, value) => MapEntry(value, withOpacity(1 - (1 - (key + 1) / 10))));

    return MaterialColor(value, shades);
  }
}
