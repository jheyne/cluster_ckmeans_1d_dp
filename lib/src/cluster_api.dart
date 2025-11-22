import 'ckmeans.dart';

/// Find clusters using the Ckmeans algorithm. This is a wrapper
/// around the traditional Ckmeans API which can be found in
/// ckmeans.dart.
ClusterResult findClusters(List<double> input, int clusterCount) {
  final result = ckmeans(input, clusterCount);
  final clusters = List<Cluster>.empty(growable: true);
  for (int i = 0; i < result.clusters.length; i++) {
    clusters.add(
      Cluster(
        i,
        result.clusters[i],
        result.centers[i],
        result.withinss[i],
        result.sizes[i],
      ),
    );
  }
  return ClusterResult(clusters, result.totalWithinss);
}

class ClusterResult {
  final List<Cluster> clusters;

  /// The total sum of squares for all clusters. Indicates distance.
  final double totalSumOfSquares;

  ClusterResult(this.clusters, this.totalSumOfSquares);
}

/// Details about a single cluster.
class Cluster {
  /// The cluster index.
  final int clusterIndex;

  /// The values in the cluster.
  final List<double> values;

  /// The center (mean) of the cluster.
  final double mean;

  /// The sum of squares for the cluster. Indicates distance.
  final double sumOfSquares;

  /// The size (number of elements) of the cluster.
  final double elementCount;

  Cluster(
    this.clusterIndex,
    this.values,
    this.mean,
    this.sumOfSquares,
    this.elementCount,
  );
}
