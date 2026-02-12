# Week 1: Orientation, Python Environment Setup & Basic Libraries
# 第一週：課程介紹、Python 環境建置與基礎函式庫

> **Date 日期**: 2026/02/26  
> **Topic 主題**: Setting the Stage for Scientific Computing 奠定科學計算的基礎

---

## Learning Objectives 學習目標

1. 理解「再現性危機」(Reproducibility Crisis) 以及程式碼在科學研究中的核心角色
2. 安裝與設定 VS Code、Anaconda/Miniforge，建立虛擬環境
3. 複習 Python 基本概念：可變/不可變型別、List Comprehension、模組化設計
4. 學會使用 **NumPy** 進行高效能陣列操作

---

## 1. The Reproducibility Crisis & Why Code Matters
## 1. 再現性危機與程式碼的重要性

Psychology has faced a significant "Reproducibility Crisis"—many published experimental findings cannot be replicated. One major reason is that researchers often rely on manual procedures, point-and-click software, and undocumented analysis steps.

心理學界面臨嚴重的「再現性危機」——許多已發表的實驗結果無法被重複驗證。主要原因之一是研究者經常仰賴手動操作、點擊式軟體和未記錄的分析步驟。

**How code solves this 程式碼如何解決這個問題:**

- **Transparency 透明性**: Every step is documented in the script
- **Reproducibility 可重複性**: Anyone can re-run the same analysis
- **Version Control 版本控制**: Changes are tracked with Git
- **Automation 自動化**: Reduce human error in repetitive tasks

---

## 2. The Stack: Development Environment
## 2. 開發環境工具組

### 2.1 VS Code

[Visual Studio Code](https://code.visualstudio.com/) is a free, powerful code editor with excellent Python support.

**推薦擴充套件 Recommended Extensions:**

```
- Python (Microsoft)
- Jupyter (Microsoft)
- Pylance (language server)
- GitLens (Git visualization)
```

### 2.2 Anaconda / Miniforge

[Miniforge](https://github.com/conda-forge/miniforge) is a lightweight Conda installer that defaults to the `conda-forge` channel—ideal for PsychoPy dependencies.

Miniforge 是一個輕量級的 Conda 安裝程式，預設使用 `conda-forge` 頻道，對 PsychoPy 的相依性支援較佳。

### 2.3 Virtual Environments 虛擬環境

Virtual environments isolate project dependencies so they don't conflict with each other.

虛擬環境將專案的相依套件隔離開來，避免互相衝突。

```bash
# Create a new environment 建立新環境
conda create -n psychopy_env python=3.10

# Activate 啟動環境
conda activate psychopy_env

# Install packages 安裝套件
pip install psychopy numpy pandas matplotlib seaborn

# Deactivate when done 完成後停用
conda deactivate

# List all environments 列出所有環境
conda env list

# Remove an environment 移除環境
conda env remove -n psychopy_env
```

**`conda` vs `venv`:**

| Feature | `conda` | `venv` |
|---------|---------|--------|
| Manages non-Python deps | ✅ | ❌ |
| Cross-platform binaries | ✅ | ❌ |
| Built into Python | ❌ | ✅ |
| Environment size | Larger | Smaller |

> **Recommendation 建議**: Use `conda` for this course because PsychoPy has complex C-level dependencies (e.g., `wxPython`).

---

## 3. Python Refresher 
## 3. Python 複習

### 3.1 Mutable vs. Immutable Types 可變與不可變型別

```python
# Immutable types: int, float, str, tuple
# 不可變型別：修改時會建立新物件
x = 10
y = x
x = 20
print(y)  # Still 10 — integers are immutable

name = "PsychoPy"
# name[0] = "p"  # ❌ TypeError: strings are immutable

# Mutable types: list, dict, set
# 可變型別：修改會影響所有參照
colors = ["red", "green", "blue"]
backup = colors        # Both point to the SAME list!
colors.append("yellow")
print(backup)  # ['red', 'green', 'blue', 'yellow'] — also changed!

# Safe copy 安全複製
backup = colors.copy()  # or colors[:]
```

**Why this matters in experiments 為什麼這在實驗中很重要:**

When creating trial lists, accidentally sharing a mutable reference can cause conditions to "leak" between trials.

建立試驗列表時，若不小心共享可變參照，可能導致條件在試驗間「洩漏」。

### 3.2 List Comprehensions 列表推導式

```python
# Traditional loop 傳統迴圈
squares = []
for i in range(10):
    squares.append(i ** 2)

# List comprehension 列表推導式 — compact & Pythonic
squares = [i ** 2 for i in range(10)]

# With condition 加入條件篩選
even_squares = [i ** 2 for i in range(10) if i % 2 == 0]
# [0, 4, 16, 36, 64]

# Practical: Generate stimulus positions 實用：生成刺激位置
positions = [(x, y) for x in [-200, 0, 200] for y in [-200, 0, 200]]
```

### 3.3 Modular Design 模組化設計

```python
# experiment_utils.py — A reusable module for experiments
# 一個可重複使用的實驗工具模組

def generate_trial_list(conditions, n_repeats=10):
    """
    Generate a randomized trial list.
    產生隨機化的試驗列表。
    
    Parameters:
        conditions (list): List of condition labels
        n_repeats (int): Number of repetitions per condition
    
    Returns:
        list: Shuffled trial list
    """
    import random
    trials = conditions * n_repeats
    random.shuffle(trials)
    return trials


def calculate_accuracy(responses, correct_answers):
    """Calculate proportion correct. 計算正確率。"""
    assert len(responses) == len(correct_answers)
    hits = sum(r == c for r, c in zip(responses, correct_answers))
    return hits / len(responses)
```

```python
# main_experiment.py — Using the module
# 在主程式中使用模組
from experiment_utils import generate_trial_list, calculate_accuracy

conditions = ["congruent", "incongruent"]
trials = generate_trial_list(conditions, n_repeats=20)
print(f"Total trials: {len(trials)}")
# Total trials: 40
```

---

## 4. Introduction to NumPy
## 4. NumPy 入門

NumPy is the foundation of scientific computing in Python. It provides fast, memory-efficient array operations essential for coordinate systems, timing, and randomization in experiments.

NumPy 是 Python 科學計算的基石，提供快速、記憶體效率高的陣列運算，在實驗中的座標系統、計時和隨機化不可或缺。

### 4.1 Creating Arrays 建立陣列

```python
import numpy as np

# From a list 從列表建立
reaction_times = np.array([0.452, 0.389, 0.521, 0.467, 0.498])

# Useful constructors 常用建構函式
zeros = np.zeros(10)                  # 10 zeros
ones = np.ones((3, 4))                # 3×4 matrix of ones
sequence = np.arange(0, 1, 0.1)       # [0.0, 0.1, 0.2, ..., 0.9]
linspace = np.linspace(0, 2*np.pi, 100)  # 100 points from 0 to 2π
```

### 4.2 Array Operations 陣列運算

```python
# Element-wise operations (vectorized — no loops needed!)
# 逐元素運算（向量化——不需要迴圈！）
rt_seconds = reaction_times
rt_ms = rt_seconds * 1000  # Convert to milliseconds 轉換為毫秒
print(rt_ms)  # [452. 389. 521. 467. 498.]

# Descriptive statistics 描述性統計
print(f"Mean RT: {np.mean(rt_seconds):.3f}s")
print(f"SD:      {np.std(rt_seconds):.3f}s")
print(f"Median:  {np.median(rt_seconds):.3f}s")
print(f"Min/Max: {np.min(rt_seconds):.3f} – {np.max(rt_seconds):.3f}s")
```

### 4.3 Boolean Indexing & Filtering 布林索引與篩選

```python
# Filter outliers (RT > 500ms)
# 篩選離群值（反應時間 > 500ms）
outlier_mask = rt_seconds > 0.5
print(f"Outliers: {rt_seconds[outlier_mask]}")
print(f"Clean data: {rt_seconds[~outlier_mask]}")

# Count how many pass a threshold
fast_count = np.sum(rt_seconds < 0.45)
print(f"Fast responses: {fast_count}")
```

### 4.4 Random Number Generation 隨機數生成

```python
rng = np.random.default_rng(seed=42)  # Reproducible randomness 可重複的隨機

# Shuffle trial order 打亂試驗順序
trial_types = np.array(["go", "go", "go", "nogo"] * 25)  # 100 trials
rng.shuffle(trial_types)

# Generate random stimulus positions 生成隨機刺激位置
x_positions = rng.uniform(-300, 300, size=50)  # 50 random x-coords
y_positions = rng.uniform(-300, 300, size=50)

# Sample from a normal distribution 從常態分佈取樣
simulated_rt = rng.normal(loc=0.450, scale=0.080, size=200)
print(f"Simulated mean: {simulated_rt.mean():.3f}s")
```

---

## 5. Lab Activity: Install-Fest 🚀
## 5. 實作活動：安裝大會 🚀

**Goal 目標**: Ensure every student has a working local environment.

確保每位同學都有可用的開發環境。

### Checklist 檢查清單

- [ ] Install Miniforge or Anaconda
- [ ] Create `psychopy_env` with Python 3.10
- [ ] Install PsychoPy: `pip install psychopy`
- [ ] Install VS Code + Python extension
- [ ] Run the environment test script (see `week-01-README.md`)
- [ ] Verify NumPy works:

```python
import numpy as np
print(f"NumPy version: {np.__version__}")
data = np.random.default_rng(0).normal(0.5, 0.1, 100)
print(f"Mean: {data.mean():.4f}, SD: {data.std():.4f}")
```

---

## 6. Homework: "Hello Data"
## 6. 作業：「Hello Data」

> Write a Python script that generates a **synthetic dataset of reaction times** using NumPy.

撰寫一個 Python 腳本，使用 NumPy 生成**合成的反應時間資料集**。

### Requirements 要求

1. Generate 200 simulated reaction times from a normal distribution (mean = 450ms, SD = 80ms)
2. Add 10% "outlier" trials (RT > 800ms) to simulate lapses of attention
3. Print summary statistics (mean, SD, median, min, max)
4. Count and report the number of "fast" (< 300ms) and "slow" (> 600ms) responses
5. Save the data to a CSV file using NumPy

### Starter Code 起始程式碼

```python
import numpy as np

def generate_synthetic_rt(n_trials=200, mean_rt=450, sd_rt=80, 
                          outlier_fraction=0.10, outlier_min=800, 
                          outlier_max=1500, seed=42):
    """
    Generate synthetic reaction time data.
    產生合成的反應時間資料。
    """
    rng = np.random.default_rng(seed)
    
    # Step 1: Generate base RTs from normal distribution
    n_normal = int(n_trials * (1 - outlier_fraction))
    n_outlier = n_trials - n_normal
    
    normal_rt = rng.normal(loc=mean_rt, scale=sd_rt, size=n_normal)
    
    # Step 2: Generate outlier RTs
    # TODO: Generate outlier trials using rng.uniform()
    
    # Step 3: Combine and shuffle
    # TODO: Concatenate and shuffle all RTs
    
    # Step 4: Clip negative values (RT can't be negative)
    # TODO: Use np.clip() to ensure all RTs >= 50ms
    
    return all_rt

if __name__ == "__main__":
    rt_data = generate_synthetic_rt()
    
    # Print summary statistics
    print("=" * 40)
    print("  Synthetic RT Dataset Summary")
    print("=" * 40)
    # TODO: Print mean, SD, median, min, max
    
    # Count fast and slow responses
    # TODO: Use boolean indexing
    
    # Save to CSV
    # TODO: Use np.savetxt()
    print("Data saved to synthetic_rt.csv")
```

---

## References 參考資料

- **Python**: [https://docs.python.org/3/](https://docs.python.org/3/)
- **Anaconda**: [https://docs.anaconda.com/](https://docs.anaconda.com/)
- **Miniforge**: [https://github.com/conda-forge/miniforge](https://github.com/conda-forge/miniforge)
- **NumPy**: [https://numpy.org/doc/stable/](https://numpy.org/doc/stable/)
- **VS Code Python**: [https://code.visualstudio.com/docs/python/python-tutorial](https://code.visualstudio.com/docs/python/python-tutorial)
- **Reproducibility Crisis**: Open Science Collaboration (2015). *Estimating the reproducibility of psychological science.* Science, 349(6251), aac4716.
