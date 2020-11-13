import 'package:flutter/material.dart';
import 'package:indexed_listview/User.dart';
import 'package:indexed_listview/indexed_list_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<User> createUserList(List data){
    List<User> list = new List();
    for (int i = 0; i < data.length; i++) {

      User movie = new User(userId: data[i]["userId"],id: data[i]["id"],title: data[i]["title"],completed: data[i]["completed"]);
      list.add(movie);
    }
    return list;
  }

  final itemHeight = 100.0;

  List<User> items = List<User>();
  List<String> alphabets = List<String>();

  @override
  void initState() {
    super.initState();

    getUserFromRequest();

  }

  getUserFromRequest() async {
    final response = await http.get('https://jsonplaceholder.typicode.com/todos');
    var responseJson = json.decode(response.body.toString());

    List<User> userList = createUserList(responseJson);

    userList.sort((a, b) => a.title.compareTo(b.title));

    for (int i = 0; i < userList.length; i++){
      alphabets.add(userList[i].title.substring(0,1).toUpperCase());
    }
    // print("Alphabets:$alphabets");

    setState(() {
      items = userList;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Indexed List"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IndexedListView(
                  itemHeight: itemHeight,
                  items: alphabets,
                  itemBuilder: (context, index){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(items[index].title),
                        Text(items[index].completed.toString())
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        )
    );
  }
}


