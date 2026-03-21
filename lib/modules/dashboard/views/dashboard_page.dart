import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import 'widgets/kpi_cards_section.dart';
import 'widgets/commandes_chart_widget.dart';
import 'widgets/revenus_chart_widget.dart';
import 'widgets/livreurs_map_widget.dart';
import 'widgets/recent_commandes_widget.dart';
import 'widgets/alerts_widget.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Tableau de Bord Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshStats,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadDashboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),

              const AlertsWidget(),
              const SizedBox(height: 24),

              const KPICardsSection(),
              const SizedBox(height: 32),

              _buildChartsGrid(),
              const SizedBox(height: 32),

              const LivreursMapWidget(),
              const SizedBox(height: 32),

              const RecentCommandesWidget(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vue d\'ensemble en temps réel',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            Text(
              'Suivez vos performances',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildPeriodSelector(),
          ],
        ),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ToggleButtons(
        isSelected: const [true, false, false],
        onPressed: (index) {
          // Logic for period change
        },
        borderRadius: BorderRadius.circular(8),
        selectedColor: Colors.white,
        fillColor: Colors.blue,
        color: Colors.grey.shade600,
        constraints: const BoxConstraints(minHeight: 36, minWidth: 100),
        renderBorder: false,
        children: const [
          Text(
            'Aujourd\'hui',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(
            'Semaine',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(
            'Mois',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(child: CommandesChartWidget()),
              SizedBox(width: 24),
              Expanded(child: RevenusChartWidget()),
            ],
          );
        } else {
          return Column(
            children: const [
              CommandesChartWidget(),
              SizedBox(height: 24),
              RevenusChartWidget(),
            ],
          );
        }
      },
    );
  }
}
