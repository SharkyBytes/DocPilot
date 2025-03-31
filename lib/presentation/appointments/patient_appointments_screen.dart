import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_button.dart';
import '../dashboard/patient_dashboard_screen.dart';
import '../prescriptions/patient_prescriptions_screen.dart';
import '../profile/patient_profile_screen.dart';
import '../notifications/patient_notifications_screen.dart';
import 'dart:math';

class PatientAppointmentsScreen extends StatefulWidget {
  const PatientAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<PatientAppointmentsScreen> createState() =>
      _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState extends State<PatientAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Today', 'Upcoming', 'Past'];
  int _selectedIndex = 1; // Schedule tab is selected by default
  String _selectedRescheduleTime = ''; // For rescheduling

  // Mock data for appointments
  final List<Map<String, dynamic>> _appointments = [
    {
      'id': '1',
      'doctorName': 'Dr. Warner',
      'doctorImage': 'assets/images/doctors/dc1.jpg',
      'specialty': 'Neurology',
      'date': DateTime.now().add(const Duration(days: 2)),
      'time': '10:00 AM',
      'duration': 30,
      'type': 'In-person',
      'status': 'Confirmed',
      'reason': 'Annual checkup',
      'location': 'Medical Center, Room 302',
    },
    {
      'id': '2',
      'doctorName': 'Dr. Ahmed',
      'doctorImage': 'assets/images/doctors/dc2.jpg',
      'specialty': 'Cardiology',
      'date': DateTime.now(),
      'time': '2:30 PM',
      'duration': 45,
      'type': 'Video',
      'status': 'Pending',
      'reason': 'Follow-up consultation',
      'location': 'Virtual Meeting Link',
    },
    {
      'id': '3',
      'doctorName': 'Dr. Martinez',
      'doctorImage': 'assets/images/doctors/dc3.jpg',
      'specialty': 'Dermatology',
      'date': DateTime.now().add(const Duration(days: 5)),
      'time': '9:15 AM',
      'duration': 30,
      'type': 'In-person',
      'status': 'Confirmed',
      'reason': 'Skin examination',
      'location': 'Dermatology Clinic, Suite 105',
    },
    {
      'id': '4',
      'doctorName': 'Dr. Warner',
      'doctorImage': 'assets/images/doctors/dc1.jpg',
      'specialty': 'Neurology',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'time': '11:30 AM',
      'duration': 60,
      'type': 'In-person',
      'status': 'Completed',
      'reason': 'Headache assessment',
      'location': 'Medical Center, Room 302',
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Appointments',
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.patientColor,
          labelColor: AppTheme.patientColor,
          unselectedLabelColor: AppTheme.secondaryTextColor,
          tabs: const [
            Tab(text: 'My Appointments'),
            Tab(text: 'Book Appointment'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentsTab(),
          _buildBookAppointmentTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              backgroundColor: AppTheme.patientColor,
              child: const Icon(Icons.add),
              onPressed: () {
                _tabController.animateTo(1);
              },
            )
          : null,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppointmentsTab() {
    return Column(
      children: [
        _buildCalendar(),
        _buildFilterChips(),
        Expanded(
          child: _buildAppointmentsList(),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2022, 1, 1),
        lastDay: DateTime.utc(2025, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        eventLoader: _getEventsForDay,
        calendarStyle: CalendarStyle(
          defaultTextStyle: const TextStyle(
            color: AppTheme.textColor,
            fontSize: 14,
          ),
          weekendTextStyle: const TextStyle(
            color: Colors.red,
            fontSize: 14,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppTheme.patientColor,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          todayDecoration: BoxDecoration(
            color: AppTheme.patientColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: AppTheme.patientColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          outsideTextStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          markerDecoration: const BoxDecoration(
            color: AppTheme.patientColor,
            shape: BoxShape.circle,
          ),
          markerSize: 5,
          markersMaxCount: 1,
          cellMargin: const EdgeInsets.all(4),
          cellPadding: const EdgeInsets.all(0),
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: true,
          formatButtonDecoration: BoxDecoration(
            color: AppTheme.patientColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          formatButtonTextStyle: const TextStyle(
            color: AppTheme.patientColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: AppTheme.patientColor,
            size: 28,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: AppTheme.patientColor,
            size: 28,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          weekendStyle: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final option = _filterOptions[index];
          final isSelected = option == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = option;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: AppTheme.patientColor.withOpacity(0.1),
              checkmarkColor: AppTheme.patientColor,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppTheme.patientColor
                    : AppTheme.secondaryTextColor,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppointmentsList() {
    final filteredAppointments = _filterAppointments();

    if (filteredAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 70,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No appointments found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Book a new appointment to get started',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _tabController.animateTo(1);
              },
              icon: const Icon(Icons.add),
              label: const Text('Book Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.patientColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        final appointment = filteredAppointments[index];
        return _buildAppointmentCard(appointment);
      },
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    final isToday = isSameDay(appointment['date'], DateTime.now());
    final isPast = appointment['date'].isBefore(DateTime.now()) &&
        !isSameDay(appointment['date'], DateTime.now());
    final statusColor = appointment['status'] == 'Confirmed'
        ? Colors.green
        : appointment['status'] == 'Pending'
            ? Colors.orange
            : appointment['status'] == 'Completed'
                ? Colors.blue
                : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showAppointmentDetails(appointment),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                appointment['status'],
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: appointment['type'] == 'Video'
                                    ? Colors.blue.withOpacity(0.1)
                                    : Colors.purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                appointment['type'],
                                style: TextStyle(
                                  color: appointment['type'] == 'Video'
                                      ? Colors.blue
                                      : Colors.purple,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isToday
                            ? 'Today'
                            : DateFormat('MMM d, yyyy')
                                .format(appointment['date']),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        appointment['time'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (value) =>
                        _handleAppointmentAction(value, appointment),
                    itemBuilder: (context) => [
                      if (appointment['status'] != 'Completed' &&
                          appointment['status'] != 'Cancelled')
                        const PopupMenuItem(
                          value: 'reschedule',
                          child: Row(
                            children: [
                              Icon(Icons.event_available, size: 20),
                              SizedBox(width: 8),
                              Text('Reschedule'),
                            ],
                          ),
                        ),
                      if (appointment['status'] != 'Completed' &&
                          appointment['status'] != 'Cancelled')
                        const PopupMenuItem(
                          value: 'cancel',
                          child: Row(
                            children: [
                              Icon(Icons.cancel_outlined, size: 20),
                              SizedBox(width: 8),
                              Text('Cancel'),
                            ],
                          ),
                        ),
                    ],
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _appointments.where((appointment) {
      final appointmentDate = appointment['date'] as DateTime;
      return isSameDay(appointmentDate, day);
    }).toList();
  }

  List<Map<String, dynamic>> _filterAppointments() {
    if (_selectedFilter == 'All') {
      if (_selectedDay != null) {
        return _appointments.where((appointment) {
          final appointmentDate = appointment['date'] as DateTime;
          return isSameDay(appointmentDate, _selectedDay!);
        }).toList();
      }
      return _appointments;
    } else if (_selectedFilter == 'Today') {
      return _appointments.where((appointment) {
        final appointmentDate = appointment['date'] as DateTime;
        return isSameDay(appointmentDate, DateTime.now());
      }).toList();
    } else if (_selectedFilter == 'Upcoming') {
      return _appointments.where((appointment) {
        final appointmentDate = appointment['date'] as DateTime;
        return appointmentDate
            .isAfter(DateTime.now().subtract(const Duration(days: 1)));
      }).toList();
    } else if (_selectedFilter == 'Past') {
      return _appointments.where((appointment) {
        final appointmentDate = appointment['date'] as DateTime;
        return appointmentDate.isBefore(DateTime.now()) &&
            !isSameDay(appointmentDate, DateTime.now());
      }).toList();
    }
    return _appointments;
  }

  void _handleAppointmentAction(
      String action, Map<String, dynamic> appointment) {
    if (action == 'details') {
      _showAppointmentDetails(appointment);
    } else if (action == 'reschedule') {
      _showRescheduleDialog(appointment);
    } else if (action == 'cancel') {
      _showCancelDialog(appointment);
    }
  }

  void _showAppointmentDetails(Map<String, dynamic> appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
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
            Container(
              padding: const EdgeInsets.all(16),
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
                      Icons.calendar_today,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Appointment Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              appointment['doctorImage'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment['doctorName'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppTheme.textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                appointment['specialty'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildDetailItem(
                      'Date & Time',
                      '${DateFormat('EEEE, MMMM d, yyyy').format(appointment['date'])} at ${appointment['time']}',
                      Icons.event_outlined,
                    ),
                    _buildDetailItem(
                      'Duration',
                      '${appointment['duration']} minutes',
                      Icons.timer_outlined,
                    ),
                    _buildDetailItem(
                      'Appointment Type',
                      appointment['type'],
                      appointment['type'] == 'Video'
                          ? Icons.videocam_outlined
                          : Icons.medical_services_outlined,
                    ),
                    _buildDetailItem(
                      'Status',
                      appointment['status'],
                      appointment['status'] == 'Confirmed'
                          ? Icons.check_circle_outline
                          : Icons.pending_outlined,
                      valueColor: appointment['status'] == 'Confirmed'
                          ? Colors.green
                          : Colors.orange,
                    ),
                    _buildDetailItem(
                      'Location',
                      appointment['location'],
                      Icons.location_on_outlined,
                    ),
                    _buildDetailItem(
                      'Reason for Visit',
                      appointment['reason'],
                      Icons.note_outlined,
                    ),
                    const SizedBox(height: 24),
                    if (appointment['status'] != 'Completed') ...[
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Reschedule',
                              icon: Icons.schedule,
                              type: ButtonType.outlined,
                              onPressed: () {
                                Navigator.pop(context);
                                _showRescheduleDialog(appointment);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              text: 'Cancel',
                              icon: Icons.cancel_outlined,
                              type: ButtonType.text,
                              onPressed: () {
                                Navigator.pop(context);
                                _showCancelDialog(appointment);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.patientColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppTheme.patientColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? AppTheme.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRescheduleDialog(Map<String, dynamic> appointment) {
    DateTime selectedDate = appointment['date'];
    _selectedRescheduleTime = appointment['time'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.patientColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.event_available,
                                color: AppTheme.patientColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Reschedule Appointment',
                              style: TextStyle(
                                fontSize: 18,
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

                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select New Date',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Calendar for date selection
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: TableCalendar(
                                firstDay: DateTime.now(),
                                lastDay: DateTime.now()
                                    .add(const Duration(days: 60)),
                                focusedDay: selectedDate,
                                calendarFormat: CalendarFormat.twoWeeks,
                                selectedDayPredicate: (day) {
                                  return isSameDay(selectedDate, day);
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  setModalState(() {
                                    selectedDate = selectedDay;
                                  });
                                },
                                calendarStyle: CalendarStyle(
                                  defaultTextStyle: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  weekendTextStyle: TextStyle(
                                    color: Colors.red[400],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  selectedDecoration: const BoxDecoration(
                                    color: AppTheme.patientColor,
                                    shape: BoxShape.circle,
                                  ),
                                  selectedTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  todayDecoration: BoxDecoration(
                                    color:
                                        AppTheme.patientColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  todayTextStyle: const TextStyle(
                                    color: AppTheme.patientColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  outsideTextStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 16,
                                  ),
                                ),
                                headerStyle: HeaderStyle(
                                  titleTextStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                  formatButtonVisible: false,
                                  leftChevronIcon: Icon(
                                    Icons.chevron_left,
                                    color: Colors.grey[800],
                                  ),
                                  rightChevronIcon: Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            Text(
                              'Select New Time',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Time slot selection
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      _selectedRescheduleTime = '9:00 AM';
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                      color:
                                          _selectedRescheduleTime == '9:00 AM'
                                              ? AppTheme.patientColor
                                              : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '9:00 AM',
                                      style: TextStyle(
                                        color:
                                            _selectedRescheduleTime == '9:00 AM'
                                                ? Colors.white
                                                : Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      _selectedRescheduleTime = '10:00 AM';
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                      color:
                                          _selectedRescheduleTime == '10:00 AM'
                                              ? AppTheme.patientColor
                                              : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '10:00 AM',
                                      style: TextStyle(
                                        color: _selectedRescheduleTime ==
                                                '10:00 AM'
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      _selectedRescheduleTime = '11:00 AM';
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                      color:
                                          _selectedRescheduleTime == '11:00 AM'
                                              ? AppTheme.patientColor
                                              : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '11:00 AM',
                                      style: TextStyle(
                                        color: _selectedRescheduleTime ==
                                                '11:00 AM'
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      _selectedRescheduleTime = '1:00 PM';
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                      color:
                                          _selectedRescheduleTime == '1:00 PM'
                                              ? AppTheme.patientColor
                                              : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '1:00 PM',
                                      style: TextStyle(
                                        color:
                                            _selectedRescheduleTime == '1:00 PM'
                                                ? Colors.white
                                                : Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      _selectedRescheduleTime = '2:00 PM';
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                      color:
                                          _selectedRescheduleTime == '2:00 PM'
                                              ? AppTheme.patientColor
                                              : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '2:00 PM',
                                      style: TextStyle(
                                        color:
                                            _selectedRescheduleTime == '2:00 PM'
                                                ? Colors.white
                                                : Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      _selectedRescheduleTime = '3:00 PM';
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                      color:
                                          _selectedRescheduleTime == '3:00 PM'
                                              ? AppTheme.patientColor
                                              : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '3:00 PM',
                                      style: TextStyle(
                                        color:
                                            _selectedRescheduleTime == '3:00 PM'
                                                ? Colors.white
                                                : Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      _selectedRescheduleTime = '4:00 PM';
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                      color:
                                          _selectedRescheduleTime == '4:00 PM'
                                              ? AppTheme.patientColor
                                              : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '4:00 PM',
                                      style: TextStyle(
                                        color:
                                            _selectedRescheduleTime == '4:00 PM'
                                                ? Colors.white
                                                : Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Confirm button
                            SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                text: 'Confirm Reschedule',
                                icon: Icons.check_circle_outline,
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    appointment['date'] = selectedDate;
                                    appointment['time'] =
                                        _selectedRescheduleTime;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Appointment rescheduled successfully'),
                                      backgroundColor: AppTheme.patientColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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

  void _showCancelDialog(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text(
            'Are you sure you want to cancel this appointment? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Keep It'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, you would make an API call here
              setState(() {
                // Remove from the list for demo purposes
                _appointments.removeWhere((a) => a['id'] == appointment['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Appointment has been cancelled'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Yes, Cancel'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // Book Appointment Tab
  Widget _buildBookAppointmentTab() {
    // Define list of specialties for the filter
    final specialties = [
      {'title': 'All', 'icon': Icons.medical_services},
      {'title': 'Neurologist', 'icon': Icons.psychology},
      {'title': 'Cardiologist', 'icon': Icons.favorite},
      {'title': 'Dermatologist', 'icon': Icons.face},
      {'title': 'Orthopedic', 'icon': Icons.accessibility_new},
      {'title': 'Pediatrician', 'icon': Icons.child_care},
      {'title': 'Ophthalmologist', 'icon': Icons.remove_red_eye},
    ];

    // Available doctors (same as before)
    final availableDoctors = [
      {
        'id': 'd1',
        'name': 'Dr. Jennifer Warner',
        'specialty': 'Cardiologist',
        'rating': '4.9',
        'experience': '15 years',
        'image': 'assets/images/doctors/dc1.jpg',
        'bio':
            'Dr. Warner is a highly experienced cardiologist specializing in preventive cardiology and heart health management. She has performed over 500 successful cardiac procedures.',
        'availability': [
          {
            'day': 'Monday',
            'slots': ['9:00 AM', '10:00 AM', '11:00 AM', '2:00 PM', '3:00 PM']
          },
          {
            'day': 'Wednesday',
            'slots': ['10:00 AM', '11:00 AM', '1:00 PM', '2:00 PM', '4:00 PM']
          },
          {
            'day': 'Friday',
            'slots': ['9:00 AM', '10:00 AM', '11:00 AM', '1:00 PM', '3:00 PM']
          }
        ]
      },
      {
        'id': 'd2',
        'name': 'Dr. John Smith',
        'specialty': 'Neurologist',
        'rating': '4.7',
        'experience': '8 years',
        'image': 'assets/images/doctors/dc2.jpg',
        'bio':
            'Dr. Smith is a skilled neurologist specializing in the diagnosis and treatment of conditions affecting the brain and nervous system. He has particular interest in headaches, epilepsy, and movement disorders.',
        'availability': [
          {
            'day': 'Tuesday',
            'slots': ['9:00 AM', '10:00 AM', '11:00 AM', '2:00 PM', '3:00 PM']
          },
          {
            'day': 'Thursday',
            'slots': ['10:00 AM', '11:00 AM', '1:00 PM', '2:00 PM', '4:00 PM']
          }
        ]
      },
      {
        'id': 'd3',
        'name': 'Dr. Sarah Wilson',
        'specialty': 'Dermatologist',
        'rating': '4.8',
        'experience': '12 years',
        'image': 'assets/images/doctors/dc3.jpg',
        'bio':
            'Dr. Wilson is a leading dermatologist with expertise in both medical and cosmetic dermatology. She specializes in skin cancer, acne treatment, and various skin conditions affecting patients of all ages.',
        'availability': [
          {
            'day': 'Monday',
            'slots': ['9:00 AM', '11:00 AM', '2:00 PM', '4:00 PM']
          },
          {
            'day': 'Wednesday',
            'slots': ['10:00 AM', '1:00 PM', '3:00 PM']
          },
          {
            'day': 'Friday',
            'slots': ['9:00 AM', '11:00 AM', '2:00 PM']
          }
        ]
      },
      {
        'id': 'd4',
        'name': 'Dr. Michael Chen',
        'specialty': 'Orthopedic',
        'rating': '4.7',
        'experience': '10 years',
        'image': 'assets/images/doctors/dc1.jpg',
        'bio':
            'Dr. Chen specializes in orthopedic surgery with a focus on sports injuries and joint replacements. He uses the latest minimally invasive techniques for faster recovery times.',
        'availability': [
          {
            'day': 'Tuesday',
            'slots': ['9:00 AM', '11:00 AM', '2:00 PM']
          },
          {
            'day': 'Thursday',
            'slots': ['10:00 AM', '1:00 PM', '3:00 PM']
          }
        ]
      },
      {
        'id': 'd5',
        'name': 'Dr. Emily Rodriguez',
        'specialty': 'Pediatrician',
        'rating': '4.9',
        'experience': '14 years',
        'image': 'assets/images/doctors/dc2.jpg',
        'bio':
            'Dr. Rodriguez is a compassionate pediatrician dedicated to child wellness from infancy through adolescence. She has expertise in developmental disorders and childhood nutrition.',
        'availability': [
          {
            'day': 'Monday',
            'slots': ['9:00 AM', '10:00 AM', '11:00 AM', '2:00 PM']
          },
          {
            'day': 'Wednesday',
            'slots': ['10:00 AM', '1:00 PM', '2:00 PM']
          },
          {
            'day': 'Friday',
            'slots': ['9:00 AM', '10:00 AM', '2:00 PM']
          }
        ]
      },
    ];

    // State variables for search and filtering
    String searchQuery = '';
    String selectedSpecialty = 'All';

    // Filter doctors based on search query and selected specialty
    List<Map<String, dynamic>> filteredDoctors =
        availableDoctors.where((doctor) {
      final nameMatches = doctor['name']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      final specialtyMatches = selectedSpecialty == 'All' ||
          doctor['specialty'] == selectedSpecialty;
      return nameMatches && specialtyMatches;
    }).toList();

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                      filteredDoctors = availableDoctors.where((doctor) {
                        final nameMatches = doctor['name']
                            .toString()
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase());
                        final specialtyMatches = selectedSpecialty == 'All' ||
                            doctor['specialty'] == selectedSpecialty;
                        return nameMatches && specialtyMatches;
                      }).toList();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search doctors...',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Specialty Filter
              Text(
                'Filter by Specialty',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.textColor,
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: specialties.length,
                  itemBuilder: (context, index) {
                    final specialty = specialties[index];
                    final isSelected = selectedSpecialty == specialty['title'];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSpecialty = specialty['title'] as String;
                          filteredDoctors = availableDoctors.where((doctor) {
                            final nameMatches = doctor['name']
                                .toString()
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase());
                            final specialtyMatches =
                                selectedSpecialty == 'All' ||
                                    doctor['specialty'] == selectedSpecialty;
                            return nameMatches && specialtyMatches;
                          }).toList();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? AppTheme.patientColor : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              specialty['icon'] as IconData,
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.patientColor,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              specialty['title'] as String,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Available Doctors',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.textColor,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                '${filteredDoctors.length} doctor${filteredDoctors.length != 1 ? 's' : ''} found',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 16),

              // Doctor Cards
              Expanded(
                child: filteredDoctors.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No doctors found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your search or filters',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredDoctors.length,
                        itemBuilder: (context, index) {
                          final doctor = filteredDoctors[index];
                          return _buildUpdatedDoctorCard(doctor);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUpdatedDoctorCard(Map<String, dynamic> doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showBookingModal(doctor),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Doctor image
                Hero(
                  tag: 'doctor-${doctor['id']}',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        doctor['image'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Doctor details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        doctor['name'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Specialty
                      Text(
                        doctor['specialty'] as String,
                        style: TextStyle(
                          color: AppTheme.patientColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Rating and Experience
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                doctor['rating'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppTheme.textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Text(
                            doctor['experience'] as String,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Book button
                ElevatedButton(
                  onPressed: () => _showBookingModal(doctor),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Book',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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

  void _showBookingModal(Map<String, dynamic> doctor) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    String selectedTimeSlot = '';
    String reasonForVisit = '';
    String selectedPeriod = 'Morning';

    final List<String> periods = ['Morning', 'Afternoon', 'Evening'];

    // Helper function to get time slots for selected date
    List<String> getAvailableSlots(DateTime date) {
      final weekday = DateFormat('EEEE').format(date);
      final availability = (doctor['availability'] as List<dynamic>).firstWhere(
        (slot) => (slot as Map<String, dynamic>)['day'] == weekday,
        orElse: () => {'day': '', 'slots': []},
      ) as Map<String, dynamic>;

      if (availability['slots'] == null) return [];

      // Filter slots based on selected period
      final slots = (availability['slots'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
      return slots.where((slot) {
        final hour = int.parse(slot.split(':')[0]);
        if (selectedPeriod == 'Morning') return hour < 12;
        if (selectedPeriod == 'Afternoon') return hour >= 12 && hour < 17;
        return hour >= 17;
      }).toList();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final availableSlots = getAvailableSlots(selectedDate);

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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            doctor['image'] as String,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor['name'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppTheme.textColor,
                                ),
                              ),
                              Text(
                                doctor['specialty'] as String,
                                style: TextStyle(
                                  color: AppTheme.patientColor,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    doctor['rating'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
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

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Doctor Bio
                          const Text(
                            'Doctor Biography',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            doctor['bio'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Schedule section
                          const Text(
                            'Schedule',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Date picker
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 7, // Show a week of dates
                              itemBuilder: (context, index) {
                                final date = DateTime.now()
                                    .add(Duration(days: index + 1));
                                final isSelected =
                                    DateUtils.isSameDay(date, selectedDate);

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedDate = date;
                                      selectedTimeSlot = '';
                                    });
                                  },
                                  child: Container(
                                    width: 60,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme.patientColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.patientColor
                                            : Colors.grey.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat('E').format(date),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat('d').format(date),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? Colors.white
                                                : AppTheme.textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Time slot selector
                          const Text(
                            'Choose Time',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Period selector (Morning, Afternoon, Evening)
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: periods.length,
                              itemBuilder: (context, index) {
                                final period = periods[index];
                                final isSelected = period == selectedPeriod;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedPeriod = period;
                                      selectedTimeSlot = '';
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme.patientColor
                                              .withOpacity(0.1)
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.patientColor
                                            : Colors.grey[300]!,
                                        width: 1,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      period,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? AppTheme.patientColor
                                            : Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Available time slots
                          if (availableSlots.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'No available slots for the selected date and time period',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          else
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: availableSlots.map((slot) {
                                final isSelected = slot == selectedTimeSlot;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedTimeSlot = slot;
                                    });
                                  },
                                  child: Container(
                                    width: 80,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme.patientColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.patientColor
                                            : Colors.grey[300]!,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      slot,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                          const SizedBox(height: 24),

                          // Reason for visit
                          const Text(
                            'Reason for Visit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            onChanged: (value) {
                              reasonForVisit = value;
                            },
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText:
                                  'Briefly describe your symptoms or reason for consultation',
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
                        ],
                      ),
                    ),
                  ),

                  // Bottom booking button
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
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: selectedTimeSlot.isEmpty
                            ? null
                            : () => _confirmAppointment(context, doctor,
                                selectedDate, selectedTimeSlot, reasonForVisit),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.patientColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey[500],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Book Appointment (\$50.00)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  void _confirmAppointment(BuildContext context, Map<String, dynamic> doctor,
      DateTime date, String timeSlot, String reason) {
    // Create a mock appointment object
    final appointment = {
      'id': 'a${DateTime.now().millisecondsSinceEpoch}',
      'doctorId': doctor['id'],
      'doctorName': doctor['name'],
      'doctorImage': doctor['image'],
      'specialty': doctor['specialty'],
      'date': date,
      'time': timeSlot,
      'duration': 30,
      'type': 'In-person',
      'status': 'Pending',
      'reason': reason.isNotEmpty ? reason : 'General consultation',
      'location': 'Medical Center, Suite ${100 + Random().nextInt(900)}',
    };

    // Add to the appointments list
    setState(() {
      _appointments.add(appointment);
    });

    // Close booking modal
    Navigator.pop(context);

    // Show success dialog with improved UI
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
            children: [
              // Success icon with gradient background
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green[300]!,
                      Colors.green[600]!,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              // Title
              const Text(
                'Appointment Requested',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 16),
              // Doctor name
              Text(
                'Dr. ${doctor['name'].split(' ')[1]}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.patientColor,
                ),
              ),
              const SizedBox(height: 8),
              // Specialty
              Text(
                doctor['specialty'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              // Appointment details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildConfirmationDetailRow(
                      Icons.calendar_today,
                      'Date',
                      DateFormat('EEEE, MMMM d, yyyy').format(date),
                    ),
                    const SizedBox(height: 12),
                    _buildConfirmationDetailRow(
                      Icons.access_time,
                      'Time',
                      timeSlot,
                    ),
                    const SizedBox(height: 12),
                    _buildConfirmationDetailRow(
                      Icons.attach_money,
                      'Consultation Fee',
                      '\$50.00',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Message
              Text(
                'You will receive a notification once the doctor confirms your appointment.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _tabController.animateTo(0);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'View Appointments',
                        style: TextStyle(
                          color: AppTheme.patientColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.patientColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationDetailRow(
      IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.patientColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.patientColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
          ],
        ),
      ],
    );
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
            currentIndex: 0,
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
}
