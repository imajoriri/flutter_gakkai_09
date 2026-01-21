import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MultiFingerScreen extends StatefulWidget {
  const MultiFingerScreen({super.key});

  @override
  State<MultiFingerScreen> createState() => _MultiFingerScreenState();
}

class _MultiFingerScreenState extends State<MultiFingerScreen>
    with SingleTickerProviderStateMixin {
  bool _isSelectionMode = false;
  final Set<int> _selectedIndices = {};
  Offset? _scaleStartFocalPoint;
  static const double _swipeThreshold = 50.0; // スワイプ検出の閾値
  late final AnimationController _animationController;

  final List<_MailItem> _mailItems = List.generate(
    20,
    (index) => _MailItem(
      id: index,
      subject: 'メール件名 ${index + 1}',
      sender: '送信者${index + 1}@example.com',
      preview: 'これはメールのプレビューテキストです。内容の一部が表示されます。',
      date: DateTime.now().subtract(Duration(hours: index)),
    ),
  );

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        )..addListener(() {
          setState(() {});
        });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onScaleStart(ScaleStartDetails details) {
    if (details.pointerCount == 2) {
      _scaleStartFocalPoint = details.focalPoint;
    }
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount == 2 && _scaleStartFocalPoint != null) {
      final delta = details.focalPoint - _scaleStartFocalPoint!;
      // 横方向へのスワイプを検出（左右どちらでも）
      if (delta.dx.abs() > _swipeThreshold && !_isSelectionMode) {
        setState(() {
          _isSelectionMode = true;
          _scaleStartFocalPoint = null;
        });
        _animationController.forward();
      }
    }
  }

  void _onScaleEnd(ScaleEndDetails details) {
    _scaleStartFocalPoint = null;
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  void _exitSelectionMode() {
    _animationController.reverse().then((_) {
      setState(() {
        _isSelectionMode = false;
        _selectedIndices.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: _isSelectionMode
            ? Text('${_selectedIndices.length}件選択')
            : const Text('メール一覧'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: _isSelectionMode
            ? [
                if (_selectedIndices.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // 削除処理（デモなので実際の削除は行わない）
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${_selectedIndices.length}件を削除'),
                        ),
                      );
                      _exitSelectionMode();
                    },
                  ),
              ]
            : null,
      ),
      body: GestureDetector(
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        onScaleEnd: _onScaleEnd,
        child: ListView.builder(
          itemCount: _mailItems.length,
          itemBuilder: (context, index) {
            final item = _mailItems[index];
            final isSelected = _selectedIndices.contains(index);

            return InkWell(
              onTap: _isSelectionMode
                  ? () => _toggleSelection(index)
                  : () {
                      // 通常モードではメール詳細を開く（デモ）
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item.subject}を開く')),
                      );
                    },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.3,
                        )
                      : null,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    SizeTransition(
                      axis: Axis.horizontal,
                      axisAlignment: -1.0,
                      sizeFactor: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Curves.easeOut,
                            ),
                          ),
                          child: FadeTransition(
                            opacity: _animationController,
                            child: Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : Colors.grey,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.subject,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.sender,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : null,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatDate(item.date),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.preview,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return '昨日';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}日前';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}

class _MailItem {
  const _MailItem({
    required this.id,
    required this.subject,
    required this.sender,
    required this.preview,
    required this.date,
  });

  final int id;
  final String subject;
  final String sender;
  final String preview;
  final DateTime date;
}
