import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

class Tooth extends Equatable {
  final String id;
  final ToothType type;
  final ToothCondition condition;

  const Tooth({
    required this.id,
    required this.type,
    required this.condition,
  });

  String get icon {
    switch (type) {
      case ToothType.INCISOR_1:
      case ToothType.INCISOR_2:
      case ToothType.CANINE:
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

  @override
  List<Object?> get props => [id, type, condition];
}

enum ToothType {
  INCISOR_1,
  INCISOR_2,
  CANINE,
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
}
