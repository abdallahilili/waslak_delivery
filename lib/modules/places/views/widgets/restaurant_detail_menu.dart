import 'package:flutter/material.dart';
import '../../models/restaurant_model.dart';

class RestaurantDetailMenu extends StatelessWidget {
  final RestaurantModel restaurant;

  const RestaurantDetailMenu({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (restaurant.menu != null && restaurant.menu!['items'] != null && (restaurant.menu!['items'] as List).isNotEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = (restaurant.menu!['items'] as List)[index];
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
            childCount: (restaurant.menu!['items'] as List).length,
          ),
        ),
      );
    } else {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Text("Menu vide", style: TextStyle(color: Colors.grey)),
          ),
        ),
      );
    }
  }
}
