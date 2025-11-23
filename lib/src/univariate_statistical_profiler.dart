import 'dart:math';
import 'named_cluster_api.dart';

enum Prefer { low, mid, high, unknown }

enum RangeLength { three, five }

const valueRangeLabels3 = ['Worse', 'Mid', 'Better'];
const valueRangeLabels5 = ['Worst', 'Worse', 'Mid', 'Better', 'Best'];

List<String> getClusterLabels(Prefer prefer, RangeLength length) {
  final worst = 'Worst';
  final worse = 'Worse';
  final mid = 'Mid';
  final better = 'Better';
  final best = 'Best';

  switch (prefer) {
    case Prefer.low:
      return length == RangeLength.three
          ? [best, mid, worst]
          : [best, better, mid, worse, worst];
    case Prefer.mid:
      return length == RangeLength.three
          ? [worse, best, worse]
          : [worst, worse, best, worse, worst];
    case Prefer.high:
      return length == RangeLength.three
          ? [worst, mid, best]
          : [worst, worse, mid, better, best];
    case Prefer.unknown:
      return length == RangeLength.three
          ? ['Lower', 'Mid', 'Higher']
          : ['Lowest', 'Lower', 'Mid', 'Higher', 'Highest'];
  }
}

/// Result of the univariate statistical profiling.
class ProfileResult {
  final Prefer prefer;

  /// The number of elements in the dataset.
  final int count;

  /// The minimum value.
  final double min;

  /// The maximum value.
  final double max;

  /// The arithmetic mean.
  final double mean;

  /// The median value (50th percentile).
  final double median;

  /// The standard deviation.
  final double standardDeviation;

  /// The lower quartile (25th percentile).
  final double lowerQuartile;

  /// The upper quartile (75th percentile).
  final double upperQuartile;

  /// The sum of all values.
  final double sum;

  List<double> sortedData;

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

class UnivariateStatisticalProfiler {
  final List<double> data;

  late List<String> clusterLabels;

  Prefer prefer;

  UnivariateStatisticalProfiler(
    this.data, {
    this.prefer = Prefer.unknown,
    RangeLength rangeLength = RangeLength.five,
    List<String>? clusterLabels,
  }) {
    this.clusterLabels = clusterLabels ?? getClusterLabels(prefer, rangeLength);
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
    final sortedData = List<double>.from(data)..sort();
    final n = sortedData.length;

    double sum = 0.0;
    double sumSquared = 0.0;

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
    double getPercentile(double p) {
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
      prefer: prefer,
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
