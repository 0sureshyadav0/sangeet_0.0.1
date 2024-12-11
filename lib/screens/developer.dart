import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sangeet/consts/consts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class DeveloperContactInfo extends StatelessWidget {
  const DeveloperContactInfo({super.key});

  void _launchUrl(String url) async {
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
        backgroundColor: appBarColor,
        centerTitle: true,
        title: const Text(
          "Developer",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: AssetImage(
                    './assets/images/background.jpeg'), // Add your background image
                fit: BoxFit.cover,
                opacity: 0.7,
              ),
            ),
          ),

          // Glassmorphism Container
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Developer Profile Picture
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: const NetworkImage(
                              'https://avatars.githubusercontent.com/u/117462201?v=4'), // Replace with your image path
                          backgroundColor: Colors.grey[300],
                        ),
                        const SizedBox(height: 20),

                        // Developer Name
                        const Text(
                          "Suresh Yadav",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Developer Title/Role
                        const Text(
                          "Full Stack Developer",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () => launchWhatsApp(),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.whatsapp,
                                      color: Color.fromARGB(255, 2, 252, 10),
                                      size: 30.0,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "WhatsApp",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 2, 252, 10),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              InkWell(
                                onTap: () => _launchUrl(
                                    'mailto:sureshyadav.info.np@gmail.com'),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.envelope,
                                      color: Color.fromARGB(255, 245, 18, 2),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "sureshyadav.info.np@gmail.com",
                                      style: TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 15),

                              // GitHub Profile
                              InkWell(
                                onTap: () => _launchUrl(
                                    'https://github.com/0sureshyadav0'),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.github,
                                      color: Color.fromARGB(255, 245, 2, 83),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "github.com/0sureshyadav0",
                                      style: TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),

                              // LinkedIn Profile
                              InkWell(
                                onTap: () => _launchUrl(
                                    'https://www.linkedin.com/in/0sureshyadav0?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app'),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.linkedinIn,
                                      color: Color.fromARGB(255, 1, 5, 241),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "linkedin.com/in/sureshyadav",
                                      style: TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Footer Note
                        const Text(
                          "Let's build something amazing together!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> launchWhatsApp() async {
    const link = WhatsAppUnilink(
      phoneNumber: "+977-9763878278",
      text: "Hi, I need some help. Please, respond in your free time...",
    );
    try {
      await launchUrl(link.asUri());
    } catch (e) {
      Get.snackbar("Error", "Failed to contact",
          duration: const Duration(seconds: 3));
    }
  }
}
