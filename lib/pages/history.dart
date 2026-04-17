import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartwallet/database/database.dart';
import 'package:smartwallet/utils/double_formatter.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final moneys = WalletDb.instance.getMoneyList().reversed.toList();

    if (moneys.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            "No transaction history yet.",
            style: Theme.of(context).textTheme.bodyLarge,
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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return HistoryListTile(
                money: moneys[index],
                balance: doubleFormatter(WalletDb.instance
                    .balanceAtIndex(moneys.length - index - 1)),
              );
            },
            childCount: moneys.length,
          ),
        ),
      ],
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
