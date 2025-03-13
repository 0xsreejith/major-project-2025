import 'package:findmyadvocate/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
   final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: 2,
        separatorBuilder: (context, index) => Divider(height: 40),
        itemBuilder: (context, index) {
          if (index == 0) return _buildAccountSection(context);
          return _buildSecuritySection(context);
        },
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'ACCOUNT',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[600]),
            ),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.email, color: Colors.blue[700]),
              title: Text('Email Address'),
              subtitle: Obx(() => Text(controller.email.value, style: TextStyle(color: Colors.grey[600]))),
              trailing: Icon(Icons.edit, color: Colors.blue[700]),
              onTap: () => _showEditDialog(context, 'email'),
            ),
          ),
        ],
      );

  Widget _buildSecuritySection(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'SECURITY',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[600]),
            ),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.lock, color: Colors.orange[700]),
              title: Text('Change Password'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => _showEditDialog(context, 'password'),
            ),
          ),
        ],
      );

  void _showEditDialog(BuildContext context, String field) {
    final TextEditingController inputController = TextEditingController();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          field == 'email' ? 'Update Email Address' : 'Change Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextField(
            controller: inputController,
            obscureText: field == 'password',
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              hintText: 'Enter new ${field == 'email' ? 'email address' : 'password'}',
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('CANCEL', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              if (field == 'email') {
                controller.updateEmail(inputController.text);
              } else {
                controller.updatePassword(inputController.text);
              }
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('SAVE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
