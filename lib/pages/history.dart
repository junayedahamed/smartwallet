import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartwallet/database/database.dart';
import 'package:smartwallet/utils/double_formatter.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime? _selectedDate;
  String _filterType = 'all';

  List<Money> _getFilteredMoneys() {
    final allMoneys = WalletDb.instance.getMoneyList().reversed.toList();
    final now = DateTime.now();

    switch (_filterType) {
      case '1day':
        return allMoneys
            .where((m) =>
                m.dateTime.isAfter(now.subtract(const Duration(days: 1))))
            .toList();
      case '3days':
        return allMoneys
            .where((m) =>
                m.dateTime.isAfter(now.subtract(const Duration(days: 3))))
            .toList();
      case '7days':
        return allMoneys
            .where((m) =>
                m.dateTime.isAfter(now.subtract(const Duration(days: 7))))
            .toList();
      case '30days':
        return allMoneys
            .where((m) =>
                m.dateTime.isAfter(now.subtract(const Duration(days: 30))))
            .toList();
      case 'custom':
        if (_selectedDate == null) return [];
        return allMoneys
            .where((m) =>
                m.dateTime.year == _selectedDate!.year &&
                m.dateTime.month == _selectedDate!.month &&
                m.dateTime.day == _selectedDate!.day)
            .toList();
      default:
        return allMoneys;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredMoneys = _getFilteredMoneys();
    final theme = Theme.of(context);

    if (WalletDb.instance.getMoneyList().isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            "No transaction history yet.",
            style: theme.textTheme.bodyLarge,
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image(
                        image: const AssetImage("assets/animated/history.gif")
                          ..evict(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Transaction timeline",
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: _buildFilterBar(context),
          ),
        ),
        if (filteredMoneys.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  "No transactions found for this period.",
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final reversedList =
                    WalletDb.instance.getMoneyList().reversed.toList();
                final transactionIndex =
                    reversedList.indexOf(filteredMoneys[index]);
                return HistoryListTile(
                  money: filteredMoneys[index],
                  balance: doubleFormatter(
                    WalletDb.instance.balanceAtIndex(transactionIndex),
                  ),
                );
              },
              childCount: filteredMoneys.length,
            ),
          ),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Filter by date",
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterButton(
                label: "All time",
                isSelected: _filterType == 'all',
                onPressed: () => setState(() {
                  _filterType = 'all';
                  _selectedDate = null;
                }),
              ),
              const SizedBox(width: 8),
              _FilterButton(
                label: "Last 1 day",
                isSelected: _filterType == '1day',
                onPressed: () => setState(() {
                  _filterType = '1day';
                  _selectedDate = null;
                }),
              ),
              const SizedBox(width: 8),
              _FilterButton(
                label: "Last 3 days",
                isSelected: _filterType == '3days',
                onPressed: () => setState(() {
                  _filterType = '3days';
                  _selectedDate = null;
                }),
              ),
              const SizedBox(width: 8),
              _FilterButton(
                label: "Last 7 days",
                isSelected: _filterType == '7days',
                onPressed: () => setState(() {
                  _filterType = '7days';
                  _selectedDate = null;
                }),
              ),
              const SizedBox(width: 8),
              _FilterButton(
                label: "Last 30 days",
                isSelected: _filterType == '30days',
                onPressed: () => setState(() {
                  _filterType = '30days';
                  _selectedDate = null;
                }),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => _showDatePicker(context),
                icon: const Icon(Icons.calendar_today_rounded),
                label: _selectedDate == null
                    ? const Text("Pick date")
                    : Text(DateFormat("dd MMM").format(_selectedDate!)),
                style: FilledButton.styleFrom(
                  backgroundColor: _filterType == 'custom'
                      ? colorScheme.primary
                      : colorScheme.primaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _filterType = 'custom';
      });
    }
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;

    return isSelected
        ? FilledButton(
            onPressed: onPressed,
            child: Text(label),
          )
        : OutlinedButton(
            onPressed: onPressed,
            child: Text(label),
          );
  }
}

class HistoryListTile extends StatelessWidget {
  const HistoryListTile({super.key, required this.money, this.balance});

  final Money money;
  final String? balance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final amountColor =
        (money.amount >= 0) ? colorScheme.primary : colorScheme.error;
    final reason = (money.reason == null || money.reason!.trim().isEmpty)
        ? "No reason"
        : money.reason!.trim();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.9),
            width: 1.1,
          ),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          title: Text(
            reason,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall,
          ),
          subtitle: Text(
            "${DateFormat("dd MMM yyyy • hh:mm a").format(money.dateTime)}\nBalance: ${balance ?? "--"}",
            style: theme.textTheme.bodySmall,
          ),
          isThreeLine: true,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                (money.amount >= 0) ? "Added" : "Spent",
                style: theme.textTheme.labelSmall,
              ),
              const SizedBox(height: 2),
              Text(
                doubleFormatter(money.amount),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
