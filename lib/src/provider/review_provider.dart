import 'package:flutter/material.dart';
import 'package:heathbridge_lao/package.dart';
import 'package:heathbridge_lao/src/models/review_model.dart'; // Adjust import as per your project structure

class ReviewProvider extends ChangeNotifier {
  List<ReviewModel> _reviews = [];

  List<ReviewModel> get reviews => _reviews;
  bool isPosting = false;
  bool isLoading = false;
  final HasuraConnect _hasuraConnect = HasuraHelper.hasuraHelper;

  Future<bool> postReview({
    required ReviewModel review,
    required String facilityId,
    required String userId,
  }) async {
    const String insertReviewMutation = """
    mutation insertReview(\$createdAt: timestamptz!, \$description: String!, \$facId: uuid!, \$rating: numeric!, \$status: Int!, \$userId: uuid!) {
      insert_reviews(objects: {created_at: \$createdAt, description: \$description, fac_id: \$facId, rating: \$rating, status: \$status, user_id: \$userId}) {
        affected_rows
      }
    }
    """;

    try {
      isPosting = true;
      notifyListeners();

      final response =
          await _hasuraConnect.mutation(insertReviewMutation, variables: {
        'createdAt': DateTime.now().toIso8601String(),
        'description': review.description,
        'facId': facilityId,
        'rating':
            review.rating!.toDouble(), // Ensure rating is passed as numeric
        'status': 1,
        'userId': userId,
      });

      isPosting = false;
      notifyListeners();

      if (response['data'] != null &&
          response['data']['insert_reviews']['affected_rows'] > 0) {
        await fetchReviews(facilityId); // Fetch reviews again after posting
        return true;
      }
      return false;
    } catch (e) {
      isPosting = false;
      notifyListeners();
      debugPrint("Error posting review: $e");
      return false;
    }
  }

  Future<void> fetchReviews(String facId) async {
    const String fetchReviewsQuery = r'''
      query MyQuery($_eq: uuid!) {
        reviews(where: {fac_id: {_eq: $_eq}}) {
          created_at
          description
          rating
          status
          fac_id
          review_id
          user {
            firstname
            lastname
            email
            tel
            user_id
          }
          facility {
            name
          }
        }
      }
    ''';

    try {
      isLoading = true;
      notifyListeners();

      final response = await _hasuraConnect
          .query(fetchReviewsQuery, variables: {'_eq': facId});

      isLoading = false;
      notifyListeners();

      if (response['data'] != null) {
        _reviews = (response['data']['reviews'] as List)
            .map((json) => ReviewModel.fromJson(json))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Error fetching reviews: $e');
      rethrow;
    }
  }

  Future<void> refreshReviews(String facId) async {
    await fetchReviews(facId);
  }
}
