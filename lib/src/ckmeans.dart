/// Result of the Ckmeans algorithm.
class CkmeansResult {
  /// The clusters found.
  final List<List<double>> clusters;

  /// The centers (means) of each cluster.
  final List<double> centers;

  /// The within-cluster sum of squares for each cluster.
  final List<double> withinss;

  /// The size (number of elements) of each cluster.
  final List<double> sizes;

  /// The total within-cluster sum of squares.
  final double totalWithinss;

  /// The number of unique elements in the dataset.
  final int uniqueElements;

  CkmeansResult({
    required this.clusters,
    required this.centers,
    required this.withinss,
    required this.sizes,
    required this.totalWithinss,
    required this.uniqueElements,
  });
}

/// Performs optimal 1-dimensional clustering using dynamic programming.
///
/// [data] is the list of numbers to cluster.
/// [k] is the number of clusters.
///
/// Returns a [CkmeansResult] containing the clusters and statistics.
///
/// Throws [ArgumentError] if [data] is empty or [k] is invalid.
CkmeansResult ckmeans(List<double> data, int k, {bool isPreSorted = false}) {
  if (data.isEmpty) {
    throw ArgumentError('Data cannot be empty');
  }
  if (k <= 0) {
    throw ArgumentError('k must be positive');
  }

  // Sort data
  final x = isPreSorted ? data : List<double>.from(data)
    ..sort();
  final n = x.length;

  // Check unique elements
  int nUnique = 1;
  for (int i = 1; i < n; i++) {
    if (x[i] != x[i - 1]) {
      nUnique++;
    }
  }

  if (k > nUnique) {
    k = nUnique;
  }

  if (k > n) {
    k = n;
  }

  // Precompute prefix sums for O(1) variance calculation
  final sumX = List<double>.filled(n + 1, 0.0);
  final sumX2 = List<double>.filled(n + 1, 0.0);

  for (int i = 0; i < n; i++) {
    sumX[i + 1] = sumX[i] + x[i];
    sumX2[i + 1] = sumX2[i] + x[i] * x[i];
  }

  double getCost(int i, int j) {
    if (i > j) return 0.0;
    final count = j - i + 1;
    final s = sumX[j + 1] - sumX[i];
    final s2 = sumX2[j + 1] - sumX2[i];
    final res = s2 - (s * s) / count;
    return res < 0 ? 0.0 : res;
  }

  // dp[m][i] stores min cost for clustering x[0...i] into m+1 clusters
  final dp = List.generate(k, (_) => List<double>.filled(n, double.infinity));
  final backtrack = List.generate(k, (_) => List<int>.filled(n, 0));

  // Initialize for k=1 (m=0)
  for (int i = 0; i < n; i++) {
    dp[0][i] = getCost(0, i);
    backtrack[0][i] = 0;
  }

  // DP Recurrence
  for (int m = 1; m < k; m++) {
    // For each element i, find best split point j
    // We want to cluster x[0...i] into m+1 clusters.
    // Last cluster is x[j...i], previous m clusters cover x[0...j-1]
    // j can range from m to i.

    // Optimization: The optimal split point j for dp[m][i] is >= optimal split point for dp[m][i-1].
    // This allows reducing the inner loop complexity.
    // However, for simplicity and correctness first, we use the standard O(n^2) approach.

    for (int i = m; i < n; i++) {
      double minVal = double.infinity;
      int bestJ = i;

      // j is the start of the last cluster.
      // It must be at least m (since we need m elements for previous m clusters in worst case?
      // Actually previous m clusters need at least m elements?
      // If we allow empty clusters? No, k-means usually non-empty.
      // So j >= m.

      for (int j = m; j <= i; j++) {
        final cost = dp[m - 1][j - 1] + getCost(j, i);
        if (cost < minVal) {
          minVal = cost;
          bestJ = j;
        }
      }
      dp[m][i] = minVal;
      backtrack[m][i] = bestJ;
    }
  }

  // Backtrack to find clusters
  final clusters = <List<double>>[];
  int currentEnd = n - 1;
  for (int m = k - 1; m >= 0; m--) {
    final start = backtrack[m][currentEnd];
    final cluster = x.sublist(start, currentEnd + 1);
    clusters.insert(0, cluster);
    currentEnd = start - 1;
  }

  // Calculate stats
  final centers = <double>[];
  final withinss = <double>[];
  final sizes = <double>[];
  double totalWithinss = 0.0;

  for (final cluster in clusters) {
    final size = cluster.length.toDouble();
    sizes.add(size);
    if (size > 0) {
      final sum = cluster.reduce((a, b) => a + b);
      final mean = sum / size;
      centers.add(mean);

      double ss = 0.0;
      for (final val in cluster) {
        ss += (val - mean) * (val - mean);
      }
      withinss.add(ss);
      totalWithinss += ss;
    } else {
      // Should not happen with current logic
      centers.add(0.0);
      withinss.add(0.0);
    }
  }

  return CkmeansResult(
    clusters: clusters,
    centers: centers,
    withinss: withinss,
    sizes: sizes,
    totalWithinss: totalWithinss,
    uniqueElements: nUnique,
  );
}
