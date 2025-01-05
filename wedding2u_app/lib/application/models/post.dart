import 'review.dart'; // Import the Review model

class Post {
  final String name;
  final String imagePath;
  final List<Review> reviews;

  Post({
    required this.name,
    required this.imagePath,
    this.reviews = const [],
  });

  // Calculate average rating
  double get averageRating {
    if (reviews.isEmpty) return 0.0;
    final totalRating = reviews.fold(0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }

  // Total number of reviews
  int get totalReviews => reviews.length;
}
