import 'package:cluster_ckmeans_1d_dp/cluster_ckmeans_1d_dp.dart';

void main(List<String> args) {
  final data = [1.0, 2.0, 3.0, 10.0, 11.0, 12.0];
  final result = ckmeans(data, 2);
  assert(result.clusters.length == 2);
  assert(result.clusters[0] == [1.0, 2.0, 3.0]);
  assert(result.clusters[1] == [10.0, 11.0, 12.0]);
  assert(result.centers[0] == 2.0);
  assert(result.centers[1] == 11.0);
  assert(result.sizes == [3.0, 3.0]);
}
