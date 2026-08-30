# 🚀 LeetCode 121 - Best Time to Buy and Sell Stock

## 📝 Problem

You are given an array `prices` where `prices[i]` is the stock price on the `iᵗʰ` day.

You may complete **only one transaction**:

- Buy one stock.
- Sell it later.

Return the **maximum profit**.

If no profit is possible, return `0`.

---

## Example 1

Input

```
prices = [7,1,5,3,6,4]
```

Output

```
5
```

Explanation

```
Buy at 1
Sell at 6

Profit = 6 - 1 = 5
```

---

## Example 2

Input

```
prices = [7,6,4,3,1]
```

Output

```
0
```

No profitable transaction exists.

---

# 💡 Approach (Greedy)

While traversing the array once:

- Keep track of the **minimum price seen so far**.
- Calculate the profit if we sell today.
- Update the maximum profit whenever we find a better one.

This guarantees the optimal answer in one pass.

---

## 🛠️ Algorithm

1. Initialize

```
minPrice = prices[0]
maxProfit = 0
```

2. Traverse the array.

3. If current price is smaller

```
Update minPrice
```

4. Otherwise

```
profit = currentPrice - minPrice
```

5. Update

```
maxProfit
```

6. Return maxProfit.

---

## 🧪 Dry Run

Input

```
[7,1,5,3,6,4]
```

Initially

```
minPrice = 7
profit = 0
```

Day 2

```
Price = 1

minPrice = 1
```

Day 3

```
Price = 5

profit = 4

maxProfit = 4
```

Day 4

```
Price = 3

profit = 2

maxProfit = 4
```

Day 5

```
Price = 6

profit = 5

maxProfit = 5
```

Day 6

```
Price = 4

profit = 3

maxProfit = 5
```

Answer

```
5
```

---

## Another Dry Run

Input

```
[7,6,4,3,1]
```

Minimum keeps decreasing

```
7
↓

6
↓

4
↓

3
↓

1
```

Profit never becomes positive.

Answer

```
0
```

---

## 📊 Complexity Analysis

| Complexity | Value |
|------------|-------|
| Time | O(n) |
| Space | O(1) |

---

## ⚠️ Edge Cases

### Single Day

```
[5]
```

Output

```
0
```

---

### Always Increasing

```
[1,2,3,4,5]
```

Output

```
4
```

---

### Always Decreasing

```
[5,4,3,2,1]
```

Output

```
0
```

---

### Same Prices

```
[4,4,4]
```

Output

```
0
```

---

## ✅ Why This Approach?

Brute Force compares every pair.

```
O(n²)
```

Instead,

- Keep the minimum buying price.
- Compute profit in one pass.

Advantages

- Single traversal.
- Constant memory.
- Standard interview solution.

---

## 🎯 Interview Follow-up

### Why is this Greedy?

At every step, we only need the **lowest buying price so far**.

Any higher buying price can never produce a better profit.

Hence, keeping only the minimum price is always optimal.

---

## 📚 Concepts Used

- Arrays
- Greedy
- One-pass Traversal

---

## 🔗 Related Problems

- 122. Best Time to Buy and Sell Stock II
- 123. Best Time to Buy and Sell Stock III
- 188. Best Time to Buy and Sell Stock IV
- 714. Best Time to Buy and Sell Stock with Transaction Fee