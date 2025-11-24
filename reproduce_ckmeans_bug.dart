import 'package:cluster_ckmeans_1d_dp/src/ckmeans.dart';

void main() {
  // 1735718400000 is approx Jan 1 2025
  final base = 1735718400000.0;
  final day = 86400000.0;
  final data = [
    base,
    base + day,
    base + day * 2,
    base + day * 10,
    base + day * 11,
    base + day * 12,
  ];
  final k = 2;

  print('Input: $data');
  print('k: $k');

  final result = ckmeans(data, k);

  print('Clusters:');
  for (var i = 0; i < result.clusters.length; i++) {
    print('Cluster $i: ${result.clusters[i]}');
  }
  print('Total WithinSS: ${result.totalWithinss}');

  // Expected split: [1, 2, 3] and [11, 12, 13]
  // Expected SS: 4.0
}
