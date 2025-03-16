import 'package:findmyadvocate/controller/court_hiring_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourtHiringsView extends StatelessWidget {
  final CourtHiringController controller = Get.put(CourtHiringController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Court Hirings")),
      body: Obx(() {
        if (controller.todayHirings.isEmpty) {
          return Center(child: Text("No court hirings today."));
        }
        return ListView.builder(
          itemCount: controller.todayHirings.length,
          itemBuilder: (context, index) {
            var hiring = controller.todayHirings[index];
            return Card(
              child: ListTile(
                title: Text(hiring['lawyer_name']),
                subtitle: Text("Case: ${hiring['case_details']}"),
                trailing: Text("Time: ${hiring['time']}"),
              ),
            );
          },
        );
      }),
    );
  }
}
