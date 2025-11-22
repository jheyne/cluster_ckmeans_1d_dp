import 'package:cluster_ckmeans_1d_dp/cluster_ckmeans_1d_dp.dart';

void main(List<String> args) {
  final data = [1.0, 2.0, 3.0, 10.0, 11.0, 12.0];
  final result = findClusters(data, 2);

  assert(result.clusters.length == 2);
  assert(result.clusters[0].values == [1.0, 2.0, 3.0]);
  assert(result.clusters[1].values == [10.0, 11.0, 12.0]);
  assert(result.clusters[0].mean == 2.0);
  assert(result.clusters[1].mean == 11.0);
  assert(result.clusters[0].elementCount == 3.0);
  assert(result.clusters[1].elementCount == 3.0);
  assert(result.clusters[0].sumOfSquares == 2.0);
  // (1-2)^2 + (2-2)^2 + (3-2)^2 = 1 + 0 + 1 = 2
  assert(result.clusters[1].sumOfSquares == 2.0);
  assert(result.totalSumOfSquares == 4.0);
}
