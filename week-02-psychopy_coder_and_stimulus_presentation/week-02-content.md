# Week 2: PsychoPy Coder & Stimulus Presentation
# 第二週：PsychoPy 程式碼模式與刺激呈現

> **Date 日期**: 2026/03/05  
> **Topic 主題**: Drawing to the Screen (Beyond the GUI) 在螢幕上繪圖（超越圖形介面）

---

## Learning Objectives 學習目標

1. 理解 PsychoPy 的 `visual.Window` 以及不同的座標單位系統
2. 學會以程式碼建立各種視覺刺激（TextStim、ImageStim、GratingStim）
3. 掌握畫面更新率（Hz）與 frame-based timing 的精確計時原理
4. 能從零開始撰寫一個呈現注視點與 Gabor 光柵的腳本

---

## 1. The Window Object
## 1. 視窗物件

The `visual.Window` is the canvas where all stimuli are drawn. Understanding its parameters is essential for precise experiments.

`visual.Window` 是所有刺激被繪製的畫布，理解其參數對精確的實驗至關重要。

```python
from psychopy import visual, core

# Create a window 建立視窗
win = visual.Window(
    size=[1024, 768],     # Resolution in pixels 解析度（像素）
    fullscr=False,        # Windowed mode for development 開發時用視窗模式
    color=[0, 0, 0],      # Background: grey (RGB -1 to 1) 背景色
    units='pix',          # Coordinate unit system 座標系統
    monitor='testMonitor' # Monitor calibration profile 螢幕校正設定
)
```

### 1.1 Coordinate Units 座標單位

| Unit | Description | Use Case |
|------|-------------|----------|
| `'pix'` | Pixels from center | Simple layouts |
| `'norm'` | Normalized (-1 to 1) | Resolution-independent |
| `'deg'` | Degrees of visual angle | Vision research (requires monitor calibration) |
| `'cm'` | Centimeters | Physical size matching |
| `'height'` | Fraction of window height | Proportional layouts |

```python
# Setting up a monitor for 'deg' units
# 為 'deg' 單位設定螢幕參數
from psychopy import monitors

mon = monitors.Monitor('myLab')
mon.setDistance(57)       # Viewing distance in cm 觀看距離
mon.setWidth(53)          # Screen width in cm 螢幕寬度
mon.setSizePix([1920, 1080])
mon.save()

win = visual.Window(monitor='myLab', units='deg')
```

### 1.2 The Double Buffer & `win.flip()`

PsychoPy uses **double buffering**: you draw stimuli to a hidden "back buffer," then call `win.flip()` to display everything at once on the next monitor refresh.

PsychoPy 使用**雙重緩衝**：刺激先繪製在隱藏的「後緩衝區」，呼叫 `win.flip()` 後在下一次螢幕刷新時一次顯示。

```python
# The fundamental draw cycle 基本繪製循環
stimulus.draw()   # Draw to back buffer 繪製到後緩衝區
win.flip()         # Swap buffers → stimulus appears 交換緩衝區 → 刺激出現
```

---

## 2. Creating Stimuli 建立刺激

### 2.1 TextStim 文字刺激

```python
# Simple text 簡單文字
fixation = visual.TextStim(win, text='+', color='white', height=40)

# Rich text 豐富文字
instruction = visual.TextStim(
    win,
    text='Press SPACE to begin\n按空白鍵開始',
    color='white',
    height=24,
    font='Arial',
    wrapWidth=600,     # Line wrap width 換行寬度
    pos=(0, 0)         # Center position 中心位置
)
```

### 2.2 ImageStim 圖片刺激

```python
face = visual.ImageStim(
    win,
    image='stimuli/happy_face.png',
    size=(200, 200),    # Width, Height in current units
    pos=(0, 0),
    opacity=1.0         # 1 = fully opaque 完全不透明
)
```

### 2.3 GratingStim (Gabor Patches) 光柵刺激（Gabor 斑塊）

Gabor patches are sinusoidal gratings windowed by a Gaussian—the most common stimulus in vision research.

Gabor 斑塊是以高斯函數為窗口的正弦光柵——視覺研究中最常見的刺激。

```python
gabor = visual.GratingStim(
    win,
    tex='sin',         # Sinusoidal grating 正弦光柵
    mask='gauss',      # Gaussian envelope 高斯包絡
    size=5,            # Size in degrees (if units='deg')
    sf=3,              # Spatial frequency (cycles/deg) 空間頻率
    ori=45,            # Orientation in degrees 方向角度
    contrast=0.8,      # Contrast (0–1)
    phase=0.0          # Phase of the grating 光柵相位
)
```

### 2.4 Other Useful Stimuli 其他常用刺激

```python
# Circle 圓形
dot = visual.Circle(win, radius=10, fillColor='red', lineColor='red')

# Rectangle 矩形
rect = visual.Rect(win, width=100, height=50, fillColor='blue')

# Line 線段
line = visual.Line(win, start=(-100, 0), end=(100, 0), lineColor='white')

# Polygon 多邊形
arrow = visual.Polygon(win, edges=3, radius=30, fillColor='green', ori=90)
```

---

## 3. Timing: Refresh Rates & Frame-Based Presentation
## 3. 計時：更新率與基於畫格的呈現

### 3.1 Understanding Refresh Rates 理解更新率

A 60 Hz monitor refreshes every **16.67 ms**. Each `win.flip()` waits for the next refresh, so the minimum duration of any stimulus is one frame.

60 Hz 的螢幕每 **16.67 毫秒**刷新一次。每次 `win.flip()` 都會等待下一次刷新，因此任何刺激的最短持續時間為一個畫格。

| Monitor Hz | Frame Duration | Possible Durations |
|-----------:|---------------:|:-------------------|
| 60 Hz | 16.67 ms | 16.7, 33.3, 50.0, ... ms |
| 120 Hz | 8.33 ms | 8.3, 16.7, 25.0, ... ms |
| 144 Hz | 6.94 ms | 6.9, 13.9, 20.8, ... ms |

### 3.2 Frame-Based Timing (Preferred) 基於畫格的計時（推薦）

```python
# Display a Gabor for exactly 200ms at 60Hz ≈ 12 frames
# 在 60Hz 下顯示 Gabor 恰好 200ms ≈ 12 個畫格
n_frames = 12  # 12 frames × 16.67ms ≈ 200ms

for frame in range(n_frames):
    gabor.phase += 0.05  # Animate: drift the grating 動畫：讓光柵漂移
    gabor.draw()
    win.flip()

# Show blank screen after stimulus 刺激後顯示空白畫面
win.flip()
```

### 3.3 Clock-Based Timing (Simpler, Less Precise) 基於時鐘的計時

```python
# Less precise — use only for non-critical timing
# 精度較低——僅用於非關鍵計時
from psychopy import core

clock = core.Clock()
while clock.getTime() < 0.2:  # 200ms
    gabor.draw()
    win.flip()
```

### 3.4 Checking Your Frame Rate 檢查畫面更新率

```python
# Measure actual frame rate 測量實際更新率
fps = win.getActualFrameRate(nIdentical=60, nMaxFrames=100)
print(f"Measured frame rate: {fps:.2f} Hz")

# Calculate ms per frame 計算每畫格毫秒數
if fps:
    ms_per_frame = 1000.0 / fps
    print(f"Frame duration: {ms_per_frame:.2f} ms")
```

---

## 4. Live Coding Exercise: Fixation → Gabor Script
## 4. 現場編碼練習：注視點 → Gabor 腳本

Build a complete script from scratch:

從零開始建立完整腳本：

```python
from psychopy import visual, core, event

# --- Setup ---
win = visual.Window(size=[800, 600], fullscr=False, 
                    color=[0, 0, 0], units='pix')

fixation = visual.TextStim(win, text='+', color='white', height=40)
gabor = visual.GratingStim(win, tex='sin', mask='gauss', 
                           size=200, sf=0.05, ori=0, contrast=0.8)

# --- Trial Sequence ---
# 1. Fixation cross for 1 second (60 frames)
for frame in range(60):
    fixation.draw()
    win.flip()

# 2. Drifting Gabor for 2 seconds (120 frames)
for frame in range(120):
    gabor.phase += 0.02   # Drift animation 漂移動畫
    gabor.draw()
    win.flip()

# 3. Blank screen, wait for keypress
win.flip()
event.waitKeys()

# --- Cleanup ---
win.close()
core.quit()
```

---

## 5. Lab: Modify the Gabor Script
## 5. 實作：修改 Gabor 腳本

**Task 任務**: Modify the script above to:
1. Change the orientation of the grating dynamically based on a frame counter  
   根據畫格計數器動態改變光柵方向
2. Make the orientation rotate smoothly by 3° per frame  
   每個畫格平滑旋轉 3°
3. Add a second Gabor at a different position  
   在不同位置新增第二個 Gabor

**Hint 提示**:
```python
gabor.ori = frame * 3  # Rotate 3° per frame
gabor2 = visual.GratingStim(win, ..., pos=(200, 0))
```

---

## References 參考資料

- **PsychoPy Visual Stimuli**: [https://www.psychopy.org/api/visual.html](https://www.psychopy.org/api/visual.html)
- **PsychoPy Coder Tutorial**: [https://www.psychopy.org/coder/coder.html](https://www.psychopy.org/coder/coder.html)
- **Monitor Center**: [https://www.psychopy.org/general/monitors.html](https://www.psychopy.org/general/monitors.html)
- **Timing & Frame Rate**: [https://www.psychopy.org/general/timing/timing.html](https://www.psychopy.org/general/timing/timing.html)
