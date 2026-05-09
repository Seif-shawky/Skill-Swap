import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';
import '../models/skill_listing.dart';
import 'cache_service.dart';

class SkillService {
  SkillService({required this.firebaseReady, required this.cacheService});

  final bool firebaseReady;
  final CacheService cacheService;

  Stream<List<SkillListing>> watchListings() {
    if (!firebaseReady) {
      final demo = SkillListing.demoList();
      cacheService.cacheListings(demo);
      return Stream.value(demo);
    }

    return FirebaseFirestore.instance
        .collection('listings')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      final listings = snapshot.docs.map((doc) => SkillListing.fromMap(doc.id, doc.data())).toList();
      cacheService.cacheListings(listings);
      return listings;
    });
  }

  Future<void> createListing(SkillListing listing) async {
    if (!firebaseReady) return;
    await FirebaseFirestore.instance.collection('listings').add(listing.toMap());
  }

  List<SkillListing> recommendedFor(AppUser user, List<SkillListing> listings) {
    final wanted = user.skillsWanted.map((skill) => skill.toLowerCase()).toSet();
    final scored = listings.where((listing) {
      final text = '${listing.title} ${listing.category} ${listing.description}'.toLowerCase();
      return wanted.any(text.contains);
    }).toList();
    return scored.isEmpty ? listings.take(3).toList() : scored;
  }
}
