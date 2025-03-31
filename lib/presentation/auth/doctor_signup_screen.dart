import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';
import '../../core/models/user_type.dart';
import 'otp_verification_screen.dart';

class DoctorSignupScreen extends StatefulWidget {
  const DoctorSignupScreen({Key? key}) : super(key: key);

  @override
  State<DoctorSignupScreen> createState() => _DoctorSignupScreenState();
}

class _DoctorSignupScreenState extends State<DoctorSignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptedTerms = false;
  String? _selectedSpecialty;
  String? _selectedGender;
  int _currentStep = 0;

  // Lists for dropdown menus
  final List<String> _specialties = [
    'Cardiologist',
    'Dermatologist',
    'Neurologist',
    'Orthopedist',
    'Pediatrician',
    'Psychiatrist',
    'Pulmonologist',
    'Radiologist',
    'General Medicine',
    'Other'
  ];

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Account',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Theme(
            data: Theme.of(context).copyWith(
              // Customize the stepper theme
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: AppTheme.doctorColor,
                    secondary: AppTheme.doctorColor.withOpacity(0.7),
                    surface: Colors.white,
                    onSurface: AppTheme.textColor,
                  ),
            ),
            child: Column(
              children: [
                // Custom stepper header
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      _buildStepIndicator(
                        stepNumber: 1,
                        title: 'Personal',
                        isActive: _currentStep >= 0,
                        isCompleted: _currentStep > 0,
                      ),
                      _buildStepConnector(_currentStep > 0),
                      _buildStepIndicator(
                        stepNumber: 2,
                        title: 'Professional',
                        isActive: _currentStep >= 1,
                        isCompleted: _currentStep > 1,
                      ),
                      _buildStepConnector(_currentStep > 1),
                      _buildStepIndicator(
                        stepNumber: 3,
                        title: 'Review',
                        isActive: _currentStep >= 2,
                        isCompleted: false,
                      ),
                    ],
                  ),
                ),
                // Step content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        if (_currentStep == 0) _buildPersonalInfo(),
                        if (_currentStep == 1) _buildProfessionalInfo(),
                        if (_currentStep == 2) _buildFinalStep(),
                        const SizedBox(height: 24),
                        _buildNavigationButtons(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator({
    required int stepNumber,
    required String title,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppTheme.doctorColor
                  : isActive
                      ? AppTheme.doctorColor.withOpacity(0.8)
                      : Colors.grey.shade200,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppTheme.doctorColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      '$stepNumber',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: isActive ? AppTheme.doctorColor : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Container(
      width: 30,
      height: 2,
      color: isActive ? AppTheme.doctorColor : Colors.grey.shade300,
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _currentStep -= 1;
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: AppTheme.doctorColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Back',
                style: TextStyle(color: AppTheme.doctorColor),
              ),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (_currentStep < 2) {
                bool canContinue = true;

                if (_currentStep == 0) {
                  // Validate personal info
                  if (_nameController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _passwordController.text.isEmpty ||
                      _confirmPasswordController.text.isEmpty ||
                      _passwordController.text !=
                          _confirmPasswordController.text ||
                      _selectedGender == null) {
                    canContinue = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Please fill all personal information fields correctly'),
                        backgroundColor: AppTheme.errorColor,
                      ),
                    );
                  }
                } else if (_currentStep == 1) {
                  // Validate professional info
                  if (_phoneController.text.isEmpty ||
                      _selectedSpecialty == null ||
                      _experienceController.text.isEmpty) {
                    canContinue = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Please fill all professional information fields'),
                        backgroundColor: AppTheme.errorColor,
                      ),
                    );
                  }
                }

                if (canContinue) {
                  setState(() {
                    _currentStep += 1;
                  });
                }
              } else {
                _signup();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.doctorColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 2,
              shadowColor: AppTheme.doctorColor.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _currentStep < 2 ? 'Continue' : 'Sign Up',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'Personal Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppTheme.doctorColor,
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _nameController,
          label: 'Full Name',
          hint: 'Enter your full name',
          prefix: const Icon(Icons.person_outline, size: 22),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _emailController,
          label: 'Email Address',
          hint: 'Enter your email address',
          prefix: const Icon(Icons.email_outlined, size: 22),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegExp.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _passwordController,
          label: 'Password',
          hint: 'Create a password',
          prefix: const Icon(Icons.lock_outline, size: 22),
          obscureText: !_isPasswordVisible,
          suffix: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              size: 22,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _confirmPasswordController,
          label: 'Confirm Password',
          hint: 'Confirm your password',
          prefix: const Icon(Icons.lock_outline, size: 22),
          obscureText: !_isConfirmPasswordVisible,
          suffix: IconButton(
            icon: Icon(
              _isConfirmPasswordVisible
                  ? Icons.visibility_off
                  : Icons.visibility,
              size: 22,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          readOnly: true,
          label: 'Gender',
          hint: _selectedGender ?? 'Select your gender',
          prefix: const Icon(Icons.person_outline, size: 22),
          onTap: () {
            _showSelectionDialog(
              title: 'Select Gender',
              options: _genders,
              selectedValue: _selectedGender,
              onSelect: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            );
          },
          suffix: const Icon(Icons.arrow_drop_down, size: 24),
          validator: (value) {
            if (_selectedGender == null) {
              return 'Please select your gender';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildProfessionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'Professional Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppTheme.doctorColor,
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _phoneController,
          label: 'Phone Number',
          hint: 'Enter your phone number',
          prefix: const Icon(Icons.phone_android, size: 22),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length < 10) {
              return 'Please enter a valid 10-digit phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          readOnly: true,
          label: 'Specialty',
          hint: _selectedSpecialty ?? 'Select your specialty',
          prefix: const Icon(Icons.medical_services_outlined, size: 22),
          onTap: () {
            _showSelectionDialog(
              title: 'Select Specialty',
              options: _specialties,
              selectedValue: _selectedSpecialty,
              onSelect: (value) {
                setState(() {
                  _selectedSpecialty = value;
                });
              },
            );
          },
          suffix: const Icon(Icons.arrow_drop_down, size: 24),
          validator: (value) {
            if (_selectedSpecialty == null) {
              return 'Please select your specialty';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _experienceController,
          label: 'Years of Experience',
          hint: 'Enter years of experience',
          prefix: const Icon(Icons.work_outline, size: 22),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your years of experience';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildLicenseUploadSection(),
      ],
    );
  }

  Widget _buildLicenseUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Medical License',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dividerColor),
          ),
          child: InkWell(
            onTap: () {
              // Implement file upload functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('File upload will be implemented soon'),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 40,
                  color: AppTheme.doctorColor,
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload your medical license',
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'PDF, JPG or PNG (Max. 5MB)',
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'Review Your Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppTheme.doctorColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          icon: Icons.person,
          title: 'Personal Information',
          items: [
            'Name: ${_nameController.text}',
            'Email: ${_emailController.text}',
            'Gender: ${_selectedGender ?? 'Not specified'}',
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          icon: Icons.medical_services,
          title: 'Professional Information',
          items: [
            'Specialty: ${_selectedSpecialty ?? 'Not specified'}',
            'Experience: ${_experienceController.text} years',
            'Phone: ${_phoneController.text}',
          ],
        ),
        const SizedBox(height: 20),
        _buildTermsAndConditions(),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.doctorColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: _acceptedTerms,
            onChanged: (value) {
              setState(() {
                _acceptedTerms = value ?? false;
              });
            },
            activeColor: AppTheme.doctorColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: 'I agree to the ',
                style: TextStyle(color: Colors.grey[700]),
                children: [
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(
                      color: AppTheme.doctorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: AppTheme.doctorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSelectionDialog({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required Function(String) onSelect,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              return ListTile(
                title: Text(option),
                trailing: selectedValue == option
                    ? Icon(Icons.check_circle, color: AppTheme.doctorColor)
                    : null,
                onTap: () {
                  onSelect(option);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _signup() async {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms & Conditions to continue'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setUserType(UserType.doctor);
      authProvider.setName(_nameController.text);
      authProvider.setEmail(_emailController.text);
      authProvider.setPassword(_passwordController.text);
      authProvider.setPhone(_phoneController.text);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(
              phoneNumber: _phoneController.text,
              name: _nameController.text,
              email: _emailController.text,
              isPatient: false,
            ),
          ),
        );
      }
    }
  }
}
