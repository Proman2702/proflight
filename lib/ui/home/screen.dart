import 'package:flutter/material.dart';
import 'package:proflight/etc/colors.dart';
import 'package:proflight/ui/common/app_toast.dart';
import 'package:proflight/ui/home/view_model.dart';
import 'package:proflight/ui/home/widgets/flight_time_summary.dart';
import 'package:proflight/ui/home/widgets/period_stat_card.dart';
import 'package:proflight/ui/home/widgets/profile_date_header.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<HomeViewModel>();
    final failure = model.takeFailure();
    if (failure != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) showAppToast(context, failure);
      });
    }

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: context.read<HomeViewModel>().load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
          children: [
            ProfileDateHeader(profile: model.profile),
            const SizedBox(height: 28),
            if (model.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 120),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              FlightTimeSummary(stats: model.totalStats),
              const SizedBox(height: 16),
              Container(
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: CustomColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Вылетов: ${model.totalStats.flights}',
                  style: const TextStyle(
                    color: CustomColors.main,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Полетные периоды',
                  style: TextStyle(color: CustomColors.mainText),
                ),
              ),
              const SizedBox(height: 12),
              PeriodStatCard(title: 'За день:', stats: model.todayStats),
              const SizedBox(height: 10),
              PeriodStatCard(title: 'За неделю:', stats: model.weekStats),
              const SizedBox(height: 10),
              PeriodStatCard(title: 'За месяц:', stats: model.monthStats),
              const SizedBox(height: 10),
              PeriodStatCard(title: 'За год:', stats: model.yearStats),
            ],
          ],
        ),
      ),
    );
  }
}
