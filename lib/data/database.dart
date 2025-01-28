import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List todoList = [];

  // reference our box
  final _myBox = Hive.box('mybox');

  // run this method if this is the 1st time opening this app
  void createInitialData() {
    todoList = [
      ["Be Disciplined!", false, DateTime.now().toString()],
      ["Think positive!", false, DateTime.now().toString()],
    ];
  }

  // load the data in the database
  void loadData() {
    todoList = _myBox.get("TODOLIST");
  }

  // update the database
  void updateDatabase() {
    _myBox.put("TODOLIST", todoList);
  }
}