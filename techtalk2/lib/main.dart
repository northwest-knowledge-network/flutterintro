// Material design framework
import 'package:flutter/material.dart';

// Network calls
import 'package:http/http.dart' as http;

// Async
import 'dart:async';

// JSON
import 'dart:convert';

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
      home: const MyHomePage(title: 'U of I Historical Photos'),
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

class Photo {
  final String title;
  final String description;
  final String imageUrl;

  Photo(this.title, this.description, this.imageUrl);
}

// The state for our stateful widget
class _MyHomePageState extends State<MyHomePage> {
  // The datasource, from the library digital collections
  var dataUrl =
      "https://www.lib.uidaho.edu/digital/uihistorical/data/metadata.json";
  List<Photo> photos = [];
  // The state widget's entry point, called first
  @override
  void initState() {
    super.initState();
    // Get the data from the datasource
    loadFromApi(dataUrl);
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
        body: Container(child: bodyWidgetsBuilder()));
    //ListView(
    ///children: [bodyWidgets(), bodyWidgets(), bodyWidgets()])));
  }

  bodyWidgetsBuilder() {
    return ListView.builder(
        itemCount: photos.length,
        itemBuilder: (BuildContext context, int index) {
          return bodyWidget(index);
        });
  }

  // The body of the app, contains the main content
  bodyWidgets() {
    return Column(children: [
      SizedBox(
        height: 300,
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(color: const Color.fromARGB(255, 196, 119, 113))),
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

  // The body of the app, contains the main content
  bodyWidget(int index) {
    Photo photo = photos[index];
    return Column(children: [
      SizedBox(
        height: 300,
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.network(photo.imageUrl, fit: BoxFit.cover)),
      ),
      Padding(
        padding: const EdgeInsets.only(
            top: 10.0, bottom: 10.0, left: 60.0, right: 60.0),
        child: Text(
          photo.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
        child: Text(
          photo.description,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black26, fontSize: 20),
        ),
      ),
    ]);
  }

  eventHandlingBodyWidget(int index) {
    return GestureDetector(
        onTap: () {
          print("Tapped on $index");
        },
        child: bodyWidget(index));
  }

  Future loadFromApi(String apiUrl) async {
    // Make a network request to the API.
    final response = await http.get(Uri.parse(apiUrl));

    // Check if the request was successful.
    if (response.statusCode == 200) {
      // Decode the JSON response.
      final json = jsonDecode(response.body);
      for (var item in json["objects"]) {
        // Get the image URL from the JSON response.
        var title = item['title'];
        var description = item['description'];
        var url = getURLFromThumb(item['contentdmfilename']);
        Photo photo = Photo(title, description, url);
        photos.add(photo);
      }
    } else {
      // Throw an error if the request was not successful.
      throw Exception('Request failed with status code ${response.statusCode}');
    }
  }

  getURLFromThumb(String thumbURL) {
    return "https://digital.lib.uidaho.edu/digital/iiif/spec_uihp/${thumbURL.replaceFirst(".jpg", "")}/full/max/0/default.jpg";
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
