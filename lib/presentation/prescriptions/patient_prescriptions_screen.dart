import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../dashboard/patient_dashboard_screen.dart';
import '../profile/patient_profile_screen.dart';
import '../appointments/patient_appointments_screen.dart';
import '../notifications/patient_notifications_screen.dart';
import 'dart:math';

class PatientPrescriptionsScreen extends StatefulWidget {
  const PatientPrescriptionsScreen({Key? key}) : super(key: key);

  @override
  State<PatientPrescriptionsScreen> createState() =>
      _PatientPrescriptionsScreenState();
}

class _PatientPrescriptionsScreenState
    extends State<PatientPrescriptionsScreen> {
  int _selectedIndex = 2; // Prescriptions tab is selected by default

  // Mock data for past appointments with prescriptions
  final List<Map<String, dynamic>> _pastAppointments = [
    {
      'id': '1',
      'doctorName': 'Dr. Jennifer Warner',
      'doctorImage': 'assets/images/doctors/dc1.jpg',
      'specialty': 'Cardiologist',
      'date': '15 March, 2023',
      'time': '10:00 AM',
      'hasReview': false,
      'prescription': {
        'notes':
            'Patient presented with mild hypertension. Blood pressure readings: 140/90 mmHg.',
        'recommendations': [
          {
            'type': 'Medication',
            'name': 'Lisinopril',
            'dosage': '10mg',
            'frequency': 'Once daily',
            'isSelected': false
          },
          {
            'type': 'Medication',
            'name': 'Aspirin',
            'dosage': '81mg',
            'frequency': 'Once daily',
            'isSelected': false
          },
          {
            'type': 'Activity',
            'name': 'Morning Walk',
            'duration': '30 minutes',
            'frequency': 'Daily',
            'isSelected': false
          },
          {
            'type': 'Diet',
            'name': 'Low Sodium Diet',
            'description': 'Limit salt intake to less than 2g per day',
            'isSelected': false
          },
        ]
      }
    },
    {
      'id': '2',
      'doctorName': 'Dr. John Smith',
      'doctorImage': 'assets/images/doctors/dc2.jpg',
      'specialty': 'Neurologist',
      'date': '22 February, 2023',
      'time': '2:30 PM',
      'hasReview': true,
      'prescription': {
        'notes':
            'Patient complained of frequent migraines. No abnormalities detected in neurological examination.',
        'recommendations': [
          {
            'type': 'Medication',
            'name': 'Sumatriptan',
            'dosage': '50mg',
            'frequency': 'As needed for migraine',
            'isSelected': false
          },
          {
            'type': 'Activity',
            'name': 'Stress Reduction',
            'duration': '15 minutes',
            'frequency': 'Twice daily',
            'isSelected': false
          },
          {
            'type': 'Lifestyle',
            'name': 'Sleep Schedule',
            'description':
                'Maintain consistent sleep schedule with 7-8 hours per night',
            'isSelected': false
          },
          {
            'type': 'Diet',
            'name': 'Trigger Food Journal',
            'description': 'Keep track of foods that may trigger migraines',
            'isSelected': false
          },
        ]
      }
    },
    {
      'id': '3',
      'doctorName': 'Dr. Sarah Wilson',
      'doctorImage': 'assets/images/doctors/dc3.jpg',
      'specialty': 'Dermatologist',
      'date': '5 January, 2023',
      'time': '9:15 AM',
      'hasReview': false,
      'prescription': {
        'notes':
            'Patient has moderate eczema on both arms. Skin is dry and shows signs of scratching.',
        'recommendations': [
          {
            'type': 'Medication',
            'name': 'Hydrocortisone Cream',
            'dosage': '1%',
            'frequency': 'Twice daily for 7 days',
            'isSelected': false
          },
          {
            'type': 'Medication',
            'name': 'Cetirizine',
            'dosage': '10mg',
            'frequency': 'Once daily if itching is severe',
            'isSelected': false
          },
          {
            'type': 'Skincare',
            'name': 'Gentle Moisturizer',
            'description': 'Apply fragrance-free moisturizer after shower',
            'isSelected': false
          },
          {
            'type': 'Lifestyle',
            'name': 'Avoid Hot Showers',
            'description': 'Use lukewarm water to prevent skin dryness',
            'isSelected': false
          },
        ]
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Prescriptions',
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildPrescriptionsBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildPrescriptionsBody() {
    if (_pastAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medication_outlined,
              size: 70,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No prescriptions yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your prescriptions will appear here after your appointments',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pastAppointments.length,
      itemBuilder: (context, index) {
        final appointment = _pastAppointments[index];
        return _buildPrescriptionCard(appointment);
      },
    );
  }

  Widget _buildPrescriptionCard(Map<String, dynamic> appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Doctor info section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      appointment['doctorImage'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.grey[400],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Doctor details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment['doctorName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment['specialty'],
                        style: TextStyle(
                          color: AppTheme.patientColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            appointment['date'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            appointment['time'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
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
          // Divider
          Divider(color: Colors.grey.withOpacity(0.2), height: 1),
          // Actions
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showPrescriptionDetails(appointment),
                    icon: const Icon(Icons.medication_outlined,
                        size: 18, color: Colors.white),
                    label: const Text('View Prescription'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showReviewDialog(appointment),
                    icon: Icon(
                      appointment['hasReview'] ? Icons.star : Icons.star_border,
                      size: 18,
                      color: appointment['hasReview']
                          ? Colors.amber
                          : AppTheme.patientColor,
                    ),
                    label: Text(
                      appointment['hasReview'] ? 'Edit Review' : 'Give Review',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.patientColor,
                      side: BorderSide(color: AppTheme.patientColor),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
  }

  void _showPrescriptionDetails(Map<String, dynamic> appointment) {
    final prescription = appointment['prescription'];
    final recommendations =
        prescription['recommendations'] as List<Map<String, dynamic>>;

    // Create a copy of the recommendations for the dialog
    final dialogRecommendations =
        List.of(recommendations.map((rec) => Map<String, dynamic>.from(rec)))
            .cast<Map<String, dynamic>>();

    // Filter recommendations by type
    final medications = dialogRecommendations
        .where((rec) => rec['type'] == 'Medication')
        .toList();

    final activities = dialogRecommendations
        .where((rec) => rec['type'] != 'Medication')
        .toList();

    // Mock AI-extracted summary data
    final aiSummary = {
      'symptoms': [
        'Recurring headaches (3-4 times per week)',
        'Dizziness when standing up quickly',
        'Occasional blurred vision'
      ],
      'diagnosis': 'Migraine with potential orthostatic hypotension',
      'tests': [
        'Complete Blood Count (CBC) - Normal',
        'Blood Pressure Monitoring - Slight variations',
        'MRI of brain - No significant findings'
      ]
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.patientColor.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.medication,
                            color: AppTheme.patientColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Prescription Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Doctor info
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage:
                                    AssetImage(appointment['doctorImage']),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appointment['doctorName'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppTheme.textColor,
                                    ),
                                  ),
                                  Text(
                                    appointment['specialty'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Date information
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Appointment: ${appointment['date']} at ${appointment['time']}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // AI Summary title and container
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.psychology,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'AI-Extracted Summary',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Symptoms section
                          _buildAISummarySection(
                              'Symptoms',
                              aiSummary['symptoms'] as List<dynamic>,
                              Colors.red,
                              Icons.sick),
                          const SizedBox(height: 16),

                          // Diagnosis section
                          _buildAISummarySection(
                              'Diagnosis',
                              [aiSummary['diagnosis']],
                              Colors.orange,
                              Icons.medical_information),
                          const SizedBox(height: 16),

                          // Tests section
                          _buildAISummarySection(
                              'Tests',
                              aiSummary['tests'] as List<dynamic>,
                              Colors.purple,
                              Icons.science),
                          const SizedBox(height: 24),

                          const Divider(height: 1, color: Colors.grey),
                          const SizedBox(height: 24),

                          // Doctor's notes
                          const Text(
                            'Doctor\'s Notes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              prescription['notes'],
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Medications section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Medications',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => _showManageActivitiesDialog(
                                    medications, 'Medications'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppTheme.patientColor.withOpacity(0.1),
                                  foregroundColor: AppTheme.patientColor,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Manage Medications'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // List medications
                          if (medications.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              child: const Text(
                                'No medications prescribed',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          else
                            ...medications
                                .map((rec) => _buildRecommendationItem(rec)),

                          const SizedBox(height: 24),

                          // Daily Activities section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Daily Activities',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => _showManageActivitiesDialog(
                                    activities, 'Activities'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppTheme.patientColor.withOpacity(0.1),
                                  foregroundColor: AppTheme.patientColor,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Manage Activities'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // List activities
                          if (activities.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              child: const Text(
                                'No activities recommended',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          else
                            ...activities
                                .map((rec) => _buildRecommendationItem(rec)),

                          const SizedBox(height: 32),

                          // Download prescription button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.download),
                              label: const Text('Download Prescription as PDF'),
                              onPressed: () {
                                // Show a snackbar to indicate download initiated
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Downloading prescription...'),
                                    backgroundColor: AppTheme.patientColor,
                                  ),
                                );

                                // Show a success dialog after a brief delay
                                Future.delayed(const Duration(seconds: 2), () {
                                  Navigator.pop(context);
                                  _showDownloadCompleteDialog(context);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.patientColor,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
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

  Widget _buildAISummarySection(
    String title,
    List<dynamic> items,
    Color color,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
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
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items
              .map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textColor,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  void _showManageActivitiesDialog(
      List<Map<String, dynamic>> recommendations, String type) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add $type to Dashboard',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select items to add to your dashboard for tracking',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Scrollable list of checkboxes
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: recommendations.map((rec) {
                            return CheckboxListTile(
                              title: Text(
                                rec['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                rec['type'] == 'Medication'
                                    ? '${rec['dosage']} - ${rec['frequency']}'
                                    : rec['type'] == 'Activity'
                                        ? '${rec['duration']} - ${rec['frequency']}'
                                        : rec['description'] ?? '',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              value: rec['isSelected'],
                              activeColor: AppTheme.patientColor,
                              checkColor: Colors.white,
                              onChanged: (bool? value) {
                                setState(() {
                                  rec['isSelected'] = value;
                                });
                              },
                              secondary: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _getIconColor(rec['type'])
                                      .withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getIconForType(rec['type']),
                                  color: _getIconColor(rec['type']),
                                  size: 20,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[600],
                              side: BorderSide(color: Colors.grey[300]!),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Here we would update the user's dashboard with selected items
                              // For demo, just show a confirmation and close dialog

                              final selectedCount = recommendations
                                  .where((rec) => rec['isSelected'] == true)
                                  .length;

                              if (selectedCount > 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '$selectedCount $type added to dashboard'),
                                    backgroundColor: AppTheme.patientColor,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }

                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.patientColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Add Selected'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDownloadCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Download Complete'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Prescription has been successfully downloaded to your device.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.file_open, size: 18),
                    label: const Text('Open File'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.patientColor,
                      side: BorderSide(color: AppTheme.patientColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Share'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.patientColor,
                      side: BorderSide(color: AppTheme.patientColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',
                style: TextStyle(color: AppTheme.patientColor)),
          ),
        ],
      ),
    );
  }

  // Helper methods for determining icon and color based on recommendation type
  IconData _getIconForType(String type) {
    switch (type) {
      case 'Medication':
        return Icons.medication;
      case 'Activity':
        return Icons.directions_run;
      case 'Diet':
        return Icons.restaurant;
      case 'Lifestyle':
        return Icons.nightlight;
      case 'Skincare':
        return Icons.spa;
      default:
        return Icons.article;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'Medication':
        return Colors.blue;
      case 'Activity':
        return Colors.green;
      case 'Diet':
        return Colors.orange;
      case 'Lifestyle':
        return Colors.purple;
      case 'Skincare':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  Widget _buildBottomNavigationBar() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            // Only highlight home button when we're on dashboard
            currentIndex: 1,
            selectedItemColor: AppTheme.patientColor,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            onTap: (index) {
              // Adjust index to account for the center button
              final adjustedIndex = index >= 2 ? index + 1 : index;

              if (adjustedIndex == 0) {
                // Schedule tab
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PatientAppointmentsScreen(),
                  ),
                );
              } else if (adjustedIndex == 1) {
                // Prescriptions tab
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PatientPrescriptionsScreen(),
                  ),
                );
              } else if (index == 3) {
                // Notifications tab
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PatientNotificationsScreen(),
                  ),
                );
              } else if (index == 4) {
                // Profile tab
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PatientProfileScreen(),
                  ),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                activeIcon: Icon(Icons.calendar_today),
                label: 'Schedule',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.medication_outlined),
                activeIcon: Icon(Icons.medication),
                label: 'Prescriptions',
              ),
              // Empty item for the center floating button
              BottomNavigationBarItem(
                icon: SizedBox(),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
        // Floating center button
        Positioned(
          bottom:
              7, // Increased to ensure button is fully visible and not cut off
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.patientColor,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.patientColor.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.home,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                // We're already on home, no action needed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PatientDashboardScreen(),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showReviewDialog(Map<String, dynamic> appointment) {
    double rating = 5.0;
    String review = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage(appointment['doctorImage']),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment['doctorName'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppTheme.textColor,
                              ),
                            ),
                            Text(
                              appointment['specialty'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Rate your experience',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Star rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < rating.floor()
                                ? Icons.star
                                : index < rating
                                    ? Icons.star_half
                                    : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              rating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),

                    const SizedBox(height: 16),

                    // Review text field
                    TextField(
                      onChanged: (value) {
                        review = value;
                      },
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Share your experience with this doctor...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.patientColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[600],
                              side: BorderSide(color: Colors.grey[300]!),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // For demo, just show confirmation and update state
                              setState(() {
                                appointment['hasReview'] = true;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(appointment['hasReview']
                                      ? 'Review updated successfully'
                                      : 'Thank you for your review!'),
                                  backgroundColor: AppTheme.patientColor,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );

                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.patientColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              appointment['hasReview']
                                  ? 'Update Review'
                                  : 'Submit Review',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRecommendationItem(Map<String, dynamic> recommendation) {
    // Set icon based on recommendation type
    IconData icon;
    Color iconColor;

    switch (recommendation['type']) {
      case 'Medication':
        icon = Icons.medication;
        iconColor = Colors.blue;
        break;
      case 'Activity':
        icon = Icons.directions_run;
        iconColor = Colors.green;
        break;
      case 'Diet':
        icon = Icons.restaurant;
        iconColor = Colors.orange;
        break;
      case 'Lifestyle':
        icon = Icons.nightlight;
        iconColor = Colors.purple;
        break;
      case 'Skincare':
        icon = Icons.spa;
        iconColor = Colors.pink;
        break;
      default:
        icon = Icons.article;
        iconColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                if (recommendation['type'] == 'Medication') ...[
                  Text(
                    'Dosage: ${recommendation['dosage']} - ${recommendation['frequency']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ] else if (recommendation['type'] == 'Activity') ...[
                  Text(
                    'Duration: ${recommendation['duration']} - ${recommendation['frequency']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ] else ...[
                  Text(
                    recommendation['description'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
