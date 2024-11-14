import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Review {
  final String userName;
  final double rating;
  final String comment;

  Review({
    required this.userName,
    required this.rating,
    required this.comment,
  });
}

class ReviewSection extends StatefulWidget {
  const ReviewSection({super.key});

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  final List<Review> reviews = [];

  // Fonction pour afficher le formulaire d'ajout d'avis
  void showAddReviewDialog() {
    final TextEditingController commentController = TextEditingController();
    double userRating = 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Noter ce spot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  userRating = rating;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'Votre avis',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  final newReview = Review(
                    userName: 'Anonymous',
                    rating: userRating,
                    comment: commentController.text,
                  );
                  setState(() {
                    reviews.add(newReview);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour afficher la liste des avis
  Widget buildReviewList() {
    if (reviews.isEmpty) {
      return const Text('Pas encore d\'avis, laissez le votre.');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.person, color: Colors.blueAccent),
            title: Text(review.userName),
            subtitle: Text(review.comment),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Text(review.rating.toStringAsFixed(1)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Avis',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        buildReviewList(),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: showAddReviewDialog,
          icon: const Icon(Icons.add_comment),
          label: const Text('Ajouter un avis'),
        ),
      ],
    );
  }
}
