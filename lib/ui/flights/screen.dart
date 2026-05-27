import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/ui/common/app_toast.dart';
import 'package:proflight/ui/common/flight_formatters.dart';
import 'package:proflight/ui/flights/view_model.dart';
import 'package:proflight/ui/flights/widgets/date_filter_bar.dart';
import 'package:proflight/ui/flights/widgets/flight_tile.dart';
import 'package:provider/provider.dart';

class FlightsScreen extends StatelessWidget {
  const FlightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<FlightsViewModel>();
    final failure = model.takeFailure();
    if (failure != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) showAppToast(context, failure);
      });
    }

    final flights = model.selectedDayFlights;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: context.read<FlightsViewModel>().load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
          children: [
            const Center(
              child: Text(
                'Журнал полетов',
                style: TextStyle(
                  color: CustomColors.main,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 18),
            DateFilterBar(
              selectedDate: model.selectedDate,
              onPrevious: () =>
                  context.read<FlightsViewModel>().setSelectedDate(
                    model.selectedDate.subtract(const Duration(days: 1)),
                  ),
              onNext: () => context.read<FlightsViewModel>().setSelectedDate(
                model.selectedDate.add(const Duration(days: 1)),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () => context.go('/main/flights/new'),
              icon: const Icon(Icons.add),
              label: const Text('Добавить'),
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                '${FlightFormatters.dateRu(model.selectedDate)}, полетов: ${flights.length}',
                style: const TextStyle(color: CustomColors.mainText),
              ),
            ),
            const SizedBox(height: 12),
            if (model.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 100),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (flights.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 100),
                child: Center(
                  child: Text(
                    'За выбранный день полетов нет',
                    style: TextStyle(color: CustomColors.mainText),
                  ),
                ),
              )
            else
              for (final flight in flights) ...[
                FlightTile(
                  flight: flight,
                  onTap: () => context.go('/main/flights/${flight.id}'),
                ),
                const SizedBox(height: 10),
              ],
          ],
        ),
      ),
    );
  }
}
