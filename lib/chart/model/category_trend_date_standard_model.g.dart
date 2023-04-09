// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_trend_date_standard_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetCateogryTrendDateStandardModelCollection on Isar {
  IsarCollection<CateogryTrendDateStandardModel>
      get cateogryTrendDateStandardModels => this.collection();
}

const CateogryTrendDateStandardModelSchema = CollectionSchema(
  name: r'CateogryTrendDateStandardModel',
  id: 7696237949572022038,
  properties: {
    r'firstDate': PropertySchema(
      id: 0,
      name: r'firstDate',
      type: IsarType.dateTime,
    ),
    r'lastDate': PropertySchema(
      id: 1,
      name: r'lastDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _cateogryTrendDateStandardModelEstimateSize,
  serialize: _cateogryTrendDateStandardModelSerialize,
  deserialize: _cateogryTrendDateStandardModelDeserialize,
  deserializeProp: _cateogryTrendDateStandardModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _cateogryTrendDateStandardModelGetId,
  getLinks: _cateogryTrendDateStandardModelGetLinks,
  attach: _cateogryTrendDateStandardModelAttach,
  version: '3.0.5',
);

int _cateogryTrendDateStandardModelEstimateSize(
  CateogryTrendDateStandardModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _cateogryTrendDateStandardModelSerialize(
  CateogryTrendDateStandardModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.firstDate);
  writer.writeDateTime(offsets[1], object.lastDate);
}

CateogryTrendDateStandardModel _cateogryTrendDateStandardModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CateogryTrendDateStandardModel();
  object.firstDate = reader.readDateTime(offsets[0]);
  object.id = id;
  object.lastDate = reader.readDateTime(offsets[1]);
  return object;
}

P _cateogryTrendDateStandardModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cateogryTrendDateStandardModelGetId(CateogryTrendDateStandardModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cateogryTrendDateStandardModelGetLinks(
    CateogryTrendDateStandardModel object) {
  return [];
}

void _cateogryTrendDateStandardModelAttach(
    IsarCollection<dynamic> col, Id id, CateogryTrendDateStandardModel object) {
  object.id = id;
}

extension CateogryTrendDateStandardModelQueryWhereSort on QueryBuilder<
    CateogryTrendDateStandardModel, CateogryTrendDateStandardModel, QWhere> {
  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CateogryTrendDateStandardModelQueryWhere on QueryBuilder<
    CateogryTrendDateStandardModel,
    CateogryTrendDateStandardModel,
    QWhereClause> {
  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
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

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
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

extension CateogryTrendDateStandardModelQueryFilter on QueryBuilder<
    CateogryTrendDateStandardModel,
    CateogryTrendDateStandardModel,
    QFilterCondition> {
  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterFilterCondition> firstDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstDate',
        value: value,
      ));
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterFilterCondition> firstDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstDate',
        value: value,
      ));
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterFilterCondition> firstDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstDate',
        value: value,
      ));
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterFilterCondition> firstDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
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

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
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

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
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

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterFilterCondition> lastDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastDate',
        value: value,
      ));
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterFilterCondition> lastDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastDate',
        value: value,
      ));
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterFilterCondition> lastDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastDate',
        value: value,
      ));
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterFilterCondition> lastDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CateogryTrendDateStandardModelQueryObject on QueryBuilder<
    CateogryTrendDateStandardModel,
    CateogryTrendDateStandardModel,
    QFilterCondition> {}

extension CateogryTrendDateStandardModelQueryLinks on QueryBuilder<
    CateogryTrendDateStandardModel,
    CateogryTrendDateStandardModel,
    QFilterCondition> {}

extension CateogryTrendDateStandardModelQuerySortBy on QueryBuilder<
    CateogryTrendDateStandardModel, CateogryTrendDateStandardModel, QSortBy> {
  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterSortBy> sortByFirstDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDate', Sort.asc);
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterSortBy> sortByFirstDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDate', Sort.desc);
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterSortBy> sortByLastDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDate', Sort.asc);
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterSortBy> sortByLastDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDate', Sort.desc);
    });
  }
}

extension CateogryTrendDateStandardModelQuerySortThenBy on QueryBuilder<
    CateogryTrendDateStandardModel,
    CateogryTrendDateStandardModel,
    QSortThenBy> {
  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterSortBy> thenByFirstDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDate', Sort.asc);
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterSortBy> thenByFirstDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDate', Sort.desc);
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterSortBy> thenByLastDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDate', Sort.asc);
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QAfterSortBy> thenByLastDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDate', Sort.desc);
    });
  }
}

extension CateogryTrendDateStandardModelQueryWhereDistinct on QueryBuilder<
    CateogryTrendDateStandardModel, CateogryTrendDateStandardModel, QDistinct> {
  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QDistinct> distinctByFirstDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstDate');
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, CateogryTrendDateStandardModel,
      QDistinct> distinctByLastDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastDate');
    });
  }
}

extension CateogryTrendDateStandardModelQueryProperty on QueryBuilder<
    CateogryTrendDateStandardModel,
    CateogryTrendDateStandardModel,
    QQueryProperty> {
  QueryBuilder<CateogryTrendDateStandardModel, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, DateTime, QQueryOperations>
      firstDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstDate');
    });
  }

  QueryBuilder<CateogryTrendDateStandardModel, DateTime, QQueryOperations>
      lastDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastDate');
    });
  }
}
