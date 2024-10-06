import 'package:flutter/material.dart';
import 'package:marshal/Presentation/pages/Playing%20page/page/playing_page.dart';
import 'package:marshal/data/models/song_model.dart';

Future<void> goToPlayingPage(context, {required Song song}) async {
  await Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => PlayingPage(song: song),
      transitionDuration:
          Duration(milliseconds: 300), // Set a reasonable duration
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        // Define the animation
        const begin = Offset(0, 1); // Slide in from the right
        const end = Offset.zero; // Final position
        const curve = Curves.easeInOut; // Smooth curve

        // Create the animation
        var tween = Tween<Offset>(begin: begin, end: end)
            .chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        // Return the SlideTransition
        return SlideTransition(
          position: offsetAnimation,
          child: child, // This is your PlayingPage
        );
      },
    ),
  );
}
