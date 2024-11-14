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
      return const Text(
        'Pas encore d\'avis, laissez le vôtre.',
        style: TextStyle(fontSize: 12),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          elevation: 4, // Ombre pour donner un effet de profondeur
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Coins arrondis
          ),
          color: const Color(0xFFF0F4FF), // Couleur de fond personnalisée
          child: ListTile(
            contentPadding: const EdgeInsets.all(8), // Espace interne
            leading: const CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              review.userName,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B3A57),
                  fontSize: 12 // Couleur personnalisée
                  ),
            ),
            subtitle: Text(
              review.comment,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black87,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Text(
                  review.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width *
          0.9, // Largeur de la Card (90% de l'écran)
      margin:
          const EdgeInsets.symmetric(horizontal: 2), // Espacement extérieur
      child: Card(
        color: const Color.fromARGB(0, 236, 236, 236).withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Coins arrondis
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Avis',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B3A57),
                ),
              ),
              const SizedBox(height: 10),
              buildReviewList(),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: showAddReviewDialog,
                icon: const Icon(
                  Icons.add_comment,
                  size: 18,
                  color: Colors.white,
                ),
                label: const Text(
                  'Ajouter un avis',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B3A57),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
