import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/restaurant_controller.dart';
import '../../models/restaurant_model.dart';
import '../../models/place_model.dart';
import '../widgets/restaurant_detail_app_bar.dart';
import '../widgets/restaurant_detail_info.dart';
import '../widgets/restaurant_detail_menu.dart';
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
            RestaurantDetailAppBar(restaurant: rest, controller: controller),
            RestaurantDetailInfo(restaurant: rest),
            RestaurantDetailMenu(restaurant: rest),
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
