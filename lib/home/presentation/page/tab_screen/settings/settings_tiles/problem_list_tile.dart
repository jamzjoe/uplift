import 'package:flutter/material.dart';

class ProblemListTile extends StatefulWidget {
  const ProblemListTile(
      {super.key, required this.problem, required this.solution});
  final String problem, solution;
  @override
  _ProblemListTileState createState() => _ProblemListTileState();
}

class _ProblemListTileState extends State<ProblemListTile> {
  bool _showDescription = true;

  void _toggleDescription() {
    setState(() {
      _showDescription = !_showDescription;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.problem),
      trailing: IconButton(
        icon: _showDescription
            ? const Icon(Icons.expand_less)
            : const Icon(Icons.expand_more),
        onPressed: _toggleDescription,
      ),
      onTap: _toggleDescription,
      subtitle: _showDescription
          ? Text(
              widget.solution,
              style: const TextStyle(color: Colors.grey),
            )
          : null,
    );
  }
}
