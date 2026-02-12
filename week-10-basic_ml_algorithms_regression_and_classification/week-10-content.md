# Week 10: Basic ML Algorithms — Regression & Classification
# 第十週：基礎機器學習演算法 — 迴歸與分類

> **Date 日期**: 2026/04/30  
> **Topic 主題**: Predictive Modeling 預測建模

---

## Learning Objectives 學習目標

1. 理解**線性迴歸** (Linear Regression) 的原理，用於預測連續變數
2. 理解**邏輯迴歸** (Logistic Regression) 與 **SVM** 用於分類任務
3. 學會使用混淆矩陣、Accuracy、Precision、Recall、ROC-AUC 評估模型
4. 在心理學情境中訓練一個分類模型預測試驗結果

---

## 1. Linear Regression 線性迴歸

Linear regression models the relationship between a continuous dependent variable and one or more independent variables.

線性迴歸建立連續依變項與一個或多個自變項之間的關係模型。

### 1.1 Simple Linear Regression 簡單線性迴歸

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score

# Simulate data: Study hours → Exam score
# 模擬資料：讀書時數 → 考試成績
np.random.seed(42)
hours = np.random.uniform(1, 10, 100)
scores = 40 + 5 * hours + np.random.normal(0, 5, 100)

X = hours.reshape(-1, 1)  # sklearn requires 2D array for features
y = scores

# Train/test split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Fit the model 訓練模型
model = LinearRegression()
model.fit(X_train, y_train)

print(f"Intercept (截距): {model.intercept_:.2f}")
print(f"Slope (斜率): {model.coef_[0]:.2f}")

# Predict and evaluate 預測與評估
y_pred = model.predict(X_test)
print(f"MSE: {mean_squared_error(y_test, y_pred):.2f}")
print(f"R²: {r2_score(y_test, y_pred):.3f}")

# Visualize 視覺化
fig, ax = plt.subplots(figsize=(8, 5))
ax.scatter(X_test, y_test, alpha=0.6, label='Actual')
ax.plot(X_test, y_pred, color='red', linewidth=2, label='Predicted')
ax.set_xlabel('Study Hours 讀書時數')
ax.set_ylabel('Exam Score 考試成績')
ax.set_title('Linear Regression: Hours vs. Score')
ax.legend()
plt.tight_layout()
plt.show()
```

### 1.2 Multiple Regression 多元迴歸

```python
# Predict RT from multiple features 用多個特徵預測反應時間
np.random.seed(42)
n = 200
data = pd.DataFrame({
    'age': np.random.randint(18, 65, n),
    'sleep_hours': np.random.uniform(4, 9, n),
    'caffeine_mg': np.random.uniform(0, 400, n),
})
# Simulate RT: older, less sleep, more caffeine → slower
data['rt'] = (
    300 + 2 * data['age'] 
    - 15 * data['sleep_hours'] 
    + 0.1 * data['caffeine_mg'] 
    + np.random.normal(0, 30, n)
)

X = data[['age', 'sleep_hours', 'caffeine_mg']]
y = data['rt']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
model = LinearRegression()
model.fit(X_train, y_train)

# Feature importance 特徵重要性
for name, coef in zip(X.columns, model.coef_):
    print(f"  {name}: {coef:.3f}")
print(f"R² = {model.score(X_test, y_test):.3f}")
```

---

## 2. Logistic Regression 邏輯迴歸

Logistic regression is used for **binary classification** — predicting one of two categories.

邏輯迴歸用於**二元分類** — 預測兩個類別之一。

```python
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report

# Psychology example: Predict if participant makes an error
# 心理學範例：預測參與者是否會犯錯
np.random.seed(42)
n = 300
data = pd.DataFrame({
    'prev_rt': np.random.normal(500, 100, n),          # Previous trial RT
    'prev_correct': np.random.choice([0, 1], n, p=[0.2, 0.8]),  # Previous accuracy
    'trial_number': np.arange(1, n + 1),               # Fatigue factor
})
# Slower RT + late trials → more errors
error_prob = 1 / (1 + np.exp(-(
    -3 + 0.003 * data['prev_rt'] 
    - 0.5 * data['prev_correct'] 
    + 0.002 * data['trial_number']
)))
data['error'] = (np.random.random(n) < error_prob).astype(int)

X = data[['prev_rt', 'prev_correct', 'trial_number']]
y = data['error']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

clf = LogisticRegression(random_state=42)
clf.fit(X_train, y_train)
y_pred = clf.predict(X_test)

print(f"Accuracy: {accuracy_score(y_test, y_pred):.3f}")
print("\nClassification Report:")
print(classification_report(y_test, y_pred, target_names=['Correct', 'Error']))
```

---

## 3. Support Vector Machine (SVM) 支持向量機

SVM finds the optimal hyperplane that separates classes with the maximum margin.

SVM 尋找以最大間距分隔類別的最佳超平面。

```python
from sklearn.svm import SVC
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline

# Create a pipeline: scale features → SVM
# 建立管道：特徵縮放 → SVM
svm_pipeline = Pipeline([
    ('scaler', StandardScaler()),
    ('svm', SVC(kernel='rbf', C=1.0, random_state=42))
])

svm_pipeline.fit(X_train, y_train)
y_pred_svm = svm_pipeline.predict(X_test)

print(f"SVM Accuracy: {accuracy_score(y_test, y_pred_svm):.3f}")
print("\nSVM Classification Report:")
print(classification_report(y_test, y_pred_svm, target_names=['Correct', 'Error']))
```

### Kernel Comparison 核函數比較

| Kernel | Use Case | Description |
|--------|----------|-------------|
| `linear` | Linearly separable data | Simple, fast |
| `rbf` | Non-linear boundaries | Most common default |
| `poly` | Polynomial relationships | Good for interaction effects |

---

## 4. Model Evaluation 模型評估

### 4.1 Confusion Matrix 混淆矩陣

```python
from sklearn.metrics import (
    confusion_matrix, ConfusionMatrixDisplay,
    roc_curve, roc_auc_score
)

# Confusion Matrix 混淆矩陣
cm = confusion_matrix(y_test, y_pred)
disp = ConfusionMatrixDisplay(cm, display_labels=['Correct', 'Error'])
disp.plot(cmap='Blues')
plt.title('Confusion Matrix')
plt.tight_layout()
plt.show()

print(f"True Negatives:  {cm[0,0]}")
print(f"False Positives: {cm[0,1]}")
print(f"False Negatives: {cm[1,0]}")
print(f"True Positives:  {cm[1,1]}")
```

### 4.2 ROC Curve & AUC

```python
# Get probability scores for ROC
# 取得 ROC 的機率分數
y_prob = clf.predict_proba(X_test)[:, 1]
fpr, tpr, thresholds = roc_curve(y_test, y_prob)
auc = roc_auc_score(y_test, y_prob)

fig, ax = plt.subplots(figsize=(6, 5))
ax.plot(fpr, tpr, color='blue', lw=2, label=f'ROC (AUC = {auc:.3f})')
ax.plot([0, 1], [0, 1], 'k--', lw=1, label='Random')
ax.set_xlabel('False Positive Rate')
ax.set_ylabel('True Positive Rate')
ax.set_title('ROC Curve')
ax.legend()
plt.tight_layout()
plt.show()

# Interpretation 解讀
# AUC = 0.5: random guessing 隨機猜測
# AUC = 1.0: perfect classifier 完美分類器
# AUC > 0.7: generally acceptable 一般可接受
```

---

## 5. Lab: Predict Trial Errors
## 5. 實作：預測試驗錯誤

### Challenge 挑戰

Using the Stroop/behavioral data from previous weeks:

1. Engineer features from trial data (RT, congruency, trial position)
2. Train a Logistic Regression model to predict errors
3. Evaluate with confusion matrix and ROC-AUC
4. Compare against an SVM classifier

```python
# Starter template 起始模板
from sklearn.model_selection import cross_val_score

# TODO: Load your behavioral data
# df = pd.read_csv('data/stroop_data.csv')

# TODO: Feature engineering
# X = df[['rt', 'congruent_code', 'trial_number']]
# y = df['error']

# TODO: Train and evaluate models
# lr_scores = cross_val_score(LogisticRegression(), X, y, cv=5, scoring='roc_auc')
# svm_scores = cross_val_score(Pipeline([('s', StandardScaler()), ('svm', SVC(probability=True))]),
#                               X, y, cv=5, scoring='roc_auc')

# TODO: Compare results
# print(f"Logistic Regression AUC: {lr_scores.mean():.3f} ± {lr_scores.std():.3f}")
# print(f"SVM AUC: {svm_scores.mean():.3f} ± {svm_scores.std():.3f}")
```

---

## References 參考資料

- **Scikit-learn Supervised Learning**: [https://scikit-learn.org/stable/supervised_learning.html](https://scikit-learn.org/stable/supervised_learning.html)
- **Logistic Regression**: [https://scikit-learn.org/stable/modules/linear_model.html#logistic-regression](https://scikit-learn.org/stable/modules/linear_model.html#logistic-regression)
- **SVM**: [https://scikit-learn.org/stable/modules/svm.html](https://scikit-learn.org/stable/modules/svm.html)
- **Model Evaluation**: [https://scikit-learn.org/stable/modules/model_evaluation.html](https://scikit-learn.org/stable/modules/model_evaluation.html)