import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../dashboard/doctor_dashboard_screen.dart';
import '../appointments/doctor_appointments_screen.dart';
import '../manage/doctor_manage_screen.dart';
import '../profile/doctor_profile_screen.dart';

class DoctorMessagesScreen extends StatefulWidget {
  const DoctorMessagesScreen({Key? key}) : super(key: key);

  @override
  State<DoctorMessagesScreen> createState() => _DoctorMessagesScreenState();
}

class _DoctorMessagesScreenState extends State<DoctorMessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data for notifications
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'New Appointment',
      'content':
          'John Smith booked an appointment for June 15, 2025 at 10:30 AM.',
      'time': '10 mins ago',
      'isRead': false,
      'type': 'appointment_new',
      'patientId': '101',
      'patientName': 'John Smith',
      'patientImage': 'images/patients/p1.jpg',
    },
    {
      'id': '2',
      'title': 'Rescheduled Appointment',
      'content':
          'Emily Johnson rescheduled her appointment from June 12 to June 14, 2025.',
      'time': '2 hours ago',
      'isRead': false,
      'type': 'appointment_reschedule',
      'patientId': '102',
      'patientName': 'Emily Johnson',
      'patientImage': 'images/patients/p2.jpg',
    },
    {
      'id': '3',
      'title': 'New Lab Results',
      'content':
          'New lab results are available for Michael Brown. Blood work and urine analysis completed.',
      'time': '5 hours ago',
      'isRead': true,
      'type': 'lab_results',
      'patientId': '103',
      'patientName': 'Michael Brown',
      'patientImage': 'images/patients/p3.jpg',
    },
    {
      'id': '4',
      'title': 'Prescription Reminder',
      'content':
          'Please approve the pending prescription for Sarah Davis by end of day.',
      'time': '8 hours ago',
      'isRead': true,
      'type': 'prescription',
      'patientId': '104',
      'patientName': 'Sarah Davis',
      'patientImage': 'images/patients/p4.jpg',
    },
    {
      'id': '5',
      'title': 'Appointment Cancelled',
      'content':
          'Robert Wilson cancelled his appointment scheduled for tomorrow at 2:00 PM.',
      'time': 'Yesterday',
      'isRead': true,
      'type': 'appointment_cancel',
      'patientId': '105',
      'patientName': 'Robert Wilson',
      'patientImage': 'images/patients/p5.jpg',
    },
    {
      'id': '6',
      'title': 'Payment Received',
      'content':
          'You received a payment of \$150 from John Smith for the consultation on June 8.',
      'time': 'Yesterday',
      'isRead': true,
      'type': 'payment',
      'patientId': '101',
      'patientName': 'John Smith',
      'patientImage': 'images/patients/p1.jpg',
    },
    {
      'id': '7',
      'title': 'Staff Message',
      'content':
          'Dr. Williams has invited you to join the weekly team meeting on Friday at 9:00 AM.',
      'time': '2 days ago',
      'isRead': true,
      'type': 'staff',
      'staffId': '201',
      'staffName': 'Dr. Williams',
      'staffImage': 'images/doctors/dc2.jpg',
    },
  ];

  final List<Map<String, dynamic>> _chats = [
    {
      'id': '101',
      'name': 'John Smith',
      'image': 'images/patients/p1.jpg',
      'lastMessage':
          'Thank you doctor, I\'ll take the medications as prescribed.',
      'time': '10:45 AM',
      'unread': 0,
      'online': true,
    },
    {
      'id': '102',
      'name': 'Emily Johnson',
      'image': 'images/patients/p2.jpg',
      'lastMessage': 'Is it okay if I take the medicine after food?',
      'time': 'Yesterday',
      'unread': 2,
      'online': false,
    },
    {
      'id': '103',
      'name': 'Michael Brown',
      'image': 'images/patients/p3.jpg',
      'lastMessage': 'I\'m feeling much better now. Thank you!',
      'time': 'Yesterday',
      'unread': 0,
      'online': true,
    },
    {
      'id': '104',
      'name': 'Sarah Davis',
      'image': 'images/patients/p4.jpg',
      'lastMessage': 'Just sent you my latest symptoms report.',
      'time': 'Jun 10',
      'unread': 0,
      'online': false,
    },
    {
      'id': '201',
      'name': 'Dr. Williams',
      'image': 'images/doctors/dc2.jpg',
      'lastMessage': 'Can we discuss the new treatment protocol?',
      'time': 'Jun 9',
      'unread': 0,
      'online': false,
    },
  ];

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
          'Messages',
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.doctorColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.doctorColor,
          tabs: const [
            Tab(text: 'Notifications'),
            Tab(text: 'Chats'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.textColor),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppTheme.textColor),
            onPressed: () {
              // Implement filter functionality
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Notifications Tab
          _buildNotificationsTab(),

          // Chats Tab
          _buildChatsTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildNotificationsTab() {
    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
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
      padding: const EdgeInsets.all(12),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final IconData iconData;
    final Color iconColor;

    // Set icon and color based on notification type
    switch (notification['type']) {
      case 'appointment_new':
        iconData = Icons.calendar_month;
        iconColor = Colors.green;
        break;
      case 'appointment_reschedule':
        iconData = Icons.calendar_today;
        iconColor = Colors.orange;
        break;
      case 'appointment_cancel':
        iconData = Icons.event_busy;
        iconColor = Colors.red;
        break;
      case 'lab_results':
        iconData = Icons.science_outlined;
        iconColor = Colors.purple;
        break;
      case 'prescription':
        iconData = Icons.medication_outlined;
        iconColor = Colors.blue;
        break;
      case 'payment':
        iconData = Icons.payment;
        iconColor = Colors.green;
        break;
      case 'staff':
        iconData = Icons.people_outline;
        iconColor = Colors.indigo;
        break;
      default:
        iconData = Icons.notifications_none;
        iconColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        border: notification['isRead'] == false
            ? Border.all(
                color: AppTheme.doctorColor.withOpacity(0.3),
                width: 1.5,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Mark as read and handle notification tap
            setState(() {
              notification['isRead'] = true;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User image or icon
                (notification.containsKey('patientImage') ||
                        notification.containsKey('staffImage'))
                    ? CircleAvatar(
                        radius: 24,
                        backgroundColor: iconColor.withOpacity(0.2),
                        backgroundImage: AssetImage(
                          notification['patientImage'] ??
                              notification['staffImage'],
                        ),
                        onBackgroundImageError: (_, __) {},
                      )
                    : Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          iconData,
                          color: iconColor,
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
                              notification['title'],
                              style: TextStyle(
                                fontWeight: notification['isRead'] == false
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                fontSize: 16,
                                color: AppTheme.textColor,
                              ),
                            ),
                          ),
                          if (notification['isRead'] == false)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppTheme.doctorColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notification['content'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: notification['isRead'] == false
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notification['time'],
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            onSelected: (value) {
                              if (value == 'delete') {
                                setState(() {
                                  _notifications.remove(notification);
                                });
                              } else if (value == 'mark') {
                                setState(() {
                                  notification['isRead'] =
                                      !notification['isRead'];
                                });
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'mark',
                                child: Text(
                                  notification['isRead'] == false
                                      ? 'Mark as read'
                                      : 'Mark as unread',
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
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

  Widget _buildChatsTab() {
    if (_chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No conversations yet',
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
      padding: const EdgeInsets.all(12),
      itemCount: _chats.length,
      itemBuilder: (context, index) {
        final chat = _chats[index];
        return _buildChatCard(chat);
      },
    );
  }

  Widget _buildChatCard(Map<String, dynamic> chat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          onTap: () {
            // Navigate to chat screen
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // User avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(chat['image']),
                      onBackgroundImageError: (_, __) {},
                    ),
                    if (chat['online'] == true)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),

                // Chat details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            chat['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppTheme.textColor,
                            ),
                          ),
                          Text(
                            chat['time'],
                            style: TextStyle(
                              fontSize: 12,
                              color: chat['unread'] > 0
                                  ? AppTheme.doctorColor
                                  : Colors.grey[500],
                              fontWeight: chat['unread'] > 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat['lastMessage'],
                              style: TextStyle(
                                fontSize: 14,
                                color: chat['unread'] > 0
                                    ? Colors.black87
                                    : Colors.grey[600],
                                fontWeight: chat['unread'] > 0
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (chat['unread'] > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppTheme.doctorColor,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                chat['unread'].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
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
    return BottomNavigationBar(
      currentIndex: 3, // Messages tab is selected
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
          // Current page - do nothing
        } else if (index == 4) {
          // Navigate to profile screen
          Navigator.pushReplacement(
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
}
