# Week 5: Statistical Analysis & Data Visualization
# 第五週：統計分析與資料視覺化

> **Date 日期**: 2026/03/26  
> **Topic 主題**: From Raw Logs to Insights 從原始資料到洞見

---

## Learning Objectives 學習目標

1. 使用 **Pandas** 匯入、清理與整理實驗資料
2. 使用 **Seaborn** 和 **Matplotlib** 繪製 Violin plots、Scatter plots 和 Error bars
3. 使用 `scipy.stats` 進行 t 檢定和相關分析
4. 分析第三週的 Stroop Task 資料，產出可發表品質的圖表

---

## 1. Data Loading & Cleaning with Pandas
## 1. 使用 Pandas 載入與清理資料

```python
import pandas as pd
import numpy as np

# Load Stroop data from Week 3 載入第三週的 Stroop 資料
df = pd.read_csv('data/001_stroop.csv')

# Explore the dataset 探索資料集
print(f"Shape: {df.shape}")        # (rows, columns)
print(f"Columns: {list(df.columns)}")
df.head()
```

### 1.1 Filtering Outliers 篩選離群值

```python
# Remove extremely fast (< 200ms) or slow (> 2000ms) responses
# 移除極快（< 200ms）或極慢（> 2000ms）的反應
df_clean = df[(df['rt'] > 0.2) & (df['rt'] < 2.0)].copy()
print(f"Removed {len(df) - len(df_clean)} outlier trials")

# Remove incorrect trials for RT analysis
# 移除錯誤試驗以進行 RT 分析
df_correct = df_clean[df_clean['correct'] == 1].copy()
print(f"Correct trials: {len(df_correct)} / {len(df_clean)}")
```

### 1.2 Grouping & Aggregation 分組與聚合

```python
# Mean RT by condition 各條件的平均反應時間
rt_by_condition = df_correct.groupby('congruent')['rt'].agg(
    ['mean', 'std', 'count']
)
print(rt_by_condition)

# Per-participant summary (for group studies)
# 每位受試者的摘要（用於群體研究）
participant_means = df_correct.groupby(
    ['participant', 'congruent']
)['rt'].mean().reset_index()
```

### 1.3 Handling Missing Values 處理遺漏值

```python
# Check for missing data 檢查遺漏值
print(df.isnull().sum())

# Drop rows with missing RT
df.dropna(subset=['rt'], inplace=True)

# Or fill with a default (use cautiously!)
# df['rt'].fillna(df['rt'].median(), inplace=True)
```

---

## 2. Data Visualization
## 2. 資料視覺化

```python
import matplotlib.pyplot as plt
import seaborn as sns

# Style setup 風格設定
sns.set_theme(style='whitegrid', font_scale=1.2)
plt.rcParams['figure.dpi'] = 150
```

### 2.1 Violin Plot 小提琴圖

Shows the full distribution of RT for each condition.

顯示每個條件下 RT 的完整分佈。

```python
fig, ax = plt.subplots(figsize=(8, 5))
sns.violinplot(data=df_correct, x='congruent', y='rt', 
               palette=['#2ecc71', '#e74c3c'], inner='box', ax=ax)
ax.set_xlabel('Condition 條件')
ax.set_ylabel('Reaction Time (s) 反應時間')
ax.set_title('Stroop Effect: RT Distribution by Congruency')
ax.set_xticklabels(['Congruent 一致', 'Incongruent 不一致'])
plt.tight_layout()
plt.savefig('figures/stroop_violin.png', dpi=300)
plt.show()
```

### 2.2 Bar Plot with Error Bars 含誤差線的長條圖

```python
fig, ax = plt.subplots(figsize=(6, 5))
sns.barplot(data=df_correct, x='congruent', y='rt',
            palette=['#2ecc71', '#e74c3c'], 
            errorbar='se',  # Standard error 標準誤
            capsize=0.1, ax=ax)
ax.set_xlabel('Condition 條件')
ax.set_ylabel('Mean RT ± SE (s)')
ax.set_title('Stroop Effect: Mean Reaction Time')
ax.set_xticklabels(['Congruent', 'Incongruent'])
plt.tight_layout()
plt.savefig('figures/stroop_bar.png', dpi=300)
plt.show()
```

### 2.3 Scatter Plot: RT vs. Trial Number 散佈圖：RT 隨試驗的變化

```python
fig, ax = plt.subplots(figsize=(10, 4))
colors = {'yes': '#2ecc71', 'no': '#e74c3c'}
for cond, grp in df_correct.groupby('congruent'):
    ax.scatter(grp.index, grp['rt'], alpha=0.5, s=15,
               color=colors[cond], label=cond)
ax.set_xlabel('Trial Number 試驗編號')
ax.set_ylabel('RT (s)')
ax.set_title('RT Across Trials (Practice Effect?)')
ax.legend(title='Congruent')
plt.tight_layout()
plt.savefig('figures/stroop_scatter.png', dpi=300)
plt.show()
```

### 2.4 Histogram of RT Distribution RT 分佈直方圖

```python
fig, ax = plt.subplots(figsize=(8, 4))
for cond, color, label in [('yes', '#2ecc71', 'Congruent'), 
                            ('no', '#e74c3c', 'Incongruent')]:
    subset = df_correct[df_correct['congruent'] == cond]['rt']
    ax.hist(subset, bins=25, alpha=0.6, color=color, label=label, edgecolor='white')
ax.set_xlabel('RT (s)')
ax.set_ylabel('Count 次數')
ax.set_title('RT Distribution by Condition')
ax.legend()
plt.tight_layout()
plt.savefig('figures/stroop_hist.png', dpi=300)
plt.show()
```

---

## 3. Statistical Analysis
## 3. 統計分析

### 3.1 Paired-Samples t-test 配對樣本 t 檢定

```python
from scipy import stats

# Get mean RT per condition for each participant
# 取得每位受試者在各條件下的平均 RT
cong_rt = participant_means[participant_means['congruent'] == 'yes']['rt'].values
incong_rt = participant_means[participant_means['congruent'] == 'no']['rt'].values

# Paired t-test (within-subject design) 配對 t 檢定（受試者內設計）
t_stat, p_value = stats.ttest_rel(incong_rt, cong_rt)
print(f"t({len(cong_rt)-1}) = {t_stat:.3f}, p = {p_value:.4f}")

# Effect size: Cohen's d 效果量
mean_diff = np.mean(incong_rt - cong_rt)
sd_diff = np.std(incong_rt - cong_rt, ddof=1)
cohens_d = mean_diff / sd_diff
print(f"Cohen's d = {cohens_d:.3f}")

# Interpretation 解讀
if p_value < 0.05:
    print("✓ Significant Stroop effect!")
else:
    print("✗ No significant difference (need more data?)")
```

### 3.2 Correlation Analysis 相關分析

```python
# Is there a speed-accuracy tradeoff? 有速度-正確性取捨嗎？
accuracy_by_trial = df_clean.groupby('participant').agg(
    mean_rt=('rt', 'mean'),
    accuracy=('correct', 'mean')
).reset_index()

r, p = stats.pearsonr(accuracy_by_trial['mean_rt'], 
                       accuracy_by_trial['accuracy'])
print(f"Pearson r = {r:.3f}, p = {p:.4f}")

# Scatter plot with regression line 含回歸線的散佈圖
fig, ax = plt.subplots(figsize=(6, 5))
sns.regplot(data=accuracy_by_trial, x='mean_rt', y='accuracy', ax=ax)
ax.set_xlabel('Mean RT (s)')
ax.set_ylabel('Accuracy')
ax.set_title(f'Speed-Accuracy Tradeoff (r={r:.3f})')
plt.tight_layout()
plt.savefig('figures/speed_accuracy.png', dpi=300)
plt.show()
```

---

## 4. Lab: Analyze Your Stroop Data
## 4. 實作：分析你的 Stroop 資料

### Deliverable 繳交作業

Write a Python script that:

1. Loads your Stroop data CSV from Week 3
2. Cleans outliers (RT < 200ms or > 2000ms)
3. Computes mean RT for congruent vs. incongruent trials
4. Runs a t-test to assess the Stroop effect
5. Produces a **publication-quality figure** showing the RT difference

Expected output: A figure like this showing the "Stroop Effect":

```
┌────────────────────────────────┐
│   Stroop Effect: RT by Cond.   │
│                                │
│  ┌─────┐                      │
│  │     │  ┌─────┐             │
│  │ 450 │  │ 520 │  ms         │
│  │     │  │     │             │
│  └──┬──┘  └──┬──┘             │
│   Cong.   Incong.             │
│    **p < .001, d = 0.85**     │
└────────────────────────────────┘
```

---

## References 參考資料

- **Pandas**: [https://pandas.pydata.org/docs/](https://pandas.pydata.org/docs/)
- **Seaborn**: [https://seaborn.pydata.org/](https://seaborn.pydata.org/)
- **Matplotlib**: [https://matplotlib.org/stable/](https://matplotlib.org/stable/)
- **SciPy Stats**: [https://docs.scipy.org/doc/scipy/reference/stats.html](https://docs.scipy.org/doc/scipy/reference/stats.html)
- **APA Figures Guide**: [https://apastyle.apa.org/style-grammar-guidelines/tables-figures](https://apastyle.apa.org/style-grammar-guidelines/tables-figures)
