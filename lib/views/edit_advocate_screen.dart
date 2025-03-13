import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/advocate_controller.dart';
import '../model/advocate_model.dart';

class EditAdvocateScreen extends StatefulWidget {
  @override
  _EditAdvocateScreenState createState() => _EditAdvocateScreenState();
}

class _EditAdvocateScreenState extends State<EditAdvocateScreen> {
  final AdvocateController advocateController = Get.find();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController specialtyController;
  late TextEditingController locationController;
  late TextEditingController experienceController;
  late TextEditingController descriptionController;
  late TextEditingController enrollmentNumberController;
  late TextEditingController mobileNumberController;
  late TextEditingController practicePlaceController;
  late TextEditingController qualificationsController;
  late TextEditingController barCouncilNumberController;
  late TextEditingController imageUrlController;

  late RxString selectedSpecialty;
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

  late AdvocateModel advocate;

  @override
  void initState() {
    super.initState();
    advocate = Get.arguments as AdvocateModel;

    // Initialize controllers with existing advocate data
    nameController = TextEditingController(text: advocate.name);
    emailController = TextEditingController(text: advocate.email);
    locationController = TextEditingController(text: advocate.location);
    experienceController = TextEditingController(text: advocate.experience);
    descriptionController = TextEditingController(text: advocate.description);
    enrollmentNumberController = TextEditingController(text: advocate.enrollmentNumber);
    mobileNumberController = TextEditingController(text: advocate.mobileNumber);
    practicePlaceController = TextEditingController(text: advocate.practicePlace);
    qualificationsController = TextEditingController(text: advocate.qualifications);
    barCouncilNumberController = TextEditingController(text: advocate.barCouncilNumber);
    imageUrlController = TextEditingController(text: advocate.imageUrl);
    
    // Handle specialty selection
    selectedSpecialty = advocate.specialty.obs;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    locationController.dispose();
    experienceController.dispose();
    descriptionController.dispose();
    enrollmentNumberController.dispose();
    mobileNumberController.dispose();
    practicePlaceController.dispose();
    qualificationsController.dispose();
    barCouncilNumberController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  /// ✅ Save Edited Data
  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> updatedData = {
        'name': nameController.text,
        'email': emailController.text,
        'specialty': selectedSpecialty.value,
        'location': locationController.text,
        'experience': experienceController.text,
        'description': descriptionController.text,
        'enrollmentNumber': enrollmentNumberController.text,
        'mobileNumber': mobileNumberController.text,
        'practicePlace': practicePlaceController.text,
        'qualifications': qualificationsController.text,
        'barCouncilNumber': barCouncilNumberController.text,
        'imageUrl': imageUrlController.text,
      };

      advocateController.updateAdvocate(advocate.id, updatedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Advocate")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField("Full Name", nameController, Icons.person),
                _buildTextField("Email", emailController, Icons.email),

                Obx(() => DropdownButtonFormField<String>(
                      value: selectedSpecialty.value,
                      items: specialties.map((specialty) => DropdownMenuItem(
                            value: specialty,
                            child: Text(specialty),
                          )).toList(),
                      onChanged: (value) => selectedSpecialty.value = value!,
                      decoration: InputDecoration(
                        labelText: 'Specialty',
                        prefixIcon: Icon(Icons.business_center),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    )),

                _buildTextField("Location", locationController, Icons.location_on),
                _buildTextField("Experience (Years)", experienceController, Icons.timeline),
                _buildTextField("Description", descriptionController, Icons.description, maxLines: 3),
                _buildTextField("Enrollment Number", enrollmentNumberController, Icons.confirmation_number),
                _buildTextField("Mobile Number", mobileNumberController, Icons.phone),
                _buildTextField("Practice Place", practicePlaceController, Icons.place),
                _buildTextField("Qualifications", qualificationsController, Icons.school),
                _buildTextField("Bar Council Number", barCouncilNumberController, Icons.verified),
                _buildTextField("Image URL", imageUrlController, Icons.image),

                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _saveChanges,
                  child: Text("Save Changes"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 📌 Custom Input Field
  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool obscureText = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) => value!.isEmpty ? "$label is required" : null,
      ),
    );
  }
}
