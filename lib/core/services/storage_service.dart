import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final SupabaseClient _client = Supabase.instance.client;
  static const String bucketName = 'livreurs_docs'; // Ensure this bucket exists in Supabase

  Future<String?> uploadImage(File imageFile, String folder) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final pathName = '$folder/$fileName';

      await _client.storage.from(bucketName).upload(
        pathName,
        imageFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      final String publicUrl = _client.storage.from(bucketName).getPublicUrl(pathName);
      return publicUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
