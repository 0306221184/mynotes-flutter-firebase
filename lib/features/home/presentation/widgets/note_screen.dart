import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("My Notes"),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 140, 255),

        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: const Icon(Icons.arrow_back)),
        // elevation: 10.0,
        // flexibleSpace: null,
        // shape: null,
        // toolbarHeight: null,
        // iconTheme: null,
        // titleTextStyle: null,
        // systemOverlayStyle: null,
        // foregroundColor: null,
        // automaticallyImplyLeading: true,
      ),
      body: const Text("main UI"),
    );
  }
}
