import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';

final budgetTypeProvider = StateNotifierProvider<BudgetTypeNotifier, BudgetType>((ref) {
  return BudgetTypeNotifier();
});

class BudgetTypeNotifier extends StateNotifier<BudgetType> {
  BudgetTypeNotifier(): super(BudgetType.dontSet);
  
  void setBudgetType(BudgetType type) {
    state = type;
  }
}