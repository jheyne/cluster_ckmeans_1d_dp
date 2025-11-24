import 'package:test/test.dart';
import 'package:cluster_ckmeans_1d_dp/src/ckmeans.dart';

void main() {
  group('Ckmeans int vs double', () {
    test('produces same clusters for int and double inputs', () {
      final intData = [1, 2, 3, 10, 11, 12];
      final doubleData = [1.0, 2.0, 3.0, 10.0, 11.0, 12.0];
      final k = 2;

      final intResult = ckmeans(intData, k);
      final doubleResult = ckmeans(doubleData, k);

      print('Int clusters: ${intResult.clusters}');
      print('Double clusters: ${doubleResult.clusters}');

      expect(intResult.clusters.length, doubleResult.clusters.length);

      for (int i = 0; i < intResult.clusters.length; i++) {
        final intCluster = intResult.clusters[i];
        final doubleCluster = doubleResult.clusters[i];

        // Convert int cluster to double for comparison
        final intClusterAsDouble = intCluster.map((e) => e.toDouble()).toList();

        expect(intClusterAsDouble, doubleCluster, reason: 'Cluster $i differs');
      }
    });

    test('reproduction with larger values', () {
      // Using values that might trigger precision issues if not handled carefully,
      // though int/double representation of these should be exact.
      final intData = [1000000, 1000001, 1000002, 2000000, 2000001, 2000002];
      final doubleData = [
        1000000.0,
        1000001.0,
        1000002.0,
        2000000.0,
        2000001.0,
        2000002.0,
      ];
      final k = 2;

      final intResult = ckmeans(intData, k);
      final doubleResult = ckmeans(doubleData, k);

      print('Int clusters (large): ${intResult.clusters}');
      print('Double clusters (large): ${doubleResult.clusters}');

      for (int i = 0; i < intResult.clusters.length; i++) {
        final intCluster = intResult.clusters[i]
            .map((e) => e.toDouble())
            .toList();
        final doubleCluster = doubleResult.clusters[i];
        expect(
          intCluster,
          doubleCluster,
          reason: 'Cluster $i differs (large values)',
        );
      }
    });
    test('reproduction with timestamps (potential overflow)', () {
      final base = 1735718400000; // Jan 1 2025
      final day = 86400000;
      final intData = [
        base,
        base + day,
        base + day * 2,
        base + day * 10,
        base + day * 11,
        base + day * 12,
      ];
      final doubleData = intData.map((e) => e.toDouble()).toList();
      final k = 2;

      final intResult = ckmeans(intData, k);
      final doubleResult = ckmeans(doubleData, k);

      print('Int clusters (timestamps): ${intResult.clusters}');
      print('Double clusters (timestamps): ${doubleResult.clusters}');

      // If overflow happens, these will likely differ
      for (int i = 0; i < intResult.clusters.length; i++) {
        final intCluster = intResult.clusters[i]
            .map((e) => e.toDouble())
            .toList();
        final doubleCluster = doubleResult.clusters[i];
        expect(
          intCluster,
          doubleCluster,
          reason: 'Cluster $i differs (timestamps)',
        );
      }
    });
  });
}
