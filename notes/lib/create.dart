import 'package:notes/api.dart';
import 'package:notes/class.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Create extends StatefulWidget {
  final Function(Class) onCreate;

  const Create({super.key, required this.onCreate});

  @override
  State<Create> createState() {
    return _CreateState();
  }
}

class _CreateState extends State<Create> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  void postData(String userId, String title, String body) async {
    try {
      http.Response response = await http.post(
        Uri.parse(api),
        body: {
          'userId': userId,
          'title': title,
          'body': body,
        },
      );

      if (response.statusCode == 201) {
        var data = jsonDecode(
          response.body.toString(),
        );
        print(data);
        print('Account Created Successfully');

        // Create a Class object form the response data
        Class newPost = Class(
          userId: int.parse(data['userId']),
          id: data['id'],
          title: data['title'],
          body: data['body'],
        );

        // Call the onCreate callback to pass the new post to HomePage
        widget.onCreate(newPost);

        // Navigage back to the HomePage after creating the post
        Navigator.pop(context);
      } else {
        print('failed');
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
        title: const Text('Create Post'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: userIdController,
              decoration: const InputDecoration(hintText: 'User ID'),
            ),
            const SizedBox(height: 20),
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
                postData(
                  userIdController.text.toString(),
                  titleController.text.toString(),
                  bodyController.text.toString(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Create',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
