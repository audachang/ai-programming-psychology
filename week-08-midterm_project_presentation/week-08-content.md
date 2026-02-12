# Week 8: Midterm Project Presentation
# 第八週：期中專題發表

> **Date 日期**: 2026/04/16  
> **Activity 活動**: Seminar & Demo 研討會與實作展示

---

## Overview 概述

This is the **midterm checkpoint**. Each student (or team) presents a fully functional experiment and pilot data analysis. This is your opportunity to demonstrate Weeks 1–7 skills in an integrated project.

這是**期中檢查點**。每位同學（或團隊）發表一個完整功能的實驗及初步資料分析。這是展示第 1-7 週整合技能的機會。

---

## Requirements 繳交要求

### 1. Functional Experiment 可運行的實驗

- [ ] A complete Python/PsychoPy experiment that runs without errors
- [ ] Collects at least **keyboard or mouse responses**
- [ ] Implements at least **2 experimental conditions**
- [ ] Includes proper **fixation → stimulus → response → ITI** trial structure

### 2. Automatic Data Logging 自動資料記錄

- [ ] Saves data to CSV or uses `ExperimentHandler`
- [ ] Logs per-trial: condition, response, accuracy, RT
- [ ] Includes participant ID in the filename

### 3. Pilot Data Visualization 初步資料視覺化

- [ ] Run the experiment on yourself (minimum 30 trials)
- [ ] Produce at least **one publication-quality figure** (e.g., bar/violin plot of RT by condition)
- [ ] Include basic descriptive statistics (mean, SD)

### 4. Clean GitHub Repository GitHub 儲存庫

- [ ] Public repository with a descriptive README
- [ ] Organized file structure:
  ```
  my-experiment/
  ├── README.md
  ├── experiment.py          # Main experiment script
  ├── experiment_utils.py    # Helper functions (if any)
  ├── conditions.csv         # Trial conditions file
  ├── analysis.py            # Data analysis script
  ├── figures/               # Generated figures
  │   └── rt_by_condition.png
  ├── .gitignore
  └── requirements.txt       # pip freeze > requirements.txt
  ```
- [ ] Meaningful commit history (not just one giant commit)
- [ ] `.gitignore` excludes raw data and cache files

---

## Presentation Format 發表格式

### Time 時間
- **7 minutes presentation** + **3 minutes Q&A** per student/team
- 每人/組 **7 分鐘發表** + **3 分鐘問答**

### Structure 架構

| Section | Duration | Content |
|---------|:--------:|---------|
| **Introduction** | 1 min | Research question & rationale |
| **Methods** | 2 min | Task design, conditions, stimuli |
| **Live Demo** | 2 min | Run the experiment live |
| **Results** | 1.5 min | Pilot data figure + stats |
| **Reflection** | 0.5 min | Challenges faced, what AI tools helped with |

### Slides Template 投影片模板

```
Slide 1: Title + Name + GitHub URL
Slide 2: Research Question (What cognitive process are you studying?)
Slide 3: Task Design (Diagram of trial sequence)
Slide 4: Live Demo (Switch to PsychoPy)
Slide 5: Pilot Results (Figure + basic stats)
Slide 6: Reflection (What was hardest? What did AI help with?)
```

---

## Grading Rubric 評分標準 (20%)

| Criterion | Points | Description |
|-----------|:------:|-------------|
| **Experiment Functionality** | 6 | Runs correctly, proper trial structure, 2+ conditions |
| **Data Logging** | 3 | Automatic per-trial CSV/psydat output |
| **Data Visualization** | 3 | Publication-quality figure with labels, title, error bars |
| **Code Quality** | 4 | PEP8, docstrings, modular functions, meaningful names |
| **GitHub Repository** | 2 | README, .gitignore, organized structure, commit history |
| **Presentation** | 2 | Clear communication, live demo success |
| **Total** | **20** | |

---

## Project Ideas 專題構想

Need inspiration? Here are some suitable paradigms:

需要靈感嗎？以下是一些適合的範式：

| Paradigm | Cognitive Process | Difficulty |
|----------|:-:|:-:|
| Stroop Task (extended) | Attention / Inhibition | ⭐ |
| Flanker Task | Attention / Conflict | ⭐ |
| Visual Search | Attention / Feature Binding | ⭐⭐ |
| Simon Task | Stimulus-Response Compatibility | ⭐⭐ |
| Go/No-Go | Response Inhibition | ⭐ |
| Posner Cueing | Attentional Orienting | ⭐⭐ |
| n-Back | Working Memory | ⭐⭐⭐ |
| Change Detection | Visual Working Memory | ⭐⭐⭐ |
| Lexical Decision | Language Processing | ⭐⭐ |
| Emotional Stroop | Emotion & Attention | ⭐⭐ |

---

## Checklist Before Presenting 發表前確認清單

- [ ] Experiment runs on the presentation computer (test beforehand!)
- [ ] Data file is generated successfully
- [ ] Figure renders correctly
- [ ] GitHub repo URL is correct and public
- [ ] Slides are uploaded
- [ ] You can explain every line of code in your experiment

---

## References 參考資料

- **PsychoPy Demos**: [https://www.psychopy.org/demos.html](https://www.psychopy.org/demos.html)
- **Open Science Framework**: [https://osf.io/](https://osf.io/) — Find replication-ready paradigms
- **GitHub Student Pack**: [https://education.github.com/pack](https://education.github.com/pack) — Free Copilot access
