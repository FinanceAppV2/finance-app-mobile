enum AssetType {
  piggyBank,
  fixedIncome,
  variableIncome;

  String get displayName {
    switch (this) {
      case AssetType.piggyBank:
        return 'Poupança';
      case AssetType.fixedIncome:
        return 'Renda Fixa';
      case AssetType.variableIncome:
        return 'Renda Variável';
    }
  }

  String get jsonValue {
    switch (this) {
      case AssetType.piggyBank:
        return 'PIGGY_BANK';
      case AssetType.fixedIncome:
        return 'FIXED_INCOME';
      case AssetType.variableIncome:
        return 'VARIABLE_INCOME';
    }
  }

  static AssetType fromJson(String value) {
    switch (value) {
      case 'PIGGY_BANK':
        return AssetType.piggyBank;
      case 'FIXED_INCOME':
        return AssetType.fixedIncome;
      case 'VARIABLE_INCOME':
        return AssetType.variableIncome;
      default:
        return AssetType.piggyBank;
    }
  }
}
