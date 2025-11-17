import 'package:flutter/material.dart';
import '../data/bagua.dart';
import '../data/liushisi_gua.dart';
import '../models/gua_model.dart';
import 'gua_item.dart';
import 'package:flutter/foundation.dart';

class GuaMatrix extends StatelessWidget {
  final LiuShiSiGua? currentGua; // 当前选中卦
  final LiuShiSiGua? hoveredGua; // 悬停变爻后的卦
  final List<LiuShiSiGua> compareList; // 对比列表
  final bool isComparing; // 是否在对比状态
  final Function(LiuShiSiGua) onGuaTap; // 点击卦回调
  final Function(int) onYaoHover; // 爻悬停回调（传爻索引）
  final Function(int) onYaoExit; // 爻离开悬停回调

  const GuaMatrix({
    super.key,
    this.currentGua,
    this.hoveredGua,
    required this.compareList,
    required this.isComparing,
    required this.onGuaTap,
    required this.onYaoHover,
    required this.onYaoExit,
  });

  @override
  Widget build(BuildContext context) {
    // 矩阵为8x8（行=外卦，列=内卦）
    return GridView.count(
      crossAxisCount: 8, // 8列（内卦）
      childAspectRatio: 1, // 宽高比1:1
      padding: const EdgeInsets.all(8),
      children: [
        // 遍历外卦（行）和内卦（列），生成64卦
        for (int row = 0; row < 8; row++) // 外卦索引
          for (int col = 0; col < 8; col++) // 内卦索引
            _buildGuaItem(row, col),
      ],
    );
  }

  // 根据外卦行、内卦列，生成对应的64卦Item
  Widget _buildGuaItem(int outerIndex, int innerIndex) {
    // 1. 获取外卦和内卦的三爻序列
    final outerTrigram = baguas[outerIndex].trigrams; // 外卦三爻
    final innerTrigram = baguas[innerIndex].trigrams; // 内卦三爻
    // 2. 组合为六爻序列（外卦三爻 + 内卦三爻，顺序必须与64卦配置一致！）
    final hexagrams = [...outerTrigram, ...innerTrigram];
    // 3. 查找对应的64卦（核心：动态匹配）
    final gua = liuShiSiGua.firstWhere(
      (g) => listEquals(g.hexagrams, hexagrams),
      orElse: () => throw "未找到对应卦：$hexagrams", // 配置正确则不会触发
    );
    // 4. 判断当前卦的状态（选中/悬停/对比）
    final isSelected = currentGua != null && listEquals(currentGua!.hexagrams, gua.hexagrams);
    final isHovered = hoveredGua != null && listEquals(hoveredGua!.hexagrams, gua.hexagrams);
    final isInCompare = compareList.any((g) => listEquals(g.hexagrams, gua.hexagrams));

    // 5. 返回卦组件
    return GuaItem(
      gua: gua,
      isSelected: isSelected,
      isHoveredGua: isHovered,
      isInCompare: isInCompare,
      onTap: () => onGuaTap(gua),
      onYaoHover: onYaoHover,
      onYaoExit: onYaoExit,
    );
  }
}