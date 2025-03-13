import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Component extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {
      'title': 'Legal Advice',
      'route': '/legalAdvice',
      'icon': Icons.gavel,
      'color': Colors.blue,
    },
    {
      'title': 'Judgement AI',
      'route': '/gemini-ai',
      'icon': Icons.android,
      'color': Colors.green,
    },
    {
      'title': 'Case Tracker',
      'route': '/case-tracker',
      'icon': Icons.track_changes,
      'color': Colors.orange,
    },
    {
      'title': 'Court Dates',
      'route': '/court-dates',
      'icon': Icons.calendar_today,
      'color': Colors.purple,
    },
  ];

  Component({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0), // Reduced padding
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,  // Two items per row
          crossAxisSpacing: 10,  // Space between columns
          mainAxisSpacing: 10,   // Space between rows
          childAspectRatio: 2.5,  // Reduced aspect ratio for smaller items
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),  // Reduced border radius
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.pushNamed(context, items[index]['route']);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), // Reduced padding
                child: Row(
                  children: [
                    // Icon or Image
                    Container(
                      padding: const EdgeInsets.all(8), // Reduced padding
                      decoration: BoxDecoration(
                        color: items[index]['color'].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6), // Reduced border radius
                      ),
                      child: Icon(
                        items[index]['icon'],
                        size: 22, // Reduced icon size
                        color: items[index]['color'],
                      ),
                    ),
                    const SizedBox(width: 10), // Reduced space between icon and title
                    // Title
                    Expanded(
                      child: Text(
                        items[index]['title'],
                        style: GoogleFonts.roboto(
                          fontSize: 13, // Reduced font size
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    // Arrow Icon
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14, // Reduced arrow icon size
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
