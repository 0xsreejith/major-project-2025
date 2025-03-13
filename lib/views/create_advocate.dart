import 'package:findmyadvocate/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAdvocateScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController enrollmentNumberController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController practicePlaceController = TextEditingController();
  final TextEditingController qualificationsController = TextEditingController();
  final TextEditingController barCouncilNumberController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  final RxString selectedSpecialty = 'Criminal Law'.obs;
  final RxBool isLoading = false.obs;

  CreateAdvocateScreen({Key? key}) : super(key: key);

  final List<String> specialties = [
    'Criminal Law',
    'Civil Law',
    'Corporate Law',
    'Family Law',
    'Intellectual Property',
    'Labor Law',
    'Tax Law',
    'Immigration Law',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Advocate')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(nameController, 'Full Name', Icons.person),
              _buildTextField(emailController, 'Email', Icons.email),
              Obx(() => DropdownButtonFormField<String>(
                    value: selectedSpecialty.value,
                    items: specialties
                        .map((specialty) => DropdownMenuItem(
                              value: specialty,
                              child: Text(specialty),
                            ))
                        .toList(),
                    onChanged: (value) => selectedSpecialty.value = value!,
                    decoration: InputDecoration(
                      labelText: 'Specialty',
                      prefixIcon: Icon(Icons.business_center),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  )),
              _buildTextField(locationController, 'Location', Icons.location_on),
              _buildTextField(experienceController, 'Experience (Years)', Icons.timeline),
              _buildTextField(descriptionController, 'Description', Icons.description, maxLines: 3),
              _buildTextField(enrollmentNumberController, 'Enrollment Number', Icons.confirmation_number),
              _buildTextField(mobileNumberController, 'Mobile Number', Icons.phone),
              _buildTextField(practicePlaceController, 'Practice Place', Icons.place),
              _buildTextField(qualificationsController, 'Qualifications', Icons.school),
              _buildTextField(barCouncilNumberController, 'Bar Council Number', Icons.verified),
              _buildTextField(imageUrlController, 'Image URL', Icons.image),
              SizedBox(height: 20),
              Obx(() => isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          isLoading.value = true;
                          await authController.createAdvocate(
                            email: emailController.text.trim(),
                            name: nameController.text.trim(),
                            specialty: selectedSpecialty.value,
                            location: locationController.text.trim(),
                            experience: experienceController.text.trim(),
                            description: descriptionController.text.trim(),
                            enrollmentNumber: enrollmentNumberController.text.trim(),
                            mobileNumber: mobileNumberController.text.trim(),
                            practicePlace: practicePlaceController.text.trim(),
                            qualifications: qualificationsController.text.trim(),
                            barCouncilNumber: barCouncilNumberController.text.trim(),
                            imageUrl: imageUrlController.text.trim(),
                          );
                          isLoading.value = false;
                          Get.dialog(
                            AlertDialog(
                              title: Text('Success!'),
                              content: Text('Advocate created successfully!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back(); // Close dialog
                                    Get.back(); // Navigate back
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.add),
                        label: Text('Create Advocate'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}