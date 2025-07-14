// import 'dart:io';

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:image_picker/image_picker.dart';

// part 'image_picker_event.dart';
// part 'image_picker_state.dart';

// class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
//   final ImagePicker _imagePicker;
//   ImagePickerBloc(this._imagePicker) : super(ImagePickerInitial()) {
//     on<CaptureImage>(_onCaptureImage);
//     on<ImageCaptured>(_onImageCaptured);
//   }

//   Future<void> _onCaptureImage(
//     CaptureImage event,
//     Emitter<ImagePickerState> emit,
//   ) async {
//     emit(ImagePickerLoading());
//     try {
//       final PickedFile = await _imagePicker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 85,
//       );
//       if (PickedFile != null) {
//         add(ImageCaptured(File(PickedFile.path)));
//       } else {
//         emit(ImagePickerInitial());
//       }
//     } catch (e) {
//       emit(ImagePickerError("Failed to capture image: ${e.toString()}"));
//     }
//   }

//   void _onImageCaptured(ImageCaptured event, Emitter<ImagePickerState> emit) {
//     emit(ImagePickerSucess(event.imageFile));
//   }
// }
