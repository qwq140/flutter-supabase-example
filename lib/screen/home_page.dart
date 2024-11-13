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
    var response = await supabase.from('todo').select().order('created_at', ascending: false);
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

  void updateCompleted(int id, bool completed) async {
    List<Map<String, dynamic>> result = await supabase.from('todo').update({'completed' : completed}).eq('id', id).select();
    TodoModel todoResult = TodoModel.fromJson(result.first);
    setState(() {
      todos = todos.map((e) => e.id == todoResult.id ? todoResult : e,).toList();
    });
  }

  void deleteTodo(int id) async {
    await supabase.from('todo').delete().eq('id', id);
    setState(() {
      todos = todos.where((e) => e.id != id,).toList();
    });
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
                onTap: (){
                  showTodoBottomSheet(context: context, todo: e, callback: (TodoModel todo) {
                    setState(() {
                      todos = todos.map((e) => e.id == todo.id ? todo : e,).toList();
                    });
                  },);
                },
                leading: Checkbox(
                  value: e.completed,
                  onChanged: (value) {
                    // update 하기
                    if(value != null) {
                      updateCompleted(e.id, value);
                    }
                  },
                ),
                title: Text(e.content),
                trailing: IconButton(
                  onPressed: () {
                    // delete 하기
                    deleteTodo(e.id);
                  },
                  icon: Icon(Icons.delete),
                ),
              ),
            )
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTodoBottomSheet(context: context, callback: (TodoModel todo) {
            setState(() {
              todos = [todo, ...todos];
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
