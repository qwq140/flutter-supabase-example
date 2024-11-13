import 'package:flutter/material.dart';
import 'package:flutter_supabase_example/model/todo_model.dart';
import 'package:flutter_supabase_example/utils/validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future showTodoBottomSheet(
        {required BuildContext context,
        Function(TodoModel)? callback,
        TodoModel? todo}) =>
    showModalBottomSheet(
      context: context,
      builder: (context) => TodoAddBottomSheet(callback: callback, todo: todo),
      isScrollControlled: true,
    );

class TodoAddBottomSheet extends StatefulWidget {
  Function(TodoModel)? callback;
  TodoModel? todo;

  TodoAddBottomSheet({super.key, this.callback, this.todo});

  @override
  State<TodoAddBottomSheet> createState() => _TodoAddBottomSheetState();
}

class _TodoAddBottomSheetState extends State<TodoAddBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  String content = '';

  void onSave() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    TodoModel savedTodo;

    Map<String, dynamic> data = {'content': content};

    if (widget.todo == null) {
      // 저장 로직
      List<Map<String,dynamic>> result = await Supabase.instance.client.from('todo').insert(data).select();
      savedTodo = TodoModel.fromJson(result.first);
    } else {
      List<Map<String, dynamic>> result = await Supabase.instance.client
          .from('todo')
          .update(data)
          .eq('id', widget.todo!.id)
          .select();
      savedTodo = TodoModel.fromJson(result.first);
    }

    widget.callback?.call(savedTodo);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // viewInsets : 기기의 키보드에 의해서 가려지는 부분
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Form(
      key: formKey,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.only(
              top: 8, left: 16, right: 16, bottom: 8 + bottomInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text('내용'),
              TextFormField(
                onChanged: (value) {
                  content = value;
                },
                initialValue: widget.todo?.content ?? '',
                validator: contentValidator,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSave,
                  child: Text('저장'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
