import 'package:flutter/physics.dart';
import 'package:flutter/material.dart';

class PictureInPictureScreen extends StatefulWidget {
  const PictureInPictureScreen({super.key});

  @override
  State<PictureInPictureScreen> createState() => _PictureInPictureScreenState();
}

class _PictureInPictureScreenState extends State<PictureInPictureScreen>
    with TickerProviderStateMixin {
  // (0,0) を「画面中央」として、そこからの移動量を持つ。
  late final AnimationController _xController;
  late final AnimationController _yController;

  // 触った瞬間に追従しつつ、離したら気持ちよく中央へ戻る程度のバネ設定。
  // ここは好みで調整してOK。
  static final SpringDescription _spring =
      SpringDescription.withDurationAndBounce(
        duration: Duration(milliseconds: 1000),
        bounce: 0.3,
      );

  Offset get _offset => Offset(_xController.value, _yController.value);

  void _setOffset(Offset offset) {
    _xController.value = offset.dx;
    _yController.value = offset.dy;
  }

  @override
  void initState() {
    super.initState();
    _xController =
        AnimationController.unbounded(
          vsync: this,
          duration: Duration(milliseconds: 1000),
        )..addListener(() {
          setState(() {});
        });
    _yController =
        AnimationController.unbounded(
          vsync: this,
          duration: Duration(milliseconds: 1000),
        )..addListener(() {
          setState(() {});
        });

    _setOffset(Offset.zero);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }

  void _stopSpring() {
    _xController.stop();
    _yController.stop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture in Picture'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // 背景は「まっさら」にする（空のキャンバス）
              const SizedBox.expand(),

              // 画面中央基準で浮かせて、ドラッグで移動（Offsetを加算）
              Align(
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: _offset,
                  child: GestureDetector(
                    onPanStart: (_) {
                      _stopSpring();
                    },
                    onPanUpdate: (details) {
                      final offset = _offset + details.delta;
                      _xController.value = offset.dx;
                      _yController.value = offset.dy;
                    },
                    onPanEnd: (details) {
                      _stopSpring();
                      final velocity = details.velocity.pixelsPerSecond;

                      _xController.animateWith(
                        SpringSimulation(_spring, _offset.dx, 0.0, velocity.dx),
                      );
                      _yController.animateWith(
                        SpringSimulation(_spring, _offset.dy, 0.0, velocity.dy),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: 180,
                      height: 120,
                      child: Text(
                        'PiP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
