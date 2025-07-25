import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vista_call_doctor/blocs/auth/auth_bloc.dart';
import 'package:vista_call_doctor/blocs/doc_auth/doc_auth_bloc.dart';
import 'package:vista_call_doctor/blocs/doc_auth/doc_auth_state.dart';
import 'package:vista_call_doctor/view_models/doctor_login_view_model.dart';
import 'package:vista_call_doctor/views/doctor_login/doctor_login_ui.dart';

class DoctorLoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DoctorLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<DoctorAuthBloc>(context);
    final viewModel = DoctorLoginViewModel(authBloc);
    return BlocListener<DoctorAuthBloc, DoctorAuthState>(
      listener: (context, state) => viewModel.handleAuthState(context, state),
      child: DoctorLoginUI(
        emailController: _emailController,
        passwordController: _passwordController,
        formKey: _formKey,
        viewModel: viewModel,
      ),
    );
  }
}
