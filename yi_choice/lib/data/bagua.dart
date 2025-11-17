import '../models/gua_model.dart';

/// 8经卦配置（顺序决定矩阵行/列，可自定义调整）
const List<Bagua> baguas = [
  (
    name: "乾",
    symbol: "☰",
    trigrams: [1, 1, 1], // 上爻=1，中爻=1，下爻=1（阳阳阳）
  ),
  (
    name: "兑",
    symbol: "☱",
    trigrams: [1, 1, 0], // 阳阳阴
  ),
  // ... 其余6卦（离、震、巽、坎、艮、坤）按顺序补充
];