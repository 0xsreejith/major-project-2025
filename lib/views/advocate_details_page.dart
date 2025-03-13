import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:findmyadvocate/model/advocate_model.dart';

class AdvocateDetailScreen extends StatelessWidget {
  final AdvocateModel advocate;

  const AdvocateDetailScreen({Key? key, required this.advocate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(advocate.name),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 24),
            _buildContactSection(context),  // Pass context here
            const SizedBox(height: 24),
            _buildDetailSection(
              context: context,  // Pass context here
              title: 'Professional Information',
              children: [
                _buildDetailItem(
                  icon: Icons.work_outline,
                  label: 'Specialty',
                  value: advocate.specialty,
                ),
                _buildDetailItem(
                  icon: Icons.location_city,
                  label: 'Practice Place',
                  value: advocate.practicePlace,
                ),
                _buildDetailItem(
                  icon: Icons.numbers,
                  label: 'Enrollment Number',
                  value: advocate.enrollmentNumber,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailSection(
              context: context,  // Pass context here
              title: 'About',
              children: [
                Text(
                  advocate.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: _buildContactButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

Widget _buildProfileHeader(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically
    crossAxisAlignment: CrossAxisAlignment.center, // Centers content horizontally
    children: [
      Hero(
        tag: 'hero-tag-${advocate.id}',
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundImage: advocate.imageUrl.isNotEmpty
                ? NetworkImage(advocate.imageUrl)
                : null,
            child: advocate.imageUrl.isEmpty
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
        ),
      ),
      const SizedBox(height: 16),
      Center( // Centering the text
        child: Text(
          advocate.name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 8),
      Center( // Centering the specialty text
        child: Text(
          advocate.specialty,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}


  Widget _buildContactSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildContactItem(
                context,
                icon: Icons.phone_rounded,
                value: advocate.mobileNumber,
                color: Colors.green,
              ),
              VerticalDivider(thickness: 1, color: Colors.grey[300]),
              _buildContactItem(
                context,
                icon: Icons.mail_rounded,
                value: advocate.email,
                color: Colors.blue,
              ),
              VerticalDivider(thickness: 1, color: Colors.grey[300]),
              _buildContactItem(
                context,
                icon: Icons.location_pin,
                value: advocate.location,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, {required IconData icon, required String value, required Color color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 28, color: color),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (advocate.mobileNumber.isEmpty) {
            Get.snackbar(
              'Error',
              'No phone number available',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return;
          }

          final Uri smsUri = Uri(scheme: 'sms', path: advocate.mobileNumber);

          try {
            if (await canLaunchUrl(smsUri)) {
              await launchUrl(smsUri);
            } else {
              throw 'Could not launch SMS app';
            }
          } catch (e) {
            Get.snackbar(
              'Error',
              'Failed to open messaging app: ${e.toString()}',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Contact Advocate',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDetailItem({required IconData icon, required String label, required String value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, color: Colors.blueGrey),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '$label: $value',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
}

}
