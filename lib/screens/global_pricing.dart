import 'package:flutter/material.dart';

class GlobalPricing with ChangeNotifier {
  // Material prices (with defaults from specs)
  double pricePerSqm = 60.0; // $60 ex GST
  double brickPrice = 12.50;
  double foamPrice = 12.29;
  double hebalPrice = 12.63;
  double cementSandPrice = 15.93;

  // Preparation & bulkhead
  double coverTrapePerSqm = 3.00;
  double plasticPerRoll = 25.0;
  double windowPerItem = 15.0;
  double prepPillarsPerItem = 50.0;
  double expansionJointsPerItem = 30.0;
  double cornerBeadPer3m = 12.0;
  double sprayGluePerCan = 45.0;

  // Labour rates
  double labourHourlyRate = 70.0;
  double traderHourlyRate = 85.0;
  double minLabourCost = 100.0;
  double minTraderCost = 150.0;

  // Extras
  double quoinsPerPiece = 600.0;
  double bandsPlinthsPerLM = 85.0;
  double bulkHeadPerLM = 120.0;
  double pillarsPerItem = 500.0;

  // Profit
  double profitPercentage = 20.0;

  // Calculation Methods
  double calculateLabourCost(double hours, {bool isTrader = false}) {
    final rate = isTrader ? traderHourlyRate : labourHourlyRate;
    final minCost = isTrader ? minTraderCost : minLabourCost;
    final cost = hours * rate;
    return cost > minCost ? cost : minCost;
  }

  double calculateBulkheadCost(double lengthMeters) {
    return (lengthMeters / 3) * cornerBeadPer3m;
  }

  double calculatePreparationCost(double sqm) {
    return sqm * coverTrapePerSqm;
  }

  // Update methods...
  void updateLabourRates({
    double? labour,
    double? trader,
    double? minLabour,
    double? minTrader,
  }) {
    if (labour != null) labourHourlyRate = labour;
    if (trader != null) traderHourlyRate = trader;
    if (minLabour != null) minLabourCost = minLabour;
    if (minTrader != null) minTraderCost = minTrader;
    notifyListeners();
  }
}
