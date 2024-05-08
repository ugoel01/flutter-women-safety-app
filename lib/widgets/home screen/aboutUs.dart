import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        width: double.infinity,
        color: Color.fromARGB(255, 66, 14, 71),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'About The App',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 230, 229, 219)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'We are committed to empowering women by providing them with tools and resources to stay safe.',
                style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 230, 229, 219)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Our app features include:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 230, 229, 219)),
              ),
              const SizedBox(height: 8),
              _buildFeatureItem('Quick Alert System'),
              _buildFeatureItem('Safety Tips and Reviews'),
              _buildFeatureItem('Chat with Guardians'),
              _buildFeatureItem('Emergency Helplines and Locations'),
              const SizedBox(height: 16),
              const Text(
                'We believe that every woman deserves to feel safe. Download our app today and share as much as possible to help us build a safe society.',
                style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 230, 229, 219)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.green),
        const SizedBox(width: 8),
        Text(feature, style: TextStyle(color: Color.fromARGB(255, 241, 236, 182))),
      ],
    );
  }
}
