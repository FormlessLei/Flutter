import '../models/gua_model.dart';

/// 8经卦配置（先天八卦顺序：乾、兑、离、震、巽、坎、艮、坤）
/// 三爻序列规则：[上爻, 中爻, 下爻]，1=阳爻，0=阴爻
const List<Bagua> baguas = [
  (
    name: "乾",
    symbol: "☰",
    trigrams: [1, 1, 1], // 上爻阳、中爻阳、下爻阳
  ),
  (
    name: "兑",
    symbol: "☱",
    trigrams: [1, 1, 0], // 上爻阳、中爻阳、下爻阴
  ),
  (
    name: "离",
    symbol: "☲",
    trigrams: [1, 0, 1], // 上爻阳、中爻阴、下爻阳
  ),
  (
    name: "震",
    symbol: "☳",
    trigrams: [0, 0, 1], // 上爻阴、中爻阴、下爻阳
  ),
  (
    name: "巽",
    symbol: "☴",
    trigrams: [0, 1, 1], // 上爻阴、中爻阳、下爻阳
  ),
  (
    name: "坎",
    symbol: "☵",
    trigrams: [0, 1, 0], // 上爻阴、中爻阳、下爻阴
  ),
  (
    name: "艮",
    symbol: "☶",
    trigrams: [1, 0, 0], // 上爻阳、中爻阴、下爻阴
  ),
  (
    name: "坤",
    symbol: "☷",
    trigrams: [0, 0, 0], // 上爻阴、中爻阴、下爻阴
  ),
];