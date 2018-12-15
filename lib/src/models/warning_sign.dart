import 'package:my_car/src/models/dashboardData.dart';

class WarningSign {
  String title, description, imageUrl;

  WarningSign({this.title, this.description, this.imageUrl});
}

List<WarningSign> warningSigns = <WarningSign>[
  WarningSign(
      title: engineTempTitle,
      description: engineTempDesc,
      imageUrl: engineTempUrl),
  WarningSign(
      title: tirePressureTitle,
      description: tirePressureDesc,
      imageUrl: tirePressureUrl),
  WarningSign(
      title: oilPressureTitle,
      description: oilPressureDesc,
      imageUrl: oilPressureUrl),
  WarningSign(
      title: tractionControlTitle,
      description: tractionControlDesc,
      imageUrl: tractionControlUrl),
  WarningSign(title: engineTitle, description: engineDesc, imageUrl: engineUrl),
  WarningSign(
    title: antiLockBreakTitle,
    description: antiLockBreakDesc,
    imageUrl: antiLockBreakUrl,
  ),
  WarningSign(
      title: autoShiftLockTitle,
      description: autoShiftLockDesc,
      imageUrl: autoShiftLockUrl),
  WarningSign(
      title: batteryTitle, description: batteryDesc, imageUrl: batteryUrl),
  WarningSign(
      title: fuelIndicatorTitle,
      description: fuelIndicatorDesc,
      imageUrl: fuelIndicatorUrl),
  WarningSign(
      title: seatBeltReminderTitle,
      description: seatBeltReminderDesc,
      imageUrl: seatBeltReminderUrl),
  WarningSign(
      title: airbagIndicatorTitle,
      description: airbagIndicatorDesc,
      imageUrl: airbagIndicatorUrl),
  WarningSign(
      title: fogLampIndicatorTitle,
      description: fogLampIndicatorDesc,
      imageUrl: fogLampIndicatorUrl),
  WarningSign(
      title: securityLightTitle,
      description: securityLightDesc,
      imageUrl: securityLightUrl),
  WarningSign(
      title: tractionControlMalfunctionTitle,
      description: tractionControlMalfunctionDesc,
      imageUrl: tractionControlMalfunctionUrl),
  WarningSign(
      title: washerFluidIndicatorTitle,
      description: washerFluidIndicatorDesc,
      imageUrl: washerFluidIndicatorUrl)
];
