import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/livreur_model.dart';
import '../widgets/livreur_card.dart';
import '../pages/livreur_detail_page.dart';

class LivreurListView extends StatelessWidget {
  final List<LivreurModel> livreurs;
  final Future<void> Function() onRefresh;

  const LivreurListView({
    Key? key,
    required this.livreurs,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (livreurs.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            alignment: Alignment.center,
            child: const Text('Aucun livreur trouvé'),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: livreurs.length,
        itemBuilder: (context, index) {
          final livreur = livreurs[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            child: LivreurCard(
              livreur: livreur,
              onTap: () => Get.to(() => LivreurDetailPage(livreur: livreur)),
            ),
          );
        },
      ),
    );
  }
}
