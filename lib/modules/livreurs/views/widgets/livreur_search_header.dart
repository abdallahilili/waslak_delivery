import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_input.dart';

class LivreurSearchHeader extends StatelessWidget {
  final Function(String) onChanged;

  const LivreurSearchHeader({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppInput(
        label: 'Rechercher',
        hint: 'Nom, téléphone ou NNI',
        suffixIcon: const Icon(Icons.search),
        onChanged: onChanged,
      ),
    );
  }
}
