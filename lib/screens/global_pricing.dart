// global_pricing.dart
import 'package:flutter/material.dart';

class GlobalPricing with ChangeNotifier {
  // Existing pricing variables...
  double pricePerSqm = 0.0;
  double brickPrice = 0.0;
  double foamPrice = 0.0;
  double hebalPrice = 0.0;
  double cementSandPrice = 0.0;

  // Labour rates...
  String labourHourlyRate = '0';
  String traderHourlyRate = '0';
  String minLabourCost = '0';
  String minTraderCost = '0';

  // Preparation & bulkhead prices...
  String coverTrapePerSqm = '0';
  String plasticPerRoll = '0';
  String windowPerItem = '0';
  String prepPillarsPerItem = '0';
  String expansionJointsPerItem = '0';
  String cornerBeadPer3m = '0';
  String sprayGluePerCan = '0';

  // Extra section prices...
  String quoinsPerPiece = '0';
  String bandsPlinthsPerLM = '0';
  String bulkHeadPerLM = '0';
  String pillarsPerItem = '0';
  String fenceTopLM = '0';
  String fenceMin = '0';

  // NEW: Profit percentage (default to 20%)
  double profitPercentage = 20.0;

  // Update method for profit percentage
  void updateProfitPercentage(double value) {
    profitPercentage = value;
    notifyListeners();
  }

  // Existing update methods...
  // Update methods
  void updateRenderPrices({
    required double pricePerSqm,
    required double brickPrice,
    required double foamPrice,
    required double hebalPrice,
    required double cementSandPrice,
  }) {
    this.pricePerSqm = pricePerSqm;
    this.brickPrice = brickPrice;
    this.foamPrice = foamPrice;
    this.hebalPrice = hebalPrice;
    this.cementSandPrice = cementSandPrice;
    notifyListeners();
  }

  void updateExtraSectionPrices({
    String? quoins,
    String? bands,
    String? bulkHead,
    String? pillars,
    String? fenceTop,
    String? fenceMin,
  }) {
    quoinsPerPiece = quoins ?? quoinsPerPiece;
    bandsPlinthsPerLM = bands ?? bandsPlinthsPerLM;
    bulkHeadPerLM = bulkHead ?? bulkHeadPerLM;
    pillarsPerItem = pillars ?? pillarsPerItem;
    fenceTopLM = fenceTop ?? fenceTopLM;
    this.fenceMin = fenceMin ?? this.fenceMin;
    notifyListeners();
  }

  void updatePrepBulkheadPrices({
    String? coverTrape,
    String? plastic,
    String? window,
    String? pillars,
    String? expansion,
    String? cornerBead,
    String? sprayGlue,
  }) {
    coverTrapePerSqm = coverTrape ?? coverTrapePerSqm;
    plasticPerRoll = plastic ?? plasticPerRoll;
    windowPerItem = window ?? windowPerItem;
    prepPillarsPerItem = pillars ?? prepPillarsPerItem;
    expansionJointsPerItem = expansion ?? expansionJointsPerItem;
    cornerBeadPer3m = cornerBead ?? cornerBeadPer3m;
    sprayGluePerCan = sprayGlue ?? sprayGluePerCan;
    notifyListeners();
  }

  void updateLabourRates({
    String? labour,
    String? trader,
    String? minLabour,
    String? minTrader,
  }) {
    labourHourlyRate = labour ?? labourHourlyRate;
    traderHourlyRate = trader ?? traderHourlyRate;
    minLabourCost = minLabour ?? minLabourCost;
    minTraderCost = minTrader ?? minTraderCost;
    notifyListeners();
  }
}
