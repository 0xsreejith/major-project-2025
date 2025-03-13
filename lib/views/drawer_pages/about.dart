import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AboutUs"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding: EdgeInsets.all(10),
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAZmY64YyYfkxIQIkyZhOOT4GwpIIfM_N1zA&s"),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LegalLink",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "GROUP13Techonlogies",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "help@legallink.com",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 13,
                ),
                Text(
                  "Version",
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("1.0"),
                const SizedBox(
                  height: 13,
                ),
                Text(
                  "Powered by",
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("GROUP13Techonlogies"),
                const SizedBox(
                  height: 13,
                ),
                Text(
                  "About Company",
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                    "We make software so easy.everyone can do it Your vision. Your software. We just build it."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}