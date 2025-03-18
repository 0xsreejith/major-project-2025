import 'package:findmyadvocate/controller/auth_controller.dart';
import 'package:findmyadvocate/controller/contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactPage extends StatelessWidget {
  final ContactController contactController = Get.put(ContactController());
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text("Contact Support",
            style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          if (authController.currentUser == null) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Legal Assistance Request",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey[800])),
                SizedBox(height: 8),
                Text(
                  "Our support team will respond to your query within 24 hours",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                SizedBox(height: 24),
                _UserInfoCard(
                  name: authController.currentUser['name'],
                  email: authController.currentUser['email'],
                ),
                SizedBox(height: 28),
                TextField(
                  controller: messageController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: "Describe your legal issue",
                    hintText: "Type your message here...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 1.5),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 30),
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: contactController.isLoading.value
                            ? SizedBox.shrink()
                            : Icon(Icons.send, size: 20),
                        label: contactController.isLoading.value
                            ? SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 3),
                              )
                            : Text("Send Message",
                                style: TextStyle(fontSize: 16,color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          backgroundColor: Theme.of(context).primaryColor,
                          disabledBackgroundColor: Colors.grey[400],
                        ),
                        onPressed: contactController.isLoading.value
                            ? null
                            : () async {
                                await contactController.sendMessage(
                                  authController.user!.uid,
                                  authController.currentUser['name'],
                                  authController.currentUser['email'],
                                  messageController.text,
                                );
                                messageController.clear();
                                Get.snackbar(
                                  "Message Sent!",
                                  "We'll respond to your query shortly",
                                  colorText: Colors.white,
                                  backgroundColor: Colors.green[600],
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.all(12),
                                );
                              },
                      ),
                    )),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  final String name;
  final String email;

  const _UserInfoCard({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.account_circle, size: 40, color: Colors.blueGrey),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey[800])),
                SizedBox(height: 4),
                Text(email,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}