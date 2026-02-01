import 'dart:io';
import 'package:flutter/material.dart';

class FormImagePicker extends StatelessWidget {
  final String label;
  final File? image;
  final String? currentUrl;
  final String type;
  final VoidCallback onTap;

  const FormImagePicker({
    Key? key,
    required this.label,
    required this.image,
    required this.currentUrl,
    required this.type,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isProfile = type == 'profil';
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 100,
            width: isProfile ? 100 : double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: isProfile ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: isProfile ? null : BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: ClipRRect(
              borderRadius: isProfile ? BorderRadius.circular(100) : BorderRadius.circular(8),
              child: image != null
                  ? Image.file(image!, fit: BoxFit.cover)
                  : (currentUrl != null 
                      ? Image.network(currentUrl!, fit: BoxFit.cover)
                      : const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
