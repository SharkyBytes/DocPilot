import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_button.dart';
import '../dashboard/doctor_dashboard_screen.dart';
import '../manage/doctor_manage_screen.dart';
import '../messages/doctor_messages_screen.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  // Mock data for doctor's appointments
  final List<Map<String, dynamic>> _appointments = [
    {
      'id': '1',
      'patientName': 'John Smith',
      'patientImage': 'images/patients/p1.jpg',
      'patientAge': 42,
      'patientGender': 'Male',
      'patientContact': '+1 123-456-7890',
      'date': DateTime.now().add(const Duration(days: 2)),
      'time': '10:00 AM',
      'duration': 30,
      'type': 'Follow-up',
      'status': 'Confirmed',
      'reason': 'Headache and dizziness',
      'notes':
          'Patient has a history of migraines. Previously prescribed sumatriptan 50mg.',
      'medications': ['Sumatriptan 50mg', 'Propranolol 40mg'],
      'allergies': ['Penicillin'],
      'medicalHistory': ['Migraines', 'Hypertension'],
      'location': 'Room 302',
    },
    {
      'id': '2',
      'patientName': 'Emily Johnson',
      'patientImage': 'images/patients/p2.jpg',
      'patientAge': 35,
      'patientGender': 'Female',
      'patientContact': '+1 234-567-8901',
      'date': DateTime.now(),
      'time': '2:30 PM',
      'duration': 45,
      'type': 'New Patient',
      'status': 'Pending',
      'reason': 'Annual checkup',
      'notes': 'First-time patient. Initial consultation needed.',
      'medications': [],
      'allergies': ['None'],
      'medicalHistory': ['None'],
      'location': 'Room 305',
    },
    {
      'id': '3',
      'patientName': 'Michael Brown',
      'patientImage': 'images/patients/p3.jpg',
      'patientAge': 58,
      'patientGender': 'Male',
      'patientContact': '+1 345-678-9012',
      'date': DateTime.now().add(const Duration(days: 5)),
      'time': '9:15 AM',
      'duration': 30,
      'type': 'Follow-up',
      'status': 'Confirmed',
      'reason': 'Diabetes management',
      'notes':
          'Patient needs to review recent lab results. HbA1c test done last week.',
      'medications': [
        'Metformin 500mg',
        'Lisinopril 10mg',
        'Atorvastatin 20mg'
      ],
      'allergies': ['Sulfa drugs'],
      'medicalHistory': ['Type 2 Diabetes', 'Hypertension', 'High Cholesterol'],
      'location': 'Room 302',
    },
    {
      'id': '4',
      'patientName': 'Sarah Davis',
      'patientImage': 'images/patients/p4.jpg',
      'patientAge': 29,
      'patientGender': 'Female',
      'patientContact': '+1 456-789-0123',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'time': '11:30 AM',
      'duration': 60,
      'type': 'Consultation',
      'status': 'Completed',
      'reason': 'Anxiety and insomnia',
      'notes':
          'Patient reports increased anxiety at work. Sleep quality has decreased significantly in the past month.',
      'medications': ['Escitalopram 10mg', 'Melatonin 5mg'],
      'allergies': ['Latex'],
      'medicalHistory': ['Generalized Anxiety Disorder', 'Insomnia'],
      'location': 'Room 301',
    },
    {
      'id': '5',
      'patientName': 'Robert Wilson',
      'patientImage': 'images/patients/p5.jpg',
      'patientAge': 62,
      'patientGender': 'Male',
      'patientContact': '+1 567-890-1234',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'time': '3:00 PM',
      'duration': 45,
      'type': 'Follow-up',
      'status': 'Completed',
      'reason': 'Post-surgery check',
      'notes':
          'Patient had knee replacement surgery 6 weeks ago. Doing well with physical therapy.',
      'medications': ['Hydrocodone/Acetaminophen 5-325mg', 'Aspirin 81mg'],
      'allergies': ['Codeine'],
      'medicalHistory': [
        'Osteoarthritis',
        'Hypertension',
        'Knee Replacement Surgery'
      ],
      'location': 'Room 303',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter appointments based on tab selection
    final upcomingAppointments = _appointments
        .where((appointment) => appointment['date']
            .isAfter(DateTime.now().subtract(const Duration(days: 1))))
        .toList();

    final pastAppointments = _appointments
        .where((appointment) =>
            appointment['date'].isBefore(DateTime.now()) &&
            appointment['status'] == 'Completed')
        .toList();

    // Filter appointments for the selected day
    final selectedDayAppointments = _appointments.where((appointment) {
      final appointmentDate = appointment['date'] as DateTime;
      return isSameDay(appointmentDate, _selectedDay);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Appointments',
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
      body: Column(
        children: [
          // Calendar section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                    CalendarFormat.week: 'Week',
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    outsideTextStyle: const TextStyle(color: Colors.black54),
                    weekendTextStyle: const TextStyle(color: Colors.black87),
                    defaultTextStyle: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    markerDecoration: BoxDecoration(
                      color: AppTheme.doctorColor,
                      shape: BoxShape.circle,
                    ),
                    markersMaxCount: 3,
                    todayDecoration: BoxDecoration(
                      color: AppTheme.doctorColor.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppTheme.doctorColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                    formatButtonShowsNext: false,
                    leftChevronIcon: Icon(Icons.chevron_left,
                        color: Colors.black87, size: 28),
                    rightChevronIcon: Icon(Icons.chevron_right,
                        color: Colors.black87, size: 28),
                    titleTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    formatButtonTextStyle: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w500),
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.fromBorderSide(
                          BorderSide(color: Colors.black26)),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                  ),
                  eventLoader: (day) {
                    return _appointments.where((appointment) {
                      final appointmentDate = appointment['date'] as DateTime;
                      return isSameDay(appointmentDate, day);
                    }).toList();
                  },
                ),
              ],
            ),
          ),

          // Tab bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.doctorColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.doctorColor,
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'Past'),
              ],
            ),
          ),

          // Selected day indicator
          if (selectedDayAppointments.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: Colors.grey[100],
              child: Row(
                children: [
                  const Icon(Icons.event,
                      size: 20, color: AppTheme.doctorColor),
                  const SizedBox(width: 8),
                  Text(
                    '${DateFormat('EEEE, MMMM d').format(_selectedDay)} - ${selectedDayAppointments.length} appointments',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textColor,
                    ),
                  ),
                ],
              ),
            ),

          // Appointments list
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Upcoming appointments tab
                _buildAppointmentsList(upcomingAppointments, isUpcoming: true),

                // Past appointments tab
                _buildAppointmentsList(pastAppointments, isUpcoming: false),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppointmentsList(List<Map<String, dynamic>> appointments,
      {required bool isUpcoming}) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.calendar_today : Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? 'No upcoming appointments' : 'No past appointments',
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
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return _buildAppointmentCard(appointments[index], isUpcoming);
      },
    );
  }

  Widget _buildAppointmentCard(
      Map<String, dynamic> appointment, bool isUpcoming) {
    final bool isToday = isSameDay(appointment['date'], DateTime.now());

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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showPatientDetails(appointment),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Appointment header with date and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.event,
                          size: 18,
                          color: AppTheme.doctorColor.withOpacity(0.9),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isToday
                              ? 'Today'
                              : DateFormat('MMM d, yyyy')
                                  .format(appointment['date']),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isToday
                                ? AppTheme.doctorColor
                                : Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _getStatusColor(appointment['status'])
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(appointment['status'])
                              .withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        appointment['status'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(appointment['status']),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Patient info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(appointment['patientImage']),
                      onBackgroundImageError: (_, __) {},
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment['patientName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppTheme.textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${appointment['patientAge']} yrs, ${appointment['patientGender']}',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Appointment details
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.doctorColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.access_time,
                        size: 18,
                        color: AppTheme.doctorColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${appointment['time']} (${appointment['duration']} min)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.doctorColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.local_hospital_outlined,
                        size: 18,
                        color: AppTheme.doctorColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      appointment['type'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.doctorColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.room_outlined,
                        size: 18,
                        color: AppTheme.doctorColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      appointment['location'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Reason for visit
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.doctorColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.healing,
                        size: 18,
                        color: AppTheme.doctorColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reason:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appointment['reason'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Action buttons
                if (isUpcoming)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildActionButton(
                        'Reschedule',
                        Icons.event_available,
                        () => _rescheduleAppointment(appointment),
                        AppTheme.doctorColor.withOpacity(0.1),
                        AppTheme.doctorColor,
                      ),
                      const SizedBox(width: 12),
                      _buildActionButton(
                        'View Record',
                        Icons.medical_services_outlined,
                        () => _showPastRecords(appointment),
                        AppTheme.doctorColor,
                        Colors.white,
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildActionButton(
                        'Prescription',
                        Icons.description_outlined,
                        () => _showPrescriptionDetails(appointment),
                        Colors.blue.withOpacity(0.15),
                        Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      _buildActionButton(
                        'View Records',
                        Icons.history,
                        () => _showPastRecords(appointment),
                        AppTheme.doctorColor.withOpacity(0.15),
                        AppTheme.doctorColor,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
    Color backgroundColor,
    Color textColor,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: backgroundColor == AppTheme.doctorColor ? 2 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Completed':
        return Colors.blue;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showPatientDetails(Map<String, dynamic> appointment) {
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
                  // Header with patient info
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.doctorColor.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Patient Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textColor,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  AssetImage(appointment['patientImage']),
                              onBackgroundImageError: (_, __) {},
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appointment['patientName'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: AppTheme.textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${appointment['patientAge']} years, ${appointment['patientGender']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        appointment['patientContact'],
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
                      ],
                    ),
                  ),

                  // Patient details sections with tabs
                  Expanded(
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          const TabBar(
                            labelColor: AppTheme.doctorColor,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: AppTheme.doctorColor,
                            tabs: [
                              Tab(text: 'Current Visit'),
                              Tab(text: 'Medical History'),
                              Tab(text: 'Past Visits'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                // Current Visit Tab
                                SingleChildScrollView(
                                  controller: scrollController,
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailSection(
                                        'Appointment Details',
                                        [
                                          _buildDetailItem(
                                              'Date',
                                              DateFormat('EEEE, MMMM d, yyyy')
                                                  .format(appointment['date'])),
                                          _buildDetailItem('Time',
                                              '${appointment['time']} (${appointment['duration']} min)'),
                                          _buildDetailItem(
                                              'Type', appointment['type']),
                                          _buildDetailItem('Location',
                                              appointment['location']),
                                          _buildDetailItem(
                                              'Status', appointment['status']),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      _buildDetailSection(
                                        'Visit Information',
                                        [
                                          _buildDetailItem('Reason for Visit',
                                              appointment['reason']),
                                          _buildDetailItem(
                                              'Notes', appointment['notes']),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      _buildDetailSection(
                                        'Current Medications',
                                        (appointment['medications']
                                                    as List<dynamic>)
                                                .isEmpty
                                            ? [
                                                _buildDetailItem(
                                                    'No medications', '')
                                              ]
                                            : (appointment['medications']
                                                    as List<dynamic>)
                                                .map((med) =>
                                                    _buildDetailItem(med, ''))
                                                .toList(),
                                      ),
                                      const SizedBox(height: 20),
                                      _buildDetailSection(
                                        'Allergies',
                                        (appointment['allergies']
                                                    as List<dynamic>)
                                                .isEmpty
                                            ? [
                                                _buildDetailItem(
                                                    'No allergies', '')
                                              ]
                                            : (appointment['allergies']
                                                    as List<dynamic>)
                                                .map((allergy) =>
                                                    _buildDetailItem(
                                                        allergy, ''))
                                                .toList(),
                                      ),
                                      const SizedBox(height: 40),
                                      if (appointment['status'] != 'Completed')
                                        CustomButton(
                                          text: 'Complete Appointment',
                                          onPressed: () =>
                                              _completeAppointment(appointment),
                                          icon: Icons.check_circle_outline,
                                        ),
                                    ],
                                  ),
                                ),

                                // Medical History Tab
                                SingleChildScrollView(
                                  controller: scrollController,
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailSection(
                                        'Medical Conditions',
                                        (appointment['medicalHistory']
                                                    as List<dynamic>)
                                                .isEmpty
                                            ? [
                                                _buildDetailItem(
                                                    'No medical conditions', '')
                                              ]
                                            : (appointment['medicalHistory']
                                                    as List<dynamic>)
                                                .map((condition) =>
                                                    _buildDetailItem(
                                                        condition, ''))
                                                .toList(),
                                      ),
                                      const SizedBox(height: 20),
                                      _buildDetailSection(
                                        'Medications History',
                                        [
                                          _buildDetailItem('Sumatriptan 50mg',
                                              'Started 3 months ago'),
                                          _buildDetailItem('Propranolol 40mg',
                                              'Started 6 months ago'),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      _buildDetailSection(
                                        'Lab Results',
                                        [
                                          _buildDetailItem('Blood Test (CBC)',
                                              'Normal - 2 months ago'),
                                          _buildDetailItem('Cholesterol Panel',
                                              'Slightly elevated - 2 months ago'),
                                          _buildDetailItem('Liver Function',
                                              'Normal - 2 months ago'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Past Visits Tab
                                ListView.builder(
                                  controller: scrollController,
                                  padding: const EdgeInsets.all(20),
                                  itemCount: 3, // Mock past visits
                                  itemBuilder: (context, index) {
                                    return _buildPastVisitCard(index);
                                  },
                                ),
                              ],
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

  Widget _buildDetailSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (value.isNotEmpty)
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPastVisitCard(int index) {
    final visits = [
      {
        'date': '15 May 2023',
        'reason': 'Annual checkup',
        'diagnosis': 'Healthy, no concerns',
        'prescriptions': ['Multivitamin'],
        'doctor': 'Self'
      },
      {
        'date': '3 January 2023',
        'reason': 'Flu symptoms',
        'diagnosis': 'Seasonal influenza',
        'prescriptions': ['Oseltamivir 75mg', 'Ibuprofen 400mg'],
        'doctor': 'Dr. Williams'
      },
      {
        'date': '25 August 2022',
        'reason': 'Migraine',
        'diagnosis': 'Chronic migraine',
        'prescriptions': ['Sumatriptan 50mg', 'Propranolol 40mg'],
        'doctor': 'Self'
      },
    ];

    final visit = visits[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  visit['date'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.textColor,
                  ),
                ),
                Text(
                  'Doctor: ${visit['doctor'] as String}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailItem('Reason', visit['reason'] as String),
            _buildDetailItem('Diagnosis', visit['diagnosis'] as String),
            const SizedBox(height: 8),
            Text(
              'Prescriptions:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            ...List.generate(
              (visit['prescriptions'] as List<dynamic>).length,
              (i) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Text(
                  '• ${(visit['prescriptions'] as List<dynamic>)[i]}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.description_outlined, size: 16),
                label: const Text('View Details'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.doctorColor,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _rescheduleAppointment(Map<String, dynamic> appointment) {
    // Show a dialog or bottom sheet for rescheduling
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        DateTime selectedDate = appointment['date'];
        String selectedTime = appointment['time'];

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.doctorColor.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Reschedule Appointment',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
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
                          // Patient info
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage:
                                    AssetImage(appointment['patientImage']),
                                onBackgroundImageError: (_, __) {},
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appointment['patientName'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppTheme.textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${appointment['patientAge']} yrs, ${appointment['patientGender']}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Date picker
                          const Text(
                            'Select New Date',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                          ),
                          const SizedBox(height: 12),

                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 90)),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: AppTheme.doctorColor,
                                          onPrimary: Colors.white,
                                          surface: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                        textTheme: const TextTheme(
                                          titleLarge:
                                              TextStyle(color: Colors.green),
                                          bodyLarge:
                                              TextStyle(color: Colors.black),
                                          bodyMedium:
                                              TextStyle(color: Colors.black),
                                          titleSmall:
                                              TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedDate != null) {
                                  setState(() {
                                    selectedDate = pickedDate;
                                  });
                                }
                              },
                              child: Container(
                                height: 250,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 48,
                                        color: AppTheme.doctorColor,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        DateFormat('EEEE, MMMM d, yyyy')
                                            .format(selectedDate),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Tap to change date',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Time slots
                          const Text(
                            'Select New Time',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                          ),
                          const SizedBox(height: 12),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              '9:00 AM',
                              '10:00 AM',
                              '11:00 AM',
                              '1:00 PM',
                              '2:00 PM',
                              '3:00 PM',
                              '4:00 PM',
                            ].map((time) {
                              final isSelected = selectedTime == time;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedTime = time;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme.doctorColor
                                        : AppTheme.doctorColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    time,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.doctorColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 40),

                          // Save button
                          CustomButton(
                            text: 'Confirm Reschedule',
                            onPressed: () {
                              // Update the appointment with new date and time
                              setState(() {
                                appointment['date'] = selectedDate;
                                appointment['time'] = selectedTime;
                                appointment['status'] = 'Rescheduled';
                              });
                              Navigator.pop(context);

                              // Show confirmation
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Appointment rescheduled successfully'),
                                  backgroundColor: AppTheme.doctorColor,
                                ),
                              );
                            },
                            icon: Icons.check_circle_outline,
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

  void _showPastRecords(Map<String, dynamic> appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
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
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Patient Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  // Patient basic info
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage(appointment['patientImage']),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment['patientName'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${appointment['patientAge']} years, ${appointment['patientGender']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                appointment['patientContact'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tabs
                  DefaultTabController(
                    length: 3,
                    child: Expanded(
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: AppTheme.doctorColor,
                            unselectedLabelColor: Colors.grey[600],
                            indicatorColor: AppTheme.doctorColor,
                            tabs: const [
                              Tab(text: 'Current Visit'),
                              Tab(text: 'Medical History'),
                              Tab(text: 'Past Visits'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                // Current Visit Tab
                                SingleChildScrollView(
                                  controller: scrollController,
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildPatientInfoCard(
                                        'Reason',
                                        appointment['reason'],
                                        Icons.edit_note,
                                        Colors.blue,
                                      ),
                                      _buildPatientInfoCard(
                                        'Diagnosis',
                                        appointment['notes'] ??
                                            'No diagnosis provided yet',
                                        Icons.medical_information,
                                        Colors.orange,
                                      ),
                                      _buildPatientInfoCard(
                                        'Prescriptions:',
                                        appointment.containsKey(
                                                    'medications') &&
                                                appointment['medications']
                                                    .isNotEmpty
                                            ? appointment['medications']
                                                .join('\n')
                                            : 'No prescriptions available',
                                        Icons.medication,
                                        Colors.green,
                                      ),
                                    ],
                                  ),
                                ),

                                // Medical History Tab
                                SingleChildScrollView(
                                  controller: scrollController,
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildPatientInfoCard(
                                        'Medical Conditions',
                                        appointment.containsKey(
                                                    'medicalHistory') &&
                                                appointment['medicalHistory']
                                                    .isNotEmpty
                                            ? appointment['medicalHistory']
                                                .join('\n')
                                            : 'No medical history recorded',
                                        Icons.history_edu,
                                        Colors.purple,
                                      ),
                                      _buildPatientInfoCard(
                                        'Allergies',
                                        appointment.containsKey('allergies') &&
                                                appointment['allergies']
                                                    .isNotEmpty
                                            ? appointment['allergies']
                                                .join('\n')
                                            : 'No known allergies',
                                        Icons.warning_amber,
                                        Colors.red,
                                      ),
                                    ],
                                  ),
                                ),

                                // Past Visits Tab
                                SingleChildScrollView(
                                  controller: scrollController,
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Past Consultations',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Some sample past visits
                                      _buildDoctorPastVisitCard(
                                        'Mar 15, 2025',
                                        'Dr. Self',
                                        'Reason: Annual checkup',
                                        'Diagnosis: Healthy, no concerns',
                                        'Prescriptions: Vitamin D supplement',
                                      ),
                                      _buildDoctorPastVisitCard(
                                        'Jan 10, 2025',
                                        'Dr. Williams',
                                        'Reason: Fever and cough',
                                        'Diagnosis: Seasonal flu',
                                        'Prescriptions: Acetaminophen, cough syrup',
                                      ),
                                      _buildDoctorPastVisitCard(
                                        'Nov 5, 2024',
                                        'Dr. Self',
                                        'Reason: Follow-up',
                                        'Diagnosis: Improving condition',
                                        'Prescriptions: None',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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

  Widget _buildPatientInfoCard(
      String title, String content, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorPastVisitCard(String date, String doctor, String reason,
      String diagnosis, String prescriptions) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.doctorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  doctor,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.doctorColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            reason,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            diagnosis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            prescriptions,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _completeAppointment(Map<String, dynamic> appointment) {
    // Show a dialog to confirm completion and add notes
    Navigator.pop(context); // Close the current modal

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Complete Appointment',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Text(
                  'Patient: ${appointment['patientName']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 20),

                // Diagnosis field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Diagnosis',
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(height: 16),

                // Prescription field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Prescription',
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(height: 16),

                // Follow-up Notes field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Follow-up Notes',
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            appointment['status'] = 'Completed';
                          });

                          // Show confirmation
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Appointment completed successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.doctorColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Complete',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
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
  }

  void _showPrescriptionDetails(Map<String, dynamic> appointment) {
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
                                Icons.description_outlined,
                                color: Colors.blue,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Prescription',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
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
                          // Patient Details
                          _buildPrescriptionSection(
                            'Patient Details',
                            Icons.person_outline,
                            Colors.blue,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment['patientName'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${appointment['patientAge']} years, ${appointment['patientGender']}',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  appointment['patientContact'],
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Symptoms
                          _buildPrescriptionSection(
                            'Symptoms',
                            Icons.sick_outlined,
                            Colors.orange,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment['reason'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Diagnosis
                          _buildPrescriptionSection(
                            'Diagnosis',
                            Icons.medical_information_outlined,
                            Colors.red,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment['notes'] ??
                                      'No diagnosis provided',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Medications
                          _buildPrescriptionSection(
                            'Medications & Dosage',
                            Icons.medication_outlined,
                            Colors.green,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...(appointment['medications'] as List<dynamic>)
                                    .map((med) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Text(
                                            '• $med',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Tests & Recommendations
                          _buildPrescriptionSection(
                            'Tests & Recommendations',
                            Icons.science_outlined,
                            Colors.purple,
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '• Complete Blood Count (CBC)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '• Blood Pressure Monitoring',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Digital Signature
                          _buildPrescriptionSection(
                            'Doctor\'s Digital Signature',
                            Icons.draw_outlined,
                            Colors.blue,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Dr. Jennifer Warner',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Signed on ${DateFormat('MMM d, yyyy h:mm a').format(DateTime.now())}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Download Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Implement PDF download
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Downloading prescription as PDF...'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.download_outlined),
                              label: const Text('Download as PDF'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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

  Widget _buildPrescriptionSection(
    String title,
    IconData icon,
    Color color,
    Widget content,
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
          content,
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1, // Appointments tab is selected
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
        } else if (index == 2) {
          // Navigate to manage screen
          Navigator.push(
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
        }
        // Other navigation can be added here
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
}
