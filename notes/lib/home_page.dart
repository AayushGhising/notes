import 'package:notes/create.dart';
import 'package:flutter/material.dart';
import 'package:notes/api.dart';
import 'package:notes/class.dart';
import 'package:notes/class_container.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<Class> myClass = [];
  bool isLoading = true;
  void fetchData() async {
    try {
      http.Response response = await http.get(Uri.parse(api));
      var data = json.decode(response.body);
      data.forEach(
        (class1) {
          Class c = Class(
            userId: class1['userId'],
            id: class1['id'],
            title: class1['title'],
            body: class1['body'],
          );
          myClass.add(c);
        },
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error is $e');
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void addNewPost(Class newPost) {
    setState(() {
      myClass.add(newPost);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001133),
      appBar: AppBar(
        title: const Text(
          'Home Page',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: myClass.map(
                      (e) {
                        return ClassContainer(
                          userId: e.userId,
                          id: e.id,
                          title: e.title,
                          body: e.body,
                          onDelete: () {
                            setState(
                              () {
                                myClass.remove(e);
                              },
                            );
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
      floatingActionButton: SizedBox(
        width: 120,
        height: 60,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Create(onCreate: addNewPost),
              ),
            );
          },
          icon: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
          label: const Text(
            'Create',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
