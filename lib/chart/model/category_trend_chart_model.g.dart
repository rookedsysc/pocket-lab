// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_trend_chart_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetCategoryTrendChartDataModelCollection on Isar {
  IsarCollection<CategoryTrendChartDataModel>
      get categoryTrendChartDataModels => this.collection();
}

const CategoryTrendChartDataModelSchema = CollectionSchema(
  name: r'CategoryTrendChartDataModel',
  id: -2338835341194595150,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'categoryId': PropertySchema(
      id: 1,
      name: r'categoryId',
      type: IsarType.long,
    ),
    r'categoryName': PropertySchema(
      id: 2,
      name: r'categoryName',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 3,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'label': PropertySchema(
      id: 4,
      name: r'label',
      type: IsarType.string,
    ),
    r'setDate': PropertySchema(
      id: 5,
      name: r'setDate',
      type: IsarType.dateTime,
    ),
    r'setLabel': PropertySchema(
      id: 6,
      name: r'setLabel',
      type: IsarType.string,
    )
  },
  estimateSize: _categoryTrendChartDataModelEstimateSize,
  serialize: _categoryTrendChartDataModelSerialize,
  deserialize: _categoryTrendChartDataModelDeserialize,
  deserializeProp: _categoryTrendChartDataModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _categoryTrendChartDataModelGetId,
  getLinks: _categoryTrendChartDataModelGetLinks,
  attach: _categoryTrendChartDataModelAttach,
  version: '3.0.5',
);

int _categoryTrendChartDataModelEstimateSize(
  CategoryTrendChartDataModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.categoryName.length * 3;
  bytesCount += 3 + object.label.length * 3;
  bytesCount += 3 + object.setLabel.length * 3;
  return bytesCount;
}

void _categoryTrendChartDataModelSerialize(
  CategoryTrendChartDataModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeLong(offsets[1], object.categoryId);
  writer.writeString(offsets[2], object.categoryName);
  writer.writeDateTime(offsets[3], object.date);
  writer.writeString(offsets[4], object.label);
  writer.writeDateTime(offsets[5], object.setDate);
  writer.writeString(offsets[6], object.setLabel);
}

CategoryTrendChartDataModel _categoryTrendChartDataModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CategoryTrendChartDataModel(
    amount: reader.readDoubleOrNull(offsets[0]) ?? 0,
    categoryId: reader.readLong(offsets[1]),
    categoryName: reader.readString(offsets[2]),
  );
  object.date = reader.readDateTime(offsets[3]);
  object.id = id;
  object.label = reader.readString(offsets[4]);
  object.setDate = reader.readDateTime(offsets[5]);
  object.setLabel = reader.readString(offsets[6]);
  return object;
}

P _categoryTrendChartDataModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _categoryTrendChartDataModelGetId(CategoryTrendChartDataModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _categoryTrendChartDataModelGetLinks(
    CategoryTrendChartDataModel object) {
  return [];
}

void _categoryTrendChartDataModelAttach(
    IsarCollection<dynamic> col, Id id, CategoryTrendChartDataModel object) {
  object.id = id;
}

extension CategoryTrendChartDataModelQueryWhereSort on QueryBuilder<
    CategoryTrendChartDataModel, CategoryTrendChartDataModel, QWhere> {
  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CategoryTrendChartDataModelQueryWhere on QueryBuilder<
    CategoryTrendChartDataModel, CategoryTrendChartDataModel, QWhereClause> {
  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterWhereClause> idBetween(
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

extension CategoryTrendChartDataModelQueryFilter on QueryBuilder<
    CategoryTrendChartDataModel,
    CategoryTrendChartDataModel,
    QFilterCondition> {
  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> categoryIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> categoryIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> categoryIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> categoryIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> categoryNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> categoryNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> categoryNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> categoryNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> categoryNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> categoryNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
          QAfterFilterCondition>
      categoryNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
          QAfterFilterCondition>
      categoryNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoryName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> categoryNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryName',
        value: '',
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> categoryNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoryName',
        value: '',
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> labelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> labelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> labelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> labelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'label',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> labelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> labelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
          QAfterFilterCondition>
      labelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
          QAfterFilterCondition>
      labelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'label',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> setDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setDate',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> setDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'setDate',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> setDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'setDate',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> setDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'setDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> setLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> setLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'setLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> setLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'setLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> setLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'setLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> setLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'setLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> setLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'setLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
          QAfterFilterCondition>
      setLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'setLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
          QAfterFilterCondition>
      setLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'setLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> setLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterFilterCondition> setLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'setLabel',
        value: '',
      ));
    });
  }
}

extension CategoryTrendChartDataModelQueryObject on QueryBuilder<
    CategoryTrendChartDataModel,
    CategoryTrendChartDataModel,
    QFilterCondition> {}

extension CategoryTrendChartDataModelQueryLinks on QueryBuilder<
    CategoryTrendChartDataModel,
    CategoryTrendChartDataModel,
    QFilterCondition> {}

extension CategoryTrendChartDataModelQuerySortBy on QueryBuilder<
    CategoryTrendChartDataModel, CategoryTrendChartDataModel, QSortBy> {
  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> sortByCategoryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryName', Sort.asc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> sortByCategoryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryName', Sort.desc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> sortByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> sortByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> sortBySetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setDate', Sort.asc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> sortBySetDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setDate', Sort.desc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> sortBySetLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setLabel', Sort.asc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> sortBySetLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setLabel', Sort.desc);
    });
  }
}

extension CategoryTrendChartDataModelQuerySortThenBy on QueryBuilder<
    CategoryTrendChartDataModel, CategoryTrendChartDataModel, QSortThenBy> {
  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> thenByCategoryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryName', Sort.asc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> thenByCategoryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryName', Sort.desc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> thenByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> thenByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> thenBySetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setDate', Sort.asc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> thenBySetDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setDate', Sort.desc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> thenBySetLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setLabel', Sort.asc);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QAfterSortBy> thenBySetLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setLabel', Sort.desc);
    });
  }
}

extension CategoryTrendChartDataModelQueryWhereDistinct on QueryBuilder<
    CategoryTrendChartDataModel, CategoryTrendChartDataModel, QDistinct> {
  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QDistinct> distinctByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId');
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QDistinct> distinctByCategoryName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QDistinct> distinctByLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'label', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QDistinct> distinctBySetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'setDate');
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, CategoryTrendChartDataModel,
      QDistinct> distinctBySetLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'setLabel', caseSensitive: caseSensitive);
    });
  }
}

extension CategoryTrendChartDataModelQueryProperty on QueryBuilder<
    CategoryTrendChartDataModel, CategoryTrendChartDataModel, QQueryProperty> {
  QueryBuilder<CategoryTrendChartDataModel, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, double, QQueryOperations>
      amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, int, QQueryOperations>
      categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, String, QQueryOperations>
      categoryNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryName');
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, DateTime, QQueryOperations>
      dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, String, QQueryOperations>
      labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'label');
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, DateTime, QQueryOperations>
      setDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'setDate');
    });
  }

  QueryBuilder<CategoryTrendChartDataModel, String, QQueryOperations>
      setLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'setLabel');
    });
  }
}
