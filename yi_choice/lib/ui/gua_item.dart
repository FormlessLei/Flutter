import 'package:flutter/material.dart';
import '../data/liushisi_gua.dart'; // 64卦数据
import 'yao_item.dart';

//分层灰色透明渐变：不同区间用不同灰度基础色，透明度同步提升
const Map<int, Color> kDiffYaoColorConfig = {
  0: Color.fromARGB(20, 245, 245, 245), // 0个差异：极浅灰底（#F5F5F5）+ 低透
  1: Color.fromARGB(40, 224, 224, 224), // 1个差异：浅灰底（#E0E0E0）+ 低透
  2: Color.fromARGB(70, 189, 189, 189), // 2个差异：淡灰底（#BDBDBD）+ 中透
  3: Color.fromARGB(100, 158, 158, 158), // 3个差异：中灰底（#9E9E9E）+ 中透
  4: Color.fromARGB(140, 128, 128, 128), // 4个差异：中深灰底（#808080）+ 高透
  5: Color.fromARGB(170, 97, 97, 97), // 5个差异：深灰底（#616161）+ 高透
  6: Color.fromARGB(200, 66, 66, 66), // 6个差异：暗灰底（#424242）+ 最高透
};
// const Map<int, Color> kDiffYaoColorConfig = {
//   0: Color.fromARGB(30, 255, 255, 255), // 0个差异：彩虹白（极透白，打底）
//   1: Color.fromARGB(220, 0, 168, 255), // 5个差异：电光蓝（高饱和）
//   2: Color.fromARGB(220, 0, 217, 64), // 4个差异：荧光绿（高饱和）
//   3: Color.fromARGB(220, 255, 214, 0), // 3个差异：柠檬黄（高饱和）
//   4: Color.fromARGB(220, 255, 123, 0), // 2个差异：日落橙（高饱和）
//   5: Color.fromARGB(255, 255, 0, 68), // 1个差异：霓虹红（高饱和）
//   6: Color.fromARGB(220, 138, 0, 255), // 6个差异：魅惑紫（高饱和）
// };

// 基础状态颜色常量
const Color kVariantHighlightColor = Color.fromARGB(181, 197, 236, 170); // 变卦高亮
const Color kHoverColor = Color.fromARGB(77, 4, 186, 247); // 悬停高亮
const Color kSelectedColor = Color.fromARGB(115, 4, 186, 247); // 选中状态
const Color kCompareColor = Color(0x33008000); // 对比列表
const Color kDefaultColor = Colors.white; // 默认背景色

class GuaItem extends StatefulWidget {
  final LiuShiSiGua gua;
  // final LiuShiSiGua? currentGua;
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
    // this.currentGua,
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
    Color bgColor = Colors.white;

    if (widget.isVariantHighlight) {
      bgColor =kVariantHighlightColor;
    } else if (widget.isSelected) {
      bgColor = kSelectedColor;
    } else if (widget.isGuaGridHovered || _isLocalHover) {
      bgColor = kHoverColor;
    } else if (widget.isInCompare) {
      bgColor = const Color.fromARGB(51, 15, 128, 0);
    }
    // 处理差异爻位的颜色
    // else {
    //   if (widget.currentGua != null) {
    //     final diffYaoIndexes = calculateBianYaoIndexes(
    //       widget.gua,
    //       widget.currentGua!,
    //     );
    //     if (diffYaoIndexes != null && diffYaoIndexes!.isNotEmpty) {
    //       final int diffCount = diffYaoIndexes!.length;
    //       // 从配置中取对应颜色，若超出配置范围则用默认差异色（此处取6个差异的颜色）
    //       bgColor = kDiffYaoColorConfig[diffCount] ?? kDiffYaoColorConfig[6]!;
    //     }
    //   }
    // }

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
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(
              color: widget.isSelected ? Colors.blue : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                blurRadius: 2,
                spreadRadius: 2,
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
