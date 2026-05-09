import 'package:flutter_test/flutter_test.dart';
import 'package:skill_swap/models/app_user.dart';
import 'package:skill_swap/models/skill_listing.dart';

void main() {
  test('demo user has matchable wanted skills', () {
    final user = AppUser.demo();
    final listings = SkillListing.demoList();

    final marketplaceText = listings
        .map((listing) => '${listing.title} ${listing.category} ${listing.description}'.toLowerCase())
        .join(' ');

    expect(
      user.skillsWanted.any((skill) => marketplaceText.contains(skill.toLowerCase())),
      isTrue,
    );
  });
}
