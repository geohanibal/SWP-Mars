import 'package:flutter/material.dart';

/// Breadcrumb
/// Author: Sergi Koniashvili
/// This widget displays a breadcrumb navigation bar to indicate the current navigation path.
/// It dynamically builds a sequence of paths separated by chevron icons.
class Breadcrumb extends StatelessWidget {
  final List<String> paths; // List of paths to display in the breadcrumb

  const Breadcrumb({Key? key, required this.paths}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey[200],
      child: Row(
        children: paths
            .map(
              (path) => Row(
                children: [
                  Text(
                    path,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (path != paths.last)
                    const Icon(Icons.chevron_right, size: 18),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
