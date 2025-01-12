import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/entities/application_entity.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
import 'package:ivdb/presentation/screens/explore_videogames/explore_videogames_view.dart';
import 'package:ivdb/presentation/viewmodels/show_applications/show_application_viewmodel.dart';
import 'package:ivdb/presentation/viewmodels/show_applications/show_application_state.dart';
import 'package:ivdb/presentation/screens/evaluate_application/evaluate_application_view.dart';
import 'package:ivdb/presentation/widgets/shared/exit_door_box.dart';
import 'package:ivdb/presentation/widgets/shared/home_box.dart';

class ShowApplicationsView extends HookConsumerWidget {
  final UserEntity user;

  const ShowApplicationsView(
    this.user, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(showApplicationsViewModelProvider);
    final viewModel = ref.read(showApplicationsViewModelProvider.notifier);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.fetchApplications();
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Manejo de estados
            state.status == ShowApplicationsStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : state.status == ShowApplicationsStatus.error
                    ? Center(child: Text('Error: ${state.errorMessage}'))
                    : Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('ID Solicitud')),
                              DataColumn(label: Text('Correo Electrónico')),
                              DataColumn(label: Text('Descripción')),
                              DataColumn(label: Text('Fecha')),
                              DataColumn(label: Text('Estado')),
                              DataColumn(label: Text('Acciones')),
                            ],
                            rows: state.applications?.map((application) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(application.id.toString())),
                                      DataCell(
                                          Text(application.email ?? 'N/A')),
                                      DataCell(
                                          Text(application.request ?? 'N/A')),
                                      DataCell(Text(
                                          application.requestDate != null
                                              ? application.requestDate
                                                  .toString()
                                                  .substring(
                                                      0, 10) // Formato de fecha
                                              : 'Sin fecha')),
                                      DataCell(Text(application.state
                                          ? 'Aprobada'
                                          : 'Pendiente')),
                                      DataCell(
                                        ElevatedButton(
                                          onPressed: () {
                                            _showApplicationDetails(
                                                context, application, user);
                                          },
                                          child: const Text('Consultar'),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList() ??
                                [],
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  void _showApplicationDetails(
      BuildContext context, ApplicationEntity application, UserEntity user) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => EvaluateApplicationView(
                user: user,
                application: application,
              )),
      (Route<dynamic> route) => false, // Elimina todas las rutas anteriores
    );
  }
}
