# Repository Coding Standards & Guidelines

This document defines the requirements for solving and documenting LeetCode problems in this repository.

---

## 1. Solution Files (`solution.dart` / `solution.sql`)
- **Always Most Optimal**: The code in `solution.dart` (or `solution.sql`) must **always contain the most optimal solution** in terms of time and space complexity.
- **Clean & Interview-Ready**: Write idiomatic, readable code with clean variable naming, edge case handling, and concise comments explaining core optimizations.

---

## 2. Documentation Files (`README.md`)
Every problem directory must contain an in-depth `README.md` that covers:
1. **Problem Statement & Schemas**: With constraints and clear examples (using markdown tables where appropriate).
2. **Evolution of Solutions ("How We Make It Better")**:
   - Must document **all possible approaches**:
     - Brute force / naive approach
     - Intermediate / intuitive approach
     - Optimal approach
     - Advanced follow-up / high-throughput optimizations (if applicable)
   - For every approach, provide:
     - Full code snippet
     - Analysis of bottlenecks and what causes inefficiency
     - Clear explanation of **how and why the next approach improves upon it**
3. **Comprehensive Comparison Matrix**: Side-by-side table showing Time Complexity, Space Complexity, operations, allocations, and trade-offs.
4. **Key Interview Gotchas & Edge Cases**: Highlights pitfalls, tricks, and interview follow-up questions.

---

## 3. Progress Tracking
- When adding a new problem, update the solved count table in root `README.md`.
