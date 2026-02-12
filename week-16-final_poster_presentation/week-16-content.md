# Week 16: Final Poster Presentation
# 第十六週：期末海報發表

> **Date 日期**: 2026/06/11  
> **Activity 活動**: Symposium 學術研討會

---

## Learning Objectives 學習目標

1. 學會製作符合學術標準的研究海報
2. 練習口頭報告與技術溝通
3. 提供並接受同儕的建設性回饋
4. 完成期末專題的最終版本並公開發布

---

## 1. Poster Requirements 海報要求

### 1.1 Required Sections 必要區塊

Your poster should include the following sections:

您的海報應包含以下區塊：

| Section | Content | Guidelines |
|---------|---------|------------|
| **Title** | Project name, authors, affiliation | Clear, concise |
| **Introduction** | Background & research question | 2-3 sentences + 1 key citation |
| **Methods** | Code/algorithm description | Include a flowchart or diagram |
| **Results** | Visualizations & metrics | 2-3 publication-quality figures |
| **Conclusion** | Key findings & limitations | What did you learn? |
| **QR Code** | Link to GitHub repository | Print-scannable |

### 1.2 Design Guidelines 設計準則

```
┌──────────────────────────────────────────────────────┐
│                    PROJECT TITLE                      │
│              Author Name — Department                 │
├──────────────┬──────────────┬────────────────────────┤
│              │              │                        │
│ Introduction │   Methods    │       Results          │
│              │              │                        │
│ • Background │ • Pipeline   │  ┌──────────────────┐  │
│ • Question   │   diagram    │  │  Figure 1: ...   │  │
│ • Motivation │ • Key code   │  │  [visualization] │  │
│              │   snippets   │  └──────────────────┘  │
│              │ • Model      │  ┌──────────────────┐  │
│              │   choice &   │  │  Figure 2: ...   │  │
│              │   params     │  │  [metrics table] │  │
│              │              │  └──────────────────┘  │
├──────────────┴──────────────┼────────────────────────┤
│         Conclusion          │    GitHub QR Code      │
│ • Key findings              │    ┌──────────┐        │
│ • Limitations               │    │ ██  ██   │        │
│ • Future work               │    │ ██  ██   │        │
│                             │    └──────────┘        │
└─────────────────────────────┴────────────────────────┘
```

**Tips 提示:**
- Font size: Title ≥ 72pt, Headers ≥ 36pt, Body ≥ 24pt
- Use high-resolution figures (300 DPI for print)
- Minimal text — let figures tell the story
- Consistent color scheme throughout

---

## 2. Presentation Format 發表格式

### 2.1 Symposium Schedule 研討會流程

| Time | Activity |
|------|----------|
| 0:00–0:15 | Setup & poster mounting |
| 0:15–1:30 | **Session 1**: Half the class presents, half browses |
| 1:30–1:40 | Break |
| 1:40–2:45 | **Session 2**: Switch roles |
| 2:45–3:00 | Voting & wrap-up |

### 2.2 Presentation Guidelines 報告指引

Each presenter should prepare:
- **2-minute elevator pitch**: What did you do? Why? Key result?
- **5-minute deep dive**: For interested visitors who want details
- **Live demo** (optional): Run one analysis live from your laptop

---

## 3. Deliverables 繳交項目

### 3.1 Code Repository 程式碼儲存庫

Your GitHub repository must include:

| Item | Requirement |
|------|-------------|
| `README.md` | Project description, install instructions, usage |
| `requirements.txt` | All Python dependencies with versions |
| Source code | Clean, documented, modular |
| Data | Raw data or instructions to download |
| Results | Output figures and evaluation metrics |
| License | MIT recommended |

### 3.2 Generating a QR Code 產生 QR Code

```python
# pip install qrcode[pil]
import qrcode

# Generate QR code for your GitHub repo
# 為你的 GitHub 儲存庫產生 QR Code
repo_url = "https://github.com/yourusername/your-project"

qr = qrcode.QRCode(version=1, box_size=10, border=4)
qr.add_data(repo_url)
qr.make(fit=True)

img = qr.make_image(fill_color="black", back_color="white")
img.save("github_qr.png")
print(f"QR code saved for: {repo_url}")
```

### 3.3 Creating Publication-Quality Figures 製作出版品質的圖表

```python
import matplotlib.pyplot as plt
import matplotlib
import numpy as np

# Set publication style 設定出版品質風格
matplotlib.rcParams.update({
    'font.size': 14,
    'font.family': 'sans-serif',
    'axes.labelsize': 16,
    'axes.titlesize': 18,
    'xtick.labelsize': 12,
    'ytick.labelsize': 12,
    'legend.fontsize': 12,
    'figure.dpi': 300,
    'savefig.dpi': 300,
    'savefig.bbox': 'tight',
})

# Example: Model comparison bar chart
# 範例：模型比較長條圖
models = ['Logistic\nRegression', 'Random\nForest', 'SVM', 'MLP']
accuracy = [0.82, 0.89, 0.85, 0.91]
auc = [0.79, 0.87, 0.83, 0.90]

x = np.arange(len(models))
width = 0.35

fig, ax = plt.subplots(figsize=(8, 5))
bars1 = ax.bar(x - width/2, accuracy, width, label='Accuracy', color='#3498db')
bars2 = ax.bar(x + width/2, auc, width, label='AUC', color='#e74c3c')

ax.set_ylabel('Score')
ax.set_title('Model Performance Comparison')
ax.set_xticks(x)
ax.set_xticklabels(models)
ax.legend()
ax.set_ylim(0.5, 1.0)
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)

# Add value labels 加上數值標籤
for bar in bars1:
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.01,
            f'{bar.get_height():.2f}', ha='center', va='bottom', fontsize=10)
for bar in bars2:
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.01,
            f'{bar.get_height():.2f}', ha='center', va='bottom', fontsize=10)

plt.tight_layout()
plt.savefig('model_comparison.png')
plt.show()
```

---

## 4. Grading Rubric 評分標準

| Criterion | Weight | Excellent (A) | Adequate (B) | Needs Work (C) |
|-----------|:------:|---------------|--------------|-----------------|
| **Code Quality** | 25% | Modular, documented, reproducible | Runs correctly, some comments | Messy, hard to follow |
| **Analysis** | 25% | Appropriate model, rigorous evaluation | Correct but basic | Missing evaluation metrics |
| **Visualization** | 20% | Publication-quality, informative | Clear but basic | Hard to read |
| **Poster & Presentation** | 20% | Professional design, clear communication | Adequate but verbose | Disorganized |
| **Reproducibility** | 10% | README + requirements.txt + seed | Partially documented | Cannot reproduce |

---

## 5. Semester Recap 學期回顧

### Module 1: Experimental Programming 實驗程式設計

| Week | Topic | Key Skill |
|:----:|-------|-----------|
| 01 | Python + Environment | Virtual environments, NumPy |
| 02 | PsychoPy Coder | Windows, stimuli, timing |
| 03 | Event Loop | Input, data logging, Stroop |
| 04 | Builder & Online | Pavlovia, staircase |
| 05 | Data Analysis | Pandas, Seaborn, scipy |
| 06 | Example Designs | Posner, n-Back |
| 07 | AI Helpers & Git | Copilot, clean code |
| 08 | Midterm | Project presentation |

### Module 2: Machine Learning & AI

| Week | Topic | Key Skill |
|:----:|-------|-----------|
| 09 | ML Foundations | scikit-learn, pipeline |
| 10 | Regression & Classification | LogReg, SVM, metrics |
| 11 | Advanced ML | Trees, PCA, K-Means |
| 12 | GPU Tools | PyTorch, benchmarking |
| 13 | Deep Learning | MLP, CNN, MNIST |
| 14 | LLMs | Transformers, HuggingFace |
| 15 | Capstone Studio | Integration, code review |
| 16 | Final Presentation | This week! |

---

## References 參考資料

- **Scientific Poster Design**: [https://www.makesigns.com/tutorials/](https://www.makesigns.com/tutorials/)
- **Matplotlib Customization**: [https://matplotlib.org/stable/tutorials/introductory/customizing.html](https://matplotlib.org/stable/tutorials/introductory/customizing.html)
- **Writing a Good README**: [https://www.makeareadme.com/](https://www.makeareadme.com/)
- **QR Code Library**: [https://pypi.org/project/qrcode/](https://pypi.org/project/qrcode/)