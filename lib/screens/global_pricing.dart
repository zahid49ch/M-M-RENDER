import 'package:flutter/material.dart';

class GlobalPricing with ChangeNotifier {
  // Material prices
  double pricePerSqm = 0.0;
  double brickPrice = 0.0;
  double foamPrice = 0.0;
  double hebalPrice = 0.0;
  double cementSandPrice = 0.0;
  
  // Preparation & bulkhead prices
  double coverTrapePerSqm = 0.0;
  double plasticPerRoll = 0.0;
  double windowPerItem = 0.0;
  double prepPillarsPerItem = 0.0;
  double expansionJointsPerItem = 0.0;
  double cornerBeadPer3m = 0.0;
  double sprayGluePerCan = 0.0;
  
  // Labour rates
  String labourHourlyRate = '0';
  String traderHourlyRate = '0';
  String minLabourCost = '0';
  String minTraderCost = '0';
  
  // Extra features prices
  String quoinsPerPiece = '0';
  String bandsPlinthsPerLM = '0';
  String bulkHeadPerLM = '0';
  String pillarsPerItem = '0';
  String fenceTopLM = '0';
  String fenceMin = '0';
  
  // Profit percentage
  double profitPercentage = 20.0;

  void updatePrepBulkheadPrices({
    double? coverTrape,
    double? plastic,
    double? window,
    double? pillars,
    double? expansion,
    double? cornerBead,
    double? sprayGlue,
  }) {
    if (coverTrape != null) coverTrapePerSqm = coverTrape;
    if (plastic != null) plasticPerRoll = plastic;
    if (window != null) windowPerItem = window;
    if (pillars != null) prepPillarsPerItem = pillars;
    if (expansion != null) expansionJointsPerItem = expansion;
    if (cornerBead != null) cornerBeadPer3m = cornerBead;
    if (sprayGlue != null) sprayGluePerCan = sprayGlue;
    notifyListeners();
  }

  void updateLabourRates({
    String? labour,
    String? trader,
    String? minLabour,
    String? minTrader,
  }) {
    if (labour != null) labourHourlyRate = labour;
    if (trader != null) traderHourlyRate = trader;
    if (minLabour != null) minLabourCost = minLabour;
    if (minTrader != null) minTraderCost = minTrader;
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
    if (quoins != null) quoinsPerPiece = quoins;
    if (bands != null) bandsPlinthsPerLM = bands;
    if (bulkHead != null) bulkHeadPerLM = bulkHead;
    if (pillars != null) pillarsPerItem = pillars;
    if (fenceTop != null) fenceTopLM = fenceTop;
    if (fenceMin != null) this.fenceMin = fenceMin;
    notifyListeners();
  }

  void updateProfitPercentage(double value) {
    profitPercentage = value;
    notifyListeners();
  }
}