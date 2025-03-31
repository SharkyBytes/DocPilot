enum UserType {
  patient,
  doctor,
  none;

  String get displayName {
    switch (this) {
      case UserType.patient:
        return 'Patient';
      case UserType.doctor:
        return 'Doctor';
      case UserType.none:
        return 'None';
    }
  }

  String get iconPath {
    switch (this) {
      case UserType.patient:
        return 'assets/images/patient_icon.png';
      case UserType.doctor:
        return 'assets/images/doctor_icon.png';
      case UserType.none:
        return '';
    }
  }
}
