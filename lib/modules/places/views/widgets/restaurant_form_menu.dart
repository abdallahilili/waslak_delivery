import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/restaurant_controller.dart';
import '../../../../shared/widgets/app_input.dart';

class RestaurantFormMenu extends StatelessWidget {
  final RestaurantController controller;
  final TextEditingController itemNameCtrl;
  final TextEditingController itemPriceCtrl;

  const RestaurantFormMenu({
    Key? key,
    required this.controller,
    required this.itemNameCtrl,
    required this.itemPriceCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Menu", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            Obx(() => Text("${controller.menuItems.length} articles", style: TextStyle(color: Colors.grey[600]))),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Ajouter un plat", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: AppInput(label: 'Nom du plat', controller: itemNameCtrl)),
                  const SizedBox(width: 10),
                  SizedBox(width: 100, child: AppInput(label: 'Prix', controller: itemPriceCtrl, keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Ajouter au Menu"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (itemNameCtrl.text.isNotEmpty && itemPriceCtrl.text.isNotEmpty) {
                      controller.addMenuItem(
                        itemNameCtrl.text, 
                        double.tryParse(itemPriceCtrl.text) ?? 0, 
                        ''
                      );
                      itemNameCtrl.clear();
                      itemPriceCtrl.clear();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Obx(() {
          if (controller.menuItems.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text("Aucun plat ajouté.", style: TextStyle(color: Colors.grey)),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.menuItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = controller.menuItems[index];
              return ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade100)),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Icon(Icons.fastfood, color: Theme.of(context).primaryColor, size: 20),
                ),
                title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("${item['price']} MRU", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red), 
                  onPressed: () => controller.removeMenuItem(index)
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
