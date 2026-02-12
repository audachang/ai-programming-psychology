# Week 11: Advanced ML Algorithms
# 第十一週：進階機器學習演算法

> **Date 日期**: 2026/05/07  
> **Topic 主題**: Complexity & Unsupervised Learning 複雜度與非監督式學習

---

## Learning Objectives 學習目標

1. 理解**決策樹** (Decision Trees) 的運作原理與視覺化
2. 掌握**隨機森林** (Random Forests) 與**梯度提升** (XGBoost) 等集成方法
3. 使用 **PCA** 進行高維資料的降維與視覺化
4. 使用 **K-Means** 聚類分析探索資料的內在結構

---

## 1. Decision Trees 決策樹

A decision tree splits data recursively based on feature thresholds to make predictions.

決策樹根據特徵閾值遞迴地分割資料以進行預測。

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.tree import DecisionTreeClassifier, plot_tree
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report

# Simulate psychology data: predict cognitive decline
# 模擬心理學資料：預測認知退化
np.random.seed(42)
n = 200
data = pd.DataFrame({
    'age': np.random.randint(40, 85, n),
    'education_years': np.random.randint(8, 22, n),
    'sleep_quality': np.random.uniform(1, 10, n),
    'exercise_freq': np.random.randint(0, 7, n),
})
# Rule: older + less education + poor sleep → decline
decline_prob = 1 / (1 + np.exp(-(
    -5 + 0.08 * data['age'] 
    - 0.15 * data['education_years'] 
    - 0.2 * data['sleep_quality']
)))
data['cognitive_decline'] = (np.random.random(n) < decline_prob).astype(int)

X = data.drop('cognitive_decline', axis=1)
y = data['cognitive_decline']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train decision tree 訓練決策樹
tree = DecisionTreeClassifier(max_depth=4, random_state=42)
tree.fit(X_train, y_train)
print(f"Accuracy: {accuracy_score(y_test, tree.predict(X_test)):.3f}")

# Visualize the tree 視覺化決策樹
fig, ax = plt.subplots(figsize=(16, 8))
plot_tree(tree, feature_names=X.columns, class_names=['Healthy', 'Decline'],
          filled=True, rounded=True, ax=ax, fontsize=9)
plt.title('Decision Tree: Cognitive Decline Prediction')
plt.tight_layout()
plt.show()
```

---

## 2. Random Forests & Ensemble Methods
## 2. 隨機森林與集成方法

Ensemble methods combine multiple models to achieve better performance than any single model.

集成方法結合多個模型，以獲得優於任何單一模型的表現。

### 2.1 Random Forest 隨機森林

```python
from sklearn.ensemble import RandomForestClassifier

# Train random forest 訓練隨機森林
rf = RandomForestClassifier(n_estimators=100, max_depth=5, random_state=42)
rf.fit(X_train, y_train)
y_pred_rf = rf.predict(X_test)

print(f"Random Forest Accuracy: {accuracy_score(y_test, y_pred_rf):.3f}")

# Feature importance 特徵重要性
importances = pd.Series(rf.feature_importances_, index=X.columns)
importances = importances.sort_values(ascending=True)

fig, ax = plt.subplots(figsize=(8, 4))
importances.plot(kind='barh', color='steelblue', ax=ax)
ax.set_xlabel('Feature Importance')
ax.set_title('Random Forest: Feature Importance for Cognitive Decline')
plt.tight_layout()
plt.show()
```

### 2.2 Gradient Boosting (XGBoost) 梯度提升

```python
# pip install xgboost
from sklearn.ensemble import GradientBoostingClassifier

gbc = GradientBoostingClassifier(
    n_estimators=100, learning_rate=0.1, max_depth=3, random_state=42
)
gbc.fit(X_train, y_train)
y_pred_gbc = gbc.predict(X_test)

print(f"Gradient Boosting Accuracy: {accuracy_score(y_test, y_pred_gbc):.3f}")

# Compare all models 比較所有模型
from sklearn.model_selection import cross_val_score

models = {
    'Decision Tree': DecisionTreeClassifier(max_depth=4, random_state=42),
    'Random Forest': RandomForestClassifier(n_estimators=100, random_state=42),
    'Gradient Boosting': GradientBoostingClassifier(n_estimators=100, random_state=42),
}

for name, model in models.items():
    scores = cross_val_score(model, X, y, cv=5, scoring='accuracy')
    print(f"{name}: {scores.mean():.3f} ± {scores.std():.3f}")
```

---

## 3. PCA — Dimensionality Reduction
## 3. PCA — 降維

PCA (Principal Component Analysis) reduces high-dimensional data to fewer dimensions while preserving maximum variance.

主成分分析 (PCA) 將高維資料降至較少的維度，同時保留最大的變異。

```python
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler

# Simulate high-dimensional survey data (e.g., 20 personality items)
# 模擬高維問卷資料（例如 20 題人格量表）
np.random.seed(42)
n_participants = 200
n_items = 20

# Generate data with 3 latent factors 產生具有 3 個潛在因子的資料
latent = np.random.randn(n_participants, 3)
loadings = np.random.randn(3, n_items) * 0.7
survey_data = latent @ loadings + np.random.randn(n_participants, n_items) * 0.5

# Standardize first 先標準化
scaler = StandardScaler()
survey_scaled = scaler.fit_transform(survey_data)

# Apply PCA 應用 PCA
pca = PCA()
pca.fit(survey_scaled)

# Scree plot: How much variance each component explains
# 碎石圖：每個成分解釋多少變異
fig, axes = plt.subplots(1, 2, figsize=(12, 4))

axes[0].bar(range(1, n_items + 1), pca.explained_variance_ratio_, color='steelblue')
axes[0].set_xlabel('Principal Component')
axes[0].set_ylabel('Explained Variance Ratio')
axes[0].set_title('Scree Plot 碎石圖')

# Cumulative variance 累積變異
cumvar = np.cumsum(pca.explained_variance_ratio_)
axes[1].plot(range(1, n_items + 1), cumvar, 'o-', color='steelblue')
axes[1].axhline(y=0.8, color='red', linestyle='--', label='80% threshold')
axes[1].set_xlabel('Number of Components')
axes[1].set_ylabel('Cumulative Variance')
axes[1].set_title('Cumulative Explained Variance')
axes[1].legend()
plt.tight_layout()
plt.show()

# Project to 2D for visualization 投射到 2D 以視覺化
pca_2d = PCA(n_components=2)
survey_2d = pca_2d.fit_transform(survey_scaled)

fig, ax = plt.subplots(figsize=(7, 5))
ax.scatter(survey_2d[:, 0], survey_2d[:, 1], alpha=0.5, s=20)
ax.set_xlabel(f'PC1 ({pca_2d.explained_variance_ratio_[0]:.1%})')
ax.set_ylabel(f'PC2 ({pca_2d.explained_variance_ratio_[1]:.1%})')
ax.set_title('Survey Data Projected to 2D (PCA)')
plt.tight_layout()
plt.show()
```

---

## 4. K-Means Clustering K-Means 聚類分析

K-Means groups data points into K clusters based on feature similarity.

K-Means 根據特徵相似性將資料點分成 K 個群組。

```python
from sklearn.cluster import KMeans

# Use the PCA-reduced survey data 使用 PCA 降維後的問卷資料
# Find optimal K using the Elbow Method
# 使用手肘法找到最佳 K 值
inertias = []
K_range = range(2, 10)
for k in K_range:
    km = KMeans(n_clusters=k, random_state=42, n_init=10)
    km.fit(survey_2d)
    inertias.append(km.inertia_)

fig, ax = plt.subplots(figsize=(7, 4))
ax.plot(K_range, inertias, 'o-', color='steelblue')
ax.set_xlabel('K (Number of Clusters)')
ax.set_ylabel('Inertia (Within-Cluster Sum of Squares)')
ax.set_title('Elbow Method for Optimal K')
plt.tight_layout()
plt.show()

# Apply K-Means with chosen K 應用選定的 K 值
k = 3  # Based on elbow plot
km = KMeans(n_clusters=k, random_state=42, n_init=10)
clusters = km.fit_predict(survey_2d)

fig, ax = plt.subplots(figsize=(7, 5))
scatter = ax.scatter(survey_2d[:, 0], survey_2d[:, 1], 
                     c=clusters, cmap='Set2', alpha=0.6, s=30)
centers = km.cluster_centers_
ax.scatter(centers[:, 0], centers[:, 1], c='red', marker='X', s=200, 
           edgecolors='black', linewidths=1, label='Centroids')
ax.set_xlabel('PC1')
ax.set_ylabel('PC2')
ax.set_title(f'K-Means Clustering (K={k}) on Survey Data')
ax.legend()
plt.tight_layout()
plt.show()
```

---

## 5. Lab: PCA + K-Means on Behavioral Data
## 5. 實作：對行為資料進行 PCA + K-Means

### Task 任務

1. Generate or load a dataset with 10+ features (e.g., multi-task cognitive battery)
2. Standardize and apply PCA — determine how many components to keep
3. Visualize the data in 2D PCA space
4. Apply K-Means to identify participant subgroups
5. Interpret: Do the clusters map onto known variables (age group, clinical status)?

---

## References 參考資料

- **Decision Trees**: [https://scikit-learn.org/stable/modules/tree.html](https://scikit-learn.org/stable/modules/tree.html)
- **Random Forest**: [https://scikit-learn.org/stable/modules/ensemble.html](https://scikit-learn.org/stable/modules/ensemble.html)
- **PCA**: [https://scikit-learn.org/stable/modules/decomposition.html#pca](https://scikit-learn.org/stable/modules/decomposition.html#pca)
- **K-Means**: [https://scikit-learn.org/stable/modules/clustering.html#k-means](https://scikit-learn.org/stable/modules/clustering.html#k-means)
- **XGBoost Docs**: [https://xgboost.readthedocs.io/](https://xgboost.readthedocs.io/)