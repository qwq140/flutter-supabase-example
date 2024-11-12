import 'package:flutter/material.dart';
import 'package:flutter_supabase_example/utils/validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future showTodoBottomSheet({required BuildContext context, VoidCallback? callback}) =>
    showModalBottomSheet(
      context: context,
      builder: (context) => TodoAddBottomSheet(callback: callback),
      isScrollControlled: true,
    );

class TodoAddBottomSheet extends StatefulWidget {
  VoidCallback? callback;

  TodoAddBottomSheet({super.key, this.callback});

  @override
  State<TodoAddBottomSheet> createState() => _TodoAddBottomSheetState();
}

class _TodoAddBottomSheetState extends State<TodoAddBottomSheet> {

  final GlobalKey<FormState> formKey = GlobalKey();

  String content = '';

  void onSave() async {
    if(!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    Map<String, dynamic> data = {
      'content' : content
    };

    // 저장 로직
    await Supabase.instance.client.from('todo').insert(data);
    widget.callback?.call();

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
          padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8+bottomInset),
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
