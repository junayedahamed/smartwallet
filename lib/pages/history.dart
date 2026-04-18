import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:smartwallet/database/database.dart';
import 'package:smartwallet/utils/double_formatter.dart';
import 'package:smartwallet/l10n/l10n.dart';

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
    final colorScheme = theme.colorScheme;

    if (WalletDb.instance.getMoneyList().isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            L10n.tr(context, "no_history_yet"),
            style: theme.textTheme.bodyLarge,
          ),
        ),
      );
    }

    // Grouping logic
    final Map<String, List<Money>> groupedMoneys = {};
    for (var money in filteredMoneys) {
      final dateKey = DateFormat("yyyy-MM-dd").format(money.dateTime);
      if (!groupedMoneys.containsKey(dateKey)) {
        groupedMoneys[dateKey] = [];
      }
      groupedMoneys[dateKey]!.add(money);
    }

    final sortedDates = groupedMoneys.keys.toList()
      ..sort((a, b) => b.compareTo(a));

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
                      L10n.tr(context, "transaction_timeline"),
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
                  L10n.tr(context, "no_transactions_found_period"),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          )
        else
          for (var dateKey in sortedDates) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatHeaderDate(context, dateKey),
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        "${L10n.tr(context, 'total')} ${doubleFormatter(groupedMoneys[dateKey]!.fold(0, (sum, m) => sum + m.amount))}",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final money = groupedMoneys[dateKey]![index];
                  final allReversed =
                      WalletDb.instance.getMoneyList().reversed.toList();
                  final transactionIndex = allReversed.indexOf(money);

                  return HistoryListTile(
                    money: money,
                    balance: doubleFormatter(
                      WalletDb.instance.balanceAtIndex(
                          allReversed.length - transactionIndex - 1),
                    ),
                  );
                },
                childCount: groupedMoneys[dateKey]!.length,
              ),
            ),
          ],
      ],
    );
  }

  String _formatHeaderDate(BuildContext context, String dateKey) {
    final date = DateTime.parse(dateKey);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return L10n.tr(context, "today");
    } else if (transactionDate == yesterday) {
      return L10n.tr(context, "yesterday");
    } else {
      return DateFormat("MMMM dd, yyyy").format(date);
    }
  }

  Widget _buildFilterBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10n.tr(context, "filter_by_date"),
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterButton(
                label: L10n.tr(context, "all_time"),
                isSelected: _filterType == 'all',
                onPressed: () => setState(() {
                  _filterType = 'all';
                  _selectedDate = null;
                }),
              ),
              const SizedBox(width: 8),
              _FilterButton(
                label: L10n.tr(context, "last_1_day"),
                isSelected: _filterType == '1day',
                onPressed: () => setState(() {
                  _filterType = '1day';
                  _selectedDate = null;
                }),
              ),
              const SizedBox(width: 8),
              _FilterButton(
                label: L10n.tr(context, "last_3_days"),
                isSelected: _filterType == '3days',
                onPressed: () => setState(() {
                  _filterType = '3days';
                  _selectedDate = null;
                }),
              ),
              const SizedBox(width: 8),
              _FilterButton(
                label: L10n.tr(context, "last_7_days"),
                isSelected: _filterType == '7days',
                onPressed: () => setState(() {
                  _filterType = '7days';
                  _selectedDate = null;
                }),
              ),
              const SizedBox(width: 8),
              _FilterButton(
                label: L10n.tr(context, "last_30_days"),
                isSelected: _filterType == '30days',
                onPressed: () => setState(() {
                  _filterType = '30days';
                  _selectedDate = null;
                }),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => _showDatePicker(context),
                icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedCalendar01,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 20,
                    strokeWidth: 2.0),
                label: _selectedDate == null
                    ? Text(L10n.tr(context, "pick_date"))
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
    final isIncome = money.amount >= 0;

    final iconColor = isIncome ? Colors.green : Colors.red;
    final bgColor = iconColor.withValues(alpha: 0.1);
    final amountColor = isIncome ? Colors.green : Colors.red;

    final reason = (money.reason == null || money.reason!.trim().isEmpty)
        ? (isIncome ? L10n.tr(context, "income") : L10n.tr(context, "expense"))
        : money.reason!.trim();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          // Circular Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: HugeIcon(
                icon: isIncome
                    ? HugeIcons.strokeRoundedArrowUp01
                    : HugeIcons.strokeRoundedArrowDown01,
                color: iconColor,
                size: 20,
                strokeWidth: 2.0,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  reason,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _getRelativeDate(context, money.dateTime),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${isIncome ? '+' : ''}${doubleFormatter(money.amount)}",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (balance != null)
                Text(
                  "Bal: $balance",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _getRelativeDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return L10n.tr(context, "today");
    } else if (transactionDate == yesterday) {
      return L10n.tr(context, "yesterday");
    } else {
      return DateFormat("dd MMM yyyy").format(date);
    }
  }
}
