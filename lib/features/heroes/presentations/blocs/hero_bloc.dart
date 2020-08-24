import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:fluttertesting/app/dependency_injector_container.dart';
import 'package:fluttertesting/cores/domains/use_case/use_case.dart';
import 'package:fluttertesting/cores/failure/failure.dart';
import 'package:fluttertesting/features/heroes/domains/entities/hero.dart';
import 'package:fluttertesting/features/heroes/domains/use_cases/get_heroes_use_case.dart';
import 'package:fluttertesting/features/heroes/presentations/blocs/hero_event.dart';
import 'package:fluttertesting/features/heroes/presentations/blocs/hero_state.dart';

class HeroBloc extends Bloc<HeroEvent, HeroState> {
  GetHeroesUseCase _getHeroes;

  HeroBloc() : super(HeroUninitialized()) {
    this._getHeroes = GetHeroesUseCase(
      repository: DependencyInjectorContainer.heroRepository
    );
  }

  @override
  Stream<HeroState> mapEventToState(HeroEvent event) async* {
    if (event is FetchHeroes) {
      yield* this.mapFetchHeroes();
    }
  }

  Stream<HeroState> mapFetchHeroes() async* {
    Either<Failure, List<HeroEntity>> result = await this._getHeroes(NoParams());

    yield* result.fold(
      (l) async* {
        yield HeroError(failure: l);
      },
      (r) async* {
        yield HeroLoaded(
          heroes: r
        );
      }
    );
  }
}