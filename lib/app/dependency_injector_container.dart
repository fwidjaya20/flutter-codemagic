import 'package:fluttertesting/app/environment.dart';
import 'package:fluttertesting/features/heroes/datas/data_sources/hero_remote_data_source.dart';
import 'package:fluttertesting/features/heroes/datas/repository/hero_repository_impl.dart';
import 'package:fluttertesting/features/heroes/domains/repository/hero_repository.dart';
import 'package:fluttertesting/features/heroes/domains/use_cases/get_heroes_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

class DependencyInjectorContainer {

  void init({
    @required Environment env
  }) {
    GetIt.I.registerLazySingleton<Environment>(() => env);

    this._initHeroesDependency(env);
  }

  void _initHeroesDependency(Environment env) {
    HeroRemoteDataSource remoteDataSource = HeroRemoteDataSource(
      baseUrl: env.baseUrl
    );
    HeroRepositoryImpl repositoryImpl = HeroRepositoryImpl(
      dataSource: remoteDataSource
    );
    GetIt.I.registerLazySingleton<HeroRepository>(() => repositoryImpl);

    GetHeroesUseCase getHeroesUseCase = GetHeroesUseCase(
      repository: repositoryImpl
    );
    GetIt.I.registerLazySingleton<GetHeroesUseCase>(() => getHeroesUseCase);
  }

  static Environment get environment => GetIt.I<Environment>();
  
  /// Repository
  static HeroRepository get heroRepository => GetIt.I<HeroRepository>();

  /// UseCase
  static GetHeroesUseCase get heroesUseCase => GetIt.I<GetHeroesUseCase>();
}