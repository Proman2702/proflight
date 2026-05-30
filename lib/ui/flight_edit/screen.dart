import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proflight/core/error/result.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/models/flight_data.dart';
import 'package:proflight/ui/common/app_toast.dart';
import 'package:proflight/ui/flight_edit/view_model.dart';
import 'package:proflight/ui/flight_edit/widgets/flight_form_section.dart';
import 'package:proflight/ui/flight_edit/widgets/time_field_row.dart';
import 'package:provider/provider.dart';

class FlightEditScreen extends StatelessWidget {
  const FlightEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<FlightEditViewModel>();
    final failure = model.takeFailure();
    if (failure != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) showAppToast(context, failure);
      });
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
        children: [
          Row(
            children: [
              IconButton.filled(
                onPressed: () => context.go('/main/flights'),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    model.isEditMode ? 'Редактирование полета' : 'Новый полет',
                    style: const TextStyle(
                      color: CustomColors.main,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              IconButton.filled(
                onPressed: model.isSaving ? null : () => _save(context),
                icon: const Icon(Icons.check),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (model.isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 160),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            FlightFormSection(
              title: 'Маршрут',
              children: [
                _textField('Дата YYYY-MM-DD', model.flightDateController),
                _textField(
                  'Номер строки',
                  model.numberController,
                  number: true,
                ),
                TimeFieldRow(
                  leftLabel: 'Вылет',
                  leftController: model.placeDepartureController,
                  rightLabel: 'Прилет',
                  rightController: model.placeArrivalController,
                ),
                _textField('Запасной аэродром', model.placeArrival2Controller),
                _textField('Рейс', model.flightController),
              ],
            ),
            const SizedBox(height: 12),
            FlightFormSection(
              title: 'Борт',
              children: [
                _textField('Номер борта', model.planeNumberController),
              ],
            ),
            const SizedBox(height: 12),
            FlightFormSection(
              title: 'Время',
              children: [
                TimeFieldRow(
                  leftLabel: 'Time On',
                  leftController: model.timeOnController,
                  rightLabel: 'Time Off',
                  rightController: model.timeOffController,
                ),
                const SizedBox(height: 8),
                TimeFieldRow(
                  leftLabel: 'Departure',
                  leftController: model.timeDepartureController,
                  rightLabel: 'Arrival',
                  rightController: model.timeArrivalController,
                ),
                const SizedBox(height: 8),
                TimeFieldRow(
                  leftLabel: 'ETD',
                  leftController: model.etdController,
                  rightLabel: 'ETA',
                  rightController: model.etaController,
                ),
                const SizedBox(height: 8),
                TimeFieldRow(
                  leftLabel: 'PVP',
                  leftController: model.timePvpController,
                  rightLabel: 'PPP',
                  rightController: model.timePppController,
                ),
              ],
            ),
            const SizedBox(height: 12),
            FlightFormSection(
              title: 'Итоги',
              children: [
                TimeFieldRow(
                  leftLabel: 'Всего HH:mm:ss',
                  leftController: model.timeAllController,
                  rightLabel: 'В воздухе',
                  rightController: model.timeAirController,
                ),
                const SizedBox(height: 8),
                TimeFieldRow(
                  leftLabel: 'День',
                  leftController: model.timeDayController,
                  rightLabel: 'Ночь',
                  rightController: model.timeNightController,
                ),
                const SizedBox(height: 8),
                TimeFieldRow(
                  leftLabel: 'PVP/PPP всего',
                  leftController: model.timePvpPppAllController,
                  rightLabel: 'ETD/ETA всего',
                  rightController: model.etdEtaAllController,
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: model.isSaving ? null : () => _save(context),
              icon: const Icon(Icons.save),
              label: const Text('Сохранить'),
            ),
            if (model.isEditMode) ...[
              const SizedBox(height: 8),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: CustomColors.danger,
                ),
                onPressed: () => _delete(context),
                icon: const Icon(Icons.delete),
                label: const Text('Удалить'),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    bool number = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: CustomColors.main),
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    final result = await context.read<FlightEditViewModel>().save();
    if (!context.mounted) return;
    if (result is Err<FlightData>) {
      showAppToast(context, result.error);
      return;
    }
    showAppMessage(context, 'Полет сохранен');
    context.go('/main/flights');
  }

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить полет?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final result = await context.read<FlightEditViewModel>().delete();
    if (!context.mounted) return;
    if (result is Err<Unit>) {
      showAppToast(context, result.error);
      return;
    }
    showAppMessage(context, 'Полет удален');
    context.go('/main/flights');
  }
}
