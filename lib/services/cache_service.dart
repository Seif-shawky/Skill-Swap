import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/skill_listing.dart';

class CacheService {
  Database? _db;

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'skill_swap_cache.db'),
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE cached_listings(
            id TEXT PRIMARY KEY,
            payload TEXT NOT NULL,
            cachedAt INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE cached_files(
            id TEXT PRIMARY KEY,
            ownerId TEXT NOT NULL,
            localPath TEXT NOT NULL,
            remoteUrl TEXT,
            cachedAt INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> cacheListings(List<SkillListing> listings) async {
    final db = _db;
    if (db == null) return;
    final batch = db.batch();
    for (final listing in listings) {
      batch.insert(
        'cached_listings',
        {
          'id': listing.id,
          'payload': jsonEncode({
            'ownerId': listing.ownerId,
            'ownerName': listing.ownerName,
            'title': listing.title,
            'category': listing.category,
            'description': listing.description,
            'skillLevel': listing.skillLevel,
            'availability': listing.availability,
            'type': listing.type,
          }),
          'cachedAt': DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<SkillListing>> getCachedListings() async {
    final db = _db;
    if (db == null) return [];
    final rows = await db.query('cached_listings', orderBy: 'cachedAt DESC');
    return rows.map((row) {
      final data = jsonDecode(row['payload']! as String) as Map<String, dynamic>;
      return SkillListing.fromMap(row['id']! as String, data);
    }).toList();
  }

  Future<void> clear() async {
    final db = _db;
    if (db == null) return;
    await db.delete('cached_listings');
    await db.delete('cached_files');
  }
}
