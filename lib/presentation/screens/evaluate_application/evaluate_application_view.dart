import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/entities/application_entity.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
import 'package:ivdb/presentation/screens/explore_videogames/explore_videogames_view.dart';
import 'package:ivdb/presentation/screens/show_applications/show_applications_view.dart';
import 'package:ivdb/presentation/viewmodels/evaluate_application/evaluate_application_viewmodel.dart';
import 'package:ivdb/presentation/widgets/shared/exit_door_box.dart';
import 'package:ivdb/presentation/widgets/shared/home_box.dart';

class EvaluateApplicationView extends ConsumerWidget {
  final ApplicationEntity application;

  final UserEntity user;

  const EvaluateApplicationView(
      {super.key, required this.application, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(evaluateApplicationViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: HomeBox(
          onPressed: () {
            AppBar(
              title: HomeBox(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExploreVideogamesView(user)),
                    (Route<dynamic> route) =>
                        false, // Elimina todas las rutas anteriores
                  );
                },
              ),
              actions: [ExitDoorBox()],
            );
          },
        ),
        actions: [ExitDoorBox()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowApplicationsView(user)),
                    (Route<dynamic> route) =>
                        false, // Elimina todas las rutas anteriores
                  );
                },
                icon: Icon(Icons.arrow_back)),
            const SizedBox(height: 16),
            // Mostrar afiliación y motivo
            Text(
              'Afiliación: ${application.request ?? 'Sin afiliación'}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Motivo: ${application.request ?? 'Sin motivo'}',
              style: const TextStyle(fontSize: 14),
            ),
            const Spacer(),
            // Botones de evaluación
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await viewModel.evaluateApplication(
                        application.email ?? '', false);

                    Navigator.pushAndRemoveUntil(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowApplicationsView(user)),
                      (Route<dynamic> route) =>
                          false, // Elimina todas las rutas anteriores
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Rechazar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await viewModel.evaluateApplication(
                        application.email ?? '', true);

                    Navigator.pushAndRemoveUntil(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowApplicationsView(user)),
                      (Route<dynamic> route) =>
                          false, // Elimina todas las rutas anteriores
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Aprobar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
