import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/user_type.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/auth_provider.dart';
import '../dashboard/dashboard_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String name;
  final String? email;
  final bool isPatient;

  const OTPVerificationScreen({
    Key? key,
    required this.phoneNumber,
    required this.name,
    this.email,
    required this.isPatient,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isResendingOTP = false;
  int _otpResendTimer = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _otpResendTimer = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpResendTimer > 0) {
        setState(() {
          _otpResendTimer--;
        });
      } else {
        timer.cancel();
      }
    });
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
          'Verify Phone Number',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(),
                  const SizedBox(height: 40),
                  _buildOtpSection(),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'VERIFY & CONTINUE',
                    isLoading: _isLoading,
                    onPressed: _verifyOTP,
                  ),
                  const SizedBox(height: 20),
                  _buildResendSection(),
                  const SizedBox(height: 40),
                  _buildDecoration(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OTP Verification',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: widget.isPatient
                    ? AppTheme.patientColor
                    : AppTheme.doctorColor,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'We have sent a verification code to ${_formatPhoneNumber(widget.phoneNumber)}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.secondaryTextColor,
              ),
        ),
      ],
    );
  }

  Widget _buildOtpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter 4-digit code',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            4,
            (index) => _buildOtpDigitField(index),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpDigitField(int index) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color:
              widget.isPatient ? AppTheme.patientColor : AppTheme.doctorColor,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty) {
            _updateOtpValue();

            // Move to next field if available
            if (index < 3) {
              _focusNodes[index + 1].requestFocus();
            } else {
              _focusNodes[index].unfocus();
            }
          } else if (value.isEmpty && index > 0) {
            // Move to previous field if current is empty (backspace)
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  void _updateOtpValue() {
    _otpController.text = _controllers.map((c) => c.text).join();
  }

  Widget _buildResendSection() {
    final color =
        widget.isPatient ? AppTheme.patientColor : AppTheme.doctorColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Didn\'t receive the code? ',
          style: TextStyle(
            color: AppTheme.secondaryTextColor,
          ),
        ),
        GestureDetector(
          onTap: _otpResendTimer > 0 || _isResendingOTP ? null : _resendOTP,
          child: Text(
            _otpResendTimer > 0
                ? 'Resend in $_otpResendTimer s'
                : _isResendingOTP
                    ? 'Sending...'
                    : 'Resend',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _otpResendTimer > 0 || _isResendingOTP
                  ? AppTheme.secondaryTextColor
                  : color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDecoration() {
    final color =
        widget.isPatient ? AppTheme.patientColor : AppTheme.doctorColor;
    final icon = widget.isPatient
        ? Icons.health_and_safety
        : Icons.medical_services_outlined;
    final title =
        widget.isPatient ? 'Patient Verification' : 'Doctor Verification';

    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -10,
            left: -10,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'One last step to complete your registration',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPhoneNumber(String phone) {
    if (phone.length != 10) return phone;
    return '+1 (${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';
  }

  void _resendOTP() async {
    setState(() {
      _isResendingOTP = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isResendingOTP = false;
      _startResendTimer();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('OTP resent successfully'),
          backgroundColor:
              widget.isPatient ? AppTheme.patientColor : AppTheme.doctorColor,
        ),
      );
    }
  }

  void _verifyOTP() async {
    // Check if all digits are filled
    if (_otpController.text.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all 4 digits'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Set user information in provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (widget.isPatient) {
      authProvider.setUserType(UserType.patient);
      // For patient we use phone number as login
      authProvider.setPhone(widget.phoneNumber);
    } else {
      authProvider.setUserType(UserType.doctor);
      // For doctor we use email
      authProvider.setEmail(widget.email ?? '');
    }

    // Set name for both user types
    authProvider.setName(widget.name);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Navigate to dashboard
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
        (route) => false,
      );
    }
  }
}
