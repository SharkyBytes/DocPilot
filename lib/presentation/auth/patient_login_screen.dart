import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/user_type.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';
import 'signup_screen.dart';
import '../dashboard/dashboard_screen.dart';
import 'patient_signup_screen.dart';
import 'user_role_selection_screen.dart';

class PatientLoginScreen extends StatefulWidget {
  const PatientLoginScreen({Key? key}) : super(key: key);

  @override
  State<PatientLoginScreen> createState() => _PatientLoginScreenState();
}

class _PatientLoginScreenState extends State<PatientLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isOtpSent = false;
  bool _isLoading = false;
  bool _isResendingOTP = false;
  int _otpResendTimer = 0;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
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
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const UserRoleSelectionScreen()),
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
                  const SizedBox(height: 40),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _isOtpSent ? _buildOtpSection() : _buildPhoneSection(),
                  const SizedBox(height: 30),
                  _buildActionButton(),
                  const SizedBox(height: 20),
                  _buildSignupPrompt(),
                  const SizedBox(height: 40),
                  _buildWaveDecoration(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sign In',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          _isOtpSent
              ? 'Please enter your verification code to proceed'
              : 'Enter your phone number to receive a verification code',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.secondaryTextColor,
              ),
        ),
      ],
    );
  }

  Widget _buildPhoneSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _phoneController,
          hint: 'Enter your phone number',
          keyboardType: TextInputType.phone,
          prefix: const Icon(Icons.phone_android, size: 22),
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
      ],
    );
  }

  Widget _buildOtpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Verification Code',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textColor,
                  ),
            ),
            GestureDetector(
              onTap: _otpResendTimer > 0 ? null : _resendOTP,
              child: Text(
                _otpResendTimer > 0
                    ? 'Resend in $_otpResendTimer s'
                    : 'Resend OTP',
                style: TextStyle(
                  color: _otpResendTimer > 0
                      ? AppTheme.secondaryTextColor
                      : AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // OTP Input Field
        Row(
          children: [
            for (int i = 0; i < 4; i++) _buildOtpDigitField(i),
          ],
        ),

        const SizedBox(height: 12),
        Text(
          'We sent the code to ${_formatPhoneNumber(_phoneController.text)}',
          style: TextStyle(
            color: AppTheme.secondaryTextColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpDigitField(int index) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: TextField(
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          onChanged: (value) {
            // Move to next field when filled
            if (value.isNotEmpty) {
              // Add to OTP
              String currentOtp = _otpController.text;
              if (index >= currentOtp.length) {
                _otpController.text = currentOtp + value;
              } else {
                _otpController.text = currentOtp.substring(0, index) +
                    value +
                    (index + 1 < currentOtp.length
                        ? currentOtp.substring(index + 1)
                        : '');
              }

              // If not last field, focus next
              if (index < 3 && value.isNotEmpty) {
                FocusScope.of(context).nextFocus();
              }
            }
          },
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: AppTheme.backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSingleOtpBox(int index) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            _otpController.text.length > index
                ? _otpController.text[index]
                : '',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return CustomButton(
      text: _isOtpSent ? 'VERIFY' : 'SEND OTP',
      isLoading: _isLoading,
      onPressed: _isOtpSent ? _verifyOTP : _sendOTP,
    );
  }

  Widget _buildSignupPrompt() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account? ',
            style: TextStyle(
              color: AppTheme.secondaryTextColor,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PatientSignupScreen(),
                ),
              );
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveDecoration() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3498DB),
            Color(0xFF2ECC71),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Abstract wave shapes
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 80),
              painter: WavePainter(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: -50,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: WavePainter(
                color: Colors.white.withOpacity(0.05),
                frequency: 1.5,
                phase: 1.0,
              ),
            ),
          ),
          // Illustration placeholder
          Positioned(
            top: 30,
            right: 30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Image(
                  image: AssetImage('images/patient_icon.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient Portal',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Access your health records, \nappointments & more',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _isOtpSent = true;
        _startResendTimer();
      });
    }
  }

  void _verifyOTP() async {
    if (_otpController.text.length == 4) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Set the user type to patient
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setUserType(UserType.patient);

      setState(() {
        _isLoading = false;
      });

      // Navigate to dashboard
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 4-digit OTP'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resent successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _startResendTimer() {
    _otpResendTimer = 30;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        if (_otpResendTimer > 0) {
          _otpResendTimer--;
        }
      });
      return _otpResendTimer > 0;
    });
  }

  String _formatPhoneNumber(String number) {
    if (number.length != 10) return number;
    return '+1 (${number.substring(0, 3)}) ${number.substring(3, 6)}-${number.substring(6)}';
  }
}

class WavePainter extends CustomPainter {
  final Color color;
  final double frequency;
  final double phase;

  WavePainter({
    required this.color,
    this.frequency = 1.0,
    this.phase = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      double y = math.sin((x / size.width * 4 * 3.141592) * frequency + phase) *
              (size.height / 4) +
          size.height / 2;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
