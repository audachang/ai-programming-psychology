# Week 15: ML & AI Capstone Studio
# 第十五週：機器學習與 AI 專題工作坊

> **Date 日期**: 2026/06/04  
> **Activity 活動**: Guided Development / Hackathon 引導式開發 / 黑客松

---

## Learning Objectives 學習目標

1. 整合本學期所學的程式設計、實驗設計與 ML/AI 技能
2. 進行同儕程式碼審查 (Peer Code Review)
3. 在限時內完成一個從資料到模型的完整 ML pipeline
4. 練習技術溝通與團隊協作

---

## 1. Capstone Project Guidelines
## 1. 專題計畫指引

### 1.1 Project Scope 專題範圍

Your final project should demonstrate integration of skills from both modules:

您的期末專題應展示兩個模組所學技能的整合：

| Module 1 (Weeks 1–8) | Module 2 (Weeks 9–14) |
|:---|:---|
| PsychoPy experiment design | ML classification/regression |
| Data collection & logging | Feature engineering |
| Statistical analysis | Model evaluation |
| Clean code & Git | Deep learning or NLP |

### 1.2 Project Types 專題類型

Choose one of the following approaches:

| Type | Description | Example |
|------|-------------|---------|
| **Full Pipeline** | Design experiment → collect data → ML analysis | Stroop task → predict errors with RF |
| **ML Analysis** | Use an existing psychology dataset with ML | Apply NLP sentiment analysis to survey data |
| **Tool Building** | Build a useful tool for psychology research | Auto stimulus generator using LLM |

### 1.3 Required Components 必要元件

```
your-project/
├── README.md              # Project description, how to run
├── requirements.txt       # Python dependencies
├── data/                  # Raw and processed data
│   ├── raw/
│   └── processed/
├── src/                   # Source code
│   ├── experiment.py      # PsychoPy experiment (if applicable)
│   ├── preprocess.py      # Data cleaning & feature engineering
│   ├── model.py           # ML model training & evaluation
│   └── visualize.py       # Result visualization
├── notebooks/             # Exploratory analysis
│   └── analysis.ipynb
└── results/               # Output figures and reports
    ├── figures/
    └── metrics.json
```

---

## 2. Hackathon Structure 黑客松流程

### Timeline 時程表

| Time | Activity |
|------|----------|
| 0:00–0:15 | Instructor check-in — goals for today |
| 0:15–1:00 | Sprint 1 — Core development |
| 1:00–1:15 | **Peer code review** (pair up with a partner) |
| 1:15–2:00 | Sprint 2 — Refinement & debugging |
| 2:00–2:30 | Sprint 3 — Visualization & documentation |
| 2:30–2:50 | Lightning demos (2 min each) |

---

## 3. Peer Code Review Guidelines
## 3. 同儕程式碼審查指引

### 3.1 What to Look For 審查重點

```markdown
## Code Review Checklist 程式碼審查清單

### Correctness 正確性
- [ ] Does the code run without errors? 程式碼是否能正確執行？
- [ ] Are train/test splits done before any preprocessing? 訓練/測試分割是否在預處理之前？
- [ ] Is there data leakage? 是否有資料洩漏？

### Readability 可讀性
- [ ] Are variable names descriptive? 變數名稱是否有描述性？
- [ ] Are functions documented with docstrings? 函數是否有文件字串？
- [ ] Is the code modular (not one giant script)? 程式碼是否模組化？

### Reproducibility 可再現性
- [ ] Are random seeds set? 是否設定了隨機種子？
- [ ] Is there a requirements.txt? 是否有 requirements.txt？
- [ ] Can someone else run this from the README? 其他人能依照 README 執行嗎？

### Analysis 分析
- [ ] Are evaluation metrics appropriate? 評估指標是否適當？
- [ ] Are results visualized clearly? 結果是否清楚地視覺化？
- [ ] Are conclusions supported by the data? 結論是否有資料支持？
```

### 3.2 Giving Feedback 給予反饋

**Good feedback is:**
- **Specific**: "Line 45: `accuracy` isn't meaningful for imbalanced classes — consider `roc_auc`"
- **Constructive**: "Consider using `sklearn.pipeline` to avoid data leakage in preprocessing"
- **Kind**: "Great job structuring the code into functions! One suggestion..."

---

## 4. Common Pitfalls 常見陷阱

### 4.1 Data Leakage 資料洩漏

```python
# ❌ WRONG: Fitting scaler on ALL data before splitting
# ❌ 錯誤：在分割之前對所有資料擬合縮放器
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)           # Leakage!
X_train, X_test = train_test_split(X_scaled)

# ✅ CORRECT: Fit scaler only on training data
# ✅ 正確：只在訓練資料上擬合縮放器
X_train, X_test = train_test_split(X)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)  # Fit on train
X_test_scaled = scaler.transform(X_test)         # Transform test
```

### 4.2 Using a Pipeline to Prevent Leakage

```python
from sklearn.pipeline import Pipeline
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score

# Pipeline ensures preprocessing is fit ONLY on training folds
# Pipeline 確保預處理只在訓練折上擬合
pipe = Pipeline([
    ('scaler', StandardScaler()),
    ('model', RandomForestClassifier(random_state=42))
])

# Cross-validation handles splitting correctly
scores = cross_val_score(pipe, X, y, cv=5, scoring='accuracy')
print(f"CV Accuracy: {scores.mean():.3f} ± {scores.std():.3f}")
```

---

## 5. Quick Reference: Model Selection
## 5. 快速參考：模型選擇

| Task | Data Size | Recommended Model |
|------|-----------|-------------------|
| Binary classification, small | < 1K samples | Logistic Regression, SVM |
| Binary classification, large | > 10K samples | Random Forest, XGBoost |
| Multi-class, tabular | Any | Random Forest, XGBoost |
| Image classification | Any | CNN (PyTorch) |
| Text classification | Any | Hugging Face Transformers |
| Clustering (no labels) | Any | K-Means, DBSCAN |
| Dimensionality reduction | High-dim | PCA, t-SNE |

---

## 6. Lab: Capstone Sprint
## 6. 實作：專題衝刺

### Today's Goals 今日目標

1. **Define** your final project scope (Type + dataset + model)
2. **Code** the core pipeline (preprocess → train → evaluate)
3. **Review** a partner's code using the checklist above
4. **Document** your README.md with clear instructions

---

## References 參考資料

- **Scikit-learn Pipelines**: [https://scikit-learn.org/stable/modules/compose.html](https://scikit-learn.org/stable/modules/compose.html)
- **Data Leakage in ML**: [https://machinelearningmastery.com/data-leakage-machine-learning/](https://machinelearningmastery.com/data-leakage-machine-learning/)
- **Code Review Best Practices**: [https://google.github.io/eng-practices/review/](https://google.github.io/eng-practices/review/)
- **Project Structure**: [https://drivendata.github.io/cookiecutter-data-science/](https://drivendata.github.io/cookiecutter-data-science/)