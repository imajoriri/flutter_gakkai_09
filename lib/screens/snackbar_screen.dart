import 'package:flutter/material.dart';

class SnackbarScreen extends StatelessWidget {
  const SnackbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(backgroundColor: theme.colorScheme.inversePrimary),
      body: Center(
        child: GestureDetector(
          onDoubleTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('ダブルタップ'),
                backgroundColor: Colors.blue,
              ),
            );
          },
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('シングルタップ')));
            },
            child: const Text('Tap!!'),
          ),
        ),
      ),
    );
  }
}
