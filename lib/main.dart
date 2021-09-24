import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:test_project/connection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late RealtimeSubscription websocket;
  int websocketResponses = 0;
  int timesRefreshed = 0;

  @override
  void initState() {
    super.initState();
    Connection.instance.account
        .createSession(email: "test@test.com", password: "testtest");
    websocket = Connection.instance.realtime
        .subscribe(["collections.${ConnectionInfo.collection}.documents"]);
    websocket.stream.listen((event) {
      setState(() {
        websocketResponses++;
      });
    });
  }

  Future<void> refreshWebsocketConnection() async {
    await websocket.close();
    websocket = Connection.instance.realtime
        .subscribe(["collections.${ConnectionInfo.collection}.documents"]);
    websocket.stream.listen((event) {
      setState(() {
        websocketResponses++;
      });
    });
    setState(() {
      timesRefreshed++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "The issue is, that only every other time I refresh the websocket connection (close it and then subscribe again), it actually works. It kinda works like a switch (first time closes the conenction, second time subscribes to it (although both of them are one after the other in the same function).",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () => refreshWebsocketConnection(),
              child: const Text("Refresh (restart the websocket connection)"),
            ),
            ElevatedButton(
              onPressed: () => Connection.instance.db.updateDocument(
                collectionId: ConnectionInfo.collection,
                documentId: ConnectionInfo.documentId,
                data: {"test": "test"},
              ),
              child: const Text("Test websocket connection"),
            ),
            Container(
              color: Colors.amberAccent,
              width: 300,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Payloads received: \n$websocketResponses",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 30),
                  ),
                  Text(
                    "Times refreshed: \n$timesRefreshed",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
