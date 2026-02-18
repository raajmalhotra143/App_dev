import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(url: url, anonKey: anonKey);
  }

  SupabaseClient get client => Supabase.instance.client;

  /// Joins an existing game with status 'waiting' or creates a new one.
  Future<String> joinRandomGame() async {
    final user = client.auth.currentUser;
    // Assuming user is authenticated. If not, handle separately or sign in anonymously.
    if (user == null) {
      // For demo, try anonymous sign in
      try {
        await client.auth.signInAnonymously();
      } catch (e) {
        print('Error signing in anonymously: $e');
      }
    }

    try {
      // 1. Try to find an open game
      final response = await client
          .from('games')
          .select()
          .eq('status', 'waiting')
          .neq(
            'player_1_id',
            client.auth.currentUser?.id ?? '',
          ) // Don't join own game
          .limit(1)
          .maybeSingle();

      if (response != null) {
        // Found a game, join it
        final gameId = response['id'];
        await client
            .from('games')
            .update({
              'player_2_id': client.auth.currentUser?.id,
              'status': 'active',
            })
            .eq('id', gameId);
        return gameId;
      }
    } catch (e) {
      print('Error looking for game: $e');
    }

    // 2. No game found, create a new one
    try {
      final response = await client
          .from('games')
          .insert({
            'player_1_id': client.auth.currentUser?.id,
            'status': 'waiting',
          })
          .select()
          .single();

      return response['id'];
    } catch (e) {
      print('Error creating game: $e');
      rethrow;
    }
  }

  /// Streams updates for a specific game
  Stream<List<Map<String, dynamic>>> streamGame(String gameId) {
    return client.from('games').stream(primaryKey: ['id']).eq('id', gameId);
  }
}
