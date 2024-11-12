import 'package:flutter/material.dart';
import 'package:flutter_supabase_example/model/todo_model.dart';
import 'package:flutter_supabase_example/screen/widgets/todo_add_bottom_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoModel> todos = [];
  late SupabaseClient supabase;

  @override
  void initState() {
    super.initState();
    supabase = Supabase.instance.client;
    loadTodos();
  }

  void loadTodos() async {
    var response = await supabase.from('todo').select();
    if (response.isNotEmpty) {
      setState(() {
        todos = response
            .map(
              (e) => TodoModel.fromJson(e),
            )
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo with supabase'),
      ),
      body: ListView(
        children: todos
            .map(
              (e) => ListTile(
                leading: Checkbox(
                  value: e.completed,
                  onChanged: (value) {
                    // update 하기
                  },
                ),
                title: Text(e.content),
                trailing: IconButton(
                  onPressed: () {
                    // delete 하기
                  },
                  icon: Icon(Icons.delete),
                ),
              ),
            )
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTodoBottomSheet(context: context, callback: () {
            loadTodos();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
