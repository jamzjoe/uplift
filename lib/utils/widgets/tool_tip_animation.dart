import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';

class AutoStartTooltip extends StatefulWidget {
  final Widget child;
  final Duration interval;
  final String tooltipMessage;

  const AutoStartTooltip({
    super.key,
    required this.child,
    required this.tooltipMessage,
    this.interval = const Duration(seconds: 1),
  });

  @override
  _AutoStartTooltipState createState() => _AutoStartTooltipState();
}

class _AutoStartTooltipState extends State<AutoStartTooltip> {
  late OverlayEntry _overlayEntry;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _overlayEntry = OverlayEntry(builder: (context) => _buildTooltip());
    _timer = Timer.periodic(widget.interval, (_) => _showTooltip());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _overlayEntry.remove();
    super.dispose();
  }

  void _showTooltip() {
    Overlay.of(context).insert(_overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _overlayEntry.remove();
      }
    });
  }

  Widget _buildTooltip() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Container(
          alignment: Alignment.center,
          color: Colors.grey.withOpacity(0.9),
          padding: const EdgeInsets.all(8),
          child: Text(
            widget.tooltipMessage,
            style: const TextStyle(color: secondaryColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
