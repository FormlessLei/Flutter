import 'package:flutter/material.dart';
import '../data/bagua.dart';
import '../data/liushisi_gua.dart';
import '../models/gua_model.dart';
import 'gua_item.dart';
import 'package:flutter/foundation.dart';

// -------------------------- 常量配置 --------------------------
class GuaMatrixConstants {
  // 行头列宽（固定值，避免动态计算）
  static const double rowHeaderColumnWidth = 40;
  // 矩阵列宽（弹性分配剩余空间）
  static const double matrixColumnFlex = 1;
  // 卦象格子宽高比
  static const double guaItemAspectRatio = 0.8;
  // 内边距/间距（统一小值，减少布局计算）
  static const EdgeInsets globalPadding = EdgeInsets.all(4);
  static const double cellSpacing = 2;
  // 表头文字样式
  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
}
// -------------------------------------------------------------------

class GuaMatrix extends StatelessWidget {
  final LiuShiSiGua? currentGua;
  final LiuShiSiGua? hoveredGua;
  final List<LiuShiSiGua> compareList;
  final bool isComparing;
  final Function(LiuShiSiGua) onGuaTap;
  final Function(int) onYaoHover;
  final Function(int) onYaoExit;

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

  List<String> get _baguaNames => baguas.map((e) => e.name).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: GuaMatrixConstants.globalPadding,
      child: SingleChildScrollView(
        // 仅保留必要的滚动，禁用复杂物理效果
        physics: const ClampingScrollPhysics(),
        child: Table(
          // 表格边框（可选，便于调试对齐）
          border: TableBorder.all(width: 0, color: Colors.transparent),
          // 列宽配置：第0列是行头（固定宽），1-8列是矩阵（弹性宽）
          columnWidths: {
            0: FixedColumnWidth(GuaMatrixConstants.rowHeaderColumnWidth),
            1: const FlexColumnWidth(GuaMatrixConstants.matrixColumnFlex),
            2: const FlexColumnWidth(GuaMatrixConstants.matrixColumnFlex),
            3: const FlexColumnWidth(GuaMatrixConstants.matrixColumnFlex),
            4: const FlexColumnWidth(GuaMatrixConstants.matrixColumnFlex),
            5: const FlexColumnWidth(GuaMatrixConstants.matrixColumnFlex),
            6: const FlexColumnWidth(GuaMatrixConstants.matrixColumnFlex),
            7: const FlexColumnWidth(GuaMatrixConstants.matrixColumnFlex),
            8: const FlexColumnWidth(GuaMatrixConstants.matrixColumnFlex),
          },
          // 单元格垂直对齐：居中，保证行头与卦象对齐
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // 第一行：顶部列头（第0列空，1-8列是经卦名）
            _buildColumnHeaderRow(),
            // 后续8行：行头 + 8个卦象
            ..._buildMatrixRows(),
          ],
        ),
      ),
    );
  }

  // 构建顶部列头行
  TableRow _buildColumnHeaderRow() {
    return TableRow(
      children: [
        // 第0列：空单元格（行头列的列头）
        const SizedBox(height: 40),
        // 1-8列：经卦名
        ..._baguaNames.map((name) => _buildHeaderCell(name, height: 40)),
      ],
    );
  }

  // 构建矩阵的8行数据
  List<TableRow> _buildMatrixRows() {
    return List.generate(8, (row) {
      return TableRow(
        children: [
          // 第0列：行头（经卦名）
          _buildHeaderCell(_baguaNames[row], width: GuaMatrixConstants.rowHeaderColumnWidth),
          // 1-8列：对应列的卦象
          ...List.generate(8, (col) => _buildGuaCell(row, col)),
        ],
      );
    });
  }

  // 构建表头单元格（行头/列头通用）
  Widget _buildHeaderCell(String text, {double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      margin: EdgeInsets.all(GuaMatrixConstants.cellSpacing),
      child: Text(text, style: GuaMatrixConstants.headerTextStyle),
    );
  }

  // 构建卦象单元格
  Widget _buildGuaCell(int row, int col) {
    // 原有卦象匹配逻辑（极简保留，无多余计算）
    final outerGua = baguas[row];
    final innerGua = baguas[col];
    final hexagrams = [...outerGua.trigrams, ...innerGua.trigrams];
    final gua = liuShiSiGua.firstWhere(
      (g) => listEquals(g.hexagrams, hexagrams),
      orElse: () => liuShiSiGua.first,
    );

    final isSelected = currentGua != null && listEquals(currentGua!.hexagrams, gua.hexagrams);
    final isHovered = hoveredGua != null && listEquals(hoveredGua!.hexagrams, gua.hexagrams);
    final isInCompare = compareList.any((g) => listEquals(g.hexagrams, gua.hexagrams));

    // 核心：用AspectRatio固定宽高比，无动态计算
    return Container(
      margin: EdgeInsets.all(GuaMatrixConstants.cellSpacing),
      child: AspectRatio(
        aspectRatio: GuaMatrixConstants.guaItemAspectRatio,
        child: GuaItem(
          gua: gua,
          isSelected: isSelected,
          isHoveredGua: isHovered,
          isInCompare: isInCompare,
          onTap: () => onGuaTap(gua),
          onYaoHover: onYaoHover,
          onYaoExit: onYaoExit,
        ),
      ),
    );
  }
}