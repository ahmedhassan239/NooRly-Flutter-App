/// Hadith library repository interface.
library;

import 'package:flutter_app/features/library/data/dto/category_dto.dart';
import 'package:flutter_app/features/library/data/dto/hadith_collection_details_response_dto.dart';
import 'package:flutter_app/features/library/data/dto/hadith_collection_dto.dart';

abstract class HadithRepository {
  Future<List<HadithCollectionDto>> fetchHadithCollectionsAll();
  Future<List<CategoryDto>> fetchHadithCategories();
  Future<List<HadithCollectionDto>> fetchHadithCollectionsByCategory(
    int categoryId,
  );
  Future<HadithCollectionDetailsResponseDto?> fetchHadithCollectionDetails(
    int collectionId,
  );
}
