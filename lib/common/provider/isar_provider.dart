import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';

final isarProvieder = FutureProvider<Isar>((ref) async {
  final isar =
      await Isar.open([TransactionSchema,TransactionCategorySchema, GoalSchema, WalletSchema]);
  return isar;
});
