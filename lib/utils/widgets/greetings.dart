import 'package:flutter/material.dart';
import 'dart:async';

import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';

class GreetingWidget extends StatefulWidget {
  const GreetingWidget({super.key});

  @override
  _GreetingWidgetState createState() => _GreetingWidgetState();
}

class _GreetingWidgetState extends State<GreetingWidget> {
  String _greetingMessage = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateGreeting);
  }

  void _updateGreeting(Timer timer) {
    setState(() {
      var now = DateTime.now();
      var hour = now.hour;
      if (hour < 12) {
        _greetingMessage = 'Good morning,';
      } else if (hour < 18) {
        _greetingMessage = 'Good afternoon,';
      } else {
        _greetingMessage = 'Good evening,';
      }
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultText(text: _greetingMessage, color: secondaryColor);
  }
}
