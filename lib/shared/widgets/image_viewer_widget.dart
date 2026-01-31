import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

class ImageViewerWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final bool showInDialog;

  const ImageViewerWidget({
    Key? key,
    required this.imageUrl,
    required this.title,
    this.showInDialog = false,
  }) : super(key: key);

  /// Ouvre l'image en plein écran avec zoom
  void openFullScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            _FullScreenImageViewer(imageUrl: imageUrl, title: title),
      ),
    );
  }

  /// Télécharge l'image
  Future<void> _downloadImage(BuildContext context) async {
    try {
      // Sur Android 10 (API 29) et plus, l'accès au stockage externe de l'application
      // ne nécessite pas de permissions. Pour la galerie publique, c'est différent.
      if (Platform.isAndroid) {
        // Optionnel : Si vous voulez vraiment tester les permissions
        // Note: Sur Android 13+, Permission.storage ne renvoie plus 'granted'
        if (await Permission.storage.isDenied) {
          await Permission.storage.request();
        }
      }

      // Afficher un indicateur de chargement
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
        barrierDismissible: false,
      );

      final dio = Dio();
      // Utilisation du dossier Downloads ou Pictures pour qu'il soit plus facile à trouver
      Directory? directory;
      
      if (Platform.isAndroid) {
        // Tente d'accéder au dossier public Downloads
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final fileName = 'Livreur_${title.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${directory!.path}/$fileName';

      await dio.download(imageUrl, filePath);

      // Fermer le dialogue de chargement
      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar(
        'Succès',
        'Image enregistrée dans : ${directory.path}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar(
        'Erreur',
        'Impossible d\'enregistrer l\'image : $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    }
  }

  /// Partage l'image
  Future<void> _shareImage(BuildContext context) async {
    try {
      // Afficher un indicateur de chargement
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Télécharger l'image temporairement
      final dio = Dio();
      final directory = await getTemporaryDirectory();
      final fileName =
          'share_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${directory.path}/$fileName';

      await dio.download(imageUrl, filePath);

      // Fermer le dialogue de chargement
      Get.back();

      // Partager l'image
      await Share.shareXFiles([XFile(filePath)], text: title);
    } catch (e) {
      // Fermer le dialogue de chargement si ouvert
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      print('Impossible de partager l\'image: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de partager l\'image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openFullScreen(context),
      child: Stack(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.download,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => _downloadImage(context),
                    tooltip: 'Télécharger',
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => _shareImage(context),
                    tooltip: 'Partager',
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.zoom_in,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => openFullScreen(context),
                    tooltip: 'Zoom',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget pour afficher l'image en plein écran avec zoom
class _FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String title;

  const _FullScreenImageViewer({
    Key? key,
    required this.imageUrl,
    required this.title,
  }) : super(key: key);

  /// Télécharge l'image (réutilise la logique du widget parent si possible, 
  /// mais ici nous sommes dans une classe séparée)
  Future<void> _downloadImage(BuildContext context) async {
    // On appelle la même logique pour rester cohérent
    try {
      if (Platform.isAndroid) {
        await Permission.storage.request();
      }

      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.blue)),
        barrierDismissible: false,
      );

      final dio = Dio();
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final fileName = 'Livreur_${title.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${directory!.path}/$fileName';

      await dio.download(imageUrl, filePath);

      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar(
        'Succès',
        'Image enregistrée avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar('Erreur', 'Erreur lors du téléchargement : $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  /// Partage l'image
  Future<void> _shareImage(BuildContext context) async {
    try {
      // Afficher un indicateur de chargement
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Télécharger l'image temporairement
      final dio = Dio();
      final directory = await getTemporaryDirectory();
      final fileName =
          'share_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${directory.path}/$fileName';

      await dio.download(imageUrl, filePath);

      // Fermer le dialogue de chargement
      Get.back();

      // Partager l'image
      await Share.shareXFiles([XFile(filePath)], text: title);
    } catch (e) {
      // Fermer le dialogue de chargement si ouvert
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Erreur',
        'Impossible de partager l\'image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () => _downloadImage(context),
            tooltip: 'Télécharger',
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () => _shareImage(context),
            tooltip: 'Partager',
          ),
        ],
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3,
        initialScale: PhotoViewComputedScale.contained,
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
          ),
        ),
        errorBuilder: (context, error, stackTrace) =>
            const Center(child: Icon(Icons.error, color: Colors.red, size: 50)),
      ),
    );
  }
}
