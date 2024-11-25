import 'package:e_commerce_app/ui/setting_page.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          // Profile Image
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150', // Replace with the user's profile picture URL
              ),
            ),
          ),
          const SizedBox(height: 12),
          // User Name
          const Text(
            "Mark Adam",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          // User Email
          const Text(
            "Sunny_Koelpin45@hotmail.com",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 30),

          // Profile Options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildProfileOption(
                  icon: Icons.person,
                  title: "Profile",
                  onTap: () {
                    // Navigate to Profile Page
                  },
                ),
                _buildProfileOption(
                  icon: Icons.settings,
                  title: "Setting",
                  onTap: () {
                    // Navigate to Settings Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                ),
                _buildProfileOption(
                  icon: Icons.contact_mail,
                  title: "Contact",
                  onTap: () {
                    // Navigate to Contact Page
                  },
                ),
                _buildProfileOption(
                  icon: Icons.share,
                  title: "Share App",
                  onTap: () {
                    // Handle Share App functionality
                  },
                ),
                _buildProfileOption(
                  icon: Icons.help_outline,
                  title: "Help",
                  onTap: () {
                    // Navigate to Help Page
                  },
                ),
              ],
            ),
          ),

          // Sign Out Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: TextButton(
              onPressed: () {
                // Handle Sign Out functionality
              },
              child: const Text(
                "Sign Out",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable widget for profile options
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
      onTap: onTap,
    );
  }
}
