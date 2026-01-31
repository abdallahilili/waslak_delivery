import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // TODO: Replace with your actual Supabase URL and Anon Key
  static const String url = 'https://qlsprtbhqodoapjmodnb.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFsc3BydGJocW9kb2Fwam1vZG5iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgxNjI1NDcsImV4cCI6MjA4MzczODU0N30.KBL39ywyNXx0trTs9fRRMb8eQy-IHkNJrPMXfZOz8L8';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
