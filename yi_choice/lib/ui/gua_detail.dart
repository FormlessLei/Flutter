import 'package:flutter/material.dart';
import '../data/liushisi_gua.dart'; // 64卦数据


class GuaDetail extends StatelessWidget {
  final LiuShiSiGua? gua; // 当前选中的卦（可为null）

  const GuaDetail({super.key, this.gua});

  @override
  Widget build(BuildContext context) {
    if (gua == null) {
      return const Center(child: Text("请选择一个卦"));
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 卦名
          Text(
            gua!.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // 卦辞
          Text("卦辞：", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          const SizedBox(height: 8),
          Text(
            gua!.guaCi,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          // 爻辞
          Text("爻辞：", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          const SizedBox(height: 8),
          ...List.generate(6, (i) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                gua!.yaoCi[i],
                style: const TextStyle(fontSize: 16),
              ),
            );
          }),
        ],
      ),
    );
  }
}