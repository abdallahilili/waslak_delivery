import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/restaurant_controller.dart';
import '../../models/restaurant_model.dart';
import '../../models/place_model.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input.dart';
import '../widgets/restaurant_form_header.dart';
import '../widgets/restaurant_form_menu.dart';

class RestaurantFormPage extends StatefulWidget {
  final PlaceModel place;
  final RestaurantModel? restaurant;

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
  final _itemNameCtrl = TextEditingController();
  final _itemPriceCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomCtrl = TextEditingController(text: widget.restaurant?.nom ?? widget.place.nom);
    _cuisineCtrl = TextEditingController(text: widget.restaurant?.typeCuisine);
    _descCtrl = TextEditingController(text: widget.restaurant?.description);
    _actif = widget.restaurant?.actif ?? true;
    
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
              pinned: false,
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
                background: RestaurantFormHeader(
                  restaurant: widget.restaurant,
                  coverFile: _coverFile,
                  logoFile: _logoFile,
                  onPickCover: () => _pickImage(true),
                  onPickLogo: () => _pickImage(false),
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
                      const SizedBox(height: 10),
                      _buildInfoSection(),
                      const Divider(height: 40, thickness: 1),
                      RestaurantFormMenu(
                        controller: controller,
                        itemNameCtrl: _itemNameCtrl,
                        itemPriceCtrl: _itemPriceCtrl,
                      ),
                      const SizedBox(height: 40),
                      _buildSubmitButton(),
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

  Widget _buildInfoSection() {
    return Column(
      children: [
        Text("Informations Générales", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
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
        SwitchListTile(
          title: const Text('Restaurant Actif'),
          subtitle: Text(_actif ? "Visible par les clients" : "Non visible"),
          value: _actif,
          onChanged: (v) => setState(() => _actif = v),
          activeColor: Theme.of(context).primaryColor,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return AppButton(
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
    );
  }
}
