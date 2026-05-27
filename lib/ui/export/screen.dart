import 'package:flutter/material.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/ui/common/app_toast.dart';
import 'package:proflight/ui/common/flight_formatters.dart';
import 'package:proflight/ui/export/view_model.dart';
import 'package:proflight/ui/export/widgets/export_format_button.dart';
import 'package:proflight/ui/export/widgets/export_summary_card.dart';
import 'package:provider/provider.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ExportViewModel>();
    final failure = model.takeFailure();
    if (failure != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) showAppToast(context, failure);
      });
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
        children: [
          const Text(
            'Настройки экспорта',
            style: TextStyle(
              color: CustomColors.main,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DatePill(
                  label: FlightFormatters.dateRu(model.startDate),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DatePill(label: FlightFormatters.dateRu(model.endDate)),
              ),
              const SizedBox(width: 10),
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.filter_alt),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Данные экспорта',
            style: TextStyle(color: CustomColors.mainText),
          ),
          const SizedBox(height: 8),
          if (model.isLoading)
            const Center(child: CircularProgressIndicator())
          else
            ExportSummaryCard(stats: model.stats),
          const SizedBox(height: 20),
          const Text(
            'Формат',
            style: TextStyle(
              color: CustomColors.main,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ExportFormatButton(
                label: 'Excel',
                color: CustomColors.success,
                onPressed: () => showAppMessage(context, 'Экспорт подготовлен'),
              ),
              const SizedBox(width: 10),
              ExportFormatButton(
                label: 'CSV',
                color: CustomColors.night,
                onPressed: () => showAppMessage(context, 'Экспорт подготовлен'),
              ),
              const SizedBox(width: 10),
              ExportFormatButton(
                label: 'PDF',
                color: CustomColors.danger,
                onPressed: () => showAppMessage(context, 'Экспорт подготовлен'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CustomColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: CustomColors.main,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
