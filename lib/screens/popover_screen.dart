import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

const _springDuration = Duration(milliseconds: 300);

final showSpring = SpringDescription.withDurationAndBounce(
  duration: _springDuration,
  bounce: 0.3,
);

final hideSpring = SpringDescription.withDurationAndBounce(
  duration: _springDuration,
  bounce: 0.3,
);

class PopoverScreen extends StatefulWidget {
  const PopoverScreen({super.key});

  @override
  State<PopoverScreen> createState() => _PopoverScreenState();
}

class _PopoverScreenState extends State<PopoverScreen> {
  final _popoverKey = GlobalKey<_PopoverWrapperState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Popover サンプル'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _PopoverWrapper(
              key: _popoverKey,
              child: ElevatedButton(
                onPressed: () {
                  _popoverKey.currentState?.showPopover();
                },
                child: const Text('Popoverを表示'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopoverWrapper extends StatefulWidget {
  const _PopoverWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<_PopoverWrapper> createState() => _PopoverWrapperState();
}

class _PopoverWrapperState extends State<_PopoverWrapper>
    with SingleTickerProviderStateMixin {
  final _layerLink = LayerLink();
  final _portalController = OverlayPortalController();

  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController.unbounded(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _hidePopover() async {
    if (!_portalController.isShowing) return;

    try {
      await _animationController.animateWith(
        SpringSimulation(hideSpring, _animationController.value, 0, 0),
      );
    } finally {
      _portalController.hide();
    }
  }

  void showPopover() {
    if (_portalController.isShowing) return;

    _portalController.show();
    _animationController
      ..value = 0
      ..animateWith(SpringSimulation(showSpring, 0, 1, 0));
  }

  @override
  Widget build(BuildContext context) {
    final opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);
    final scale = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(_animationController);
    final translateY = Tween<double>(
      begin: -10,
      end: 0,
    ).animate(_animationController);

    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _portalController,
        overlayChildBuilder: (context) {
          return Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                targetAnchor: Alignment.bottomLeft,
                offset: const Offset(0, 8),
                showWhenUnlinked: false,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, _) => Opacity(
                    opacity: opacity.value.clamp(0, 1),
                    child: Transform.translate(
                      offset: Offset(0, translateY.value),
                      child: Transform.scale(
                        alignment: Alignment.topLeft,
                        scale: scale.value,
                        child: TapRegion(
                          onTapOutside: (_) => _hidePopover(),
                          child: _PopoverContent(onClose: _hidePopover),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}

class _PopoverContent extends StatelessWidget {
  const _PopoverContent({required this.onClose});

  final VoidCallback onClose;

  static const _arrowWidth = 14.0;
  static const _arrowHeight = 8.0;
  static const _radius = 10.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 260,
      child: Material(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: _arrowHeight),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(_radius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 60,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Popoverのタイトル',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'これはPopoverのサンプルです。テキストのみのシンプルな実装になっています。',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 20,
              child: CustomPaint(
                size: const Size(_arrowWidth, _arrowHeight),
                painter: _PopoverArrowPainter(color: theme.colorScheme.surface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopoverArrowPainter extends CustomPainter {
  const _PopoverArrowPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PopoverArrowPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
