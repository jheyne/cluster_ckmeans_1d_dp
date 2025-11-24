import 'package:test/test.dart';
import 'package:cluster_ckmeans_1d_dp/src/adapters.dart';
import 'package:intl/intl.dart';

void main() {
  group('DateTimeAdapter', () {
    test('clusters dates correctly', () {
      final now = DateTime(2025, 1, 1);
      final day = Duration(days: 1);
      final dates = [
        now, // Jan 1
        now.add(day), // Jan 2
        now.add(day * 2), // Jan 3
        now.add(day * 10), // Jan 11
        now.add(day * 11), // Jan 12
        now.add(day * 12), // Jan 13
      ];

      final adapter = DateTimeAdapter(dates, clusterCount: 2);

      expect(adapter.result.clusters.length, 2);

      // Check cluster names format
      final names = adapter.getClusterNames(dates);
      expect(names.length, 6);

      // First cluster should end with the last date of the first group
      // Last cluster should start with the first date of the last group
      // Middle clusters (if any) have range

      // We expect 2 clusters: [0, 1, 2] and [3, 4, 5]
      // Cluster 1: ...end
      // Cluster 2: start...

      // Debug prints
      for (var i = 0; i < adapter.result.clusters.length; i++) {
        print('Cluster $i: ${adapter.result.clusters[i].name}');
        print('Values: ${adapter.result.clusters[i].values}');
      }

      final c1End = DateFormat.yMd().format(dates[2]); // 1/3/2025
      final c2Start = DateFormat.yMd().format(dates[3]); // 1/11/2025

      expect(names[0], '...$c1End');
      expect(names[3], '$c2Start...');
    });

    test('handles fewer dates than clusters', () {
      final now = DateTime.now();
      final dates = [now, now.add(Duration(days: 1))];

      // Requesting 5 clusters for 2 dates
      final adapter = DateTimeAdapter(dates, clusterCount: 5);

      // Should have at most 2 clusters (or 1 if they are close, but here likely 2)
      expect(adapter.result.clusters.length, lessThanOrEqualTo(2));
    });

    test('getClusterName returns correct name for date', () {
      final now = DateTime.now();
      final dates = [now];
      final adapter = DateTimeAdapter(dates, clusterCount: 1);

      // Single cluster: ...end (logic says if first==last, it enters first block? No, if size 1, first==last.
      // Let's check logic in adapters.dart:
      // if (cluster == clusters.first) ...
      // else if (cluster == clusters.last) ...
      // If there is only 1 cluster, it is both first and last.
      // The 'if' will catch it as first. So '...end'.

      final end = DateFormat.yMd().format(now);
      expect(adapter.getClusterName(now), '...$end');
    });
  });
}
