import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("main UI"),
        backgroundColor: const Color.fromARGB(255, 0, 140, 255),
      ),
      body: const Text("main UI"),
    );
  }
}
