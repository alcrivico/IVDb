import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/presentation/widgets/login/alert_message_info.dart';
import 'package:ivdb/presentation/widgets/shared/button_box.dart';
import 'package:ivdb/presentation/widgets/shared/home_box.dart';
import 'package:ivdb/presentation/widgets/shared/text_field_box.dart';
import 'package:ivdb/presentation/viewmodels/signup/signup_viewmodel.dart';
import 'package:ivdb/presentation/viewmodels/signup/signup_state.dart';
import 'package:ivdb/presentation/screens/login/login_view.dart';

class SignupView extends HookConsumerWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;

    final signupState = ref.watch(signupViewModelProvider);
    final signupViewModel = ref.read(signupViewModelProvider.notifier);

    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final TextButton btnIniciarSesion = TextButton(
      style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          overlayColor: WidgetStateProperty.all(Colors.transparent)),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      },
      child: const Text(
        '¿Ya tienes una cuenta? Inicia Sesión',
        style: TextStyle(
          color: Color(0xff1971c2),
          fontSize: 20,
          fontStyle: FontStyle.normal,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: HomeBox(
            onPressed: null,
          ),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Container(
          constraints: BoxConstraints(maxWidth: 700),
          width: size.width * 0.9,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: const Color(0xff1971c2), width: 4),
              borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            SizedBox(height: size.height * 0.05),
            const Text('Registrate',
                style: TextStyle(
                    fontSize: 50,
                    color: Color(0xff1971c2),
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Anton SC',
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.center),
            SizedBox(height: size.height * 0.1),
            TextFieldBox(
              'tfUsername',
              controller: usernameController,
              hint: 'fulanito',
              label: 'Nombre de Usuario',
            ),
            SizedBox(height: size.height * 0.05),
            TextFieldBox(
              'tfEmail',
              controller: emailController,
              hint: 'example@mail.com',
              label: 'Correo Electrónico',
            ),
            SizedBox(height: size.height * 0.05),
            TextFieldBox('tfPassword',
                label: 'Contraseña',
                controller: passwordController,
                obscureText: true),
            SizedBox(height: size.height * 0.05),
            TextFieldBox('tfConfirmPassword',
                label: 'Confirmar Contraseña',
                controller: confirmPasswordController,
                obscureText: true),
            SizedBox(height: size.height * 0.05),
            if (signupState.status == SignupStatus.error)
              AlertMessageInfo(
                  message: signupState.errorMessage.toString(),
                  color: Colors.yellow,
                  messageColor: Colors.black)
            else if (signupState.status == SignupStatus.success)
              AlertMessageInfo(
                  message:
                      'Usuario ${signupState.user!.username} creado correctamente',
                  color: Colors.green,
                  messageColor: Colors.white)
            else
              const SizedBox(height: 0),
            SizedBox(height: size.height * 0.03),
            if (signupState.status == SignupStatus.loading)
              const CircularProgressIndicator()
            else
              ButtonBox(
                  text: 'Registrarse',
                  onPressed: () {
                    final username = usernameController.text.trim();
                    final email = emailController.text.trim();
                    final password = passwordController.text;
                    final confirmPassword = confirmPasswordController.text;

                    signupViewModel.signup(
                        username, email, password, confirmPassword);
                  }),
            SizedBox(height: size.height * 0.05),
            btnIniciarSesion,
          ]),
        ))));
  }
}
