import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../dashboard/doctor_dashboard_screen.dart';
import '../appointments/doctor_appointments_screen.dart';
import '../profile/doctor_profile_screen.dart';
import '../messages/doctor_messages_screen.dart';

class DoctorManageScreen extends StatefulWidget {
  const DoctorManageScreen({Key? key}) : super(key: key);

  @override
  State<DoctorManageScreen> createState() => _DoctorManageScreenState();
}

class _DoctorManageScreenState extends State<DoctorManageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isRecording = false;
  bool _isLoading = false;
  bool _showPostRecordingOptions = false;

  // Mock patient data
  final List<Map<String, dynamic>> _upcomingPatients = [
    {
      'name': 'Sarah Davis',
      'age': 29,
      'gender': 'Female',
      'image': 'images/patients/p4.jpg',
      'condition': 'Anxiety and insomnia',
      'appointmentDate': '2025-04-10',
      'appointmentTime': '10:30 AM',
      'aiConsultation': true,
    },
    {
      'name': 'John Smith',
      'age': 42,
      'gender': 'Male',
      'image': 'images/patients/p1.jpg',
      'condition': 'Migraine',
      'appointmentDate': '2025-04-12',
      'appointmentTime': '09:00 AM',
      'aiConsultation': false,
    },
  ];

  final List<Map<String, dynamic>> _completedPatients = [
    {
      'name': 'Emily Johnson',
      'age': 35,
      'gender': 'Female',
      'image': 'images/patients/p2.jpg',
      'condition': 'Annual checkup',
      'lastVisit': '2025-03-15',
      'aiConsultation': true,
    },
  ];

  Map<String, dynamic>? _selectedPatient;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Manage Patients',
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.doctorColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.doctorColor,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Upcoming Appointments'),
            Tab(text: 'Completed Appointments'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Upcoming Appointments Tab
          _buildPatientsList(_upcomingPatients, isUpcoming: true),

          // Completed Appointments Tab
          _buildPatientsList(_completedPatients, isUpcoming: false),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 2, // Manage tab is selected
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
          // Current page - do nothing
        } else if (index == 3) {
          // Navigate to messages screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DoctorMessagesScreen(),
            ),
          );
        } else if (index == 4) {
          // Navigate to profile screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DoctorProfileScreen(),
            ),
          );
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

  Widget _buildPatientsList(List<Map<String, dynamic>> patients,
      {required bool isUpcoming}) {
    if (patients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.event_available : Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming
                  ? 'No upcoming appointments'
                  : 'No completed appointments',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        return isUpcoming
            ? _buildUpcomingPatientCard(patient)
            : _buildCompletedPatientCard(patient);
      },
    );
  }

  Widget _buildUpcomingPatientCard(Map<String, dynamic> patient) {
    bool isSelected = _selectedPatient == patient;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Patient info section with clickable area for recording
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (_selectedPatient != patient) {
                  setState(() {
                    _selectedPatient = patient;
                    _isRecording = true;
                    _isLoading = false;
                    _showPostRecordingOptions = false;
                  });
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(patient['image']),
                      onBackgroundImageError: (_, __) {},
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${patient['age']} years, ${patient['gender']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.event,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${patient['appointmentDate']} at ${patient['appointmentTime']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Divider(height: 1),

          // Condition and AI toggle section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.doctorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    patient['condition'],
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.doctorColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'AI Consultation',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: patient['aiConsultation'],
                  onChanged: (value) {
                    setState(() {
                      patient['aiConsultation'] = value;
                    });
                  },
                  activeColor: AppTheme.doctorColor,
                ),
              ],
            ),
          ),

          // Voice recording UI
          if (isSelected && _isRecording) _buildRecordingUI(patient),

          // Loading animation
          if (isSelected && _isLoading) _buildLoadingAnimation(),

          // Post-recording options
          if (isSelected && _showPostRecordingOptions)
            _buildPostRecordingOptions(patient),
        ],
      ),
    );
  }

  Widget _buildCompletedPatientCard(Map<String, dynamic> patient) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Patient info section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(patient['image']),
                  onBackgroundImageError: (_, __) {},
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${patient['age']} years, ${patient['gender']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Last visit: ${patient['lastVisit']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Condition badge section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.doctorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    patient['condition'],
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.doctorColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showAISummary(patient),
                    icon: const Icon(Icons.edit_note, size: 18),
                    label: const Text('Edit AI Summary'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showPrescription(patient),
                    icon: const Icon(Icons.edit_document, size: 18),
                    label: const Text('Edit Prescription'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.doctorColor,
                      side: BorderSide(color: AppTheme.doctorColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAISummary(Map<String, dynamic> patient) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.psychology_alt,
                                color: Colors.blue,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'AI Summary',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textColor,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Mock AI summary sections
                          _buildSummarySection(
                            'Symptoms',
                            Icons.sick_outlined,
                            Colors.red,
                            [
                              'Recurring headaches (3-4 times per week)',
                              'Dizziness when standing up quickly',
                              'Occasional blurred vision',
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSummarySection(
                            'Diagnosis',
                            Icons.medical_information_outlined,
                            Colors.orange,
                            ['Migraine with potential orthostatic hypotension'],
                          ),
                          const SizedBox(height: 20),
                          _buildSummarySection(
                            'Tests & Results',
                            Icons.science_outlined,
                            Colors.purple,
                            [
                              'Complete Blood Count (CBC) - Normal',
                              'Blood Pressure Monitoring - Slight variations',
                              'MRI of brain - No significant findings',
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSummarySection(
                            'Medications',
                            Icons.medication_outlined,
                            Colors.green,
                            [
                              'Sumatriptan 50mg - as needed for migraine attacks',
                              'Propranolol 40mg - daily for prevention',
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSummarySection(
                            'Recommendations',
                            Icons.recommend_outlined,
                            Colors.blue,
                            [
                              'Continue current medications',
                              'Increase water intake',
                              'Maintain regular sleep schedule',
                              'Follow up in 3 months',
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSummarySection(
    String title,
    IconData icon,
    Color color,
    List<String> items,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: color.withOpacity(0.5),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void _showPrescription(Map<String, dynamic> patient) {
    bool isPrescriptionReady = false;
    bool isDigitallySigned = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.doctorColor.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.doctorColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.description_outlined,
                                    color: AppTheme.doctorColor,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Prescription',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),

                      // Content
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Patient Info
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey[200]!,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      patient['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${patient['age']} years, ${patient['gender']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Condition: ${patient['condition']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Diagnosis
                              const Text(
                                'Diagnosis',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                initialValue:
                                    'Migraine with potential orthostatic hypotension',
                                maxLines: 3,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Medications
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Medications',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textColor,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      // Add new medication logic
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      size: 18,
                                      color: Colors.blue,
                                    ),
                                    label: const Text(
                                      'Add Medication',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildMedicationItem(
                                'Sumatriptan 50mg',
                                'Take as needed for migraine attacks',
                                '1 tablet',
                              ),
                              const SizedBox(height: 8),
                              _buildMedicationItem(
                                'Propranolol 40mg',
                                'Take daily for prevention',
                                '1 tablet',
                              ),
                              const SizedBox(height: 20),

                              // Instructions
                              const Text(
                                'Instructions',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                initialValue:
                                    '1. Take medications as prescribed\n2. Stay hydrated\n3. Maintain regular sleep schedule\n4. Follow up in 3 months',
                                maxLines: 5,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Digital Signature
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey[200]!,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Digital Signature',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (!isDigitallySigned)
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            isDigitallySigned = true;
                                            isPrescriptionReady = true;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.draw_outlined,
                                          size: 18,
                                        ),
                                        label: const Text('Sign Prescription'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AppTheme.doctorColor,
                                          side: BorderSide(
                                            color: AppTheme.doctorColor,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      )
                                    else
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Signed by Dr. John Doe',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const Spacer(),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                isDigitallySigned = false;
                                                isPrescriptionReady = false;
                                              });
                                            },
                                            child: const Text(
                                              'Remove',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Bottom Actions
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // Print prescription logic
                                },
                                icon: const Icon(
                                  Icons.print_outlined,
                                  size: 18,
                                ),
                                label: const Text('Print'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.doctorColor,
                                  side: BorderSide(
                                    color: AppTheme.doctorColor,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: isPrescriptionReady
                                    ? () {
                                        // Send prescription logic
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Prescription sent to patient',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    : null,
                                icon: const Icon(
                                  Icons.send_outlined,
                                  size: 18,
                                ),
                                label: const Text('Send'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.doctorColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMedicationItem(String name, String instructions, String dosage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 20,
                ),
                onPressed: () {
                  // Delete medication logic
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            instructions,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Dosage: $dosage',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingUI(Map<String, dynamic> patient) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Voice Recording in Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 20),

          // Voice wave animation (simplified)
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                30,
                (index) => Container(
                  width: 5,
                  height: (index % 3 == 0)
                      ? 60.0
                      : (index % 2 == 0)
                          ? 30.0
                          : 15.0,
                  decoration: BoxDecoration(
                    color: AppTheme.doctorColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '00:45',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(width: 40),
              // Stop recording button
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isRecording = false;
                    _isLoading = true;

                    // Simulate 15-second loading time
                    Future.delayed(const Duration(seconds: 15), () {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                          _showPostRecordingOptions = true;
                        });
                      }
                    });
                  });
                },
                icon: const Icon(Icons.stop_circle,
                    color: Colors.white, size: 24),
                label: const Text(
                  'Stop Recording',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.doctorColor),
          ),
          const SizedBox(height: 20),
          const Text(
            'Generating AI Summary...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Please wait while we process the recording',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostRecordingOptions(Map<String, dynamic> patient) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Recording Processed Successfully',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showAISummary(patient),
                  icon: const Icon(Icons.psychology_alt, size: 18),
                  label: const Text('View AI Summary'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showPrescription(patient),
                  icon: const Icon(Icons.description_outlined, size: 18),
                  label: const Text('View Prescription'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.doctorColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _completeAppointment(patient);
              },
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: const Text('Complete Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _completeAppointment(Map<String, dynamic> patient) {
    setState(() {
      // Add the patient to completed list
      _completedPatients.add({
        'name': patient['name'],
        'age': patient['age'],
        'gender': patient['gender'],
        'image': patient['image'],
        'condition': patient['condition'],
        'lastVisit': patient['appointmentDate'],
        'aiConsultation': patient['aiConsultation'],
      });

      // Remove from upcoming list
      _upcomingPatients.remove(patient);

      // Reset UI states
      _selectedPatient = null;
      _isRecording = false;
      _isLoading = false;
      _showPostRecordingOptions = false;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment marked as completed'),
          backgroundColor: Colors.green,
        ),
      );

      // Switch to completed tab
      _tabController.animateTo(1);
    });
  }
}
