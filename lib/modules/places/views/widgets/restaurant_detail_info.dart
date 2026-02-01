import 'package:flutter/material.dart';
import '../../models/restaurant_model.dart';

class RestaurantDetailInfo extends StatelessWidget {
  final RestaurantModel restaurant;

  const RestaurantDetailInfo({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (restaurant.logoUrl != null)
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(restaurant.logoUrl!, width: 64, height: 64, fit: BoxFit.cover),
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
                              restaurant.typeCuisine.toUpperCase(),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (!restaurant.actif)
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
                      if (restaurant.description != null && restaurant.description!.isNotEmpty)
                        Text(
                          restaurant.description!,
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
    );
  }
}
