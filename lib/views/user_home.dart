import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmyadvocate/views/widgets/top_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/advocate_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AdvocateController advocateController = Get.put(AdvocateController());

  @override
  void initState() {
    super.initState();
    advocateController.fetchTopAdvocates(5); // Fetch only top 5 advocates
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Light Grey Background
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          children: [
            /// 🔥 Hero Section
            _buildHeroSection(),
                        const SizedBox(height: 20),
            Text("New Features",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E))),
            const SizedBox(height: 10),
            Component(),

            const SizedBox(height: 20),

            /// 🏆 Top Advocates Section
            _buildTopAdvocatesSection(),

            const SizedBox(height: 20),

            /// 📌 Legal Insights (Instead of Legal Tips)
            _buildLegalInsightsSection(),
          ],
        ),
      ),
    );
  }

  /// 🔥 1️⃣ Hero Section
  Widget _buildHeroSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF0D47A1)], // Deep Blue Gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "“Justice Delayed is Justice Denied”",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            "Find expert legal advice and trusted advocates to protect your rights.",
            style: TextStyle(fontSize: 15, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  /// 🏆 2️⃣ Top Advocates Section (Showing only 5 advocates)
  Widget _buildTopAdvocatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("🏆 Top Advocates",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E))),
        const SizedBox(height: 10),
        Obx(() {
          if (advocateController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (advocateController.advocatesList.isEmpty) {
            return Center(child: Text("No advocates found"));
          }
          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: advocateController.advocatesList.length,
              itemBuilder: (context, index) {
                final advocate = advocateController.advocatesList[index];
                return _buildAdvocateCard(advocate);
              },
            ),
          );
        }),
      ],
    );
  }

  /// 🔖 Advocate Card UI (New Design)
  Widget _buildAdvocateCard(dynamic advocate) {
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 2)
        ],
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
              radius: 40, backgroundImage: NetworkImage(advocate.imageUrl)),
          const SizedBox(height: 8),
          Text("Adv. " + advocate.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
          const SizedBox(height: 5),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1A237E), // Deep Blue Button
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Get.toNamed('/advocate-details', arguments: advocate);
            },
            child: Text("View", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// 📌 3️⃣ Legal Insights Section
  Widget _buildLegalInsightsSection() {
    List<Map<String, String>> legalInsights = [
      {
        "title": "⚖️ Your Right to Legal Representation",
        "desc":
            "No matter the case, every citizen has the right to an advocate of their choice."
      },
      {
        "title": "🛡️ Protection Against Unfair Arrest",
        "desc":
            "You cannot be arrested without a valid reason or legal warrant."
      },
      {
        "title": "📜 Right to Information Act (RTI)",
        "desc":
            "Any citizen can request government documents and decisions under RTI."
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("📌 Legal Insights",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E))),
        const SizedBox(height: 10),
        ...legalInsights.map((insight) => Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 6),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                leading: Icon(Icons.lightbulb, color: Colors.amber[800]),
                title: Text(insight["title"]!,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                subtitle: Text(insight["desc"]!,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700])),
              ),
            )),
      ],
    );
  }
}
