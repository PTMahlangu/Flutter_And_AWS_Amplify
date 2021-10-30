import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:aws_amplify/models/ModelProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoView extends StatefulWidget {
  @override
  createState() => _TodoView();
}

class _TodoView extends State<TodoView> {
  final _todoTittleController = TextEditingController();

  bool _showIncompleteOnly = false;

  List<Todo> _todo = [];

  List<Todo> get _presentTodos {
    return _showIncompleteOnly
        ? _todo.where((todo) => !todo.isComplete!).toList()
        : _todo;
  }

  @override
  void initState() {
    super.initState();
    _observeTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        if (_todo.isEmpty) {
          return _emptyTodoView();
        } else {
          return _todoListView();
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return _crateNewTodoView();
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _emptyTodoView() {
    return Center(
      child: Text("No todo yet"),
    );
  }

  Widget _crateNewTodoView() {
    return Center(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 30,right: 30,bottom: 20),
            child: TextField(
              controller: _todoTittleController,
              decoration: InputDecoration(labelText: "Todo Title"),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                _saveTodo();
                _todoTittleController.text = '';
                Navigator.pop(context);
              },
              child: Text("Save Todo"))
        ],
      ),
    );
  }

  Widget _todoListView() {
    return ListView.builder(
      itemCount: _presentTodos.length,
      itemBuilder: (context, index) {
        final todo = _presentTodos[index];
        return Card(
          child: CheckboxListTile(
            title: Text(todo.name),
            subtitle: todo.isComplete! ? Text("done") : Text("Not done"),
            value: todo.isComplete,
            onChanged: (newValue)  => _updateTodoCompleStatus(todo, newValue!),
          ),
        );
      },
    );
  }

  void _updateTodoCompleStatus(Todo todo, bool isComplete) async{
    try {
      final updateTodo = todo.copyWith(isComplete: isComplete);
      await Amplify.DataStore.save(updateTodo);
    } catch (e) {
      print(e);
    }
  }

  void _saveTodo() async {
    try {
      final newTodo = Todo(name: _todoTittleController.text, isComplete: false);
      await Amplify.DataStore.save(newTodo);
    } catch (e) {
      print(e);
    }
  }

  void _observeTodo() async {
    final stream = Amplify.DataStore.observe(Todo.classType);

    stream.listen((event) async {
      try {
        final todos = await Amplify.DataStore.query(Todo.classType);
        setState(() {
          _todo = todos;
        });
      } catch (e) {
        print(e);
      }
    });
  }
}
