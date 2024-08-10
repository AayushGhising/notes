import 'dart:convert';
import 'package:notes/class.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes/api.dart';

class Update extends StatefulWidget {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Update({
    super.key,
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  @override
  State<Update> createState() {
    return _UpdateState();
  }
}

class _UpdateState extends State<Update> {
  late TextEditingController titleController;
  late TextEditingController bodyController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    bodyController = TextEditingController(text: widget.body);
  }

  void updateData(String title, String body) async {
    try {
      http.Response response = await http.put(
        Uri.parse(api + '/${widget.id}'),
        body: {
          'userId': widget.userId.toString(),
          'title': title,
          'body': body,
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print('Post ${widget.id} Updated Successfully');
        print(data);

        Navigator.pop(context, {
          'title': titleController.text.toString(),
          'body': bodyController.text.toString(),
        });
      } else {
        print('Failed to update post');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Post',
          style: TextStyle(
            // color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: bodyController,
            decoration: const InputDecoration(hintText: 'Body'),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              updateData(
                titleController.text.toString(),
                bodyController.text.toString(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Update',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
