import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertesting/app/dependency_injector_container.dart';
import 'package:fluttertesting/features/heroes/domains/entities/hero.dart';
import 'package:fluttertesting/features/heroes/presentations/blocs/hero_bloc.dart';
import 'package:fluttertesting/features/heroes/presentations/blocs/hero_event.dart';
import 'package:fluttertesting/features/heroes/presentations/blocs/hero_state.dart';

class HeroPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HeroPageState();
  }
}

class _HeroPageState extends State<HeroPage> {
  // ignore: close_sinks
  HeroBloc _bloc;

  @override
  void initState() {
    super.initState();
    this._bloc = HeroBloc(
      getHeroesUseCase: DependencyInjectorContainer.heroesUseCase
    );
    this.fetchHeroes();
  }

  @override
  void dispose() {
    this._bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(r"Dota 2 Hero"),
      ),
      body: Container(
        child: this.buildBlocConsumer(),
      ),
    );
  }

  Widget buildBlocConsumer() {
    return BlocConsumer<HeroBloc, HeroState>(
      cubit: this._bloc,
      listener: (BuildContext context, HeroState state) {

      },
      builder: (BuildContext context, HeroState state) {
        if (state is HeroUninitialized || state is HeroLoading) {
          return this.buildLoading();
        }

        if (state is HeroLoaded) {
          if (state.heroes.length < 1) {
            return this.buildEmpty();
          }

          return this.buildListView(state.heroes);
        }

        if (state is HeroError) {
          return this.buildError();
        }

        return Container();
      },
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildEmpty() {
    return Center(
      child: Text("Data Empty"),
    );
  }

  Widget buildListView(List<HeroEntity> entities) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: entities.length,
      itemBuilder: (BuildContext context, int index) {
        HeroEntity entity = entities.elementAt(index);
        return ListTile(
          title: Text(entity.localizedName),
        );
      },
    );
  }

  Widget buildError() {
    return Center(
      child: Text("Fetch Error. Try Again"),
    );
  }

  void fetchHeroes() {
    this._bloc.add(FetchHeroes());
  }
}