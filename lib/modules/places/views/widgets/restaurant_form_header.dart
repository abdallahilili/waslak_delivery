import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/restaurant_model.dart';

class RestaurantFormHeader extends StatelessWidget {
  final RestaurantModel? restaurant;
  final File? coverFile;
  final File? logoFile;
  final VoidCallback onPickCover;
  final VoidCallback onPickLogo;

  const RestaurantFormHeader({
    Key? key,
    this.restaurant,
    this.coverFile,
    this.logoFile,
    required this.onPickCover,
    required this.onPickLogo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: onPickCover,
              child: Container(
                height: 220,
                width: double.infinity,
                child: coverFile != null
                    ? Image.file(coverFile!, fit: BoxFit.cover)
                    : (restaurant?.couvertureUrl != null
                        ? Image.network(restaurant!.couvertureUrl!, fit: BoxFit.cover)
                        : Container(
                            color: Colors.grey[800],
                            child: Icon(Icons.camera_alt, size: 50, color: Colors.white.withOpacity(0.5)),
                          )),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: onPickCover,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5)
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
        Transform.translate(
          offset: const Offset(0, -50),
          child: Center(
            child: GestureDetector(
              onTap: onPickLogo,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
                      ]
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: logoFile != null 
                        ? FileImage(logoFile!) 
                        : (restaurant?.logoUrl != null ? NetworkImage(restaurant!.logoUrl!) : null) as ImageProvider?,
                      child: (logoFile == null && restaurant?.logoUrl == null) 
                        ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                        : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
