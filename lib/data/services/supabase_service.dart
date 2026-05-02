import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper that exposes the initialized Supabase client.
class SupabaseService {
  SupabaseService._();

  static SupabaseClient get client => Supabase.instance.client;
}
