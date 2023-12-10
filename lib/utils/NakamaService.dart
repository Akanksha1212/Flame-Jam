import 'package:flutter/material.dart';
import 'package:nakama/api.dart';
import 'package:nakama/nakama.dart';
import 'package:nakama/src/session.dart' as NakamaSession;

class NakamaService {
  NakamaAuth auth = NakamaAuth();
  NakamaLeaderboard leaderboard = NakamaLeaderboard();

  NakamaService() {
    getNakamaClient(
      host: '127.0.0.1',
      ssl: false,
      serverKey: 'defaultkey',
      httpPort: 7350,
    );

    debugPrint('Nakama Service created.');
  }
}

class NakamaAuth {
  Future<NakamaSession.Session> _authenticateEmail({
    required String email,
    required String password,
    required String? username,
    required bool create,
  }) async {
    try {
      NakamaSession.Session session = await getNakamaClient().authenticateEmail(
        email: email,
        password: password,
        username: username,
        create: create,
      );

      debugPrint('Nakama UID ${session.userId}');

      return session;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<NakamaSession.Session> createEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    NakamaSession.Session session = await _authenticateEmail(
      email: email,
      password: password,
      username: username,
      create: true,
    );

    return session;
  }
}

class NakamaLeaderboard {
  static const String leaderboardId = 'weekly_leaderboard';

  Future<LeaderboardRecord> writeLeaderboardRecord({
    required NakamaSession.Session session,
    required int score,
  }) async {
    try {
      LeaderboardRecord leaderboardRecord =
          await getNakamaClient().writeLeaderboardRecord(
        session: session,
        leaderboardId: leaderboardId,
        score: score,
      );

      return leaderboardRecord;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<LeaderboardRecord>> listLeaderboardRecords({
    required NakamaSession.Session session,
  }) async {
    try {
      LeaderboardRecordList leaderboardRecordList =
          await getNakamaClient().listLeaderboardRecords(
        leaderboardName: leaderboardId,
        session: session,
      );

      List<LeaderboardRecord> leaderboardRecords =
          leaderboardRecordList.records;

      return leaderboardRecords;
    } catch (e) {
      throw Exception(e);
    }
  }
}
