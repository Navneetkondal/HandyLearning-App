import 'package:flutter/material.dart';
import '../../../core/widgets/code_snippet_card.dart';

class DsaProblem {
  final String id;
  final String title;
  final String category; // 'Two Pointers', 'Sliding Window', 'Trees & Graphs', 'Dynamic Programming'
  final String difficulty; // 'Easy', 'Medium', 'Hard'
  final String timeComplexity;
  final String spaceComplexity;
  final String description;
  final String approach;
  final String pythonSolution;
  final String swiftSolution;
  final String dartSolution;

  const DsaProblem({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.timeComplexity,
    required this.spaceComplexity,
    required this.description,
    required this.approach,
    required this.pythonSolution,
    required this.swiftSolution,
    required this.dartSolution,
  });
}

class CodingDsaHubScreen extends StatefulWidget {
  const CodingDsaHubScreen({super.key});

  @override
  State<CodingDsaHubScreen> createState() => _CodingDsaHubScreenState();
}

class _CodingDsaHubScreenState extends State<CodingDsaHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedDifficulty = 'All';

  final List<String> _categories = [
    'All',
    'Two Pointers',
    'Sliding Window',
    'Trees & Graphs',
    'Dynamic Programming',
  ];

  static const List<DsaProblem> _problems = [
    DsaProblem(
      id: 'tp-1',
      title: 'Two Sum II - Input Array Is Sorted',
      category: 'Two Pointers',
      difficulty: 'Medium',
      timeComplexity: 'O(n)',
      spaceComplexity: 'O(1)',
      description: 'Given a 1-indexed array of integers numbers that is already sorted in non-decreasing order, find two numbers such that they add up to a specific target number.',
      approach: 'Initialize two pointers: `left = 0` and `right = n - 1`. If `numbers[left] + numbers[right] > target`, decrement `right`. If the sum is smaller, increment `left`. Since the array is sorted, this guarantees finding the pair in linear time without extra hash map memory.',
      pythonSolution: '''def twoSum(numbers: list[int], target: int) -> list[int]:
    left, right = 0, len(numbers) - 1
    while left < right:
        cur_sum = numbers[left] + numbers[right]
        if cur_sum == target:
            return [left + 1, right + 1]
        elif cur_sum < target:
            left += 1
        else:
            right -= 1
    return []''',
      swiftSolution: '''func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
    var left = 0, right = numbers.count - 1
    while left < right {
        let sum = numbers[left] + numbers[right]
        if sum == target {
            return [left + 1, right + 1]
        } else if sum < target {
            left += 1
        } else {
            right -= 1
        }
    }
    return []
}''',
      dartSolution: '''List<int> twoSum(List<int> numbers, int target) {
  int left = 0;
  int right = numbers.length - 1;
  while (left < right) {
    final sum = numbers[left] + numbers[right];
    if (sum == target) {
      return [left + 1, right + 1];
    } else if (sum < target) {
      left++;
    } else {
      right--;
    }
  }
  return [];
}''',
    ),
    DsaProblem(
      id: 'tp-2',
      title: '3Sum (Triple Zero Sum)',
      category: 'Two Pointers',
      difficulty: 'Medium',
      timeComplexity: 'O(n²)',
      spaceComplexity: 'O(1) extra',
      description: 'Given an integer array nums, return all the triplets [nums[i], nums[j], nums[k]] such that i != j, i != k, and j != k, and nums[i] + nums[j] + nums[k] == 0. The solution set must not contain duplicate triplets.',
      approach: 'Sort the array. Iterate through each index `i`. For each `i`, run two pointers `left = i + 1` and `right = n - 1`. Skip duplicate numbers at `i`, `left`, and `right` to ensure unique triplets.',
      pythonSolution: '''def threeSum(nums: list[int]) -> list[list[int]]:
    nums.sort()
    res = []
    for i in range(len(nums) - 2):
        if i > 0 and nums[i] == nums[i - 1]:
            continue
        l, r = i + 1, len(nums) - 1
        while l < r:
            s = nums[i] + nums[l] + nums[r]
            if s == 0:
                res.append([nums[i], nums[l], nums[r]])
                while l < r and nums[l] == nums[l + 1]: l += 1
                while l < r and nums[r] == nums[r - 1]: r -= 1
                l += 1; r -= 1
            elif s < 0:
                l += 1
            else:
                r -= 1
    return res''',
      swiftSolution: '''func threeSum(_ nums: [Int]) -> [[Int]] {
    let sorted = nums.sorted()
    var res: [[Int]] = []
    for i in 0..<(sorted.count - 2) {
        if i > 0 && sorted[i] == sorted[i - 1] { continue }
        var l = i + 1, r = sorted.count - 1
        while l < r {
            let s = sorted[i] + sorted[l] + sorted[r]
            if s == 0 {
                res.append([sorted[i], sorted[l], sorted[r]])
                while l < r && sorted[l] == sorted[l + 1] { l += 1 }
                while l < r && sorted[r] == sorted[r - 1] { r -= 1 }
                l += 1; r -= 1
            } else if s < 0 {
                l += 1
            } else {
                r -= 1
            }
        }
    }
    return res
}''',
      dartSolution: '''List<List<int>> threeSum(List<int> nums) {
  final sorted = List<int>.from(nums)..sort();
  final res = <List<int>>[];
  for (int i = 0; i < sorted.length - 2; i++) {
    if (i > 0 && sorted[i] == sorted[i - 1]) continue;
    int l = i + 1, r = sorted.length - 1;
    while (l < r) {
      final s = sorted[i] + sorted[l] + sorted[r];
      if (s == 0) {
        res.add([sorted[i], sorted[l], sorted[r]]);
        while (l < r && sorted[l] == sorted[l + 1]) l++;
        while (l < r && sorted[r] == sorted[r - 1]) r--;
        l++; r--;
      } else if (s < 0) {
        l++;
      } else {
        r--;
      }
    }
  }
  return res;
}''',
    ),
    DsaProblem(
      id: 'sw-1',
      title: 'Longest Substring Without Repeating Characters',
      category: 'Sliding Window',
      difficulty: 'Medium',
      timeComplexity: 'O(n)',
      spaceComplexity: 'O(min(n, m))',
      description: 'Given a string s, find the length of the longest substring without duplicate characters.',
      approach: 'Use a dynamic sliding window `[left, right]`. Store the last seen index of each character in a map. When a repeated character is encountered inside the current window, jump `left` forward to `last_index + 1`. Track maximum window size `right - left + 1`.',
      pythonSolution: '''def lengthOfLongestSubstring(s: str) -> int:
    char_map = {}
    left = max_len = 0
    for right, ch in enumerate(s):
        if ch in char_map and char_map[ch] >= left:
            left = char_map[ch] + 1
        char_map[ch] = right
        max_len = max(max_len, right - left + 1)
    return max_len''',
      swiftSolution: '''func lengthOfLongestSubstring(_ s: String) -> Int {
    var charMap = [Character: Int]()
    var left = 0, maxLen = 0
    for (right, ch) in s.enumerated() {
        if let lastIdx = charMap[ch], lastIdx >= left {
            left = lastIdx + 1
        }
        charMap[ch] = right
        maxLen = max(maxLen, right - left + 1)
    }
    return maxLen
}''',
      dartSolution: '''int lengthOfLongestSubstring(String s) {
  final charMap = <String, int>{};
  int left = 0;
  int maxLen = 0;
  for (int right = 0; right < s.length; right++) {
    final ch = s[right];
    if (charMap.containsKey(ch) && charMap[ch]! >= left) {
      left = charMap[ch]! + 1;
    }
    charMap[ch] = right;
    maxLen = (right - left + 1) > maxLen ? (right - left + 1) : maxLen;
  }
  return maxLen;
}''',
    ),
    DsaProblem(
      id: 'sw-2',
      title: 'Minimum Size Subarray Sum',
      category: 'Sliding Window',
      difficulty: 'Medium',
      timeComplexity: 'O(n)',
      spaceComplexity: 'O(1)',
      description: 'Given an array of positive integers nums and a positive integer target, return the minimal length of a subarray whose sum is greater than or equal to target. If there is no such subarray, return 0 instead.',
      approach: 'Expand the window by advancing `right` and adding to `current_sum`. While `current_sum >= target`, record the minimum length `right - left + 1`, then shrink the window by subtracting `nums[left]` and incrementing `left`.',
      pythonSolution: '''def minSubArrayLen(target: int, nums: list[int]) -> int:
    left = current_sum = 0
    min_len = float('inf')
    for right in range(len(nums)):
        current_sum += nums[right]
        while current_sum >= target:
            min_len = min(min_len, right - left + 1)
            current_sum -= nums[left]
            left += 1
    return 0 if min_len == float('inf') else min_len''',
      swiftSolution: '''func minSubArrayLen(_ target: Int, _ nums: [Int]) -> Int {
    var left = 0, currentSum = 0, minLen = Int.max
    for right in 0..<nums.count {
        currentSum += nums[right]
        while currentSum >= target {
            minLen = min(minLen, right - left + 1)
            currentSum -= nums[left]
            left += 1
        }
    }
    return minLen == Int.max ? 0 : minLen
}''',
      dartSolution: '''int minSubArrayLen(int target, List<int> nums) {
  int left = 0, currentSum = 0, minLen = 1 << 30;
  for (int right = 0; right < nums.length; right++) {
    currentSum += nums[right];
    while (currentSum >= target) {
      final len = right - left + 1;
      if (len < minLen) minLen = len;
      currentSum -= nums[left];
      left++;
    }
  }
  return minLen == (1 << 30) ? 0 : minLen;
}''',
    ),
    DsaProblem(
      id: 'tg-1',
      title: 'Lowest Common Ancestor of a Binary Tree',
      category: 'Trees & Graphs',
      difficulty: 'Medium',
      timeComplexity: 'O(n)',
      spaceComplexity: 'O(h) call stack',
      description: 'Given a binary tree, find the lowest common ancestor (LCA) of two given nodes p and q.',
      approach: 'Use post-order DFS traversal. If the current root is null, or equals p or q, return root. Recursively search left and right subtrees. If both return non-null, current root is the LCA. If only one returns non-null, propagate that node upward.',
      pythonSolution: '''def lowestCommonAncestor(root: TreeNode, p: TreeNode, q: TreeNode) -> TreeNode:
    if not root or root == p or root == q:
        return root
    left = lowestCommonAncestor(root.left, p, q)
    right = lowestCommonAncestor(root.right, p, q)
    if left and right:
        return root
    return left if left else right''',
      swiftSolution: '''func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
    guard let root = root else { return nil }
    if root === p || root === q { return root }
    let left = lowestCommonAncestor(root.left, p, q)
    let right = lowestCommonAncestor(root.right, p, q)
    if left != nil && right != nil { return root }
    return left ?? right
}''',
      dartSolution: '''TreeNode? lowestCommonAncestor(TreeNode? root, TreeNode? p, TreeNode? q) {
  if (root == null || root == p || root == q) return root;
  final left = lowestCommonAncestor(root.left, p, q);
  final right = lowestCommonAncestor(root.right, p, q);
  if (left != null && right != null) return root;
  return left ?? right;
}''',
    ),
    DsaProblem(
      id: 'dp-1',
      title: 'Longest Increasing Subsequence (LIS)',
      category: 'Dynamic Programming',
      difficulty: 'Medium',
      timeComplexity: 'O(n log n) with Patience Sorting / O(n²) DP',
      spaceComplexity: 'O(n)',
      description: 'Given an integer array nums, return the length of the longest strictly increasing subsequence.',
      approach: 'Maintain an array `tails` where `tails[i]` stores the smallest tail of all increasing subsequences of length `i + 1`. For each `x` in nums, binary search (`bisect_left`) the position in `tails`. If `x` is larger than all elements, append it; otherwise overwrite the found index.',
      pythonSolution: '''import bisect

def lengthOfLIS(nums: list[int]) -> int:
    tails = []
    for x in nums:
        idx = bisect.bisect_left(tails, x)
        if idx == len(tails):
            tails.append(x)
        else:
            tails[idx] = x
    return len(tails)''',
      swiftSolution: '''func lengthOfLIS(_ nums: [Int]) -> Int {
    var tails: [Int] = []
    for x in nums {
        var l = 0, r = tails.count
        while l < r {
            let mid = (l + r) / 2
            if tails[mid] < x { l = mid + 1 }
            else { r = mid }
        }
        if l == tails.count { tails.append(x) }
        else { tails[l] = x }
    }
    return tails.count
}''',
      dartSolution: '''int lengthOfLIS(List<int> nums) {
  final tails = <int>[];
  for (final x in nums) {
    int l = 0, r = tails.length;
    while (l < r) {
      final mid = (l + r) ~/ 2;
      if (tails[mid] < x) {
        l = mid + 1;
      } else {
        r = mid;
      }
    }
    if (l == tails.length) {
      tails.add(x);
    } else {
      tails[l] = x;
    }
  }
  return tails.length;
}''',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<DsaProblem> get _filteredProblems {
    return _problems.where((p) {
      final cat = _categories[_tabController.index];
      final matchCat = (cat == 'All') || (p.category == cat);
      final matchDiff = (_selectedDifficulty == 'All') || (p.difficulty == _selectedDifficulty);
      return matchCat && matchDiff;
    }).toList();
  }

  Color _difficultyColor(String diff, [bool isDark = false]) {
    switch (diff) {
      case 'Easy':
        return isDark ? const Color(0xFF34D399) : const Color(0xFF047857);
      case 'Medium':
        return isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309);
      case 'Hard':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  void _showProblemSheet(DsaProblem problem, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ProblemDetailSheet(problem: problem, isDark: isDark),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
    final subCol = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardCol = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderCol = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F17) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Coding & DSA Track',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFFF97316),
          indicatorColor: const Color(0xFFF97316),
          tabs: _categories.map((c) => Tab(text: c)).toList(),
          onTap: (_) => setState(() {}),
        ),
      ),
      body: Column(
        children: [
          // Filter Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: isDark ? const Color(0xFF131B2A) : Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Icon(Icons.filter_list_rounded, size: 16, color: subCol),
                  const SizedBox(width: 6),
                  Text(
                    'Difficulty:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: subCol),
                  ),
                  const SizedBox(width: 8),
                  Wrap(
                    spacing: 6,
                    children: ['All', 'Easy', 'Medium', 'Hard'].map((diff) {
                      final selected = _selectedDifficulty == diff;
                      return ChoiceChip(
                        label: Text(
                          diff,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                            color: selected
                                ? Colors.white
                                : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                          ),
                        ),
                        selected: selected,
                        selectedColor: const Color(0xFFF97316),
                        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        onSelected: (val) {
                          if (val) setState(() => _selectedDifficulty = diff);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          // Problems List
          Expanded(
            child: _filteredProblems.isEmpty
                ? Center(
                    child: Text(
                      'No problems match your filters',
                      style: TextStyle(color: subCol, fontSize: 14),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: _filteredProblems.length,
                    itemBuilder: (context, index) {
                      final prob = _filteredProblems[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: cardCol,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderCol),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => _showProblemSheet(prob, isDark),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: _difficultyColor(prob.difficulty, isDark).withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          prob.difficulty,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: _difficultyColor(prob.difficulty, isDark),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF97316).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          prob.category,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFF97316),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '⏱ ${prob.timeComplexity}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: subCol,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    prob.title,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: textCol,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    prob.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 13, color: subCol, height: 1.35),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Space: ${prob.spaceComplexity}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: subCol,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'View Solutions',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFFF97316),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 14,
                                            color: Color(0xFFF97316),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ProblemDetailSheet extends StatefulWidget {
  final DsaProblem problem;
  final bool isDark;

  const _ProblemDetailSheet({required this.problem, required this.isDark});

  @override
  State<_ProblemDetailSheet> createState() => _ProblemDetailSheetState();
}

class _ProblemDetailSheetState extends State<_ProblemDetailSheet> with SingleTickerProviderStateMixin {
  late TabController _langController;

  @override
  void initState() {
    super.initState();
    _langController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _langController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.problem;
    final isDark = widget.isDark;
    final textCol = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
    final subCol = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardCol = isDark ? const Color(0xFF1E293B) : Colors.white;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Grab handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 8),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF97316).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            p.category,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF97316),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          p.difficulty,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: p.difficulty == 'Easy'
                                ? (isDark ? const Color(0xFF34D399) : const Color(0xFF047857))
                                : (isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309)),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      p.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textCol),
                    ),
                    const SizedBox(height: 12),
                    // Complexity Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardCol,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text('Time Complexity', style: TextStyle(fontSize: 11, color: subCol)),
                              const SizedBox(height: 2),
                              Text(
                                p.timeComplexity,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textCol),
                              ),
                            ],
                          ),
                          Container(width: 1, height: 24, color: subCol.withValues(alpha: 0.2)),
                          Column(
                            children: [
                              Text('Space Complexity', style: TextStyle(fontSize: 11, color: subCol)),
                              const SizedBox(height: 2),
                              Text(
                                p.spaceComplexity,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textCol),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Problem Statement',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textCol),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      p.description,
                      style: TextStyle(fontSize: 13, color: subCol, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Algorithm & Mental Model',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textCol),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0EA5E9).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF0EA5E9).withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        p.approach,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? const Color(0xFFBAE6FD) : const Color(0xFF0369A1),
                          height: 1.45,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Production Implementations',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textCol),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: cardCol,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                        controller: _langController,
                        indicatorColor: const Color(0xFFF97316),
                        labelColor: const Color(0xFFF97316),
                        unselectedLabelColor: subCol,
                        tabs: const [
                          Tab(text: 'Python 3'),
                          Tab(text: 'Swift 6'),
                          Tab(text: 'Dart'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 240,
                      child: TabBarView(
                        controller: _langController,
                        children: [
                          CodeSnippetCard(
                            title: 'Python 3 Implementation',
                            language: 'python',
                            code: p.pythonSolution,
                          ),
                          CodeSnippetCard(
                            title: 'Swift 6 Implementation',
                            language: 'swift',
                            code: p.swiftSolution,
                          ),
                          CodeSnippetCard(
                            title: 'Dart Implementation',
                            language: 'dart',
                            code: p.dartSolution,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
