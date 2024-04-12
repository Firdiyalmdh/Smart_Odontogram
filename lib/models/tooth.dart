import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

class Tooth extends Equatable {
  final String id;
  final ToothType type;
  final ToothCondition condition;
  final String imagePath;

  const Tooth({
    required this.id,
    required this.type,
    required this.condition,
    required this.imagePath,
  });

  String get icon {
    switch (type) {
      case ToothType.SERI_1:
      case ToothType.SERI_2:
      case ToothType.TARING:
        return getClosedIcon();
      default:
        return getOpenIcon();
    }
  }

  String getClosedIcon() {
    switch (condition) {
      case ToothCondition.NORMAL:
        return "assets/normal1.png";
      case ToothCondition.IMPAKSI:
        return "assets/impaksi1.png";
      case ToothCondition.KARIES:
        return "assets/karies1.png";
      case ToothCondition.SISA_AKAR:
        return "assets/sisa_akar1.png";
      case ToothCondition.TUMPATAN:
        return "assets/tumpatan1.png";
    }
  }

  String getOpenIcon() {
    switch (condition) {
      case ToothCondition.NORMAL:
        return "assets/normal.png";
      case ToothCondition.IMPAKSI:
        return "assets/impaksi.png";
      case ToothCondition.KARIES:
        return "assets/karies.png";
      case ToothCondition.SISA_AKAR:
        return "assets/sisa_akar.png";
      case ToothCondition.TUMPATAN:
        return "assets/tumpatan.png";
    }
  }

  String getTitle() => "$id - ${type.name.replaceFirst("_", " ").toLowerCase().capitalizeFirst}";

  @override
  List<Object?> get props => [id, type, condition, imagePath];
}

enum ToothType {
  SERI_1,
  SERI_2,
  TARING,
  PREMOLAR_1,
  PREMOLAR_2,
  MOLAR_1,
  MOLAR_2,
  MOLAR_3
}

enum ToothCondition { NORMAL, KARIES, TUMPATAN, SISA_AKAR, IMPAKSI }

enum ToothQuadrant { QUADRANT_I, QUADRANT_II, QUADRANT_III, QUADRANT_IV }

extension ToothQuadranExt on ToothQuadrant {
  List<int> get idList => switch (this) {
        ToothQuadrant.QUADRANT_I => List.generate(8, (index) => index + 11),
        ToothQuadrant.QUADRANT_II => List.generate(8, (index) => index + 21),
        ToothQuadrant.QUADRANT_III => List.generate(8, (index) => index + 41),
        ToothQuadrant.QUADRANT_IV => List.generate(8, (index) => index + 31),
      };

  bool get isReverse =>
      [ToothQuadrant.QUADRANT_I, ToothQuadrant.QUADRANT_III].contains(this);

  String get title => name.toLowerCase().split("_").join(" ").capitalize ?? "";

  String get icon => switch (this) {
        ToothQuadrant.QUADRANT_I => "assets/kuadran_1.png",
        ToothQuadrant.QUADRANT_II => "assets/kuadran_2.png",
        ToothQuadrant.QUADRANT_III => "assets/kuadran_3.png",
        ToothQuadrant.QUADRANT_IV => "assets/kuadran_4.png",
      };
  
  int get intRepresentative => switch(this) {
    ToothQuadrant.QUADRANT_I => 1,
    ToothQuadrant.QUADRANT_II => 2,
    ToothQuadrant.QUADRANT_III => 3,
    ToothQuadrant.QUADRANT_IV => 4
  };
}

extension ToothTypeIdExt on int {
  ToothType get toothType => ToothType.values[this % 10 - 1];
}

extension StringExt on String {
  List<Tooth> parseToToothList() {
    final List<dynamic> jsonList = jsonDecode(this);
    
    final List<Tooth> toothList = jsonList.map((jsonObject) {
      return Tooth(
        id: jsonObject['id'],
        type: _parseToothType(jsonObject['type']),
        condition: _parseToothCondition(jsonObject['condition']),
        imagePath: jsonObject['imagePath'],
      );
    }).toList();

    return toothList;
  }

  ToothType _parseToothType(String typeString) {
    return ToothType.values.firstWhere(
      (type) => type.toString().split('.').last == typeString,
      orElse: () => ToothType.SERI_1,
    );
  }

  ToothCondition _parseToothCondition(String conditionString) {
    return ToothCondition.values.firstWhere(
      (condition) => condition.toString().split('.').last == conditionString,
      orElse: () => ToothCondition.NORMAL,
    );
  }
}