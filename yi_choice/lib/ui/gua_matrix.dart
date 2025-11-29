import 'package:flutter/material.dart';
import '../data/liushisi_gua.dart'; // 64卦数据
import 'gua_item.dart'; // 卦项组件

class GuaMatrixConstants {
  static const double rowHeaderColumnWidth = 40;
  static const double matrixColumnFlex = 1;
  static const double guaItemAspectRatio = 0.8;
  static const EdgeInsets globalPadding = EdgeInsets.all(4);
  static const double cellSpacing = 2;
  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
}

class GuaMatrix extends StatelessWidget {
  final LiuShiSiGua? currentGua; // 选中的卦
  final LiuShiSiGua? hoveredGuaGrid; // 矩阵中悬停的卦
  final int? hoveredYaoIndexOfCurrent; // 选中卦悬停的爻位
  final List<LiuShiSiGua> currentGuaVariants; // 选中卦的6个变卦
  final List<LiuShiSiGua> compareList; // 对比列表
  final bool isComparing; // 是否处于对比模式
  final Function(LiuShiSiGua) onGuaTap; // 卦点击回调
  final Function(LiuShiSiGua) onGuaGridHover; // 矩阵卦悬停回调
  final Function() onGuaGridExit; // 矩阵卦离开回调
  final Function(int) onCurrentGuaYaoHover; // 选中卦爻悬停回调
  final Function() onCurrentGuaYaoExit; // 选中卦爻离开回调

  const GuaMatrix({
    super.key,
    this.currentGua,
    this.hoveredGuaGrid,
    this.hoveredYaoIndexOfCurrent,
    required this.currentGuaVariants,
    required this.compareList,
    required this.isComparing,
    required this.onGuaTap,
    required this.onGuaGridHover,
    required this.onGuaGridExit,
    required this.onCurrentGuaYaoHover,
    required this.onCurrentGuaYaoExit,
  });

  // 获取8经卦的名称列表
  List<String> get _baguaNames => baguas.map((e) => e.name).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: GuaMatrixConstants.globalPadding,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Table(
          border: TableBorder.all(width: 0, color: Colors.transparent),
          columnWidths: {
            0: FixedColumnWidth(GuaMatrixConstants.rowHeaderColumnWidth),
            for (int i = 1; i <= 8; i++)
              i: const FlexColumnWidth(GuaMatrixConstants.matrixColumnFlex),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [_buildColumnHeaderRow(), ..._buildMatrixRows()],
        ),
      ),
    );
  }

  // 构建列头（8经卦名称）
  TableRow _buildColumnHeaderRow() {
    return TableRow(
      children: [
        const SizedBox(height: 40), // 第一列空单元格（行头的列头）
        ..._baguaNames.map((name) => _buildHeaderCell(name, height: 40)),
      ],
    );
  }

  // 构建矩阵行（8行，每行对应一个外卦）
  List<TableRow> _buildMatrixRows() {
    return List.generate(8, (row) {
      return TableRow(
        children: [
          // 行头（8经卦名称）
          _buildHeaderCell(
            _baguaNames[row],
            width: GuaMatrixConstants.rowHeaderColumnWidth,
          ),
          // 每行8个单元格（列），对应内卦
          ...List.generate(8, (col) => _buildGuaCell(row, col)),
        ],
      );
    });
  }

  // 构建头单元格（行/列头）
  Widget _buildHeaderCell(String text, {double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      margin: EdgeInsets.all(GuaMatrixConstants.cellSpacing),
      child: Text(
        text,
        style: GuaMatrixConstants.headerTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  // 构建卦单元格（核心：外卦+内卦拼接64卦）
  Widget _buildGuaCell(int row, int col) {
    // 1. 获取外卦（行）和内卦（列）的三爻序列
    final outerGua = baguas[row];
    final innerGua = baguas[col];
    // 拼接六爻序列：外卦三爻（上） + 内卦三爻（下）→ 64卦的六爻
    final hexagrams = [...outerGua.trigrams, ...innerGua.trigrams];

    // 2. 根据六爻序列匹配对应的64卦
    final gua = liushisiGuaList.firstWhere(
      (g) => gListEquals(g.yaoList, hexagrams),
      orElse: () => liushisiGuaList.first, // 无匹配时返回乾为天
    );

    // 3. 状态判断（核心：适配悬停/选中/变卦高亮需求）
    final isSelected =
        currentGua != null && gListEquals(currentGua!.yaoList, gua.yaoList);
    final isInCompare = compareList.any(
      (g) => gListEquals(g.yaoList, gua.yaoList),
    );
    final isGuaGridHovered =
        hoveredGuaGrid != null &&
        gListEquals(hoveredGuaGrid!.yaoList, gua.yaoList);

    // 变卦高亮：①爻悬停→高亮对应变卦 ②选中卦悬停→高亮所有变卦
    bool isVariantHighlight = false;
    if (currentGua != null && currentGuaVariants.isNotEmpty) {
      if (hoveredYaoIndexOfCurrent != null &&
          hoveredYaoIndexOfCurrent! >= 0 &&
          hoveredYaoIndexOfCurrent! < 6) {
        // 选中卦的爻悬停→高亮对应变卦
        isVariantHighlight = gListEquals(
          gua.yaoList,
          currentGuaVariants[hoveredYaoIndexOfCurrent!].yaoList,
        );
      } else if (isGuaGridHovered && isSelected) {
        // 选中卦自身悬停→高亮所有6个变卦
        isVariantHighlight = currentGuaVariants.any(
          (v) => gListEquals(v.yaoList, gua.yaoList),
        );
      } else if (currentGuaVariants.contains(gua)) {
        isVariantHighlight = true;
      }
    }

    final List<int>? diffYaoIndexes =
        (hoveredGuaGrid != null && currentGua != null)
        ? calculateBianYaoIndexes(currentGua!, hoveredGuaGrid!)
        : null;

    // 4. 返回卦项组件
    return IntrinsicWidth(
      child: AspectRatio(
        aspectRatio: GuaMatrixConstants.guaItemAspectRatio,
        child: GuaItem(
          gua: gua,
          // currentGua: currentGua,
          isSelected: isSelected,
          isGuaGridHovered: isGuaGridHovered,
          isVariantHighlight: isVariantHighlight,
          isInCompare: isInCompare,
          hoveredYaoIndex: hoveredYaoIndexOfCurrent, // 新增：传递悬停爻位
          diffYaoIndexes: diffYaoIndexes,
          onGuaTap: () => onGuaTap(gua),
          onGuaGridHover: () => onGuaGridHover(gua),
          onGuaGridExit: onGuaGridExit,
          onYaoHover: isSelected ? onCurrentGuaYaoHover : null,
          onYaoExit: isSelected ? onCurrentGuaYaoExit : null,
        ),
      ),
    );
  }
}
