import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('2画面目')),
      body: const Center(
        child: Text('ここが2画面目', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
