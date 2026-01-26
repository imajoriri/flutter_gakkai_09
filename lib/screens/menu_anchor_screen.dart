import 'package:flutter/material.dart';

class MenuAnchorScreen extends StatelessWidget {
  const MenuAnchorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MenuAnchor サンプル'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuAnchor(
              builder: (context, controller, child) {
                return ElevatedButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  child: const Text('メニューを開く 1'),
                );
              },
              menuChildren: [
                MenuItemButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('項目1が選択されました')),
                    );
                  },
                  child: const Text('項目1'),
                ),
                MenuItemButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('項目2が選択されました')),
                    );
                  },
                  child: const Text('項目2'),
                ),
                MenuItemButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('項目3が選択されました')),
                    );
                  },
                  child: const Text('項目3'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            MenuAnchor(
              builder: (context, controller, child) {
                return ElevatedButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  child: const Text('メニューを開く 2'),
                );
              },
              menuChildren: [
                MenuItemButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('項目1が選択されました')),
                    );
                  },
                  child: const Text('項目1'),
                ),
                MenuItemButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('項目2が選択されました')),
                    );
                  },
                  child: const Text('項目2'),
                ),
                MenuItemButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('項目3が選択されました')),
                    );
                  },
                  child: const Text('項目3'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
