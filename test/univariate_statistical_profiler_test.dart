import 'package:test/test.dart';
import 'package:cluster_ckmeans_1d_dp/src/univariate_statistical_profiler.dart';

void main() {
  group('UnivariateStatisticalProfiler', () {
    test('throws ArgumentError on empty list', () {
      final profiler = UnivariateStatisticalProfiler([]);
      expect(() => profiler.profile(), throwsArgumentError);
    });

    test('calculates stats for single element', () {
      final profiler = UnivariateStatisticalProfiler([5.0]);
      final result = profiler.profile();

      expect(result.count, 1);
      expect(result.min, 5.0);
      expect(result.max, 5.0);
      expect(result.mean, 5.0);
      expect(result.median, 5.0);
      expect(result.standardDeviation, 0.0);
      expect(result.sum, 5.0);
    });

    test('calculates stats for simple list (odd count)', () {
      final data = [1.0, 2.0, 3.0, 4.0, 5.0];
      final profiler = UnivariateStatisticalProfiler(data);
      final result = profiler.profile();

      expect(result.count, 5);
      expect(result.min, 1.0);
      expect(result.max, 5.0);
      expect(result.mean, 3.0);
      expect(result.median, 3.0);
      expect(result.sum, 15.0);
      // Variance = ((1-3)^2 + ... + (5-3)^2) / 5 = (4+1+0+1+4)/5 = 2. StdDev = sqrt(2) approx 1.414
      expect(result.standardDeviation, closeTo(1.41421356, 0.00001));
      expect(result.lowerQuartile, 2.0);
      expect(result.upperQuartile, 4.0);
    });

    test('calculates stats for simple list (even count)', () {
      final data = [1.0, 2.0, 3.0, 4.0];
      final profiler = UnivariateStatisticalProfiler(data);
      final result = profiler.profile();

      expect(result.count, 4);
      expect(result.min, 1.0);
      expect(result.max, 4.0);
      expect(result.mean, 2.5);
      expect(result.median, 2.5); // (2+3)/2
      expect(result.sum, 10.0);
      // Variance = ((1-2.5)^2 + ...)/4 = (2.25 + 0.25 + 0.25 + 2.25)/4 = 5/4 = 1.25. StdDev = sqrt(1.25) approx 1.118
      expect(result.standardDeviation, closeTo(1.11803398, 0.00001));
    });

    test('handles unsorted input', () {
      final data = [5.0, 1.0, 4.0, 2.0, 3.0];
      final profiler = UnivariateStatisticalProfiler(data);
      final result = profiler.profile();

      expect(result.min, 1.0);
      expect(result.max, 5.0);
      expect(result.median, 3.0);
    });

    test('calculates quartiles correctly with interpolation', () {
      // 0, 10, 20, 30
      // n=4
      // p=0.25 -> index = 0.75. lower=0, upper=1. weight=0.75.
      // val = 0 * 0.25 + 10 * 0.75 = 7.5
      final data = [0.0, 10.0, 20.0, 30.0];
      final profiler = UnivariateStatisticalProfiler(data);
      final result = profiler.profile();

      expect(result.lowerQuartile, 7.5);
      expect(result.upperQuartile, 22.5);
    });
  });
}
