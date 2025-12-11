import 'package:flutter/material.dart';
import '../models/fluxo_icon.dart';

class IconGrid extends StatelessWidget {
  final List<FluxoIcon> icons;
  final Function(FluxoIcon) onSelect;

  const IconGrid({required this.icons, required this.onSelect, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1,
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: icons.map((ic) {
        return GestureDetector(
          onTap: () => onSelect(ic),
          child: Column(
            children: [
              Image.asset(ic.asset, width: 80, height: 80),
              const SizedBox(height: 8),
              Text(ic.label, style: const TextStyle(fontSize: 18)),
            ],
          ),
        );
      }).toList(),
    );
  }
}