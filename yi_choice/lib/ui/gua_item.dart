import 'package:flutter/material.dart';
import '../models/gua_model.dart';
import 'yao_item.dart';

class GuaItem extends StatelessWidget {
  final LiuShiSiGua gua; // 当前卦数据
  final bool isSelected; // 是否被选中（当前卦）
  final bool isHoveredGua; // 是否为悬停变爻后的卦
  final bool isInCompare; // 是否在对比列表中
  final VoidCallback onTap; // 点击回调
  final Function(int) onYaoHover; // 爻悬停回调（传爻索引）
  final Function(int) onYaoExit; // 爻离开悬停回调

  const GuaItem({
    super.key,
    required this.gua,
    this.isSelected = false,
    this.isHoveredGua = false,
    this.isInCompare = false,
    required this.onTap,
    required this.onYaoHover,
    required this.onYaoExit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60, // 卦宽度
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _getBackgroundColor(), // 根据状态显示背景色
          border: _getBorder(), // 根据状态显示边框
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 卦名（简洁显示）
            Text(
              gua.fullName,
              style: const TextStyle(fontSize: 12),
            ),
            // 六爻（从初爻到上爻，按索引0-5排列）
            ...List.generate(6, (i) {
              final isYang = gua.hexagrams[i] == 1; // 注意：此处依赖六爻顺序！
              return YaoItem(
                isYang: isYang,
                index: i,
                isHovered: false, // 暂不处理爻自身悬停样式，由父组件控制
                onHover: () => onYaoHover(i),
                onExit: () => onYaoExit(i),
              );
            }),
          ],
        ),
      ),
    );
  }

  // 根据状态获取背景色（选中/悬停/对比）
  Color _getBackgroundColor() {
    if (isSelected) return Colors.blue[100]!;
    if (isHoveredGua) return Colors.green[100]!;
    if (isInCompare) return Colors.orange[100]!;
    return Colors.white;
  }

  // 根据状态获取边框
  Border _getBorder() {
    if (isSelected) {
      return Border.all(color: Colors.blue, width: 2);
    } else if (isInCompare) {
      return Border.all(color: Colors.orange, width: 2);
    }
    return Border.all(color: Colors.grey, width: 1);
  }
}