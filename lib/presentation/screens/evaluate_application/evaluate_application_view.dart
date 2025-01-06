import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/entities/application_entity.dart';
import 'package:ivdb/presentation/viewmodels/evaluate_application/evaluate_application_viewmodel.dart';

class EvaluateApplicationView extends ConsumerWidget {
  final ApplicationEntity application;

  const EvaluateApplicationView({Key? key, required this.application})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(evaluateApplicationViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluar Solicitud'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  onPressed: () {
                    viewModel.evaluateApplication(application.email ?? '', false);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Rechazar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    viewModel.evaluateApplication(application.email ?? '', true);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
