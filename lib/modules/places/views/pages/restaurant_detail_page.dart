import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/restaurant_controller.dart';
import '../../models/restaurant_model.dart';
import '../../models/place_model.dart';
import 'restaurant_form_page.dart';

class RestaurantDetailPage extends StatefulWidget {
  final PlaceModel place;
  final RestaurantModel restaurant;

  const RestaurantDetailPage({Key? key, required this.place, required this.restaurant}) : super(key: key);

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  late RestaurantController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RestaurantController());
    // Initialize the observable with the passed restaurant to ensure updated data is shown
    controller.currentRestaurant.value = widget.restaurant;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Obx(() {
        final rest = controller.currentRestaurant.value ?? widget.restaurant;
        
        return CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              stretch: true,
              backgroundColor: Theme.of(context).primaryColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  ),
                  tooltip: 'Supprimer',
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Confirmer',
                      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                      middleText: 'Voulez-vous vraiment supprimer ce restaurant ?',
                      textConfirm: 'Supprimer',
                      textCancel: 'Annuler',
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.red,
                      onConfirm: () async {
                        await controller.deleteRestaurant(rest.id);
                        if (controller.currentRestaurant.value == null) {
                           Get.back(); // Close Page if delete successful
                        }
                      },
                    );
                  },
                ),
                const SizedBox(width: 12),
              ],
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 16),
                title: Text(
                  rest.nom,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2))],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'cover_${rest.id}',
                      child: rest.couvertureUrl != null
                          ? Image.network(rest.couvertureUrl!, fit: BoxFit.cover)
                          : Container(
                              color: Colors.grey[800],
                              child: const Icon(Icons.restaurant, size: 80, color: Colors.white24),
                            ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black12, Colors.black45],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Info Header (Logo, Cuisine, Description)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (rest.logoUrl != null)
                          Container(
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(rest.logoUrl!, width: 64, height: 64, fit: BoxFit.cover),
                            ),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      rest.typeCuisine.toUpperCase(),
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  if (!rest.actif)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'FERMÉ',
                                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (rest.description != null && rest.description!.isNotEmpty)
                                Text(
                                  rest.description!,
                                  style: TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.4),
                                )
                              else
                                const Text("Aucune description.", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 40),
                    Row(
                      children: [
                        Icon(Icons.restaurant_menu_rounded, color: Colors.blueGrey[800]),
                        const SizedBox(width: 10),
                        Text(
                          "Menu",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Menu List
            if (rest.menu != null && rest.menu!['items'] != null && (rest.menu!['items'] as List).isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = (rest.menu!['items'] as List)[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10, spreadRadius: -10, offset: Offset(0, 5))],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.fastfood, color: Theme.of(context).primaryColor, size: 20),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'] ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  if (item['description'] != null && item['description'].toString().isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        item['description'],
                                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              "${item['price'] ?? 0} MRU",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: (rest.menu!['items'] as List).length,
                  ),
                ),
              )
            else
              const SliverToBoxAdapter(
                 child: Center(
                   child: Padding(
                     padding: EdgeInsets.all(40.0),
                     child: Text("Menu vide", style: TextStyle(color: Colors.grey)),
                   ),
                 ),
              ),
              
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final rest = controller.currentRestaurant.value ?? widget.restaurant;
          Get.to(() => RestaurantFormPage(place: widget.place, restaurant: rest));
        },
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text("Modifier", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
