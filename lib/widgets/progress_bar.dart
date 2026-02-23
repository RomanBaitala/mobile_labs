import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int progress;
  const ProgressBar({required this.progress, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, _buildLevelStep),
    );

  }

  Widget _buildLevelStep(int index){
    final bool isActive = index < progress;

    return Container(
      width: 40,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: 
          isActive ? Colors.green : const Color.fromARGB(124, 158, 158, 158),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
