//@dart=2.9
//Package
// import 'package:movies_project_moviesmania/model/movie.dart';
// import 'package:movies_project_moviesmania/model/search_category.dart';
//Package
import 'dart:async';

// import 'package:flickd_app/models/search_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

//Models
import '../model/main_page_data.dart';
// import '../models/movie.dart';

//Services
import '../model/movie.dart';
import '../model/search_category.dart';
import '../services/movies_services.dart';

class MainPageDataController extends StateNotifier<MainPageData> {
  MainPageDataController([MainPageData state])
      : super(state ?? MainPageData.inital()) {
    getMovies();
  }

  final MovieService _movieService = GetIt.instance.get<MovieService>();

  Future<void> getMovies() async {
    try {
      List<Movie> _movies = [];

      if (state.searchText.isEmpty) {
        if (state.searchCategory == SearchCategory.popular) {
          _movies = await (_movieService.getPopularMovies(page: state.page));
        } else if (state.searchCategory == SearchCategory.upcoming) {
          _movies = await (_movieService.getUpcomingMovies(page: state.page));
        } else if (state.searchCategory == SearchCategory.top_rated) {
          _movies = await (_movieService.getTopRatedMovies(page: state.page));
        } else if (state.searchCategory == SearchCategory.none) {
          _movies = [];
        }
      } else {
        _movies = await (_movieService.searchMovies(state.searchText));
      }
      state = state.copyWith(
          movies: [...state.movies, ..._movies], page: state.page + 1);
    } catch (e) {
      print(e);
    }
  }

  void updateSearchCategory(String _category) {
    try {
      state = state.copyWith(
          movies: [], page: 1, searchCategory: _category, searchText: '');
      getMovies();
    } catch (e) {
      print(e);
    }
  }

  void updateTextSearch(String _searchText) {
    try {
      state = state.copyWith(
          movies: [],
          page: 1,
          searchCategory: SearchCategory.none,
          searchText: _searchText);
      getMovies();
    } catch (e) {
      print(e);
    }
  }
}
