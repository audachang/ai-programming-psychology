# Week 7: Coding with AI Helpers & Sustainable Programming Practices
# 第七週：AI 輔助程式設計與永續編程實踐

> **Date 日期**: 2026/04/09  
> **Topic 主題**: Modern Coding Workflows 現代化程式設計工作流程

---

## Learning Objectives 學習目標

1. 學會對 GitHub Copilot / ChatGPT 進行有效的提示工程（Prompt Engineering）
2. 掌握 Clean Code 原則：模組化函式、Docstrings、PEP8 規範
3. 學會 Git 版本控制基礎：`init`、`commit`、`push`
4. 參與「重構日」實作活動

---

## 1. AI Tools for Coding
## 1. 程式設計的 AI 工具

### 1.1 GitHub Copilot

GitHub Copilot is an AI pair programmer that suggests code completions inline in VS Code.

GitHub Copilot 是一個 AI 配對程式設計工具，在 VS Code 中提供行內程式碼建議。

**Effective usage patterns 有效使用模式:**

```python
# Pattern 1: Write a descriptive comment, let Copilot complete
# 模式 1：寫描述性註解，讓 Copilot 補完

# Generate a list of 100 trial conditions with balanced 
# congruent and incongruent Stroop conditions, shuffled randomly
# Copilot will suggest the implementation below...

# Pattern 2: Write the function signature + docstring
def create_stroop_trials(n_trials=100, colors=None):
    """Create a balanced, randomized list of Stroop trial dicts.
    
    Args:
        n_trials: Total number of trials
        colors: List of color names to use
    
    Returns:
        List of dicts with 'word', 'color', 'congruent' keys
    """
    # Copilot suggests implementation here...
```

### 1.2 ChatGPT / Claude for Debugging

**Effective prompts for debugging 有效的除錯提示:**

```
❌ Bad: "My code doesn't work. Fix it."
✅ Good: "I'm running a PsychoPy Stroop task on Python 3.10. 
When I call event.waitKeys(), the function returns None instead 
of the key pressed. Here is my code: [paste code]. 
What could cause this?"
```

**Prompt templates 提示模板:**

| Task | Template |
|------|----------|
| **Explain bug** | "Explain why this code produces [error]. Here is the traceback: [paste]" |
| **Refactor** | "Refactor this function to be more readable and follow PEP8: [paste code]" |
| **Optimize** | "This loop processes 10,000 trials and takes 30 seconds. Optimize it using NumPy vectorization: [paste]" |
| **Generate tests** | "Write pytest unit tests for this function: [paste function]" |
| **Translate** | "Convert this PsychoPy Python code to PsychoJS for Pavlovia: [paste]" |

### 1.3 Limitations & Ethics 限制與倫理

> **⚠️ Be a critical consumer of AI-generated code!**
> 
> **⚠️ 對 AI 產生的程式碼保持批判性！**

- AI can hallucinate functions that don't exist (e.g., `psychopy.tools.colorToHex()`)
- AI may suggest outdated APIs (e.g., `event.getKeys()` instead of `keyboard.Keyboard()`)
- Always test AI-generated code before committing
- Cite AI assistance in your project documentation
- **You are responsible for understanding every line of code you submit**

---

## 2. Clean Code Principles
## 2. 清晰程式碼原則

### 2.1 Modular Functions 模組化函式

```python
# ❌ Bad: One giant script with everything inline
# 不好：一個巨大腳本把所有東西塞在一起
win = visual.Window(...)
for i in range(100):
    if conditions[i] == 'congruent':
        stim.color = colors[i]
        stim.text = words[i]
    # ... 200 more lines inline

# ✅ Good: Break into focused functions
# 好：拆分成專注的函式

def setup_window(fullscr=False):
    """Create and return a PsychoPy window."""
    return visual.Window(size=[800, 600], fullscr=fullscr, 
                         color=[0, 0, 0], units='pix')

def show_fixation(win, duration_frames=30):
    """Display a fixation cross for the given number of frames."""
    fix = visual.TextStim(win, text='+', color='white', height=40)
    for _ in range(duration_frames):
        fix.draw()
        win.flip()

def run_trial(win, kb, trial_info):
    """Execute a single trial and return response data."""
    show_fixation(win)
    # ... present stimulus, collect response
    return {'response': key, 'rt': rt, 'correct': is_correct}

def save_data(all_trials, filename):
    """Save trial data to CSV."""
    pd.DataFrame(all_trials).to_csv(filename, index=False)
```

### 2.2 Docstrings 文件字串

Follow **Google-style** or **NumPy-style** docstrings:

```python
def compute_dprime(hit_rate, fa_rate):
    """Compute d-prime (d') for signal detection analysis.
    
    d' = Z(hit_rate) - Z(false_alarm_rate)
    
    Args:
        hit_rate (float): Proportion of hits (0–1). 
            Values of 0 or 1 will be adjusted.
        fa_rate (float): Proportion of false alarms (0–1).
    
    Returns:
        float: d-prime value. Higher = better discrimination.
    
    Example:
        >>> compute_dprime(0.85, 0.10)
        2.32
    """
    from scipy.stats import norm
    # Avoid infinite z-scores
    hit_rate = np.clip(hit_rate, 0.01, 0.99)
    fa_rate = np.clip(fa_rate, 0.01, 0.99)
    return norm.ppf(hit_rate) - norm.ppf(fa_rate)
```

### 2.3 PEP8 Style Guide PEP8 風格指南

```python
# ❌ Bad naming 不好的命名
def calc(a,b,c):
    x=a*b+c
    return x

# ✅ Good naming (PEP8) 好的命名
def calculate_visual_angle(distance_cm, size_cm, screen_width_px):
    """Calculate visual angle in degrees."""
    angle_rad = 2 * np.arctan(size_cm / (2 * distance_cm))
    angle_deg = np.degrees(angle_rad)
    return angle_deg
```

**Key PEP8 rules PEP8 重點規則:**

| Rule | Example |
|------|---------|
| Variables: `snake_case` | `trial_count`, `mean_rt` |
| Functions: `snake_case` | `calculate_accuracy()` |
| Classes: `CamelCase` | `ExperimentManager` |
| Constants: `UPPER_CASE` | `MAX_TRIALS = 200` |
| Line length: ≤ 79 chars | Use line breaks for long expressions |
| Spacing: 4-space indent | Never mix tabs and spaces |

---

## 3. Git Version Control
## 3. Git 版本控制

### 3.1 Why Git? 為什麼用 Git？

- **History 歷史**: Every change is recorded; you can go back in time
- **Backup 備份**: Push to GitHub for cloud backup
- **Collaboration 協作**: Multiple people can work on the same codebase
- **Reproducibility 再現性**: Tag specific versions of your analysis

### 3.2 Essential Commands 基本指令

```bash
# Initialize a new repository 初始化新儲存庫
git init

# Check status 檢查狀態
git status

# Stage files for commit 暫存檔案
git add experiment.py           # Add one file
git add .                       # Add all changed files

# Commit with a message 提交並附上訊息
git commit -m "Add Stroop task with data logging"

# Connect to GitHub 連接到 GitHub
git remote add origin https://github.com/username/my-experiment.git

# Push to GitHub 推送到 GitHub
git push -u origin main

# Pull latest changes 拉取最新變更
git pull

# View commit history 查看提交歷史
git log --oneline -10
```

### 3.3 Good Commit Messages 好的提交訊息

```bash
# ❌ Bad
git commit -m "update"
git commit -m "fix"
git commit -m "stuff"

# ✅ Good
git commit -m "Add error feedback display after each trial"
git commit -m "Fix RT calculation bug: use kb.clock instead of core.Clock"
git commit -m "Refactor trial loop into run_trial() function"
```

### 3.4 The `.gitignore` File

```gitignore
# Python
__pycache__/
*.pyc
.ipynb_checkpoints/

# Data (don't commit raw participant data!)
data/*.csv
data/*.psydat

# OS files
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
```

---

## 4. Hackathon: "Refactor Day" 🔧
## 4. 黑客松：「重構日」🔧

### The Challenge 挑戰

You will receive a **messy, broken Python script** that is supposed to run a simple reaction time task. Your mission:

你將收到一個**凌亂且有錯誤的 Python 腳本**，它應該要執行一個簡單的反應時間作業。你的任務：

1. **Fix all bugs** so the script runs without errors
2. **Refactor** for readability (rename variables, add docstrings, follow PEP8)
3. **Add data logging** (save to CSV)
4. **Use AI tools** (Copilot/ChatGPT) to help — document which parts were AI-assisted

### Messy Script Example 凌亂腳本範例

```python
# BROKEN_experiment.py — Fix me!
from psychopy import visual,core,event
import random
w = visual.Window([800,600],color='black')
s = visual.TextStim(w,text='',height=40)
c = core.Clock()
t = ['left','right','up','down'] * 25
random.shuffled(t)  # Bug 1: wrong method name
d = []
for i in t:
 s.text = i  # Bug 2: indentation
 s.draw()
 w.flip()
 c.reset
 k = event.waitKeys(maxWait=2)
 if k:
  rt = c.getTime()
  d.append({'trial':i,'key':k[0],'rt':rt,'acc':k[0]==i})
# Bug 3: data never saved!
# Bug 4: window never closed!
```

### Expected Output 預期產出

A clean, documented script with:
- Descriptive variable names
- Functions for setup, trial execution, and data saving
- Error handling
- PEP8 compliance
- A commit to your personal GitHub repo

---

## References 參考資料

- **PEP8**: [https://peps.python.org/pep-0008/](https://peps.python.org/pep-0008/)
- **Git Documentation**: [https://git-scm.com/doc](https://git-scm.com/doc)
- **GitHub Copilot**: [https://github.com/features/copilot](https://github.com/features/copilot)
- **Google Python Style Guide**: [https://google.github.io/styleguide/pyguide.html](https://google.github.io/styleguide/pyguide.html)
