import 'package:flutter/material.dart';

Widget buildBackgroundIcons() {
  final backgroundIcons = [
    Icons.fitness_center,
    Icons.directions_run,
    Icons.pool,
    Icons.sports_basketball,
    Icons.sports_soccer,
    Icons.sports_tennis,
    Icons.restaurant,
    Icons.local_dining,
    Icons.coffee,
    Icons.wine_bar,
    Icons.music_note,
    Icons.headphones,
    Icons.brush,
    Icons.palette,
    Icons.camera,
    Icons.photo,
    Icons.book,
    Icons.school,
    Icons.work,
    Icons.business,
    Icons.home,
    Icons.bed,
    Icons.car_crash,
    Icons.flight,
    Icons.favorite,
    Icons.star,
    Icons.lightbulb,
    Icons.shopping_cart,
    Icons.accessibility_new,
    Icons.self_improvement,
    Icons.spa,
    Icons.nightlife,
    Icons.mic,
    Icons.piano,
    Icons.draw,
    Icons.edit,
    Icons.laptop,
    Icons.computer,
    Icons.phone,
    Icons.tablet,
    Icons.shower,
    Icons.kitchen,
    Icons.train,
    Icons.directions_bike,
    Icons.sentiment_satisfied,
    Icons.emoji_emotions,
    Icons.psychology,
    Icons.healing,
  ];

  return Positioned.fill(
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 12,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1,
      ),
      itemCount: 200,
      itemBuilder: (context, index) {
        final icon = backgroundIcons[index % backgroundIcons.length];
        return Icon(
          icon,
          size: 20,
          color: Colors.grey.withOpacity(0.1),
        );
      },
    ),
  );
}
