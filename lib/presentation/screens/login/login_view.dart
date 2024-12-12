import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ivdb/presentation/screens/explore_videogames/explore_videogames_view.dart';
import 'package:ivdb/presentation/viewmodels/login/login_viewmodel.dart';
import 'package:ivdb/presentation/widgets/login/alert_message_info.dart';
import 'package:ivdb/presentation/widgets/shared/button_box.dart';
import 'package:ivdb/presentation/widgets/shared/text_field_box.dart';
import 'package:ivdb/presentation/viewmodels/login/login_state.dart';
import 'package:ivdb/presentation/screens/signup/signup_view.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;

    final loginState = ref.watch(loginViewModelProvider);
    final loginViewModel = ref.read(loginViewModelProvider.notifier);

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    TextFieldBox tfEmail = TextFieldBox(
      'tfEmail',
      controller: emailController,
      hint: 'ejemplo@mail.com',
      label: 'Correo Electrónico',
    );

    TextFieldBox tfPassword = TextFieldBox('tfPassword',
        label: 'Contraseña', controller: passwordController, obscureText: true);

    TextButton btnRegistrate = TextButton(
      style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          overlayColor: WidgetStateProperty.all(Colors.transparent)),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignupView()),
        );
      },
      child: const Text(
        'Regístrate',
        style: TextStyle(
          color: Color(0xff1971c2),
          fontSize: 20,
          fontStyle: FontStyle.italic,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );

    useEffect(() {
      if (loginState.status == LoginStatus.success) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ExploreVideogamesView(
                user: loginState.user!,
              ),
            ),
          );
        });
      }
      return null;
    }, [loginState.status]);

    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            width: size.width * 0.9,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: const Color(0xff1971c2), width: 4),
                borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              SizedBox(height: size.height * 0.05),
              const Text('IVDb',
                  style: TextStyle(
                      fontSize: 60,
                      color: Color(0xff1971c2),
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Anton SC',
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center),
              SizedBox(height: size.height * 0.1),
              tfEmail,
              SizedBox(height: size.height * 0.05),
              tfPassword,
              SizedBox(height: size.height * 0.05),
              if (loginState.status == LoginStatus.error)
                AlertMessageInfo(
                    message: loginState.errorMessage.toString(),
                    color: Colors.yellow,
                    messageColor: Colors.black)
              else
                const SizedBox(height: 0),
              SizedBox(height: size.height * 0.05),
              if (loginState.status == LoginStatus.loading)
                const CircularProgressIndicator()
              else
                ButtonBox(
                    text: 'Iniciar Sesión',
                    onPressed: () {
                      final email = emailController.text.trim();
                      final password = passwordController.text;

                      loginViewModel.login(email, password);
                    }),
              SizedBox(height: size.height * 0.05),
              btnRegistrate,
            ])),
      )),
    );
  }
}
