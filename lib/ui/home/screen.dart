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
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
          children: [
            ProfileDateHeader(profile: model.profile),
            const SizedBox(height: 26),
            if (model.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 70),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              FlightTimeSummary(stats: model.totalStats),
            if (!model.isLoading) ...[
              const SizedBox(height: 10),
              Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: CustomColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Вылетов',
                        style: TextStyle(
                          color: CustomColors.mainText,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      '${model.totalStats.flights}',
                      style: const TextStyle(
                        color: CustomColors.main,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 18),
                    const Icon(Icons.more_horiz, color: CustomColors.mainText),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              PeriodStatCard(
                title: 'За день',
                stats: model.todayStats,
                highlighted: true,
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Прочие периоды',
                  style: TextStyle(
                    color: CustomColors.mainText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              PeriodStatCard(title: 'За неделю', stats: model.weekStats),
              const SizedBox(height: 10),
              PeriodStatCard(title: 'За месяц', stats: model.monthStats),
              const SizedBox(height: 10),
              PeriodStatCard(title: 'За год', stats: model.yearStats),
            ],
          ],
        ),
      ),
    );
  }
}
