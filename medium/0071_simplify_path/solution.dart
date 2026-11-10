// LeetCode 0071: Simplify Path
// Optimal Solution: Two-Pointer Direct Token Scanning with Stack
// Time Complexity: O(N) where N is the length of path
// Space Complexity: O(N) auxiliary space for canonical directory stack

class Solution {
  String simplifyPath(String path) {
    final List<String> stack = [];
    final int len = path.length;
    int i = 0;

    // Scan the path from left to right
    while (i < len) {
      // 1. Skip consecutive '/' delimiters (slash consolidation)
      while (i < len && path.codeUnitAt(i) == 47) { // 47 is ASCII for '/'
        i++;
      }
      if (i >= len) break;

      // 2. Identify the boundary [start, i) of the next directory segment
      final int start = i;
      while (i < len && path.codeUnitAt(i) != 47) {
        i++;
      }

      final int tokenLen = i - start;

      // 3. Process the directory token
      if (tokenLen == 1 && path.codeUnitAt(start) == 46) {
        // '.' refers to current directory -> no-op
        continue;
      } else if (tokenLen == 2 &&
          path.codeUnitAt(start) == 46 &&
          path.codeUnitAt(start + 1) == 46) {
        // '..' refers to parent directory -> pop from stack if not at root
        if (stack.isNotEmpty) {
          stack.removeLast();
        }
      } else {
        // Valid directory or file name (e.g. 'home', '...', 'hidden')
        stack.add(path.substring(start, i));
      }
    }

    // Join simplified tokens starting with a root slash
    return '/${stack.join('/')}';
  }
}
