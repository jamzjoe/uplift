import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class Test extends StatefulWidget {
  const Test({Key? key, required this.payloader}) : super(key: key);
  final String payloader;

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final data = jsonDecode(widget.payloader);
    return Scaffold(
      body: Center(child: SmallText(text: widget.payloader, color: darkColor)),
    );
  }
}
