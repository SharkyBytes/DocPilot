import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';
import '../auth/user_role_selection_screen.dart';
import '../dashboard/doctor_dashboard_screen.dart';
import '../appointments/doctor_appointments_screen.dart';
import '../manage/doctor_manage_screen.dart';
import '../messages/doctor_messages_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({Key? key}) : super(key: key);

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _qualificationsController =
      TextEditingController();
  final TextEditingController _licensesController = TextEditingController();
  final TextEditingController _clinicAddressController =
      TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _languagesController = TextEditingController();
  bool _editMode = false;
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    _loadDoctorData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialtyController.dispose();
    _experienceController.dispose();
    _qualificationsController.dispose();
    _licensesController.dispose();
    _clinicAddressController.dispose();
    _aboutController.dispose();
    _languagesController.dispose();
    super.dispose();
  }

  void _loadDoctorData() {
    // In a real app, this would come from an API or local storage
    // For now, hardcode some values for demo
    _nameController.text = "Dr. Sarah Williams";
    _emailController.text = "dr.williams@docpilot.com";
    _phoneController.text = "+1 234 567 8901";
    _specialtyController.text = "Neurology";
    _experienceController.text = "12 years";
    _qualificationsController.text =
        "MD (Johns Hopkins), PhD (Stanford), ABPN Board Certified";
    _licensesController.text = "Medical License #12345, DEA #XY1234567";
    _clinicAddressController.text =
        "123 Medical Plaza, Suite 204, San Francisco, CA 94107";
    _aboutController.text =
        "Specialist in neurological disorders with focus on migraines and epilepsy. Published researcher in neuromodulation techniques.";
    _languagesController.text = "English, Spanish, French";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Doctor Profile',
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _editMode ? Icons.save : Icons.edit,
              color: AppTheme.doctorColor,
            ),
            onPressed: () {
              setState(() {
                if (_editMode) {
                  // Save profile logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Profile saved successfully'),
                      backgroundColor: AppTheme.doctorColor,
                    ),
                  );
                }
                _editMode = !_editMode;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildProfileSections(),
            const SizedBox(height: 30),
            _buildLogoutButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 4, // Profile tab is selected
      selectedItemColor: AppTheme.doctorColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 8,
      onTap: (index) {
        if (index == 0) {
          // Navigate to home/dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DoctorDashboardScreen(),
            ),
          );
        } else if (index == 1) {
          // Navigate to appointments
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DoctorAppointmentsScreen(),
            ),
          );
        } else if (index == 2) {
          // Navigate to manage screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DoctorManageScreen(),
            ),
          );
        } else if (index == 3) {
          // Navigate to messages screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DoctorMessagesScreen(),
            ),
          );
        } else if (index == 4) {
          // Current page - do nothing
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today),
          label: 'Appointments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.manage_accounts_outlined),
          activeIcon: Icon(Icons.manage_accounts),
          label: 'Manage',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined),
          activeIcon: Icon(Icons.message),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    'assets/images/doctors/dc1.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (_editMode)
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.doctorColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      // Photo upload logic here
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _nameController.text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _specialtyController.text,
            style: TextStyle(
              color: AppTheme.doctorColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'License ID: D-78934',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip(
                Icons.school_outlined,
                'Experience',
                _experienceController.text,
              ),
              const SizedBox(width: 16),
              _buildInfoChip(
                Icons.language_outlined,
                'Languages',
                _languagesController.text.split(',').length.toString(),
              ),
              const SizedBox(width: 16),
              _buildInfoChip(
                Icons.star_outline,
                'Rating',
                '4.9/5',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAvailabilitySwitch(),
        ],
      ),
    );
  }

  Widget _buildAvailabilitySwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _isAvailable ? Colors.green[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isAvailable
              ? Colors.green.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Availability Status:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _isAvailable ? 'Available' : 'Unavailable',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _isAvailable ? Colors.green[700] : Colors.grey[700],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: _isAvailable,
            onChanged: _editMode
                ? (value) {
                    setState(() {
                      _isAvailable = value;
                    });
                  }
                : null,
            activeColor: Colors.green,
            activeTrackColor: Colors.green[100],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.doctorColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppTheme.doctorColor,
            size: 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSections() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Personal Information'),
          const SizedBox(height: 16),
          _buildPersonalInfoSection(),
          const SizedBox(height: 24),
          _buildSectionTitle('Professional Information'),
          const SizedBox(height: 16),
          _buildProfessionalInfoSection(),
          const SizedBox(height: 24),
          _buildSectionTitle('About Me'),
          const SizedBox(height: 16),
          _buildAboutSection(),
          const SizedBox(height: 24),
          _buildSectionTitle('App Settings'),
          const SizedBox(height: 16),
          _buildAppSettingsSection(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppTheme.doctorColor,
            width: 3,
          ),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: AppTheme.textColor,
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileField(
            'Full Name',
            _nameController,
            Icons.person_outline,
          ),
          const Divider(),
          _buildProfileField(
            'Email',
            _emailController,
            Icons.email_outlined,
          ),
          const Divider(),
          _buildProfileField(
            'Phone Number',
            _phoneController,
            Icons.phone_outlined,
          ),
          const Divider(),
          _buildProfileField(
            'Clinic Address',
            _clinicAddressController,
            Icons.location_on_outlined,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileField(
            'Specialty',
            _specialtyController,
            Icons.medical_services_outlined,
          ),
          const Divider(),
          _buildProfileField(
            'Experience',
            _experienceController,
            Icons.timeline_outlined,
          ),
          const Divider(),
          _buildProfileField(
            'Qualifications',
            _qualificationsController,
            Icons.school_outlined,
            maxLines: 3,
          ),
          const Divider(),
          _buildProfileField(
            'Medical Licenses',
            _licensesController,
            Icons.badge_outlined,
            maxLines: 2,
          ),
          const Divider(),
          _buildProfileField(
            'Languages',
            _languagesController,
            Icons.language_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileField(
            'Professional Summary',
            _aboutController,
            Icons.description_outlined,
            maxLines: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            'Notifications',
            Icons.notifications_outlined,
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: AppTheme.doctorColor,
            ),
          ),
          const Divider(),
          _buildSettingsItem(
            'Dark Mode',
            Icons.dark_mode_outlined,
            trailing: Switch(
              value: false,
              onChanged: (value) {},
              activeColor: AppTheme.doctorColor,
            ),
          ),
          const Divider(),
          _buildSettingsItem(
            'Two-Factor Authentication',
            Icons.security_outlined,
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: AppTheme.doctorColor,
            ),
          ),
          const Divider(),
          _buildSettingsItem(
            'Language',
            Icons.language_outlined,
            trailingText: 'English',
            onTap: () {
              // Show language selection
            },
          ),
          const Divider(),
          _buildSettingsItem(
            'Privacy Policy',
            Icons.privacy_tip_outlined,
            onTap: () {
              // Navigate to privacy policy
            },
          ),
          const Divider(),
          _buildSettingsItem(
            'Terms & Conditions',
            Icons.description_outlined,
            onTap: () {
              // Navigate to terms & conditions
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.doctorColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppTheme.doctorColor,
            size: 22,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _editMode
              ? CustomTextField(
                  controller: controller,
                  hint: label,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        controller.text,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textColor,
                        ),
                        maxLines: maxLines,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    String title,
    IconData icon, {
    Widget? trailing,
    String? trailingText,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.doctorColor,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null) trailing,
            if (trailingText != null)
              Row(
                children: [
                  Text(
                    trailingText,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ],
              ),
            if (trailing == null && trailingText == null && onTap != null)
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomButton(
        text: 'Logout',
        onPressed: () => _showLogoutDialog(context),
        type: ButtonType.outlined,
        icon: Icons.logout,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserRoleSelectionScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text('Logout'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
