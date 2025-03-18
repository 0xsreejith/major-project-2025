import 'package:findmyadvocate/controller/auth_controller.dart';
import 'package:findmyadvocate/controller/court_hiring_controller.dart';
import 'package:findmyadvocate/views/admin_dashboard.dart';
import 'package:findmyadvocate/views/admin_query_screen.dart';
import 'package:findmyadvocate/views/advocate_details_page.dart';
import 'package:findmyadvocate/views/all_advocates.dart';
import 'package:findmyadvocate/views/case_tracker/case_tracker_page.dart';
import 'package:findmyadvocate/views/create_advocate.dart';
import 'package:findmyadvocate/views/edit_advocate_screen.dart';
import 'package:findmyadvocate/views/judgement_ai/judgement_ai.dart';
import 'package:findmyadvocate/views/legal_advice_screen.dart';
import 'package:findmyadvocate/views/login_screen.dart';
import 'package:findmyadvocate/views/main_page.dart';
import 'package:findmyadvocate/views/signup_screen.dart';
import 'package:findmyadvocate/views/add_court_hiring.dart';
import 'package:findmyadvocate/views/user_case_view.dart';
import 'package:findmyadvocate/views/user_court_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthController()); // Initialize AuthController globally
  Get.put(CourtHiringController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find My Advocate',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => LoginScreen()), // Default login page
        GetPage(name: '/signup', page: () => SignupScreen()),
        GetPage(name: '/admin-dashboard', page: () => AdminDashboard()),
        GetPage(name: '/user-dashboard', page: () => MainPage()),
        GetPage(name: '/main-page', page: () => MainPage()),
        GetPage(name: '/create-advocate', page: () => CreateAdvocateScreen()),
        GetPage(name: '/all-advocates', page: () => AllAdvocates()),
        GetPage(name: '/edit-advocate', page: () => EditAdvocateScreen()),
        GetPage(
          name: '/advocate-details',
          page: () => AdvocateDetailScreen(advocate: Get.arguments),
        ),
        GetPage(name: '/legalAdvice', page: () => LegalAdviceListScreen()),
        GetPage(name: '/case-tracker', page: () => CaseTrackerPage()),

        GetPage(name: '/gemini-ai', page: () => ChatScreen()),
        GetPage(name: '/add-court-hiring', page: () => AddCourtHiringView()),
        GetPage(name: '/court-dates', page: () => UserCourtDatesView()),
        GetPage(name: '/user-queries', page: () => AdminUserQueriesScreen())
      ],
    );
  }
}
