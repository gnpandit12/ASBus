import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
String _message = '';
String webViewURL = "https://asbuscompany.com";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'ASBus'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    _register();
    getMessage();
    print("InitState!");
    super.initState();
  }

  void getMessage(){
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');
          setState(() => _message = message["notification"]["title"]);
        }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["title"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["title"]);
    });
  }


  _register() {
    _firebaseMessaging.getToken().then((token) => print(token));
  }

  @override
  Widget build(BuildContext context) {
    final Completer<WebViewController> _controller = Completer<WebViewController>();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: WebView(
        initialUrl: webViewURL,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ), //
      floatingActionButton: FutureBuilder<WebViewController>(
          future: _controller.future,
          builder: (BuildContext context,
              AsyncSnapshot<WebViewController> controller) {
            if (controller.hasData) {
              return FloatingActionButton(
                backgroundColor: Colors.lightBlueAccent,
                  child: Icon(
                      Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    controller.data.goBack();
                  });
            }
            return Container();
          }
      ),
    );// This trailing comma makes auto-formatting nicer for build methods.
  }
}
