import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

import '../../di.dart';
import '../accounts/models/account.dart';
import '../accounts/module.dart';
import '../balances/widgets/context_ext.dart';
import 'data/repository.dart';
import 'services/cancel_tx_created_watcher.dart';
import 'services/cancel_tx_sent_watcher.dart';
import 'services/tx_confirmed_watcher.dart';
import 'services/tx_created_watcher.dart';
import 'services/tx_ready_watcher.dart';
import 'services/tx_sent_watcher.dart';

class OSKPModule extends SingleChildStatelessWidget {
  const OSKPModule({super.key, super.child});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) => MultiProvider(
        providers: [
          Provider<TxReadyWatcher>(
            lazy: false,
            create: (context) => sl<TxReadyWatcher>(
              param1: context.read<MyAccount>().wallet.publicKey,
            )..init(onBalanceAffected: () => context.notifyBalanceAffected()),
            dispose: (_, value) => value.dispose(),
          ),
          Provider<TxConfirmedWatcher>(
            lazy: false,
            create: (context) => sl<TxConfirmedWatcher>()
              ..call(onBalanceAffected: () => context.notifyBalanceAffected()),
            dispose: (_, value) => value.dispose(),
          ),
          Provider<TxCreatedWatcher>(
            lazy: false,
            create: (context) => sl<TxCreatedWatcher>()
              ..call(onBalanceAffected: () => context.notifyBalanceAffected()),
            dispose: (_, value) => value.dispose(),
          ),
          Provider<TxSentWatcher>(
            lazy: false,
            create: (context) => sl<TxSentWatcher>()
              ..call(onBalanceAffected: () => context.notifyBalanceAffected()),
            dispose: (_, value) => value.dispose(),
          ),
          Provider<CancelTxCreatedWatcher>(
            lazy: false,
            create: (context) => sl<CancelTxCreatedWatcher>()
              ..call(onBalanceAffected: () => context.notifyBalanceAffected()),
            dispose: (_, value) => value.dispose(),
          ),
          Provider<CancelTxSentWatcher>(
            lazy: false,
            create: (context) => sl<CancelTxSentWatcher>()
              ..call(onBalanceAffected: () => context.notifyBalanceAffected()),
            dispose: (_, value) => value.dispose(),
          ),
        ],
        child: LogoutListener(
          onLogout: (_) => sl<OSKPRepository>().clear(),
          child: child,
        ),
      );
}
