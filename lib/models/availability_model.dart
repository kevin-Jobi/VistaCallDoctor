// class AvailabilityModel {
//   final List<String> availableDays;
//   final String yearsOfExperience;
//   final String fees;

//   AvailabilityModel({
//     this.availableDays = const [],
//     this.yearsOfExperience = '',
//     this.fees = '',
//   });

//   AvailabilityModel copyWith({
//     List<String>? availableDays,
//     String? yearsOfExperience,
//     String? fees,
//   }) {
//     return AvailabilityModel(
//       availableDays: availableDays ?? this.availableDays,
//       yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
//       fees: fees ?? this.fees,
//     );
//   }
// }

import 'package:vista_call_doctor/blocs/availability/availability_event.dart';

import '../blocs/availability/availability_bloc.dart';

class AvailabilityViewModel {
  final AvailabilityBloc availabilityBloc;

  AvailabilityViewModel(this.availabilityBloc);

  void toggleDay(String day) {
    availabilityBloc.add(ToggleDay(day));
  }

  void updateYearsOfExperience(String value) {
    availabilityBloc.add(UpdateYearsOfExperience(value));
  }

  void updateFees(String value) {
    availabilityBloc.add(UpdateFees(value));
  }

  void submitAvailability() {
    availabilityBloc.add(const SubmitAvailability());
  }
}
