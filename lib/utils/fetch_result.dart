// for ticket 003. Future<FetchResult<List<Programme>>> your api design
// a workaround to satisfy both requirements simultaneously for 003 and 007
// optional
class FetchResult<T> {
  final T data;
  final dynamic error;

  const FetchResult({
    required this.data,
    this.error,
  });

  bool get hasError => error != null;
}