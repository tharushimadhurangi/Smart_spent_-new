
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'auth_widgets.dart';
import 'credentials_page.dart';

class SetupProfilePage extends StatefulWidget {
  final String fullName;

  const SetupProfilePage({
    super.key,
    this.fullName = '',
  });

  @override
  State<SetupProfilePage> createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends State<SetupProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  final phoneController = TextEditingController();

  DateTime? birthDate;
  String? gender;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.fullName);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.secondary,
              surface: AppColors.card,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      setState(() => birthDate = selected);
    }
  }

  void continueProfile() {
    if (!_formKey.currentState!.validate()) return;

    if (birthDate == null || gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date of birth and gender.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CredentialsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const AuthBackButton(),

              const AuthHeading(
                title: 'Set Up Profile',
                subtitle: 'Tell us a little about yourself.',
              ),

              const SizedBox(height: 28),

              Stack(
                children: [
                  const CircleAvatar(
                    radius: 61,
                    backgroundColor: Color(0xFF17266B),
                    child: Icon(
                      Icons.person,
                      size: 78,
                      color: AppColors.secondary,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 21,
                      backgroundColor: AppColors.primary,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Profile image picker will be added later.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 19,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              AuthTextField(
                hint: 'Full Name',
                icon: Icons.person_outline,
                controller: nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              AuthTextField(
                hint: 'Contact Number',
                icon: Icons.phone_outlined,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your contact number';
                  }
                  if (value.trim().length < 9) {
                    return 'Enter a valid contact number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              InkWell(
                onTap: selectDate,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.input,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          birthDate == null
                              ? 'Date of Birth'
                              : '${birthDate!.day.toString().padLeft(2, '0')}/'
                                '${birthDate!.month.toString().padLeft(2, '0')}/'
                                '${birthDate!.year}',
                          style: const TextStyle(
                            color: AppColors.mutedText,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.input,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: gender,
                    hint: const Row(
                      children: [
                        Icon(Icons.wc, color: Colors.white70),
                        SizedBox(width: 14),
                        Text(
                          'Gender',
                          style: TextStyle(
                            color: AppColors.mutedText,
                          ),
                        ),
                      ],
                    ),
                    dropdownColor: AppColors.card,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    items: ['Male', 'Female', 'Other'].map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => gender = value);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 35),

              AuthButton(
                title: 'Continue',
                onPressed: continueProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
