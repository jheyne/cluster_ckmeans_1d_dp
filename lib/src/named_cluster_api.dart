import 'dart:math' as math;
import 'ckmeans.dart';

/// Find clusters using the Ckmeans algorithm. This is a wrapper
/// around the traditional Ckmeans API which can be found in
/// ckmeans.dart.
NamedClusterResult clustersNamed(
  List<double> input,
  List<String> clusterNames,
) {
  final result = ckmeans(input, clusterNames.length);
  assert(
    result.clusters.length >= clusterNames.length,
    'insufficient clusters',
  );
  while (result.clusters.length < clusterNames.length) {
    final removed = clusterNames.removeAt(clusterNames.length ~/ 2);
    print('Removed $removed from clusterNames: insufficient clusters');
  }
  final clusters = List<NamedCluster>.empty(growable: true);
  for (int i = 0; i < result.clusters.length; i++) {
    clusters.add(
      NamedCluster(
        clusterNames[i],
        i,
        result.clusters[i],
        result.centers[i],
        result.withinss[i],
        result.sizes[i],
      ),
    );
  }
  return NamedClusterResult(clusters, result.totalWithinss);
}

class NamedClusterResult {
  final List<NamedCluster> clusters;

  /// The total sum of squares for all clusters. Indicates distance.
  final double totalSumOfSquares;

  NamedClusterResult(this.clusters, this.totalSumOfSquares);

  String mapValueToName(double value) {
    return clusters
        .firstWhere(
          (cluster) => cluster.contains(value),
          orElse: () =>
              value < clusters.first.min ? clusters.first : clusters.last,
        )
        .name;
  }
}

/// Details about a single cluster.
class NamedCluster {
  final String name;

  /// The cluster index.
  final int clusterIndex;

  /// The values in the cluster.
  final List<double> values;

  double get min => values.first;

  double get max => values.last;

  /// The center (mean) of the cluster.
  final double mean;

  /// The sum of squares for the cluster. Indicates distance.
  final double sumOfSquares;

  /// The size (number of elements) of the cluster.
  final double elementCount;

  NamedCluster(
    this.name,
    this.clusterIndex,
    this.values,
    this.mean,
    this.sumOfSquares,
    this.elementCount,
  ) {
    assert(values.isNotEmpty);
    assert(values.reduce(math.min) == min);
    assert(values.reduce(math.max) == max);
  }

  bool contains(double value) => min >= value && max <= value;
}
