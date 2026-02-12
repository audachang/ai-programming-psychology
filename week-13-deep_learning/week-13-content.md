# Week 13: Deep Learning
# 第十三週：深度學習

> **Date 日期**: 2026/05/21  
> **Topic 主題**: Neural Networks 神經網路

---

## Learning Objectives 學習目標

1. 理解神經網路的基本元件：神經元、層、權重、偏差、激活函數
2. 理解反向傳播 (Backpropagation) 與優化器 (Optimizers) 的運作原理
3. 使用 **PyTorch** 建構多層感知機 (MLP)
4. 學習 CNN 的基本概念與影像分類應用
5. 掌握 Dropout 和 Batch Normalization 等正則化技巧

---

## 1. Neural Network Fundamentals
## 1. 神經網路基礎

### 1.1 The Artificial Neuron 人工神經元

```
  x₁ --w₁--\
  x₂ --w₂---→ Σ(wᵢxᵢ + b) → f(z) → output
  x₃ --w₃--/
```

- **Inputs (x)**: Features from the data 資料的特徵
- **Weights (w)**: Learnable parameters 可學習的參數
- **Bias (b)**: An offset term 偏差項
- **Activation f(z)**: Non-linear function 非線性函數

### 1.2 Activation Functions 激活函數

```python
import torch
import torch.nn as nn
import matplotlib.pyplot as plt
import numpy as np

x = torch.linspace(-5, 5, 200)

activations = {
    'ReLU': torch.relu(x),
    'Sigmoid': torch.sigmoid(x),
    'Tanh': torch.tanh(x),
}

fig, axes = plt.subplots(1, 3, figsize=(14, 3))
for ax, (name, y) in zip(axes, activations.items()):
    ax.plot(x.numpy(), y.numpy(), linewidth=2, color='steelblue')
    ax.set_title(name)
    ax.axhline(0, color='gray', linewidth=0.5)
    ax.axvline(0, color='gray', linewidth=0.5)
    ax.set_xlabel('z')
    ax.set_ylabel('f(z)')
plt.tight_layout()
plt.show()
```

| Activation | Formula | Range | Use Case |
|:-:|:-:|:-:|:-:|
| ReLU | max(0, z) | [0, ∞) | Hidden layers (default) |
| Sigmoid | 1/(1+e⁻ᶻ) | (0, 1) | Binary output |
| Tanh | (eᶻ−e⁻ᶻ)/(eᶻ+e⁻ᶻ) | (−1, 1) | Centered output |

---

## 2. Building an MLP in PyTorch
## 2. 在 PyTorch 中建構 MLP

### 2.1 MNIST Digit Classification MNIST 手寫數字分類

```python
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader
from torchvision import datasets, transforms

# Device setup 裝置設定
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print(f"Using: {device}")

# Load MNIST dataset 載入 MNIST 資料集
transform = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize((0.1307,), (0.3081,))
])

train_data = datasets.MNIST('./data', train=True, download=True, transform=transform)
test_data = datasets.MNIST('./data', train=False, transform=transform)

train_loader = DataLoader(train_data, batch_size=64, shuffle=True)
test_loader = DataLoader(test_data, batch_size=1000)
```

### 2.2 Define the Model 定義模型

```python
class MLP(nn.Module):
    """Multi-Layer Perceptron for digit classification.
    用於數字分類的多層感知機。
    """
    def __init__(self):
        super().__init__()
        self.flatten = nn.Flatten()
        self.layers = nn.Sequential(
            nn.Linear(28 * 28, 256),    # Input → Hidden 1
            nn.ReLU(),
            nn.Dropout(0.2),            # Regularization 正則化
            nn.Linear(256, 128),         # Hidden 1 → Hidden 2
            nn.ReLU(),
            nn.Dropout(0.2),
            nn.Linear(128, 10),          # Hidden 2 → Output (10 digits)
        )
    
    def forward(self, x):
        x = self.flatten(x)             # (batch, 1, 28, 28) → (batch, 784)
        return self.layers(x)

model = MLP().to(device)
print(model)

# Count parameters 計算參數數量
total_params = sum(p.numel() for p in model.parameters())
print(f"Total parameters: {total_params:,}")
```

### 2.3 Training Loop 訓練迴圈

```python
optimizer = optim.Adam(model.parameters(), lr=0.001)
loss_fn = nn.CrossEntropyLoss()

def train_epoch(model, loader, optimizer, loss_fn, device):
    """Train for one epoch. 訓練一個 epoch。"""
    model.train()
    total_loss, correct, total = 0, 0, 0
    
    for X_batch, y_batch in loader:
        X_batch, y_batch = X_batch.to(device), y_batch.to(device)
        
        # Forward pass 前向傳播
        output = model(X_batch)
        loss = loss_fn(output, y_batch)
        
        # Backward pass 反向傳播
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        
        total_loss += loss.item() * len(y_batch)
        correct += (output.argmax(1) == y_batch).sum().item()
        total += len(y_batch)
    
    return total_loss / total, correct / total

def evaluate(model, loader, loss_fn, device):
    """Evaluate model on test data. 在測試資料上評估模型。"""
    model.eval()
    total_loss, correct, total = 0, 0, 0
    
    with torch.no_grad():
        for X_batch, y_batch in loader:
            X_batch, y_batch = X_batch.to(device), y_batch.to(device)
            output = model(X_batch)
            loss = loss_fn(output, y_batch)
            total_loss += loss.item() * len(y_batch)
            correct += (output.argmax(1) == y_batch).sum().item()
            total += len(y_batch)
    
    return total_loss / total, correct / total

# Training 訓練
n_epochs = 10
history = {'train_loss': [], 'test_loss': [], 'train_acc': [], 'test_acc': []}

for epoch in range(n_epochs):
    train_loss, train_acc = train_epoch(model, train_loader, optimizer, loss_fn, device)
    test_loss, test_acc = evaluate(model, test_loader, loss_fn, device)
    
    history['train_loss'].append(train_loss)
    history['test_loss'].append(test_loss)
    history['train_acc'].append(train_acc)
    history['test_acc'].append(test_acc)
    
    print(f"Epoch {epoch+1}/{n_epochs} — "
          f"Train Loss: {train_loss:.4f}, Acc: {train_acc:.3f} | "
          f"Test Loss: {test_loss:.4f}, Acc: {test_acc:.3f}")
```

### 2.4 Visualize Training 視覺化訓練過程

```python
fig, axes = plt.subplots(1, 2, figsize=(12, 4))

axes[0].plot(history['train_loss'], label='Train')
axes[0].plot(history['test_loss'], label='Test')
axes[0].set_xlabel('Epoch')
axes[0].set_ylabel('Loss')
axes[0].set_title('Loss Curve')
axes[0].legend()

axes[1].plot(history['train_acc'], label='Train')
axes[1].plot(history['test_acc'], label='Test')
axes[1].set_xlabel('Epoch')
axes[1].set_ylabel('Accuracy')
axes[1].set_title('Accuracy Curve')
axes[1].legend()

plt.tight_layout()
plt.show()
```

---

## 3. Convolutional Neural Networks (CNN)
## 3. 卷積神經網路 (CNN)

CNNs are designed for grid-like data (images). They use convolutional filters to detect local patterns.

CNN 專為網格狀資料（影像）設計，使用卷積濾波器偵測局部模式。

```python
class SimpleCNN(nn.Module):
    """CNN for MNIST classification. 用於 MNIST 分類的 CNN。"""
    def __init__(self):
        super().__init__()
        self.conv_layers = nn.Sequential(
            nn.Conv2d(1, 16, kernel_size=3, padding=1),  # (1, 28, 28) → (16, 28, 28)
            nn.ReLU(),
            nn.MaxPool2d(2),                              # → (16, 14, 14)
            nn.Conv2d(16, 32, kernel_size=3, padding=1),  # → (32, 14, 14)
            nn.ReLU(),
            nn.MaxPool2d(2),                              # → (32, 7, 7)
        )
        self.fc_layers = nn.Sequential(
            nn.Flatten(),
            nn.Linear(32 * 7 * 7, 128),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(128, 10),
        )
    
    def forward(self, x):
        x = self.conv_layers(x)
        return self.fc_layers(x)

cnn_model = SimpleCNN().to(device)
print(f"CNN Parameters: {sum(p.numel() for p in cnn_model.parameters()):,}")
```

---

## 4. Regularization Techniques 正則化技巧

| Technique | Purpose | PyTorch |
|-----------|---------|---------|
| **Dropout** | Randomly zero neurons during training | `nn.Dropout(p=0.2)` |
| **Batch Norm** | Normalize layer inputs | `nn.BatchNorm1d(n)` |
| **Weight Decay** | L2 penalty on weights | `optim.Adam(..., weight_decay=1e-4)` |
| **Early Stopping** | Stop when val loss increases | Manual implementation |

---

## 5. Lab: MNIST Classification
## 5. 實作：MNIST 數字分類

### Task 任務

1. Train the MLP on MNIST and record test accuracy
2. Train the CNN on MNIST and compare — which performs better and why?
3. Experiment: What happens when you remove Dropout layers?
4. Visualize some misclassified digits — what makes them hard?

---

## References 參考資料

- **PyTorch Tutorials**: [https://pytorch.org/tutorials/beginner/basics/intro.html](https://pytorch.org/tutorials/beginner/basics/intro.html)
- **Deep Learning Book** (Goodfellow et al.): [https://www.deeplearningbook.org/](https://www.deeplearningbook.org/)
- **3Blue1Brown Neural Networks**: [https://www.3blue1brown.com/topics/neural-networks](https://www.3blue1brown.com/topics/neural-networks)
- **MNIST Dataset**: [http://yann.lecun.com/exdb/mnist/](http://yann.lecun.com/exdb/mnist/)