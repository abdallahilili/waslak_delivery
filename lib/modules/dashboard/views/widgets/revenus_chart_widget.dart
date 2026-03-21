import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../../models/dashboard_stats_model.dart';
import 'package:intl/intl.dart';

class RevenusChartWidget extends GetView<DashboardController> {
  const RevenusChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Revenus du jour',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Icon(Icons.more_horiz, color: Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat('dd MMM'),
                    majorGridLines: const MajorGridLines(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Revenus (MRU)'),
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true, header: ''),
                  series: <CartesianSeries<DashboardChartData, DateTime>>[
                    ColumnSeries<DashboardChartData, DateTime>(
                      dataSource: controller.revenusData,
                      xValueMapper: (DashboardChartData data, _) => data.date,
                      yValueMapper: (DashboardChartData data, _) => data.value,
                      name: 'Revenus',
                      color: Colors.green,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      width: 0.6,
                    )
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
