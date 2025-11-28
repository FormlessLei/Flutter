/// 8经卦模型（三爻）
typedef Bagua = ({
  String name,       // 卦名（如"乾"）
  String symbol,     // 符号（如"☰"）
  List<int> trigrams // 三爻阴阳序列（1=阳，0=阴，顺序：上爻→下爻，固定！）
});

/// 64卦模型（六爻）
typedef LiuShiSiGua = ({
  String name,       // 卦名（如"乾为天"）
  String shortName,   // 简称（如"乾"）
  List<int> yaoList, // 六爻阴阳序列（顺序：上爻→初爻，固定！）
  String guaCi,      // 卦辞
  List<String> yaoCi // 六爻爻辞（索引0=初爻，5=上爻）
});