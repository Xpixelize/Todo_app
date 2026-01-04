import 'package:flutter/material.dart';
import 'package:todoapp/Models/Todoes.models.dart';
import 'package:todoapp/Themes/colours.dart';
import 'package:todoapp/services/db_helper.dart';

class SubdasbroadScreen extends StatefulWidget {
  final int? ktid;

  const SubdasbroadScreen({super.key, this.ktid});

  @override
  State<SubdasbroadScreen> createState() => _SubdasbroadScreenState();
}

class _SubdasbroadScreenState extends State<SubdasbroadScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final DatabaseHelper db = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    if (widget.ktid != null) {
      _loadTodo();
    }
  }

  Future<void> _loadTodo() async {
    final todos = await db.getTodos();
    final todo = todos.firstWhere((e) => e.id == widget.ktid);

    if (!mounted) return;

    setState(() {
      titleController.text = todo.title;
      descriptionController.text = todo.description;
    });
  }

  /// Save todo
  Future<void> _saveTodo() async {
    String title = titleController.text;
    String description = descriptionController.text;

    if (title.isEmpty && description.isEmpty) {
      title = "Untitled";
      description = "";
    }

    if (widget.ktid == null) {
      await db.C(
        Todelist(
          title: title,
          description: description,
          createdAt: DateTime.now().toString(),
        ),
      );
    } else {
      await db.updateTodo(
        Todelist(
          id: widget.ktid,
          title: title,
          description: description,
          createdAt: DateTime.now().toString(),
        ),
      );
    }
  }

  Future<void> _deleteTodo() async {
    await db.deleteTodo(widget.ktid!);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.ktid == null ? "New Task" : titleController.text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColours.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: () async {
              await _saveTodo();
             Navigator.pop(context);
              
            },
          ),
          if (widget.ktid != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertDialog(
                    title: const Text("Delete"),
                    content: const Text(
                      "Are you sure you want to delete this task?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("No"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _deleteTodo();
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          TextFormField(
            controller: titleController,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration(
              hintText: "Untitled",
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: descriptionController,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: "Description",
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
