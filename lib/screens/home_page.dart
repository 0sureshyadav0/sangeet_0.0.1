import 'package:flutter/material.dart';
import 'dart:ui';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                opacity: 0.7,
                image: AssetImage(
                    "./assets/images/joker.jpeg"), // Add your image in assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Glassmorphism effect
          Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  // App Title
                  const Text(
                    "Welcome to Sangeet",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Card Menu Options
                  _buildGlassCard(
                    context: context,
                    title: "Playlists",
                    icon: Icons.queue_music,
                    onTap: () {
                      debugPrint("Navigate to Playlists");
                    },
                  ),
                  _buildGlassCard(
                    context: context,
                    title: "Artists",
                    icon: Icons.person,
                    onTap: () {
                      debugPrint("Navigate to Artists");
                    },
                  ),
                  _buildGlassCard(
                    context: context,
                    title: "Albums",
                    icon: Icons.album,
                    onTap: () {
                      debugPrint("Navigate to Albums");
                    },
                  ),
                  _buildGlassCard(
                    context: context,
                    title: "Favorites",
                    icon: Icons.favorite,
                    onTap: () {
                      debugPrint("Navigate to Favorites");
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Icon(icon, size: 40, color: Colors.white),
                  const SizedBox(width: 15),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios,
                      size: 20, color: Colors.white70),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
