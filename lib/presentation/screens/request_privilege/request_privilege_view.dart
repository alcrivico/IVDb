import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
import 'package:ivdb/presentation/screens/explore_videogames/explore_videogames_view.dart';
import 'package:ivdb/presentation/viewmodels/request_privilege/request_privilege_state.dart';
import 'package:ivdb/presentation/viewmodels/request_privilege/request_privilege_viewmodel.dart';

class RequestPrivilegeView extends ConsumerWidget {
  final UserEntity user;

  const RequestPrivilegeView({
    super.key,
    required this.user,
  });



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestPrivilegeState = ref.watch(requestPrivilegeViewModelProvider);
    final requestPrivilegeViewModel =
        ref.read(requestPrivilegeViewModelProvider.notifier);

    final TextEditingController motiveController = TextEditingController();

    ref.listen<RequestPrivilegeState>(requestPrivilegeViewModelProvider, (previous, next) {
      if (next.status == RequestPrivilegeStatus.success) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ExploreVideogamesView(user)),
            (Route<dynamic> route) =>
                false, 
          );
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Solicitar Privilegios',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff1971c2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ExploreVideogamesView(user)),
            (Route<dynamic> route) =>
                false, 
          );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Motivo de la solicitud:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff1971c2),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: motiveController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Escribe aquí el motivo...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xff1971c2),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton( 
                  onPressed: 
                  requestPrivilegeState.status ==
                          RequestPrivilegeStatus.loading
                      ? null
                      : () {
                          if (motiveController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Por favor escribe un motivo.'),
                              ),
                            );
                            
                          } else {
                            requestPrivilegeViewModel.restart();
                            requestPrivilegeViewModel.sendRequest(
                              user.email,
                              motiveController.text.trim(),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1971c2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: requestPrivilegeState.status ==
                          RequestPrivilegeStatus.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Enviar',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (requestPrivilegeState.status == RequestPrivilegeStatus.error)
              Text(
                'Error: ${requestPrivilegeState.errorMessage}',
                style: const TextStyle(color: Colors.red),
              )
            else if (requestPrivilegeState.status ==
                RequestPrivilegeStatus.success)
              const Text(
                'Solicitud enviada con éxito.',
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
