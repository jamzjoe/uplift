import 'package:flutter/material.dart';

class UIServices {
  Future<void> scrollToBottom(ScrollController scrollController) {
    return scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
