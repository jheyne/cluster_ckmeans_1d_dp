import 'dart:math';
import 'named_cluster_api.dart';

/// Indicates, for example, whether high values are better. This is used to generate cluster labels.
enum BestValues { low, mid, high, unknown }

/// Indicates the number of clusters to generate. This is used to generate cluster labels.
enum ClusterCount { three, five }

List<String> getClusterLabels(BestValues prefer, ClusterCount length) {
  final worst = 'Worst';
  final worse = 'Worse';
  final mid = 'Mid';
  final better = 'Better';
  final best = 'Best';

  switch (prefer) {
    case BestValues.low:
      return length == ClusterCount.three
          ? [best, mid, worst]
          : [best, better, mid, worse, worst];
    case BestValues.mid:
      return length == ClusterCount.three
          ? [worse, best, worse]
          : [worst, worse, best, worse, worst];
    case BestValues.high:
      return length == ClusterCount.three
          ? [worst, mid, best]
          : [worst, worse, mid, better, best];
    case BestValues.unknown:
      return length == ClusterCount.three
          ? ['Lower', 'Mid', 'Higher']
          : ['Lowest', 'Lower', 'Mid', 'Higher', 'Highest'];
  }
}

/// Result of the univariate statistical profiling.
class ProfileResult {
  final BestValues prefer;

  /// The number of elements in the dataset.
  final int count;

  /// The minimum value.
  final num min;

  /// The maximum value.
  final num max;

  /// The arithmetic mean.
  final num mean;

  /// The median value (50th percentile).
  final num median;

  /// The standard deviation.
  final num standardDeviation;

  /// The lower quartile (25th percentile).
  final num lowerQuartile;

  /// The upper quartile (75th percentile).
  final num upperQuartile;

  /// The sum of all values.
  final num sum;

  List<num> sortedData;

  NamedClusterResult clusters;

  ProfileResult({
    required this.prefer,
    required this.count,
    required this.min,
    required this.max,
    required this.mean,
    required this.median,
    required this.standardDeviation,
    required this.lowerQuartile,
    required this.upperQuartile,
    required this.sum,
    required this.sortedData,
    required this.clusters,
  });

  @override
  String toString() {
    return 'ProfileResult(prefer: $prefer, count: $count, min: $min, max: $max, mean: $mean, median: $median, stdDev: $standardDeviation, lq: $lowerQuartile, uq: $upperQuartile, sum: $sum)';
  }
}

/// Calculates a comprehensive statistical profile of the data, including clustering.
class StatisticalProfiler {
  final List<num> data;

  late List<String> clusterLabels;

  BestValues bestValues;

  /// BestBalues and ClusterCount are used to generate cluster labels. Labels can also be provided explicitly.
  StatisticalProfiler(
    this.data, {
    List<String>? clusterLabels,
    this.bestValues = BestValues.unknown,
    ClusterCount clusterCount = ClusterCount.five,
  }) {
    this.clusterLabels =
        clusterLabels ?? getClusterLabels(bestValues, clusterCount);
  }

  /// Calculates statistical profile of the data.
  ///
  /// This method sorts the data to calculate quartiles and median efficiently.
  /// It performs a single pass over the sorted data to calculate sum and sum of squares
  /// for standard deviation.
  ProfileResult profile() {
    if (data.isEmpty) {
      throw ArgumentError('Data cannot be empty');
    }

    // Sort data (copy to avoid mutating original)
    final sortedData = List<num>.from(data)..sort();
    final n = sortedData.length;

    num sum = 0;
    num sumSquared = 0;

    // Single pass for sum and sumSquared
    for (final value in sortedData) {
      sum += value;
      sumSquared += value * value;
    }

    final mean = sum / n;
    final variance = (sumSquared / n) - (mean * mean);
    final standardDeviation = sqrt(
      variance < 0 ? 0 : variance,
    ); // Handle potential floating point errors

    // Quartiles
    num getPercentile(double p) {
      final index = p * (n - 1);
      final lowerIndex = index.floor();
      final upperIndex = index.ceil();
      if (lowerIndex == upperIndex) {
        return sortedData[lowerIndex];
      }
      final weight = index - lowerIndex;
      return sortedData[lowerIndex] * (1 - weight) +
          sortedData[upperIndex] * weight;
    }

    final median = getPercentile(0.5);
    final lowerQuartile = getPercentile(0.25);
    final upperQuartile = getPercentile(0.75);

    final clusters = clustersNamed(sortedData, clusterLabels);

    return ProfileResult(
      prefer: bestValues,
      sortedData: sortedData,
      count: n,
      min: sortedData.first,
      max: sortedData.last,
      mean: mean,
      median: median,
      standardDeviation: standardDeviation,
      lowerQuartile: lowerQuartile,
      upperQuartile: upperQuartile,
      sum: sum,
      clusters: clusters,
    );
  }
}
