# Week 9: Machine Learning Foundations
# 第九週：機器學習基礎

> **Date 日期**: 2026/04/23  
> **Topic 主題**: Concepts & Pipelines 概念與流程

---

## Learning Objectives 學習目標

1. 理解機器學習的基本概念：監督式學習與非監督式學習、特徵與標籤。
2. 熟悉機器學習工作流程 (ML Pipeline)，包含資料預處理步驟。
3. 掌握資料分割 (Train/Test Split) 與交叉驗證 (Cross-Validation) 的重要性與實作。
4. 認識偏差-變異權衡 (Bias-Variance Tradeoff) 對模型表現的影響。
5. 入門 `scikit-learn` 函式庫，進行基本的機器學習任務。

---

## 1. Introduction to Machine Learning 機器學習導論
## 1.1 Supervised vs. Unsupervised Learning 監督式與非監督式學習

機器學習是人工智慧的一個分支，旨在讓電腦從資料中學習，而不是透過明確的程式指令。

**監督式學習 (Supervised Learning):**
- **定義**: 模型從帶有「標籤」(labels) 的資料中學習，目標是預測新資料的輸出。
- **範例**: 預測房價 (迴歸)、辨識電子郵件是否為垃圾郵件 (分類)。
- **心理學應用**: 根據腦電圖 (EEG) 特徵預測個體的認知狀態；根據行為數據分類臨床群體。

**非監督式學習 (Unsupervised Learning):**
- **定義**: 模型從沒有預設標籤的資料中學習模式，目標是發現資料的內在結構或分組。
- **範例**: 將顧客分群 (聚類)、降維 (PCA)。
- **心理學應用**: 從大量問卷反應中找出潛在的人格特質群體；分析 fMRI 數據以識別大腦活動模式。

```python
# Conceptual example of data with features and labels
# 帶有特徵和標籤的資料概念範例
features = [[1.2, 3.1], [2.5, 2.8], [0.8, 3.5], [3.0, 1.9]] # X (e.g., age, reaction time)
labels = [0, 1, 0, 1]                                      # y (e.g., control, patient)

print(f"Features (X): {features}")
print(f"Labels (y): {labels}")

# In unsupervised learning, 'labels' would be absent
# 在非監督式學習中，'labels' 會不存在
unsupervised_features = [[1.2, 3.1], [2.5, 2.8], [0.8, 3.5], [3.0, 1.9]]
print(f"Unsupervised Features: {unsupervised_features}")
```

---

## 2. The ML Pipeline 機器學習工作流程
## 2.1 Data Preprocessing 資料預處理

機器學習任務通常遵循一個標準的工作流程，從資料準備到模型部署。資料預處理是其中關鍵的第一步。

**主要步驟 (Key Steps):**

1.  **資料收集 (Data Collection)**
2.  **資料清理 (Data Cleaning)**: 處理遺失值、異常值。
3.  **資料預處理 (Data Preprocessing)**:
    *   **特徵縮放 (Feature Scaling)**: 將數值特徵轉換到相似的尺度，例如標準化 (Standardization) 或正規化 (Normalization)。這對於許多演算法（如 SVM、KNN）至關重要。
    *   **類別特徵編碼 (Categorical Feature Encoding)**: 將類別資料（如 "男性" / "女性"）轉換為數值形式，如 One-Hot Encoding。
    *   **特徵工程 (Feature Engineering)**: 創造新的特徵以提升模型表現。
4.  **模型訓練 (Model Training)**
5.  **模型評估 (Model Evaluation)**
6.  **模型部署 (Model Deployment)**

```python
import pandas as pd
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
import numpy as np

# Sample data 範例資料
data = {
    'Age': [25, 30, 35, 28, 40, 22],
    'RT': [450, 380, 520, 470, 410, 490],
    'Gender': ['Male', 'Female', 'Male', 'Female', 'Male', 'Female'],
    'CognitiveScore': [10, 12, 9, 11, 13, 10]
}
df = pd.DataFrame(data)
print("Original DataFrame:")
print(df)

# Define preprocessing steps
# 定義預處理步驟
numeric_features = ['Age', 'RT']
categorical_features = ['Gender']

# Create a preprocessor using ColumnTransformer
# 使用 ColumnTransformer 建立預處理器
preprocessor = ColumnTransformer(
    transformers=[
        ('num', StandardScaler(), numeric_features),
        ('cat', OneHotEncoder(handle_unknown='ignore'), categorical_features)
    ])

# Apply preprocessing (e.g., as part of a pipeline)
# 應用預處理（例如，作為管道的一部分）
# For demonstration, we'll just transform here
# 為了示範，我們在這裡只進行轉換
transformed_data = preprocessor.fit_transform(df)
print("
Transformed data (numeric scaled, categorical one-hot encoded):")
print(transformed_data)
print(f"Transformed data shape: {transformed_data.shape}")
```

---

## 3. Data Splitting & Cross-Validation 資料分割與交叉驗證
## 3.1 Train/Test Split 訓練集/測試集分割

為了評估模型的泛化能力（對未見資料的表現），我們必須將資料分成訓練集和測試集。

-   **訓練集 (Training Set)**: 用於訓練模型。
-   **測試集 (Test Set)**: 用於評估模型，模型在訓練過程中從未見過這些資料。

**重要性**: 避免模型過度擬合 (Overfitting) 訓練資料，導致在新資料上表現不佳。

```python
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score

# Generate synthetic data
# 生成合成資料
X = np.random.rand(100, 5) # 100 samples, 5 features
y = (X[:, 0] + X[:, 1] > 1).astype(int) # Binary labels based on first two features

print(f"Original X shape: {X.shape}")
print(f"Original y shape: {y.shape}")

# Split data into training and testing sets (80% train, 20% test)
# 將資料分割為訓練集和測試集（80% 訓練，20% 測試）
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

print(f"X_train shape: {X_train.shape}")
print(f"X_test shape: {X_test.shape}")
print(f"y_train shape: {y_train.shape}")
print(f"y_test shape: {y_test.shape}")

# Train a simple model
# 訓練一個簡單模型
model = LogisticRegression(random_state=42)
model.fit(X_train, y_train)

# Evaluate on the test set
# 在測試集上評估
y_pred = model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print(f"Model accuracy on test set: {accuracy:.2f}")
```

## 3.2 Cross-Validation 交叉驗證

當資料量有限時，單次訓練/測試分割可能不穩定。交叉驗證是一種更穩健的評估方法。

**K-Fold Cross-Validation (K-折交叉驗證):**
1.  將資料分成 K 個大小相等的「折」(folds)。
2.  重複 K 次：每次用 K-1 個折作為訓練集，剩餘的 1 個折作為驗證集。
3.  計算 K 次模型表現的平均值和標準差。

**優點**:
-   更全面地利用資料進行訓練和評估。
-   提供對模型泛化能力更可靠的估計。

```python
from sklearn.model_selection import KFold, cross_val_score

# K-Fold Cross-Validation example
# K-折交叉驗證範例
kf = KFold(n_splits=5, shuffle=True, random_state=42) # 5 folds

# Evaluate the model using cross-validation
# 使用交叉驗證評估模型
cv_scores = cross_val_score(model, X, y, cv=kf, scoring='accuracy')

print(f"Cross-validation scores: {cv_scores}")
print(f"Average CV accuracy: {cv_scores.mean():.2f} (+/- {cv_scores.std():.2f})")
```

---

## 4. Bias-Variance Tradeoff 偏差-變異權衡

理解偏差與變異是建立優良機器學習模型的關鍵。

-   **偏差 (Bias)**: 模型對訓練資料的預測與真實值之間的系統性誤差。
    -   **高偏差**: 模型過於簡單，未能捕捉資料中的真實模式 (欠擬合, Underfitting)。
    -   **心理學類比**: 一個過於簡化的理論無法解釋複雜的人類行為。
-   **變異 (Variance)**: 模型對不同訓練資料集敏感度的量度。
    -   **高變異**: 模型對訓練資料中的雜訊過於敏感，導致對新資料的預測能力差 (過度擬合, Overfitting)。
    -   **心理學類比**: 一個對特定樣本數據過度解釋的理論，無法推廣到其他人群。

**權衡 (Tradeoff)**: 降低偏差通常會增加變異，反之亦然。目標是找到兩者之間的最佳平衡點，以達到最佳的泛化能力。

|           | 低偏差 (Low Bias)         | 高偏差 (High Bias)        |
| :-------- | :------------------------ | :------------------------ |
| **低變異 (Low Variance)** | 理想情況 (Ideal)          | 模型欠擬合 (Underfit)     |
| **高變異 (High Variance)** | 模型過度擬合 (Overfit)    | 糟糕情況 (Worst Case)     |

**範例**:
-   **線性迴歸 (Linear Regression)**: 通常偏差較高（模型簡單），變異較低。
-   **決策樹 (Decision Tree)**: 深度過大時，可能偏差較低但變異很高（過度擬合）。

---

## 5. Lab Activity: Data Preprocessing for ML
## 5. 實作活動：機器學習的資料預處理

**目標**: 使用 `scikit-learn` 對一個合成的行為資料集進行預處理，使其準備好用於機器學習模型。

**Goal**: Use `scikit-learn` to preprocess a synthetic behavioral dataset, preparing it for machine learning models.

### 任務 Task

1.  生成一個包含數值 (年齡、反應時間) 和類別 (性別、實驗組別) 特徵的 `DataFrame`。
2.  使用 `StandardScaler` 標準化數值特徵。
3.  使用 `OneHotEncoder` 對類別特徵進行 One-Hot 編碼。
4.  將上述兩種預處理步驟整合成一個 `ColumnTransformer`。
5.  將預處理後的資料與原始的標籤 (labels) 一起分割成訓練集和測試集。

```python
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline

# 1. Generate a synthetic behavioral dataset
# 1. 生成一個合成的行為資料集
np.random.seed(42)
n_samples = 100
data = {
    'Age': np.random.randint(20, 60, n_samples),
    'ReactionTime': np.random.normal(500, 100, n_samples),
    'Gender': np.random.choice(['Male', 'Female'], n_samples),
    'ExperimentalGroup': np.random.choice(['Control', 'TreatmentA', 'TreatmentB'], n_samples),
    'PerformanceScore': np.random.randint(50, 100, n_samples) # This will be our target (label)
}
df_behavior = pd.DataFrame(data)

# Assume 'PerformanceScore' is our target variable (y), and others are features (X)
# 假設 'PerformanceScore' 是我們的目標變數 (y)，其他是特徵 (X)
X_raw = df_behavior.drop('PerformanceScore', axis=1)
y = df_behavior['PerformanceScore']

print("Original Features (first 5 rows):")
print(X_raw.head())
print("
Original Labels (first 5 values):")
print(y.head())

# Define numerical and categorical features
# 定義數值和類別特徵
numerical_cols = ['Age', 'ReactionTime']
categorical_cols = ['Gender', 'ExperimentalGroup']

# Create preprocessing pipelines for numerical and categorical features
# 為數值和類別特徵建立預處理管道
numerical_transformer = StandardScaler()
categorical_transformer = OneHotEncoder(handle_unknown='ignore')

# Create a column transformer to apply different transformations to different columns
# 建立一個 ColumnTransformer，將不同的轉換應用於不同的欄位
preprocessor = ColumnTransformer(
    transformers=[
        ('num', numerical_transformer, numerical_cols),
        ('cat', categorical_transformer, categorical_cols)
    ])

# 2. Apply preprocessing and split data
# 2. 應用預處理並分割資料
# For simplicity, we'll create a pipeline for the whole process
# 為了簡化，我們將為整個過程建立一個管道
# Normally, you'd integrate this into a full ML pipeline with a model
# 通常，您會將其整合到包含模型的完整 ML 管道中

# Fit and transform features
X_processed = preprocessor.fit_transform(X_raw)

# Get feature names after one-hot encoding (optional, for readability)
# 取得 One-Hot 編碼後的特徵名稱（可選，為了可讀性）
# This part is a bit more complex as ColumnTransformer doesn't directly give names for non-pipeline steps
# Need to get names from the OneHotEncoder after fit
# transformed_feature_names = numerical_cols + list(preprocessor.named_transformers_['cat'].get_feature_names_out(categorical_cols))


print("
Processed Features (first 5 rows of transformed array):")
print(X_processed[:5])
print(f"Processed Features shape: {X_processed.shape}")

# Split the processed data into training and testing sets
# 將預處理後的資料分割為訓練集和測試集
X_train, X_test, y_train, y_test = train_test_split(X_processed, y, test_size=0.25, random_state=42)

print(f"
Training features shape: {X_train.shape}")
print(f"Testing features shape: {X_test.shape}")
print(f"Training labels shape: {y_train.shape}")
print(f"Testing labels shape: {y_test.shape}")

# Now X_train, y_train, X_test, y_test are ready for model training and evaluation
# 現在 X_train, y_train, X_test, y_test 已準備好用於模型訓練和評估
```

---

## 6. References 參考資料

- **Scikit-learn User Guide**: [https://scikit-learn.org/stable/user_guide.html](https://scikit-learn.org/stable/user_guide.html)
- **Pandas Documentation**: [https://pandas.pydata.org/docs/](https://pandas.pydata.org/docs/)
- **Bias-Variance Tradeoff Explained**: [https://www.ibm.com/cloud/learn/bias-variance](https://www.ibm.com/cloud/learn/bias-variance)
- **Train-Test Split**: [https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.train_test_split.html](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.train_test_split.html)
- **Cross-Validation**: [https://scikit-learn.org/stable/modules/cross_validation.html](https://scikit-learn.org/stable/modules/cross_validation.html)
