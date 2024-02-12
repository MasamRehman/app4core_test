import 'package:flutter/material.dart';
import 'package:masam_flutter_task/provider/setting_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${AppLocalizations.of(context)!.setting}"),
      ),
      body: Consumer<SettingProvider>(
        builder: (context, weatherProvider, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile<Unit>(
                title: Text("${AppLocalizations.of(context)!.metrick}"),
                value: Unit.metric,
                groupValue: weatherProvider.unit,
                onChanged: (value) {
                  weatherProvider.changeUnit(value!);
                },
              ),
              RadioListTile<Unit>(
                title: Text("${AppLocalizations.of(context)!.imperial}"),
                value: Unit.imperial,
                groupValue: weatherProvider.unit,
                onChanged: (value) {
                  weatherProvider.changeUnit(value!);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
