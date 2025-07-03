// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'availability_event.dart';
// // import 'availability_state.dart';
// // import '../../models/availability_model.dart';

// // class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
// //   AvailabilityBloc() : super(AvailabilityState(availability: AvailabilityModel())) {
// //     on<ToggleDay>((event, emit) {
// //       final updatedDays = List<String>.from(state.availability.availableDays);
// //       if (updatedDays.contains(event.day)) {
// //         updatedDays.remove(event.day);
// //       } else {
// //         updatedDays.add(event.day);
// //       }
// //       emit(state.copyWith(
// //         availability: state.availability.copyWith(availableDays: updatedDays),
// //       ));
// //     });

// //     on<UpdateYearsOfExperience>((event, emit) {
// //       emit(state.copyWith(
// //         availability: state.availability.copyWith(yearsOfExperience: event.years),
// //       ));
// //     });

// //     on<UpdateFees>((event, emit) {
// //       emit(state.copyWith(
// //         availability: state.availability.copyWith(fees: event.fees),
// //       ));
// //     });

// //     on<SubmitAvailability>((event, emit) async {
// //       emit(state.copyWith(isSubmitting: true));
// //       await Future.delayed(const Duration(seconds: 2));
// //       emit(state.copyWith(isSubmitting: false, isSuccess: true));
// //     });
// //   }
// // }

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'availability_event.dart';
// import 'availability_state.dart';

// class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
//   AvailabilityBloc()
//     : super(const AvailabilityState(availability: Availability())) {
//     on<ToggleDay>((event, emit) {
//       final currentDays = List<String>.from(state.availability.availableDays);
//       if (currentDays.contains(event.day)) {
//         currentDays.remove(event.day);
//       } else {
//         currentDays.add(event.day);
//       }
//       emit(
//         state.copyWith(availability: Availability(availableDays: currentDays)),
//       );
//     });
//     on<UpdateYearsOfExperience>((event, emit) {
//       emit(
//         state.copyWith(
//           availability: Availability(
//             yearsOfExperience: event.value,
//             availableDays: state.availability.availableDays,
//             fees: state.availability.fees,
//           ),
//         ),
//       );
//     });
//     on<UpdateFees>((event, emit) {
//       emit(
//         state.copyWith(
//           availability: Availability(
//             fees: event.value,
//             availableDays: state.availability.availableDays,
//             yearsOfExperience: state.availability.yearsOfExperience,
//           ),
//         ),
//       );
//     });
//     on<SubmitAvailability>((event, emit) {
//       emit(state.copyWith(isSubmitting: true));
//       // Simulate success
//       emit(state.copyWith(isSubmitting: false, isSuccess: true));
//     });
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'availability_event.dart';
import 'availability_state.dart';

class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  AvailabilityBloc()
    : super(const AvailabilityState(availability: Availability())) {
    on<ToggleDay>((event, emit) {
      final currentDays = List<String>.from(state.availability.availableDays);
      if (currentDays.contains(event.day)) {
        currentDays.remove(event.day);
      } else {
        currentDays.add(event.day);
      }
      print('Toggled day: $event, New days: $currentDays');
      emit(
        state.copyWith(availability: Availability(availableDays: currentDays)),
      );
    });
    on<UpdateYearsOfExperience>((event, emit) {
      print('Updated years: ${event.value}');
      emit(
        state.copyWith(
          availability: Availability(
            yearsOfExperience: event.value,
            availableDays: state.availability.availableDays,
            fees: state.availability.fees,
          ),
        ),
      );
    });
    on<UpdateFees>((event, emit) {
      print('Updated fees: ${event.value}');
      emit(
        state.copyWith(
          availability: Availability(
            fees: event.value,
            availableDays: state.availability.availableDays,
            yearsOfExperience: state.availability.yearsOfExperience,
          ),
        ),
      );
    });
    on<SubmitAvailability>((event, emit) {
      print('Submitting availability');
      emit(state.copyWith(isSubmitting: true));
      // Simulate success
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    });
  }
}
