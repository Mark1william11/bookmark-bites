import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_category.freezed.dart';
part 'recipe_category.g.dart';

@freezed
class RecipeCategory with _$RecipeCategory {
  const factory RecipeCategory({
    required String idCategory,
    required String strCategory,
    required String strCategoryThumb,
    required String strCategoryDescription,
  }) = _RecipeCategory;

  factory RecipeCategory.fromJson(Map<String, dynamic> json) =>
      _$RecipeCategoryFromJson(json);
}

// A wrapper class because the API returns a list under a "categories" key.
@freezed
class CategoriesResponse with _$CategoriesResponse {
  const factory CategoriesResponse({
    required List<RecipeCategory> categories,
  }) = _CategoriesResponse;

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseFromJson(json);
}