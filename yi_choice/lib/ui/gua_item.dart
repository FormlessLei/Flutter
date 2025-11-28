import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/gua_model.dart';
import 'yao_item.dart';

class GuaItem extends StatefulWidget {
  final LiuShiSiGua gua;
  final bool isSelected; // 是否为选中卦
  final bool isGuaGridHovered; // 矩阵中卦的悬停状态
  final bool isVariantHighlight; // 变卦高亮状态
  final bool isInCompare; // 是否在对比列表
  final int? hoveredYaoIndex; // 选中卦的悬停爻位
  final List<int>? diffYaoIndexes; // 选中卦和悬停卦对比时的差异爻位
  final Function() onGuaTap; // 点击回调
  final Function() onGuaGridHover; // 矩阵卦悬停回调
  final Function() onGuaGridExit; // 矩阵卦离开回调
  final Function(int)? onYaoHover; // 爻悬停回调（仅选中卦）
  final Function()? onYaoExit; // 爻离开回调（仅选中卦）

  const GuaItem({
    super.key,
    required this.gua,
    required this.isSelected,
    required this.isGuaGridHovered,
    required this.isVariantHighlight,
    required this.isInCompare,
    this.hoveredYaoIndex,
    this.diffYaoIndexes,
    required this.onGuaTap,
    required this.onGuaGridHover,
    required this.onGuaGridExit,
    this.onYaoHover,
    this.onYaoExit,
  });

  @override
  State<GuaItem> createState() => _GuaItemState();
}

class _GuaItemState extends State<GuaItem> {
  bool _isLocalHover = false; // 本地悬停状态

  @override
  Widget build(BuildContext context) {
    //     final maxWidth = widget.;

    // // 动态计算尺寸（基于宽度的比例）
    // final itemHeight = maxWidth * 1.5; // 高度为宽度的1.5倍
    // final guaNameFontSize = maxWidth * 0.15; // 卦名字体为宽度的15%
    // final yaoFontSize = maxWidth * 0.2; // 爻字体为宽度的20%

    Color bgColor = Colors.white;
    if (widget.isVariantHighlight) {
      bgColor = Colors.red.withOpacity(0.2); // 变卦高亮（纯红浅背景）
    } else if (widget.isGuaGridHovered || _isLocalHover) {
      bgColor = Colors.lightBlue.withOpacity(0.3); // 悬停高亮
    } else if (widget.isSelected) {
      bgColor = Colors.blue.withOpacity(0.2); // 选中状态
    } else if (widget.isInCompare) {
      bgColor = Colors.green.withOpacity(0.2); // 对比列表
    }

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isLocalHover = true);
        widget.onGuaGridHover(); // 触发矩阵卦悬停回调
      },
      onExit: (_) {
        setState(() => _isLocalHover = false);
        widget.onGuaGridExit(); // 触发矩阵卦离开回调
      },
      child: GestureDetector(
        onTap: widget.onGuaTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          // height: itemHeight,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(
              color: widget.isSelected ? Colors.blue : Colors.grey,
              width: widget.isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              // 新增阴影，让卦框更立体
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 2,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 15,
          ), // 增大内边距
          child: Column(
            children: [
              // 卦名：占1份空间，自动适配字体
              Expanded(
                flex: 1,
                child: FittedBox(
                  // 防止卦名过长溢出，自动缩放
                  fit: BoxFit.contain,
                  child: Text(
                    widget.gua.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // 六爻容器（占主要空间）
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // 居中紧凑排列
                  mainAxisSize: MainAxisSize.min, // 仅占最小必要空间
                  children: widget.gua.yaoList.asMap().entries.map((entry) {
                    final yaoIndex = entry.key;
                    final yaoValue = entry.value;
                    final isYaoHighlight =
                        (widget.isSelected || widget.isVariantHighlight) &&
                        widget.hoveredYaoIndex == yaoIndex;
                    final isYaoInDiff =
                        (widget.isGuaGridHovered || widget.isSelected) &&
                        (widget.diffYaoIndexes != null &&
                            widget.diffYaoIndexes!.contains(yaoIndex));
                    // 还有一种高亮情况：如果没有选中任何爻，而且有选中卦，并且悬浮在另一个卦上。悬浮卦和选中卦都高亮。
                    // 所需信息：当前谁悬浮widget.isGuaGridHovered，当前谁选中 widget.isSelected。此爻是否属于
                    return Flexible(
                      child: YaoItem(
                        yaoValue: yaoValue,
                        yaoIndex: yaoIndex,
                        isHighlight: isYaoHighlight || isYaoInDiff,
                        isSelectedGua: widget.isSelected,
                        onYaoHover: (index) {
                          if (widget.onYaoHover != null) {
                            widget.onYaoHover!(index);
                          }
                        },
                        onYaoExit: () {
                          if (widget.onYaoExit != null) {
                            widget.onYaoExit!();
                          }
                        },
                        fontSize: 20,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
