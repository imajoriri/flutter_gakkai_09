import 'package:flutter/material.dart';

class SuperellipseComparisonScreen extends StatefulWidget {
  const SuperellipseComparisonScreen({super.key});

  @override
  State<SuperellipseComparisonScreen> createState() =>
      _SuperellipseComparisonScreenState();
}

class _SuperellipseComparisonScreenState
    extends State<SuperellipseComparisonScreen> {
  double _radius = 20.0;
  bool _isOverlapped = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RSuperellipse比較'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // スライダーコントロール
              _buildControlSection(theme),
              const SizedBox(height: 32),
              // サイドバイサイド比較
              _buildSideBySideComparison(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('コーナー半径の調整', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Text('半径: ${_radius.toStringAsFixed(1)}'),
            Slider(
              value: _radius,
              min: 0,
              max: 100,
              divisions: 100,
              label: _radius.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _radius = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('重ねて表示', style: theme.textTheme.bodyMedium),
                Switch(
                  value: _isOverlapped,
                  onChanged: (value) {
                    setState(() {
                      _isOverlapped = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideBySideComparison(ThemeData theme) {
    final rRectWidget = Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: Center(
        child: Text(
          'RRect',
          style: theme.textTheme.titleSmall?.copyWith(color: Colors.white),
        ),
      ),
    );

    final superellipseWidget = ClipRSuperellipse(
      borderRadius: BorderRadius.circular(_radius),
      child: Container(
        width: 150,
        height: 150,
        color: Colors.orange,
        child: Center(
          child: Text(
            'RSuperellipse',
            style: theme.textTheme.titleSmall?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('サイドバイサイド比較', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Center(
              child: _isOverlapped
                  ? Stack(
                      alignment: Alignment.center,
                      children: [rRectWidget, superellipseWidget],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            rRectWidget,
                            const SizedBox(height: 8),
                            Text('通常の角丸', style: theme.textTheme.bodySmall),
                          ],
                        ),
                        Column(
                          children: [
                            superellipseWidget,
                            const SizedBox(height: 8),
                            Text(
                              'Superellipse',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
