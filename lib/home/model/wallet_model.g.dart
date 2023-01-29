// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetWalletCollection on Isar {
  IsarCollection<Wallet> get wallets => this.collection();
}

const WalletSchema = CollectionSchema(
  name: r'Wallet',
  id: 8666280453615945738,
  properties: {
    r'balance': PropertySchema(
      id: 0,
      name: r'balance',
      type: IsarType.long,
    ),
    r'budget': PropertySchema(
      id: 1,
      name: r'budget',
      type: IsarType.object,
      target: r'BudgetModel',
    ),
    r'budgetType': PropertySchema(
      id: 2,
      name: r'budgetType',
      type: IsarType.string,
      enumMap: _WalletbudgetTypeEnumValueMap,
    ),
    r'imgAddr': PropertySchema(
      id: 3,
      name: r'imgAddr',
      type: IsarType.string,
    ),
    r'isSelected': PropertySchema(
      id: 4,
      name: r'isSelected',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _walletEstimateSize,
  serialize: _walletSerialize,
  deserialize: _walletDeserialize,
  deserializeProp: _walletDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'BudgetModel': BudgetModelSchema},
  getId: _walletGetId,
  getLinks: _walletGetLinks,
  attach: _walletAttach,
  version: '3.0.5',
);

int _walletEstimateSize(
  Wallet object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 +
      BudgetModelSchema.estimateSize(
          object.budget, allOffsets[BudgetModel]!, allOffsets);
  bytesCount += 3 + object.budgetType.name.length * 3;
  bytesCount += 3 + object.imgAddr.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _walletSerialize(
  Wallet object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.balance);
  writer.writeObject<BudgetModel>(
    offsets[1],
    allOffsets,
    BudgetModelSchema.serialize,
    object.budget,
  );
  writer.writeString(offsets[2], object.budgetType.name);
  writer.writeString(offsets[3], object.imgAddr);
  writer.writeBool(offsets[4], object.isSelected);
  writer.writeString(offsets[5], object.name);
}

Wallet _walletDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Wallet(
    balance: reader.readLongOrNull(offsets[0]) ?? 0,
    budget: reader.readObjectOrNull<BudgetModel>(
          offsets[1],
          BudgetModelSchema.deserialize,
          allOffsets,
        ) ??
        BudgetModel(),
    budgetType:
        _WalletbudgetTypeValueEnumMap[reader.readStringOrNull(offsets[2])] ??
            BudgetType.dontSet,
    imgAddr: reader.readStringOrNull(offsets[3]) ??
        "asset/img/bank/금융아이콘_PNG_카카오뱅크.png",
    isSelected: reader.readBoolOrNull(offsets[4]) ?? false,
    name: reader.readString(offsets[5]),
  );
  object.id = id;
  return object;
}

P _walletDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readObjectOrNull<BudgetModel>(
            offset,
            BudgetModelSchema.deserialize,
            allOffsets,
          ) ??
          BudgetModel()) as P;
    case 2:
      return (_WalletbudgetTypeValueEnumMap[reader.readStringOrNull(offset)] ??
          BudgetType.dontSet) as P;
    case 3:
      return (reader.readStringOrNull(offset) ??
          "asset/img/bank/금융아이콘_PNG_카카오뱅크.png") as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _WalletbudgetTypeEnumValueMap = {
  r'dontSet': r'dontSet',
  r'perWeek': r'perWeek',
  r'perMonth': r'perMonth',
  r'perSpecificDate': r'perSpecificDate',
};
const _WalletbudgetTypeValueEnumMap = {
  r'dontSet': BudgetType.dontSet,
  r'perWeek': BudgetType.perWeek,
  r'perMonth': BudgetType.perMonth,
  r'perSpecificDate': BudgetType.perSpecificDate,
};

Id _walletGetId(Wallet object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _walletGetLinks(Wallet object) {
  return [];
}

void _walletAttach(IsarCollection<dynamic> col, Id id, Wallet object) {
  object.id = id;
}

extension WalletQueryWhereSort on QueryBuilder<Wallet, Wallet, QWhere> {
  QueryBuilder<Wallet, Wallet, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WalletQueryWhere on QueryBuilder<Wallet, Wallet, QWhereClause> {
  QueryBuilder<Wallet, Wallet, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WalletQueryFilter on QueryBuilder<Wallet, Wallet, QFilterCondition> {
  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> balanceEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'balance',
        value: value,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> balanceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'balance',
        value: value,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> balanceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'balance',
        value: value,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> balanceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'balance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> budgetTypeEqualTo(
    BudgetType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'budgetType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> budgetTypeGreaterThan(
    BudgetType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'budgetType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> budgetTypeLessThan(
    BudgetType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'budgetType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> budgetTypeBetween(
    BudgetType lower,
    BudgetType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'budgetType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> budgetTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'budgetType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> budgetTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'budgetType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> budgetTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'budgetType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> budgetTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'budgetType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> budgetTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'budgetType',
        value: '',
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> budgetTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'budgetType',
        value: '',
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> imgAddrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imgAddr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> imgAddrGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imgAddr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> imgAddrLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imgAddr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> imgAddrBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imgAddr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> imgAddrStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imgAddr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> imgAddrEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imgAddr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> imgAddrContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imgAddr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> imgAddrMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imgAddr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> imgAddrIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imgAddr',
        value: '',
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> imgAddrIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imgAddr',
        value: '',
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> isSelectedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSelected',
        value: value,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension WalletQueryObject on QueryBuilder<Wallet, Wallet, QFilterCondition> {
  QueryBuilder<Wallet, Wallet, QAfterFilterCondition> budget(
      FilterQuery<BudgetModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'budget');
    });
  }
}

extension WalletQueryLinks on QueryBuilder<Wallet, Wallet, QFilterCondition> {}

extension WalletQuerySortBy on QueryBuilder<Wallet, Wallet, QSortBy> {
  QueryBuilder<Wallet, Wallet, QAfterSortBy> sortByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.asc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> sortByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.desc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> sortByBudgetType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetType', Sort.asc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> sortByBudgetTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetType', Sort.desc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> sortByImgAddr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imgAddr', Sort.asc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> sortByImgAddrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imgAddr', Sort.desc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> sortByIsSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.asc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> sortByIsSelectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.desc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension WalletQuerySortThenBy on QueryBuilder<Wallet, Wallet, QSortThenBy> {
  QueryBuilder<Wallet, Wallet, QAfterSortBy> thenByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.asc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> thenByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.desc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> thenByBudgetType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetType', Sort.asc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> thenByBudgetTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetType', Sort.desc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> thenByImgAddr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imgAddr', Sort.asc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> thenByImgAddrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imgAddr', Sort.desc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> thenByIsSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.asc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> thenByIsSelectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.desc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Wallet, Wallet, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension WalletQueryWhereDistinct on QueryBuilder<Wallet, Wallet, QDistinct> {
  QueryBuilder<Wallet, Wallet, QDistinct> distinctByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'balance');
    });
  }

  QueryBuilder<Wallet, Wallet, QDistinct> distinctByBudgetType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'budgetType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Wallet, Wallet, QDistinct> distinctByImgAddr(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imgAddr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Wallet, Wallet, QDistinct> distinctByIsSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSelected');
    });
  }

  QueryBuilder<Wallet, Wallet, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension WalletQueryProperty on QueryBuilder<Wallet, Wallet, QQueryProperty> {
  QueryBuilder<Wallet, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Wallet, int, QQueryOperations> balanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'balance');
    });
  }

  QueryBuilder<Wallet, BudgetModel, QQueryOperations> budgetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'budget');
    });
  }

  QueryBuilder<Wallet, BudgetType, QQueryOperations> budgetTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'budgetType');
    });
  }

  QueryBuilder<Wallet, String, QQueryOperations> imgAddrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imgAddr');
    });
  }

  QueryBuilder<Wallet, bool, QQueryOperations> isSelectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSelected');
    });
  }

  QueryBuilder<Wallet, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const BudgetModelSchema = Schema(
  name: r'BudgetModel',
  id: 7247118153370490723,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.long,
    ),
    r'budgetDate': PropertySchema(
      id: 1,
      name: r'budgetDate',
      type: IsarType.string,
    ),
    r'budgetPeriod': PropertySchema(
      id: 2,
      name: r'budgetPeriod',
      type: IsarType.long,
    )
  },
  estimateSize: _budgetModelEstimateSize,
  serialize: _budgetModelSerialize,
  deserialize: _budgetModelDeserialize,
  deserializeProp: _budgetModelDeserializeProp,
);

int _budgetModelEstimateSize(
  BudgetModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.budgetDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _budgetModelSerialize(
  BudgetModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amount);
  writer.writeString(offsets[1], object.budgetDate);
  writer.writeLong(offsets[2], object.budgetPeriod);
}

BudgetModel _budgetModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BudgetModel(
    amount: reader.readLongOrNull(offsets[0]),
    budgetDate: reader.readStringOrNull(offsets[1]),
    budgetPeriod: reader.readLongOrNull(offsets[2]),
  );
  return object;
}

P _budgetModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension BudgetModelQueryFilter
    on QueryBuilder<BudgetModel, BudgetModel, QFilterCondition> {
  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition> amountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'amount',
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      amountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'amount',
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition> amountEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      amountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition> amountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition> amountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'budgetDate',
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'budgetDate',
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'budgetDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'budgetDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'budgetDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'budgetDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'budgetDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'budgetDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'budgetDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'budgetDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'budgetDate',
        value: '',
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'budgetDate',
        value: '',
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetPeriodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'budgetPeriod',
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetPeriodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'budgetPeriod',
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetPeriodEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'budgetPeriod',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetPeriodGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'budgetPeriod',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetPeriodLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'budgetPeriod',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetModel, BudgetModel, QAfterFilterCondition>
      budgetPeriodBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'budgetPeriod',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BudgetModelQueryObject
    on QueryBuilder<BudgetModel, BudgetModel, QFilterCondition> {}
