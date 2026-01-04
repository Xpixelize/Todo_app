import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todoapp/Models/Todoes.models.dart';
import 'package:todoapp/Screens/subdasbroad_screen.dart';
import 'package:todoapp/services/db_helper.dart';
import 'package:todoapp/Themes/colours.dart';

class DasbroadScreen extends StatefulWidget {
  const DasbroadScreen({super.key});

  @override
  State<DasbroadScreen> createState() => _DasbroadScreenState();
}

class _DasbroadScreenState extends State<DasbroadScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<Todelist> todoList = [];
  List<int> Items_Delete = [];

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    final data = await dbHelper.getTodos();
    if (!mounted) return;

    setState(() {
      todoList.clear();
      for (int i = data.length - 1; i >= 0; i--) {
        todoList.add(data[i]);
      }
    });
  }

  // deleting multiple items
  Future<void> deleteMultipleItems() async {

    for (int id in Items_Delete) {
      if (Items_Delete.contains(id)){
      await dbHelper.deleteTodo(id);
      }
  }
   setState(() {
      Items_Delete.clear();
      todoList.clear();
    });

    fetchTodos();

  }
  // add deleting item 
  void deleteItem(int id){
    
    setState(() {
        if (!Items_Delete.contains(id)){
    Items_Delete.add(id);
  
}  else {
    Items_Delete.remove(id);
  }
    });
  }

  /// Navigate and refresh after returning
  Future<void> openTodo({int? id}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SubdasbroadScreen(ktid: id)),
    );

    if (result == true) {
      fetchTodos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TODOS',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColours.primary,
        leading: const Image(
          image: AssetImage('assets/images/applogo_icon.png'),
        ),
        actions: [
          if (Items_Delete.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertDialog(
                    title: Text(
                      'Delete ${Items_Delete.length.toString()} Item',
                    ),
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
                          
                          await deleteMultipleItems();
                          Navigator.pop(context);
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColours.primary,
        onPressed: () => openTodo(),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),

      body: todoList.isEmpty
          ? Center(child: Lottie.asset('assets/animations/notodes.json'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final todo = todoList[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      Items_Delete.contains(todo.id!)
                          ? Icons.check_circle
                          : Icons.check_circle_outline_outlined,
                    ),
                    title: Text(todo.title),
                    subtitle: Text(
                      todo.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Items_Delete.isEmpty
                          ? openTodo(id: todo.id)
                          : setState(() {
                              deleteItem(todo.id!);
                            });
                    },
                    onLongPress: () {
                      setState(() {
                        deleteItem(todo.id!);
                        }
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
