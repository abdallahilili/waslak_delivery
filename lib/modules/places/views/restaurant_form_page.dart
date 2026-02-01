import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/restaurant_controller.dart';
import '../models/restaurant_model.dart';
import '../models/place_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';

class RestaurantFormPage extends StatefulWidget {
  final PlaceModel place;
  final RestaurantModel? restaurant; // Null if creating

  const RestaurantFormPage({Key? key, required this.place, this.restaurant}) : super(key: key);

  @override
  State<RestaurantFormPage> createState() => _RestaurantFormPageState();
}

class _RestaurantFormPageState extends State<RestaurantFormPage> {
  final controller = Get.put(RestaurantController());
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomCtrl;
  late TextEditingController _cuisineCtrl;
  late TextEditingController _descCtrl;
  bool _actif = true;

  File? _logoFile;
  File? _coverFile;

  final ImagePicker _picker = ImagePicker();

  // Menu Form
  final _itemNameCtrl = TextEditingController();
  final _itemPriceCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize fields
    _nomCtrl = TextEditingController(text: widget.restaurant?.nom ?? widget.place.nom);
    _cuisineCtrl = TextEditingController(text: widget.restaurant?.typeCuisine);
    _descCtrl = TextEditingController(text: widget.restaurant?.description);
    _actif = widget.restaurant?.actif ?? true;
    
    // Initialize controller state depending on edit/create
    if (widget.restaurant != null) {
      controller.menuItems.clear(); 
      if (widget.restaurant!.menu != null && widget.restaurant!.menu!['items'] != null) {
          final List<dynamic> items = widget.restaurant!.menu!['items'];
          controller.menuItems.assignAll(items.map((e) => Map<String, dynamic>.from(e)).toList());
       }
    } else {
      controller.menuItems.clear();
    }
    
    controller.currentRestaurant.value = widget.restaurant;
  }

  Future<void> _pickImage(bool isCover) async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file != null) {
      setState(() {
        if (isCover) {
          _coverFile = File(file.path);
        } else {
          _logoFile = File(file.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen width for layout
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        if (controller.isSaving.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 220,
              pinned: false, // Unpinned ensures Logo (in body) draws on top of App Bar
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                widget.restaurant != null ? "Modifier Restaurant" : "Nouveau Restaurant",
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 1))]
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Cover Image Display
                    GestureDetector(
                      onTap: () => _pickImage(true),
                      child: _coverFile != null
                          ? Image.file(_coverFile!, fit: BoxFit.cover)
                          : (widget.restaurant?.couvertureUrl != null
                              ? Image.network(widget.restaurant!.couvertureUrl!, fit: BoxFit.cover)
                              : Container(
                                  color: Colors.grey[800],
                                  child: Icon(Icons.camera_alt, size: 50, color: Colors.white.withOpacity(0.5)),
                                )),
                    ),
                    
                    // Gradient for Text contrast (wrapped in IgnorePointer to allow clicks)
                    IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black54, Colors.transparent, Colors.black54],
                            stops: const [0.0, 0.4, 1.0],
                          ),
                        ),
                      ),
                    ),
                    
                    // "Change Cover" Hint/Badge
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: () => _pickImage(true),
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
              ),
            ),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Logo Area with Overlap and Edit Badge
                      Transform.translate(
                        offset: const Offset(0, -50),
                        child: Center(
                          child: GestureDetector(
                            onTap: () => _pickImage(false),
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
                                    backgroundImage: _logoFile != null 
                                      ? FileImage(_logoFile!) 
                                      : (widget.restaurant?.logoUrl != null ? NetworkImage(widget.restaurant!.logoUrl!) : null) as ImageProvider?,
                                    child: (_logoFile == null && widget.restaurant?.logoUrl == null) 
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
                      
                      // Spacing adjustment because of negative margin
                      const SizedBox(height: 10), // Reduced from negative margin compensation

                      Text("Informations Générales", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      
                      // Fields
                      AppInput(
                        label: 'Nom du Restaurant *', 
                        controller: _nomCtrl, 
                        validator: (v) => v!.isEmpty ? 'Requis' : null,
                        prefixIcon: Icons.store,
                      ),
                      const SizedBox(height: 15),
                      AppInput(
                        label: 'Type de Cuisine *', 
                        controller: _cuisineCtrl, 
                        validator: (v) => v!.isEmpty ? 'Requis' : null,
                        hint: 'Ex: Fastfood, Pizzeria, Café',
                        prefixIcon: Icons.restaurant,
                      ),
                      const SizedBox(height: 15),
                      AppInput(
                        label: 'Description', 
                        controller: _descCtrl, 
                        maxLines: 3,
                        prefixIcon: Icons.description,
                      ),
                      
                      const SizedBox(height: 10),
                      SwitchListTile(
                        title: const Text('Restaurant Actif'),
                        subtitle: Text(_actif ? "Visible par les clients" : "Non visible"),
                        value: _actif,
                        onChanged: (v) => setState(() => _actif = v),
                        activeColor: Theme.of(context).primaryColor,
                        contentPadding: EdgeInsets.zero,
                      ),
                      
                      const Divider(height: 40, thickness: 1),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Menu", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          Text("${controller.menuItems.length} articles", style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                      const SizedBox(height: 15),
                      
                      // Add Item Form
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
                                Expanded(child: AppInput(label: 'Nom du plat', controller: _itemNameCtrl)),
                                const SizedBox(width: 10),
                                SizedBox(width: 100, child: AppInput(label: 'Prix', controller: _itemPriceCtrl, keyboardType: TextInputType.number)),
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
                                  if (_itemNameCtrl.text.isNotEmpty && _itemPriceCtrl.text.isNotEmpty) {
                                    controller.addMenuItem(
                                      _itemNameCtrl.text, 
                                      double.tryParse(_itemPriceCtrl.text) ?? 0, 
                                      ''
                                    );
                                    _itemNameCtrl.clear();
                                    _itemPriceCtrl.clear();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // List Menu Items
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
                      
                      const SizedBox(height: 40),
                      AppButton(
                        text: widget.restaurant != null ? 'METTRE À JOUR' : 'ENREGISTRER',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.saveRestaurant(
                              placeId: widget.place.id,
                              nom: _nomCtrl.text,
                              typeCuisine: _cuisineCtrl.text,
                              description: _descCtrl.text,
                              logoFile: _logoFile,
                              coverFile: _coverFile,
                              actif: _actif,
                              isUpdate: widget.restaurant != null,
                              existingId: widget.restaurant?.id,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
