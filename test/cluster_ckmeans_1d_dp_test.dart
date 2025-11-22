import 'package:cluster_ckmeans_1d_dp/cluster_ckmeans_1d_dp.dart';
import 'package:test/test.dart';

void main() {
  group('Ckmeans', () {
    test('Basic clustering k=2', () {
      final data = [1.0, 2.0, 3.0, 10.0, 11.0, 12.0];
      final result = ckmeans(data, 2);

      expect(result.clusters.length, 2);
      expect(result.clusters[0], [1.0, 2.0, 3.0]);
      expect(result.clusters[1], [10.0, 11.0, 12.0]);
      expect(result.centers[0], 2.0);
      expect(result.centers[1], 11.0);
      expect(result.sizes, [3.0, 3.0]);
      expect(
        result.withinss[0],
        2.0,
      ); // (1-2)^2 + (2-2)^2 + (3-2)^2 = 1 + 0 + 1 = 2
      expect(result.withinss[1], 2.0);
      expect(result.totalWithinss, 4.0);
    });

    test('k=1', () {
      final data = [1.0, 2.0, 3.0];
      final result = ckmeans(data, 1);

      expect(result.clusters.length, 1);
      expect(result.clusters[0], [1.0, 2.0, 3.0]);
      expect(result.centers[0], 2.0);
      expect(result.totalWithinss, 2.0);
    });

    test('k=N', () {
      final data = [1.0, 2.0, 3.0];
      final result = ckmeans(data, 3);

      expect(result.clusters.length, 3);
      expect(result.clusters[0], [1.0]);
      expect(result.clusters[1], [2.0]);
      expect(result.clusters[2], [3.0]);
      expect(result.totalWithinss, 0.0);
    });

    test('Duplicates', () {
      final data = [1.0, 1.0, 1.0, 10.0, 10.0];
      final result = ckmeans(data, 2);

      expect(result.clusters.length, 2);
      expect(result.clusters[0], [1.0, 1.0, 1.0]);
      expect(result.clusters[1], [10.0, 10.0]);
      expect(result.totalWithinss, 0.0);
    });

    test('k > nUnique', () {
      final data = [1.0, 1.0, 1.0];
      final result = ckmeans(data, 5);

      expect(result.clusters.length, 1); // Should reduce k to 1
      expect(result.clusters[0], [1.0, 1.0, 1.0]);
    });

    test('Unsorted input', () {
      final data = [12.0, 1.0, 11.0, 2.0, 10.0, 3.0];
      final result = ckmeans(data, 2);

      expect(result.clusters.length, 2);
      expect(result.clusters[0], [1.0, 2.0, 3.0]);
      expect(result.clusters[1], [10.0, 11.0, 12.0]);
    });
  });
}
