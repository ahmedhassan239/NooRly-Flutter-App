/// Unified API response model.
///
/// All API responses follow this structure:
/// ```json
/// {
///   "status": true/false,
///   "message": "Success/Error message",
///   "data": { ... } or [ ... ],
///   "meta": { "pagination": { ... } }
/// }
/// ```
library;

/// Unified API response wrapper.
class ApiResponse<T> {
  const ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.meta,
  });

  /// Parse API response from JSON.
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      meta: json['meta'] != null
          ? ApiMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Whether the request was successful.
  final bool status;

  /// Response message (success or error).
  final String message;

  /// Response data (can be object, array, or null).
  final T? data;

  /// Metadata (pagination, etc.).
  final ApiMeta? meta;

  /// Check if response has data.
  bool get hasData => data != null;

  /// Check if response has pagination.
  bool get hasPagination => meta?.pagination != null;
}

/// API metadata (pagination, etc.).
class ApiMeta {
  const ApiMeta({
    this.pagination,
  });

  factory ApiMeta.fromJson(Map<String, dynamic> json) {
    return ApiMeta(
      pagination: json['pagination'] != null
          ? ApiPagination.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  final ApiPagination? pagination;
}

/// Pagination metadata.
class ApiPagination {
  const ApiPagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory ApiPagination.fromJson(Map<String, dynamic> json) {
    return ApiPagination(
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 15,
      total: json['total'] as int? ?? 0,
    );
  }

  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  /// Check if there are more pages.
  bool get hasMore => currentPage < lastPage;

  /// Check if this is the first page.
  bool get isFirst => currentPage == 1;

  /// Check if this is the last page.
  bool get isLast => currentPage >= lastPage;
}

/// Paginated list response helper.
class PaginatedList<T> {
  const PaginatedList({
    required this.items,
    required this.pagination,
  });

  final List<T> items;
  final ApiPagination pagination;

  /// Check if there are more items to load.
  bool get hasMore => pagination.hasMore;

  /// Check if the list is empty.
  bool get isEmpty => items.isEmpty;

  /// Check if the list is not empty.
  bool get isNotEmpty => items.isNotEmpty;

  /// Get the total number of items.
  int get total => pagination.total;
}
