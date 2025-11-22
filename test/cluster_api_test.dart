import 'package:cluster_ckmeans_1d_dp/cluster_ckmeans_1d_dp.dart';
import 'package:cluster_ckmeans_1d_dp/src/cluster_api.dart';
import 'package:test/test.dart';

void main() {
  group('Ckmeans', () {
    test('Basic clustering k=2', () {
      final data = [1.0, 2.0, 3.0, 10.0, 11.0, 12.0];
      final result = findClusters(data, 2);

      expect(result.clusters.length, 2);
      expect(result.clusters[0].values, [1.0, 2.0, 3.0]);
      expect(result.clusters[1].values, [10.0, 11.0, 12.0]);
      expect(result.clusters[0].mean, 2.0);
      expect(result.clusters[1].mean, 11.0);
      expect(result.clusters[0].elementCount, 3.0);
      expect(result.clusters[1].elementCount, 3.0);
      expect(
        result.clusters[0].sumOfSquares,
        2.0,
      ); // (1-2)^2 + (2-2)^2 + (3-2)^2 = 1 + 0 + 1 = 2
      expect(result.clusters[1].sumOfSquares, 2.0);
      expect(result.totalSumOfSquares, 4.0);
    });

    test('k=1', () {
      final data = [1.0, 2.0, 3.0];
      final result = findClusters(data, 1);

      expect(result.clusters.length, 1);
      expect(result.clusters[0].values, [1.0, 2.0, 3.0]);
      expect(result.clusters[0].mean, 2.0);
      expect(result.totalSumOfSquares, 2.0);
    });

    test('k=N', () {
      final data = [1.0, 2.0, 3.0];
      final result = findClusters(data, 3);

      expect(result.clusters.length, 3);
      expect(result.clusters[0].values, [1.0]);
      expect(result.clusters[1].values, [2.0]);
      expect(result.clusters[2].values, [3.0]);
      expect(result.totalSumOfSquares, 0.0);
    });

    test('Duplicates', () {
      final data = [1.0, 1.0, 1.0, 10.0, 10.0];
      final result = findClusters(data, 2);

      expect(result.clusters.length, 2);
      expect(result.clusters[0].values, [1.0, 1.0, 1.0]);
      expect(result.clusters[1].values, [10.0, 10.0]);
      expect(result.totalSumOfSquares, 0.0);
    });

    test('k > nUnique', () {
      final data = [1.0, 1.0, 1.0];
      final result = findClusters(data, 5);

      expect(result.clusters.length, 1); // Should reduce k to 1
      expect(result.clusters[0].values, [1.0, 1.0, 1.0]);
    });

    test('Unsorted input', () {
      final data = [12.0, 1.0, 11.0, 2.0, 10.0, 3.0];
      final result = findClusters(data, 2);

      expect(result.clusters.length, 2);
      expect(result.clusters[0].values, [1.0, 2.0, 3.0]);
      expect(result.clusters[1].values, [10.0, 11.0, 12.0]);
    });
  });
}
