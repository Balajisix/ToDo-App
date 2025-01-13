import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapplication/data/database.dart';
import 'package:todoapplication/util/dialog_box.dart';
import 'package:todoapplication/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // references the hive box
  // final _myBox = Hive.openBox('mybox');
  late Box _myBox;
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    // TODO: implement initState

    // if this is the 1st time ever opening the app, then create default data
    // if(_myBox.get("TODOLIST") == null) {
    //   db.createInitialData();
    // } else {
    //   db.loadData();
    // }

    super.initState();
    _initializeHiveBox();
  }

  Future<void> _initializeHiveBox() async {
    _myBox = await Hive.openBox('mybox');
    if(_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    setState(() {});
  }

  // text controller
  final _controller = TextEditingController();

  // list of todo tasks
  // List todoList = [
  //   ["Make tutorial", false],
  //   ["Do Excercise", false],
  // ];

  // check box tapping'
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateDatabase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.todoList.add([ _controller.text, false ]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  // creating a new task
  void createNewTask() {
    showDialog(
      context: context, builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      }
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple[200],
        appBar: AppBar(
          backgroundColor: Colors.purple[300],
          title: Text(
            "ToDo App",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
            ),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewTask,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: db.todoList.length,
            itemBuilder: (context, index) {
              return TodoTile(
                taskName: db.todoList[index][0],
                taskCompleted: db.todoList[index][1],
                onChanged: (value) => checkBoxChanged(value, index),
                deleteFunction: (context) => deleteTask(index),
              );
            }
        )
    );
  }
}

extension FutureBoxExtension on Future<Box> {
  Future<dynamic> getValue(String key) async {
    final box = await this; // Await the Future<Box> to get the actual Box
    return box.get(key); // Retrieve the value for the given key
  }
}


