import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../dashboard/patient_dashboard_screen.dart';
import '../appointments/patient_appointments_screen.dart';
import '../profile/patient_profile_screen.dart';
import '../prescriptions/patient_prescriptions_screen.dart';

class PatientNotificationsScreen extends StatefulWidget {
  const PatientNotificationsScreen({Key? key}) : super(key: key);

  @override
  State<PatientNotificationsScreen> createState() =>
      _PatientNotificationsScreenState();
}

class _PatientNotificationsScreenState
    extends State<PatientNotificationsScreen> {
  int _selectedIndex = 3; // Notifications tab is selected by default

  // Mock data for notifications
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'type': 'appointment_accepted',
      'title': 'Appointment Confirmed',
      'message':
          'Your appointment with Dr. Jennifer Warner on June 15, 2024 at 10:30 AM has been confirmed.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': false,
      'iconData': Icons.check_circle,
      'iconColor': Colors.green,
      'actionText': 'View Details',
      'actionRoute': '/appointments',
    },
    {
      'id': '2',
      'type': 'appointment_reminder',
      'title': 'Upcoming Appointment',
      'message':
          'Your appointment with Dr. Mark Smith is in 30 minutes. Check your email for the link.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'isRead': true,
      'iconData': Icons.access_time,
      'iconColor': Colors.orange,
      'actionText': 'Join Now',
      'actionRoute': '/appointments',
    },
    {
      'id': '3',
      'type': 'appointment_declined',
      'title': 'Appointment Rescheduled',
      'message':
          'Your appointment with Dr. Sarah Wilson has been rescheduled. Please check the new time.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': false,
      'iconData': Icons.event_busy,
      'iconColor': Colors.red,
      'actionText': 'Reschedule',
      'actionRoute': '/appointments',
    },
    {
      'id': '4',
      'type': 'prescription_ready',
      'title': 'New Prescription Available',
      'message':
          'Dr. Warner has prescribed new medication. View details in the Prescriptions tab.',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'isRead': true,
      'iconData': Icons.medication,
      'iconColor': Colors.blue,
      'actionText': 'View Prescription',
      'actionRoute': '/prescriptions',
    },
    {
      'id': '5',
      'type': 'lab_results',
      'title': 'Lab Results Available',
      'message':
          'Your recent lab results are now available. Please review them at your earliest convenience.',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'isRead': false,
      'iconData': Icons.science,
      'iconColor': Colors.purple,
      'actionText': 'View Results',
      'actionRoute': '/profile',
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
          'Notifications',
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                for (var notification in _notifications) {
                  notification['isRead'] = true;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications marked as read'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.done_all, size: 18),
            label: const Text('Mark all as read'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.patientColor,
            ),
          ),
        ],
      ),
      body: _buildNotificationsBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildNotificationsBody() {
    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 70,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'ll receive notifications about your appointments and prescriptions here',
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
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    // Format the timestamp
    final timestamp = notification['timestamp'] as DateTime;
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    String timeText;
    if (difference.inMinutes < 60) {
      timeText = '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      timeText =
          '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      timeText =
          '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification['isRead'] as bool ? Colors.white : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notification['isRead'] as bool
              ? Colors.transparent
              : AppTheme.patientColor.withOpacity(0.3),
          width: notification['isRead'] as bool ? 0 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Mark as read when tapped
            setState(() {
              notification['isRead'] = true;
            });

            // Handle navigation based on notification type
            final route = notification['actionRoute'] as String;
            if (route == '/appointments') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PatientAppointmentsScreen(),
                ),
              );
            } else if (route == '/prescriptions') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PatientPrescriptionsScreen(),
                ),
              );
            } else if (route == '/profile') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PatientProfileScreen(),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status indicator and icon
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        (notification['iconColor'] as Color).withOpacity(0.1),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    notification['iconData'] as IconData,
                    color: notification['iconColor'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Notification content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'] as String,
                              style: TextStyle(
                                fontWeight: notification['isRead'] as bool
                                    ? FontWeight.w600
                                    : FontWeight.bold,
                                fontSize: 16,
                                color: AppTheme.textColor,
                              ),
                            ),
                          ),
                          if (!notification['isRead'] as bool)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppTheme.patientColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification['message'] as String,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            timeText,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle navigation based on notification type
                              final route =
                                  notification['actionRoute'] as String;
                              if (route == '/appointments') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PatientAppointmentsScreen(),
                                  ),
                                );
                              } else if (route == '/prescriptions') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PatientPrescriptionsScreen(),
                                  ),
                                );
                              } else if (route == '/profile') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PatientProfileScreen(),
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.patientColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              notification['actionText'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
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
          ),
        ),
      ),
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
            currentIndex: 3,
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
