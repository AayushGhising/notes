import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes/api.dart';
import 'package:notes/update.dart';

class ClassContainer extends StatefulWidget {
  int userId;
  int id;
  String title;
  String body;
  VoidCallback onDelete;

  ClassContainer({
    super.key,
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    required this.onDelete,
  });

  @override
  State<ClassContainer> createState() => _ClassContainerState();
}

class _ClassContainerState extends State<ClassContainer> {
  void deleteData(int userId) async {
    try {
      http.Response response =
          await http.delete(Uri.parse('$api/${widget.id}'));

      if (response.statusCode == 200) {
        print('Post ${widget.id} deleted successfully.');
        widget.onDelete();
      } else {
        print('Failed to delete the post. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  void updatePost() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 170,
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  widget.body,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Update(
                            userId: widget.userId,
                            id: widget.id,
                            title: widget.title,
                            body: widget.body,
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          widget.title = result['title'];
                          widget.body = result['body'];
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.update,
                      color: Colors.white,
                    ), // Add an icon for consistency
                    label: const Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      deleteData(widget.id);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ), // Add an icon for consistency
                    label: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
