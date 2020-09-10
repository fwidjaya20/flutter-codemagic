import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertesting/cores/exceptions/exception.dart';
import 'package:fluttertesting/cores/failure/failure.dart';
import 'package:fluttertesting/features/heroes/datas/data_sources/hero_remote_data_source.dart';
import 'package:fluttertesting/features/heroes/datas/models/hero.dart';
import 'package:fluttertesting/features/heroes/datas/repository/hero_repository_impl.dart';
import 'package:fluttertesting/features/heroes/domains/entities/hero.dart';
import 'package:mockito/mockito.dart';

class HeroRemoteDataSourceMock extends Mock implements HeroRemoteDataSource {}

void main() {
  HeroRepositoryImpl repositoryImpl;
  HeroRemoteDataSourceMock dataSourceMock;

  setUp(() {
    dataSourceMock = HeroRemoteDataSourceMock();
    repositoryImpl = HeroRepositoryImpl(
      dataSource: dataSourceMock
    );
  });

  test("should return remote data when the call to remote data source is successfully", () async {
    final mockData = [
      {
        "id": 1,
        "name": "npc_dota_hero_antimage",
        "localized_name": "Anti-Mage",
        "primary_attr": "agi",
        "attack_type": "Melee",
        "roles": ["Carry", "Escape", "Nuker"],
        "legs": 2
      },
      {
        "id": 2,
        "name": "npc_dota_hero_axe",
        "localized_name": "Axe",
        "primary_attr": "str",
        "attack_type": "Melee",
        "roles": ["Initiator", "Durable", "Disabler", "Jungler"],
        "legs": 2
      }
    ];
    List<HeroModel> heroModels = mockData.map((e) => HeroModel.fromJson(e)).toList();

    when(dataSourceMock.getHeroes())
      .thenAnswer((realInvocation) async => heroModels);

    final result = await repositoryImpl.getHeroes();

    expect(result.isRight(), true);
    result.fold(
      (l) => null, 
      (r) => expect(r, isA<List<HeroEntity>>())
    );
  });

  test("should return ServerFailure when the call to remote data source is throw ServerException", () async {
    when(dataSourceMock.getHeroes())
      .thenThrow(ServerException());

    final result = await repositoryImpl.getHeroes();

    expect(result.isLeft(), true);
    result.fold(
      (l) => expect(l, isA<ServerFailure>()), 
      (r) => null
    );
  });
}