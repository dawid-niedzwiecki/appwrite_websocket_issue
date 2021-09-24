import 'package:appwrite/appwrite.dart';

class ConnectionInfo {
  // com.example.test_project (add to Platforms ;D in Appwrite dashboard)

  static const String project = ""; //test project ID

  // The collection has just one rule (type text, called test).
  // with permissions set to read: * and write: *.
  static const String collection = ""; //test collection ID

  // And a document in it {"test": "test"} with permissions set to
  // read: * and write: *.
  static const String documentId = ""; //test document ID.

  // There is also a user created with the email "test@test.com".
  // And a password "testtest".
  static const String endpoint = ""; //endpoint
}

class Connection {
  final Client client = Client();
  late Account account;
  late Database db;
  late Avatars avatars;
  late Storage storage;
  late Realtime realtime;
  static Connection? _instance;

  Connection._internal() {
    client
        .setEndpoint(ConnectionInfo.endpoint)
        .setProject(ConnectionInfo.project);
    account = Account(client);
    db = Database(client);
    avatars = Avatars(client);
    storage = Storage(client);
    realtime = Realtime(client);
  }

  static Connection get instance {
    _instance ??= Connection._internal();
    return _instance!;
  }
}
