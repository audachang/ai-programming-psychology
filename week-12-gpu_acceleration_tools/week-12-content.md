# Week 12: GPU Acceleration Tools
# 第十二週：GPU 加速工具

> **Date 日期**: 2026/05/14  
> **Topic 主題**: High-Performance Computing 高效能運算

---

## Learning Objectives 學習目標

1. 理解 **CPU vs. GPU** 的架構差異與各自的適用場景
2. 學會使用 **Google Colab** 存取雲端 GPU
3. 掌握 **PyTorch Tensors** 的基本操作與 GPU 加速
4. 實作 CPU vs. GPU 效能基準測試

---

## 1. CPU vs. GPU Architecture
## 1. CPU 與 GPU 架構

| Feature | CPU | GPU |
|---------|-----|-----|
| Cores | Few (4–16) powerful cores | Thousands of small cores |
| Best for | Sequential tasks, logic | Parallel computation |
| Memory | Large shared RAM | Smaller dedicated VRAM |
| Use case | Data loading, I/O | Matrix multiplication, training |

**Analogy 類比**: 
- CPU = One expert chef cooking complex dishes sequentially
- GPU = A thousand assembly-line workers each doing simple tasks simultaneously

In deep learning, most operations (matrix multiplication, convolution) can be parallelized — making GPUs essential.

在深度學習中，大多數操作（矩陣乘法、卷積）都可以平行化 — 這使得 GPU 變得不可或缺。

---

## 2. Google Colab — Free Cloud GPUs
## 2. Google Colab — 免費雲端 GPU

**Getting started 入門:**

1. Go to [colab.research.google.com](https://colab.research.google.com)
2. `Runtime → Change runtime type → GPU (T4)`
3. Verify GPU availability:

```python
# Check GPU availability in Colab
# 在 Colab 中確認 GPU 可用性
import torch

if torch.cuda.is_available():
    device = torch.device('cuda')
    print(f"GPU available: {torch.cuda.get_device_name(0)}")
    print(f"GPU memory: {torch.cuda.get_device_properties(0).total_mem / 1e9:.1f} GB")
else:
    device = torch.device('cpu')
    print("No GPU available, using CPU")

print(f"Using device: {device}")
```

---

## 3. PyTorch Tensors & GPU Operations
## 3. PyTorch Tensors 與 GPU 操作

### 3.1 Tensor Basics 基本張量操作

```python
import torch
import numpy as np

# Create tensors 建立張量
a = torch.tensor([1.0, 2.0, 3.0])
b = torch.zeros(3, 4)         # 3×4 matrix of zeros
c = torch.randn(3, 4)         # Random normal
d = torch.arange(0, 10, 0.5)  # Range

print(f"a: {a}")
print(f"b shape: {b.shape}")
print(f"c:\n{c}")

# Convert between NumPy and PyTorch
# NumPy 與 PyTorch 之間的轉換
np_array = np.array([[1, 2], [3, 4]])
tensor = torch.from_numpy(np_array).float()
back_to_np = tensor.numpy()

# Basic operations 基本操作
x = torch.randn(3, 3)
y = torch.randn(3, 3)

print(f"Element-wise multiply: {x * y}")
print(f"Matrix multiply: {x @ y}")
print(f"Sum: {x.sum()}")
print(f"Mean per column: {x.mean(dim=0)}")
```

### 3.2 Moving Data to GPU 將資料移至 GPU

```python
# Create tensor on CPU, then move to GPU
# 在 CPU 上建立張量，然後移至 GPU
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

x_cpu = torch.randn(1000, 1000)
x_gpu = x_cpu.to(device)       # Move to GPU
print(f"x_cpu device: {x_cpu.device}")
print(f"x_gpu device: {x_gpu.device}")

# Operations on GPU tensors 在 GPU 張量上的操作
y_gpu = torch.randn(1000, 1000, device=device)  # Create directly on GPU
z_gpu = x_gpu @ y_gpu  # Matrix multiply on GPU

# Move result back to CPU for NumPy/plotting
# 將結果移回 CPU 以使用 NumPy/繪圖
z_cpu = z_gpu.cpu()
z_np = z_cpu.numpy()
```

---

## 4. Benchmark: CPU vs. GPU
## 4. 效能基準測試：CPU vs. GPU

```python
import torch
import time

def benchmark_matmul(size, device, n_runs=10):
    """Benchmark matrix multiplication on a given device.
    在指定裝置上對矩陣乘法進行基準測試。
    """
    a = torch.randn(size, size, device=device)
    b = torch.randn(size, size, device=device)
    
    # Warm-up run 預熱
    _ = a @ b
    if device.type == 'cuda':
        torch.cuda.synchronize()
    
    # Timed runs 計時執行
    times = []
    for _ in range(n_runs):
        start = time.perf_counter()
        _ = a @ b
        if device.type == 'cuda':
            torch.cuda.synchronize()  # Wait for GPU to finish
        elapsed = time.perf_counter() - start
        times.append(elapsed)
    
    return np.mean(times), np.std(times)

# Run benchmarks 執行基準測試
sizes = [512, 1024, 2048, 4096]
results = []

for size in sizes:
    cpu_mean, cpu_std = benchmark_matmul(size, torch.device('cpu'))
    print(f"Size {size}x{size} — CPU: {cpu_mean*1000:.1f} ms")
    
    if torch.cuda.is_available():
        gpu_mean, gpu_std = benchmark_matmul(size, torch.device('cuda'))
        speedup = cpu_mean / gpu_mean
        print(f"Size {size}x{size} — GPU: {gpu_mean*1000:.1f} ms (Speedup: {speedup:.1f}x)")
        results.append({'size': size, 'cpu_ms': cpu_mean*1000, 'gpu_ms': gpu_mean*1000, 'speedup': speedup})

# Visualize results 視覺化結果
if results:
    import matplotlib.pyplot as plt
    df_bench = pd.DataFrame(results)
    
    fig, axes = plt.subplots(1, 2, figsize=(12, 4))
    
    axes[0].bar(range(len(sizes)), df_bench['cpu_ms'], width=0.35, label='CPU', color='#e74c3c')
    axes[0].bar([x+0.35 for x in range(len(sizes))], df_bench['gpu_ms'], width=0.35, label='GPU', color='#2ecc71')
    axes[0].set_xticks([x+0.175 for x in range(len(sizes))])
    axes[0].set_xticklabels([f'{s}²' for s in sizes])
    axes[0].set_ylabel('Time (ms)')
    axes[0].set_title('Matrix Multiplication Time')
    axes[0].legend()
    axes[0].set_yscale('log')
    
    axes[1].plot(sizes, df_bench['speedup'], 'o-', color='steelblue', linewidth=2)
    axes[1].set_xlabel('Matrix Size')
    axes[1].set_ylabel('GPU Speedup (×)')
    axes[1].set_title('GPU vs. CPU Speedup')
    
    plt.tight_layout()
    plt.show()
```

---

## 5. Custom Training Loop (Preview)
## 5. 自訂訓練迴圈（預習）

A preview of what Week 13 will cover in depth — the basic PyTorch training pattern:

預覽第 13 週將深入探討的內容 — 基本 PyTorch 訓練模式：

```python
import torch.nn as nn
import torch.optim as optim

# Simple model 簡單模型
model = nn.Sequential(
    nn.Linear(10, 32),
    nn.ReLU(),
    nn.Linear(32, 1)
).to(device)

optimizer = optim.Adam(model.parameters(), lr=0.001)
loss_fn = nn.MSELoss()

# Training loop 訓練迴圈
X_dummy = torch.randn(100, 10, device=device)
y_dummy = torch.randn(100, 1, device=device)

for epoch in range(5):
    # Forward pass 前向傳播
    predictions = model(X_dummy)
    loss = loss_fn(predictions, y_dummy)
    
    # Backward pass 反向傳播
    optimizer.zero_grad()
    loss.backward()
    optimizer.step()
    
    print(f"Epoch {epoch+1}: Loss = {loss.item():.4f}")
```

---

## 6. Lab: CPU vs. GPU Benchmark
## 6. 實作：CPU vs. GPU 基準測試

### Task 任務

1. Open Google Colab and enable GPU runtime
2. Run the benchmark code above with matrix sizes [256, 512, 1024, 2048, 4096, 8192]
3. Create a bar chart comparing CPU vs. GPU times
4. Determine: At what matrix size does the GPU become faster? Why?

---

## References 參考資料

- **PyTorch Documentation**: [https://pytorch.org/docs/stable/](https://pytorch.org/docs/stable/)
- **Google Colab**: [https://colab.research.google.com/](https://colab.research.google.com/)
- **CUDA Programming Guide**: [https://docs.nvidia.com/cuda/](https://docs.nvidia.com/cuda/)
- **PyTorch Tutorials**: [https://pytorch.org/tutorials/](https://pytorch.org/tutorials/)