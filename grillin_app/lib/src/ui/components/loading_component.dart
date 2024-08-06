// ignore_for_file: unnecessary_null_comparison, unnecessary_type_check

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../values/k_colors.dart';

class LoadingComponent extends StatefulWidget {
  final Color color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;

  const LoadingComponent({
    super.key,
    this.color = Colors.grey,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 2000),
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        assert(size != null);

  @override
  SpinKitChasingDotsState createState() => SpinKitChasingDotsState();
}

class SpinKitChasingDotsState extends State<LoadingComponent>
    with TickerProviderStateMixin {
  late AnimationController _scaleCtrl, _rotateCtrl;
  late Animation<double> _scale, _rotate;

  @override
  void initState() {
    super.initState();

    _scaleCtrl = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() => setState(() {}))
      ..repeat(reverse: true);
    _scale = Tween(begin: -1.0, end: 1.0)
        .animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut));

    _rotateCtrl = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() => setState(() {}))
      ..repeat();
    _rotate = Tween(begin: 0.0, end: 360.0)
        .animate(CurvedAnimation(parent: _rotateCtrl, curve: Curves.linear));
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _rotateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: const CircularProgressIndicator(
          color: KColors.primary,
        ),
      ),
    );
  }
}

Widget loadingComponent(
  bool isVisible, {
  Color? color,
  double size = 50,
  EdgeInsetsGeometry? padding,
}) {
  return Visibility(
    visible: isVisible,
    child: Container(
      padding: padding ?? const EdgeInsets.all(0),
      color: Colors.transparent,
      alignment: Alignment.center,
      child: LoadingComponent(
        color: color ?? KColors.primary,
        size: size,
      ),
    ),
  );
}
