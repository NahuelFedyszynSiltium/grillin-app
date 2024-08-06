// ignore_for_file: unnecessary_null_comparison, unnecessary_type_check

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../values/k_colors.dart';

class LoadingComponent extends StatefulWidget {
  const LoadingComponent({
    super.key,
  });

  @override
  SpinKitChasingDotsState createState() => SpinKitChasingDotsState();
}

class SpinKitChasingDotsState extends State<LoadingComponent>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size.square(MediaQuery.of(context).size.width * .2),
        child: const CircularProgressIndicator(
          color: KColors.primaryL1,
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
      child: const LoadingComponent(),
    ),
  );
}
