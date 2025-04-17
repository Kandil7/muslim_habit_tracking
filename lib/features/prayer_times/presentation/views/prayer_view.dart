import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/manager/prayer/prayer_cubit.dart';

import 'prayer_settings_view.dart';
import 'widgets/prayer_view_body.dart';

class PrayerView extends StatelessWidget {
  const PrayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PrayerCubit>().getPrayerTimes();
            },
          ),
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () {
              context.read<PrayerCubit>().setLocation();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrayerSettingsView(),
                ),
              );
            },
          ),
        ],
      ),
      body: const PrayerViewBody(),
    );
  }
}
