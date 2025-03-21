import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmyadvocate/controller/auth_controller.dart';
import 'package:findmyadvocate/views/add_court_hiring.dart';
import 'package:findmyadvocate/views/case_management.dart';
import 'package:findmyadvocate/views/create_legal_advice_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    authController.fetchAdvocates(); // Fetch advocates on page load

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Top Cards in Grid Layout
            GridView.count(
              crossAxisCount: 3, // 3 cards in a row
              shrinkWrap: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: NeverScrollableScrollPhysics(), // Disable scrolling
              children: [
                _buildDashboardCard(
                  title: 'Total Advocates',
                  icon: Icons.people,
                  onTap: () => Get.toNamed('/all-advocates'),
                ),
                _buildDashboardCard(
                  title: 'Create Advocate',
                  icon: Icons.person_add,
                  onTap: () => Get.toNamed('/create-advocate'),
                ),
                _buildDashboardCard(
                  title: 'Legal Advice',
                  icon: Icons.gavel,
                  onTap: () {
                    Get.to(() => CreateLegalAdviceScreen());
                  },
                ),
                _buildDashboardCard(
                  title: 'Court Hirings', // New Card
                  icon: Icons.business,
                  onTap: () {
                    Get.to(() =>
                        AddCourtHiringView()); // Navigate to AddCourtHiringView
                  },
                ),
                _buildDashboardCard(
                  title: 'Case Info',
                  icon: Icons.article,
                  onTap: () {
                    Get.to(() =>
                        CaseManagementScreen()); // Navigate to case screen
                  },
                ),
                _buildDashboardCard(
                  title: 'User Queries',
                  icon: Icons.message,
                  onTap: () {
                    Get.toNamed(
                        '/user-queries'); // Navigate to User Queries page
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper method to create a Dashboard Card
  Widget _buildDashboardCard({
    required String title,
    String? count,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.blue),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              if (count != null)
                Text(
                  count,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
