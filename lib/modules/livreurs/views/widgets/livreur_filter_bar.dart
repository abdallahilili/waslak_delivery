import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/livreur_controller.dart';
import '../../models/livreur_filter_model.dart';

class LivreurFilterBar extends GetView<LivreurController> {
  const LivreurFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            onChanged: (val) => controller.searchLivreurs(val),
            decoration: InputDecoration(
              hintText: 'Rechercher par nom, téléphone, NNI...',
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatusDropdown(),
                const SizedBox(width: 8),
                _buildZoneDropdown(),
                const SizedBox(width: 8),
                _buildDispoDropdown(),
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: () {
                     controller.filterLivreurs(LivreurFilter());
                  },
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Réinitialiser'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Obx(() {
      return Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.currentFilter.value.statut,
            style: const TextStyle(fontSize: 13, color: Colors.black),
            items: const [
              DropdownMenuItem(value: 'tous', child: Text('Tous les statuts')),
              DropdownMenuItem(value: 'actif', child: Text('Actif')),
              DropdownMenuItem(value: 'inactif', child: Text('Inactif')),
              DropdownMenuItem(value: 'bloque', child: Text('Bloqué')),
            ],
            onChanged: (val) {
              if (val != null) {
                controller.filterLivreurs(controller.currentFilter.value.copyWith(statut: val));
              }
            },
          ),
        ),
      );
    });
  }

  Widget _buildZoneDropdown() {
    return Obx(() {
      return Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            value: controller.currentFilter.value.zone,
            hint: const Text('Toutes Zones', style: TextStyle(fontSize: 13)),
            style: const TextStyle(fontSize: 13, color: Colors.black),
            items: const [
              DropdownMenuItem(value: null, child: Text('Toutes Zones')),
              DropdownMenuItem(value: 'NKC_CENTER', child: Text('NKC Centre')),
              DropdownMenuItem(value: 'NKC_NORTH', child: Text('NKC Nord')),
              DropdownMenuItem(value: 'NKC_SOUTH', child: Text('NKC Sud')),
            ],
            onChanged: (val) {
              controller.filterLivreurs(controller.currentFilter.value.copyWith(zone: val));
            },
          ),
        ),
      );
    });
  }

  Widget _buildDispoDropdown() {
    return Obx(() {
      return Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<bool?>(
            value: controller.currentFilter.value.estDisponible,
            hint: const Text('Disponibilité', style: TextStyle(fontSize: 13)),
            style: const TextStyle(fontSize: 13, color: Colors.black),
            items: const [
              DropdownMenuItem(value: null, child: Text('Tous types')),
              DropdownMenuItem(value: true, child: Text('Disponibles')),
              DropdownMenuItem(value: false, child: Text('Connectés')),
            ],
            onChanged: (val) {
              controller.filterLivreurs(controller.currentFilter.value.copyWith(estDisponible: val));
            },
          ),
        ),
      );
    });
  }
}
