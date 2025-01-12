import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/presentation/screens/login/login_view.dart';
import 'package:ivdb/presentation/viewmodels/login/login_viewmodel.dart';
import 'package:ivdb/presentation/widgets/shared/confirmation_message_box.dart';

class ExitDoorBox extends HookConsumerWidget {
  const ExitDoorBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExitHovered = useState(false);

    return Container(
      padding: const EdgeInsets.only(right: 20),
      child: MouseRegion(
        onEnter: (_) {
          isExitHovered.value = true;
        },
        onExit: (_) {
          isExitHovered.value = false;
        },
        child: IconButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            elevation: WidgetStateProperty.all(0),
            shadowColor: WidgetStateProperty.all(Colors.transparent),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
          icon: Icon(
            isExitHovered.value
                ? FontAwesomeIcons.doorOpen
                : FontAwesomeIcons.doorClosed,
            color: const Color(0xff1971c2),
            size: 30,
            weight: 12,
          ),
          onPressed: () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmationMessageBox(
                  title: 'Cerrar Sesión',
                  message: '¿Estás seguro de que deseas cerrar sesión?',
                  action: 'Cerrar Sesión',
                  cancel: 'Cancelar',
                );
              },
            );

            if (result != null && result) {
              ref.read(loginViewModelProvider.notifier).logout();
              Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            }
          },
        ),
      ),
    );
  }
}
