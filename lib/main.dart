import 'package:flutter/material.dart';

import 'screens/menu_anchor_screen.dart';
import 'screens/multi_finger_screen.dart';
import 'screens/picture_in_picture_screen.dart';
import 'screens/popover_screen.dart';
import 'screens/snackbar_screen.dart';
import 'screens/superellipse_comparison_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('onTap'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SnackbarScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Picture in Picture'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PictureInPictureScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('マルチタッチジェスチャー'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MultiFingerScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('RSuperellipse比較'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SuperellipseComparisonScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Popover サンプル'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PopoverScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('MenuAnchor サンプル'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MenuAnchorScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
