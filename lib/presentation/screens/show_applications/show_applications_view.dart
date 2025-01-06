import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/entities/application_entity.dart'; // Nota: Asegúrate de importar la entidad correcta
import 'package:ivdb/presentation/viewmodels/show_applications/show_application_viewmodel.dart';
import 'package:ivdb/presentation/viewmodels/show_applications/show_application_state.dart';

class ShowApplicationsView extends ConsumerWidget {
  const ShowApplicationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(showApplicationsViewModelProvider);
    final viewModel = ref.read(showApplicationsViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar Solicitudes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Botón para recargar solicitudes
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => viewModel.fetchApplications(),
                child: const Text('Actualizar'),
              ),
            ),
            const SizedBox(height: 16),
            // Manejo de estados
            state.status == ShowApplicationsStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : state.status == ShowApplicationsStatus.error
                    ? Center(child: Text('Error: ${state.errorMessage}'))
                    : Expanded(
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('ID Solicitud')),
                            DataColumn(label: Text('Descripción')),
                            DataColumn(label: Text('Fecha')),
                            DataColumn(label: Text('Estado')),
                            DataColumn(label: Text('Acciones')),
                          ],
                          rows: state.applications?.map((application) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(application.id.toString())),
                                    DataCell(Text(application.request ?? 'N/A')),
                                    DataCell(Text(
                                        application.requestDate != null
                                            ? application.requestDate
                                                .toString()
                                                .substring(0, 10) // Formato de fecha
                                            : 'Sin fecha')),
                                    DataCell(Text(
                                        application.state ? 'Aprobada' : 'Pendiente')),
                                    DataCell(
                                      ElevatedButton(
                                        onPressed: () {
                                          _showApplicationDetails(
                                              context, application);
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
          ],
        ),
      ),
    );
  }

  /// Muestra detalles de una solicitud seleccionada
  void _showApplicationDetails(BuildContext context, ApplicationEntity application) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalles de la Solicitud'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${application.id}'),
            Text('Descripción: ${application.request ?? 'N/A'}'),
            Text('Fecha: ${application.requestDate?.toString().substring(0, 10) ?? 'Sin fecha'}'),
            Text('Estado: ${application.state ? 'Aprobada' : 'Pendiente'}'),
            const SizedBox(height: 16),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}