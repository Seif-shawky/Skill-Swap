import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../models/chat_thread.dart';
import '../models/skill_listing.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/review_service.dart';
import '../services/skill_service.dart';
import '../services/swap_request_service.dart';

class AppState extends ChangeNotifier {
  AppState({
    required this.authService,
    required this.skillService,
    required this.chatService,
    required this.swapRequestService,
    required this.reviewService,
  });

  final AuthService authService;
  final SkillService skillService;
  final ChatService chatService;
  final SwapRequestService swapRequestService;
  final ReviewService reviewService;

  AppUser? currentUser;
  List<SkillListing> listings = [];
  List<ChatThread> chatThreads = [];
  bool isLoading = true;
  String? errorMessage;

  StreamSubscription<AppUser?>? _authSub;
  StreamSubscription<List<SkillListing>>? _listingSub;
  StreamSubscription<List<ChatThread>>? _chatSub;

  bool get isLoggedIn => currentUser != null;

  Future<void> bootstrap() async {
    _authSub = authService.authStateChanges().listen((user) {
      currentUser = user;
      isLoading = false;
      _watchAppData();
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    await _guard(() async {
      currentUser = await authService.signIn(email, password);
      _watchAppData();
    });
  }

  Future<void> signUp(String name, String email, String password) async {
    await _guard(() async {
      currentUser = await authService.signUp(name: name, email: email, password: password);
      _watchAppData();
    });
  }

  Future<void> updateProfile(AppUser user) async {
    await _guard(() async {
      await authService.updateProfile(user);
      currentUser = user;
    });
  }

  Future<void> createListing({
    required String title,
    required String category,
    required String description,
    required String skillLevel,
    required String availability,
  }) async {
    final user = currentUser;
    if (user == null) return;
    final listing = SkillListing(
      id: '',
      ownerId: user.uid,
      ownerName: user.name,
      title: title,
      category: category,
      description: description,
      skillLevel: skillLevel,
      availability: availability,
      type: 'offering',
      createdAt: DateTime.now(),
    );
    await _guard(() => skillService.createListing(listing));
    if (!skillService.firebaseReady) {
      listings = [listing.copyDemo(id: DateTime.now().millisecondsSinceEpoch.toString()), ...listings];
      notifyListeners();
    }
  }

  Future<bool> requestSwap(SkillListing listing) async {
    final user = currentUser;
    if (user == null) return false;
    if (listing.ownerId == user.uid) {
      errorMessage = 'You cannot request your own listing.';
      notifyListeners();
      return false;
    }
    var persisted = false;
    await _guard(() async {
      persisted = await swapRequestService.createRequest(requester: user, listing: listing);
    });
    return persisted;
  }

  Future<bool> completeSwapAndReview({
    required ChatThread thread,
    required int rating,
    String? comment,
  }) async {
    final user = currentUser;
    if (user == null) return false;
    final swapRequestId = thread.swapRequestId;
    if (swapRequestId == null || swapRequestId.isEmpty) return false;
    await _guard(() async {
      await swapRequestService.markCompleted(swapRequestId);
      await reviewService.submitReview(
        swapRequestId: swapRequestId,
        fromUserId: user.uid,
        toUserId: thread.peerId,
        rating: rating,
        comment: comment,
      );
      await chatService.sendMessage(
        chatId: thread.id,
        senderId: user.uid,
        text: 'Swap completed and rated $rating/5.',
      );
    });
    return true;
  }

  List<SkillListing> get recommendedListings {
    final user = currentUser;
    if (user == null) return listings.take(3).toList();
    return skillService.recommendedFor(user, listings);
  }

  Future<void> signOut() async {
    await authService.signOut();
    currentUser = null;
    chatThreads = [];
    notifyListeners();
  }

  void _watchAppData() {
    final user = currentUser;
    _listingSub?.cancel();
    _chatSub?.cancel();
    _listingSub = skillService.watchListings().listen((value) {
      listings = value;
      notifyListeners();
    });
    if (user != null) {
      _chatSub = chatService.watchThreads(user.uid).listen((value) {
        chatThreads = value;
        notifyListeners();
      });
    }
  }

  Future<void> _guard(Future<void> Function() action) async {
    errorMessage = null;
    notifyListeners();
    try {
      await action();
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _listingSub?.cancel();
    _chatSub?.cancel();
    super.dispose();
  }
}

extension on SkillListing {
  SkillListing copyDemo({required String id}) {
    return SkillListing(
      id: id,
      ownerId: ownerId,
      ownerName: ownerName,
      title: title,
      category: category,
      description: description,
      skillLevel: skillLevel,
      availability: availability,
      type: type,
      createdAt: createdAt,
    );
  }
}
