import 'package:flamejam_coderjedi/utils/NakamaService.dart';
import 'package:flutter/material.dart';
import 'package:nakama/api.dart';
import 'package:nakama/src/session.dart' as NakamaSession;

class NakamaProvider extends ChangeNotifier {
  final NakamaService _nakamaService = NakamaService();

  NakamaSession.Session? _session;

  NakamaProvider() {
    debugPrint('Nakama Provider created.');
  }

  Future createEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    NakamaSession.Session session = await _nakamaService.auth.createEmail(
      email: email,
      password: password,
      username: username,
    );

    _session = session;
  }

  Future<LeaderboardRecord> writeLeaderboardRecord({
    required int score,
  }) async {
    if (_session == null) {
      throw Exception('User session not yet set.');
    }

    LeaderboardRecord leaderboardRecord =
        await _nakamaService.leaderboard.writeLeaderboardRecord(
      session: _session!,
      score: score,
    );

    return leaderboardRecord;
  }

  Future<List<LeaderboardRecord>> listLeaderboardRecords() async {
    if (_session == null) {
      throw Exception('User session not yet set.');
    }

    List<LeaderboardRecord> leaderboardRecords =
        await _nakamaService.leaderboard.listLeaderboardRecords(
      session: _session!,
    );

    return leaderboardRecords;
  }
}
